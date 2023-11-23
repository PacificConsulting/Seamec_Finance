xmlport 50400 "Salary Upload1"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Gen. Journal Line"; "Gen. Journal Line")
            {
                AutoSave = false;
                XmlName = 'IM';
                UseTemporary = true;
                textattribute(PostingDate)
                {
                }
                textattribute(PartType)
                {
                }
                textattribute(PartyCode)
                {
                }
                textattribute(Accounttype)
                {
                }
                textattribute(AccNo)
                {
                }
                textattribute(CreditAmt)
                {
                }
                textattribute(TDSTCSAmt)
                {
                }
                textattribute(BalAccNo)
                {
                }
                textattribute(TDSNature11)
                {
                }
                textattribute(ShortDim1)
                {
                }
                textattribute(ShortDim2)
                {
                }
                textattribute(ShortDim3)
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    rec_GenJnlLine.RESET;
                    rec_GenJnlLine.SETRANGE("Journal Template Name", 'JOURNAL VO');
                    rec_GenJnlLine.SETRANGE("Journal Batch Name", 'SALARY JV');
                    IF rec_GenJnlLine.FINDLAST THEN
                        intLine := rec_GenJnlLine."Line No.";

                    recGenJnlLine.INIT;
                    recGenJnlLine.VALIDATE("Journal Template Name", 'JOURNAL VO');
                    recGenJnlLine.VALIDATE("Journal Batch Name", 'SALARY JV'); //Avinash)
                    recGenJnlLine.VALIDATE("Document No.", cd_DocumentNo);
                    recGenJnlLine.VALIDATE("Source Code", 'JOURNALV');
                    recGenJnlLine.VALIDATE("Document Type", "Gen. Journal Line"."Document Type"::Invoice);
                    recGenJnlLine.VALIDATE("Account Type", "Gen. Journal Line"."Account Type"::"G/L Account");
                    recGenJnlLine."Salary Transaction" := TRUE;
                    recGenJnlLine."Line No." := intLine + 10000;
                    recGenJnlLine."External Document No." := cd_DocumentNo;
                    recGenJnlLine.INSERT;

                    ICount := ICount + 1;
                    TdsNature := TDSNature11;
                    ShortCutDim1 := ShortDim1;
                    ShortCutDim2 := ShortDim2;
                    EVALUATE(decCreditAmt, CreditAmt);
                    IF decCreditAmt <> 0 THEN
                        recGenJnlLine.VALIDATE("Debit Amount", decCreditAmt);

                    Vendor.RESET;
                    Vendor.GET(PartyCode);
                    EVALUATE(PD, PostingDate);
                    recGenJnlLine.VALIDATE("Posting Date", PD);
                    recGenJnlLine.VALIDATE("Account No.", BalAccNo);
                    recGenJnlLine.VALIDATE("Bill-to/Pay-to No.", BalAccNo);
                    recGenJnlLine.VALIDATE("Sell-to/Buy-from No.", BalAccNo);
                    recGenJnlLine.VALIDATE("Currency Code", Vendor."Currency Code");
                    //recGenJnlLine.VALIDATE("Bal. Account No.", BalAccNo);
                    recGenJnlLine."Gen. Posting Type" := 0;
                    recGenJnlLine."Gen. Bus. Posting Group" := '';
                    recGenJnlLine."Gen. Prod. Posting Group" := '';
                    recGenJnlLine."VAT Bus. Posting Group" := '';
                    recGenJnlLine."VAT Prod. Posting Group" := '';
                    EVALUATE(decTDS, TDSTCSAmt);

                    recGenJnlLine."Manual Entry" := TRUE;
                    recGenJnlLine.VALIDATE("Shortcut Dimension 1 Code", ShortCutDim1);
                    //recGenJnlLine.VALIDATE("Shortcut Dimension 2 Code", ShortCutDim2);
                    recGenJnlLine.VALIDATE("Project Code", ShortDim2);  //PCPL-25/220823
                    tempDimSetEntry.DELETEALL;
                    tempDimSetEntry.INIT;
                    tempDimSetEntry.VALIDATE("Dimension Code", 'COSTCENTRE');
                    tempDimSetEntry.VALIDATE("Dimension Value Code", ShortDim1);
                    tempDimSetEntry.INSERT;
                    tempDimSetEntry.INIT;
                    tempDimSetEntry.VALIDATE("Dimension Code", 'PROJECT');
                    tempDimSetEntry.VALIDATE("Dimension Value Code", ShortDim2);
                    tempDimSetEntry.INSERT;
                    tempDimSetEntry.INIT;
                    tempDimSetEntry.VALIDATE("Dimension Code", 'EMPLOYEE');
                    tempDimSetEntry.VALIDATE("Dimension Value Code", ShortDim3);
                    tempDimSetEntry.INSERT;
                    recGenJnlLine."Dimension Set ID" := recDimSetEntry.GetDimensionSetID(tempDimSetEntry);
                    intLine := recGenJnlLine."Line No.";
                    recGenJnlLine.MODIFY;

                    //PCPL-25/270623 for tds
                    //PCPL-25/240823
                    Clear(decTDS);
                    if TDSTCSAmt <> '0' then
                        EVALUATE(decTDS, TDSTCSAmt);
                    if decTDS <> 0 then begin
                        //PCPL-25/240823

                        //if TDSTCSAmt > 0 then begin
                        PurchPay.Get();
                        PurchPay.TestField("TDS Salary GL");
                        EVALUATE(decTDS, TDSTCSAmt);

                        recGenJnlL.INIT;
                        recGenJnlL.VALIDATE("Journal Template Name", 'JOURNAL VO');
                        recGenJnlL.VALIDATE("Journal Batch Name", 'SALARY JV');
                        recGenJnlL.VALIDATE("Document No.", cd_DocumentNo);
                        recGenJnlL.VALIDATE("Source Code", 'JOURNALV');
                        recGenJnlL.VALIDATE("Document Type", "Gen. Journal Line"."Document Type"::Invoice);
                        recGenJnlL.VALIDATE("Account Type", "Gen. Journal Line"."Account Type"::"G/L Account");
                        recGenJnlL.VALIDATE("Bal. Account Type", "Gen. Journal Line"."Bal. Account Type"::"G/L Account");
                        recGenJnlL.VALIDATE("Bal. Gen. Posting Type", "Gen. Journal Line"."Bal. Gen. Posting Type"::Purchase);
                        recGenJnlL."Salary Transaction" := TRUE;
                        recGenJnlL."Line No." := intLine + 10000;
                        recGenJnlL."External Document No." := cd_DocumentNo;
                        recGenJnlL.INSERT;

                        ICount := ICount + 1;
                        TdsNature := TDSNature11;
                        ShortCutDim1 := ShortDim1;
                        ShortCutDim2 := ShortDim2;
                        EVALUATE(PD, PostingDate);
                        recGenJnlL.VALIDATE("Posting Date", PD);
                        recGenJnlL.VALIDATE("Account No.", PurchPay."TDS Salary GL");
                        recGenJnlL."Gen. Posting Type" := 0;
                        recGenJnlL."Gen. Bus. Posting Group" := '';
                        recGenJnlL."Gen. Prod. Posting Group" := '';
                        recGenJnlL."VAT Bus. Posting Group" := '';
                        recGenJnlL."VAT Prod. Posting Group" := '';
                        //EVALUATE(decTDS, TDSTCSAmt); temp comment
                        recGenJnlL.Validate("Credit Amount", Abs(decTDS));

                        recGenJnlL."Manual Entry" := TRUE;
                        recGenJnlL.VALIDATE("Shortcut Dimension 1 Code", ShortCutDim1);
                        //recGenJnlL.VALIDATE("Shortcut Dimension 2 Code", ShortCutDim2);
                        recGenJnlL.VALIDATE("Project Code", ShortDim2);  //PCPL-25/220823
                        tempDimSetE.DELETEALL;
                        tempDimSetE.INIT;
                        tempDimSetE.VALIDATE("Dimension Code", 'COSTCENTRE');
                        tempDimSetE.VALIDATE("Dimension Value Code", ShortDim1);
                        tempDimSetE.INSERT;
                        tempDimSetE.INIT;
                        tempDimSetE.VALIDATE("Dimension Code", 'PROJECT');
                        tempDimSetE.VALIDATE("Dimension Value Code", ShortDim2);
                        tempDimSetE.INSERT;
                        tempDimSetE.INIT;
                        tempDimSetE.VALIDATE("Dimension Code", 'EMPLOYEE');
                        tempDimSetE.VALIDATE("Dimension Value Code", ShortDim3);
                        tempDimSetE.INSERT;
                        recGenJnlL."Dimension Set ID" := recDimSetEntry.GetDimensionSetID(tempDimSetE);
                        intLine := recGenJnlL."Line No.";
                        recGenJnlL.Correction := false;
                        recGenJnlL.MODIFY;
                    end;

                    if AccNo <> '' then begin
                        recGenJnlLine.INIT;
                        recGenJnlLine.VALIDATE("Journal Template Name", 'JOURNAL VO');
                        recGenJnlLine.VALIDATE("Journal Batch Name", 'SALARY JV'); //Avinash)
                        recGenJnlLine.VALIDATE("Document No.", cd_DocumentNo);
                        recGenJnlLine.VALIDATE("Source Code", 'JOURNALV');
                        recGenJnlLine.VALIDATE("Document Type", "Gen. Journal Line"."Document Type"::Invoice);
                        recGenJnlLine.VALIDATE("Account Type", "Gen. Journal Line"."Account Type"::Vendor);
                        recGenJnlLine.VALIDATE("Bal. Account Type", "Gen. Journal Line"."Bal. Account Type"::"G/L Account");
                        recGenJnlLine.VALIDATE("Bal. Gen. Posting Type", "Gen. Journal Line"."Bal. Gen. Posting Type"::Purchase);
                        recGenJnlLine."Salary Transaction" := TRUE;
                        recGenJnlLine."Line No." := intLine + 10000;
                        recGenJnlLine."External Document No." := cd_DocumentNo;
                        recGenJnlLine.INSERT;

                        ICount := ICount + 1;
                        TdsNature := TDSNature11;
                        ShortCutDim1 := ShortDim1;
                        ShortCutDim2 := ShortDim2;

                        IF decCreditAmt - ABS(decTDS) <> 0 THEN
                            recGenJnlLine.VALIDATE("Credit Amount", ABS(decCreditAmt - Abs(decTDS)));

                        Vendor.RESET;
                        Vendor.GET(AccNo);
                        // recGenJnlLine.VALIDATE("Party Type", recGenJnlLine."Party Type"::Vendor);  //pcpl code uncommented
                        // recGenJnlLine.VALIDATE("Party Code", PartyCode);
                        EVALUATE(PD, PostingDate);
                        recGenJnlLine.VALIDATE("Posting Date", PD);
                        recGenJnlLine.Description := Vendor.Name;
                        recGenJnlLine."Posting Group" := Vendor."Vendor Posting Group";
                        recGenJnlLine."Salespers./Purch. Code" := Vendor."Purchaser Code";
                        recGenJnlLine."Payment Terms Code" := Vendor."Payment Terms Code";
                        recGenJnlLine.VALIDATE("Payment Terms Code");
                        recGenJnlLine.VALIDATE("Account No.", AccNo);
                        recGenJnlLine.VALIDATE("Bill-to/Pay-to No.", AccNo);
                        recGenJnlLine.VALIDATE("Sell-to/Buy-from No.", AccNo);
                        recGenJnlLine.VALIDATE("Currency Code", Vendor."Currency Code");
                        //recGenJnlLine.VALIDATE("Bal. Account No.", AccNo);
                        recGenJnlLine."Gen. Posting Type" := 0;
                        recGenJnlLine."Gen. Bus. Posting Group" := '';
                        recGenJnlLine."Gen. Prod. Posting Group" := '';
                        recGenJnlLine."VAT Bus. Posting Group" := '';
                        recGenJnlLine."VAT Prod. Posting Group" := '';
                        recGenJnlLine."Manual Entry" := TRUE;
                        recGenJnlLine.VALIDATE("Shortcut Dimension 1 Code", ShortCutDim1);
                        //recGenJnlLine.VALIDATE("Shortcut Dimension 2 Code", ShortCutDim2);
                        recGenJnlLine.VALIDATE("Project Code", ShortDim2);  //PCPL-25/220823
                        tempDimSetEntry.DELETEALL;
                        tempDimSetEntry.INIT;
                        tempDimSetEntry.VALIDATE("Dimension Code", 'COSTCENTRE');
                        tempDimSetEntry.VALIDATE("Dimension Value Code", ShortDim1);
                        tempDimSetEntry.INSERT;
                        tempDimSetEntry.INIT;
                        tempDimSetEntry.VALIDATE("Dimension Code", 'PROJECT');
                        tempDimSetEntry.VALIDATE("Dimension Value Code", ShortDim2);
                        tempDimSetEntry.INSERT;
                        tempDimSetEntry.INIT;
                        tempDimSetEntry.VALIDATE("Dimension Code", 'EMPLOYEE');
                        tempDimSetEntry.VALIDATE("Dimension Value Code", ShortDim3);
                        tempDimSetEntry.INSERT;
                        recGenJnlLine."Dimension Set ID" := recDimSetEntry.GetDimensionSetID(tempDimSetEntry);
                        recGenJnlLine.MODIFY;
                    end;
                    //PCPL-25/270623
                    cd_DocumentNo := INCSTR(cd_DocumentNo);

                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin

        MESSAGE('Data Updated Successfully');
    end;

    trigger OnPreXmlPort()
    begin
        rec_GenJnlLine.RESET;
        rec_GenJnlLine.SETRANGE("Journal Template Name", 'JOURNAL VO');
        rec_GenJnlLine.SETRANGE("Journal Batch Name", 'SALARY JV');
        rec_GenJnlLine.SETFILTER(Amount, '%1', 0);
        IF rec_GenJnlLine.FINDLAST THEN
            rec_GenJnlBatch.SETRANGE("Journal Template Name", 'JOURNAL VO');
        rec_GenJnlBatch.SETRANGE(Name, 'SALARY JV');
        IF rec_GenJnlBatch.FINDFIRST THEN BEGIN
            IF rec_GenJnlBatch."No. Series" <> '' THEN BEGIN
                CLEAR(cu_NoSeriesMgt);
                cd_DocumentNo := cu_NoSeriesMgt.GetNextNo(rec_GenJnlBatch."No. Series", rec_GenJnlLine."Posting Date", FALSE);
            END;
        END;
    end;

    var
        ExtDocNo: Code[50];
        cd_DocumentNo: Code[20];
        cd_newDocumentNo: Code[20];
        cu_NoSeriesMgt: Codeunit 396;
        rec_GenJnlBatch: Record 232;
        rec_GenJnlLine: Record 81;
        rec_GenJnlTemplate: Record 80;
        dt_PostingDate: Date;
        TdsNature: Code[10];
        ICount: Integer;
        rec_DimensionValue: Record 349;
        ShortCutDim3: Code[10];
        JournalLineDimension: Record 356;
        ShortCutDim1: Code[20];
        ShortCutDim2: Code[20];
        Vendor: Record 23;
        vendRecGenJnlLine: Record 81;
        blnRecFound: Boolean;
        recGenJnlLine: Record 81;
        intLine: Integer;
        decCreditAmt: Decimal;
        PD: Date;
        tempDimSetEntry: Record 480 temporary;
        recDimSetEntry: Record 480;
        decTDS: Decimal;
        recGenJnlL: Record "Gen. Journal Line";
        tempDimSetE: Record 480 temporary;
        rec_GenJnlL: Record "Gen. Journal Line";
        PurchPay: Record "Purchases & Payables Setup";
}

