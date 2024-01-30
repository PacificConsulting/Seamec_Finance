page 50403 "Approve Payment Vendor"
{
    ApplicationArea = all;
    Caption = 'Approve Payment Vendor';
    PageType = List;
    SaveValues = true;
    SourceTable = "Payment Suggestion";
    SourceTableView = where(Status = filter(Approve), "Bank Voucher Created" = filter(false), "Remaining Amount" = filter(< 0));
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Control120)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Invoice No"; Rec."Invoice No")
                {
                    ApplicationArea = all;
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                    ApplicationArea = all;
                }
                field("Vendor No"; Rec."Vendor No")
                {
                    ApplicationArea = all;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = all;
                }
                field("Invoice Amount"; Rec."Invoice Amount")
                {
                    ApplicationArea = all;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = all;
                }
                field("MSME Vendor"; Rec."MSME Vendor")
                {
                    ApplicationArea = all;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = all;
                }
                field("MSME Due Date"; Rec."MSME Due Date")
                {
                    ApplicationArea = all;
                }
                field("Amount to be Paid"; Rec."Amount to be Paid")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Payment Release Date"; Rec."Payment Release Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Print Document"; Rec."Print Document")
                {
                    ApplicationArea = all;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = all;
                }
                field("Bank Payment Date"; Rec."Bank Payment Date")
                {
                    ApplicationArea = all;
                }
                field("Select Bank Payment"; Rec."Create Bank Voucher")
                {
                    ApplicationArea = all;
                }

                field("Batch Name"; Rec."Batch Name")
                {
                    ApplicationArea = all;
                }
                field("Costcentre Code"; Rec."Costcentre Code")
                {
                    ApplicationArea = all;
                }
                field("Project Code"; Rec."Project Code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Bill for RTGS/NEFT Payment")
            {
                ApplicationArea = all;
                Caption = 'Bill for RTGS/NEFT Payment IDBI';
                Image = Report;
                trigger OnAction()
                var
                    Vend: Record Vendor;
                begin
                    Vend.Reset();
                    Vend.SetRange("No.", Rec."Vendor No");
                    if Vend.FindFirst() then
                        Report.RunModal(50400, true, true, vend);
                end;
            }
            action("Bill for Pmnt. Detail-Payment")
            {
                ApplicationArea = all;
                Image = Report;
                trigger OnAction()
                var
                    Vend: Record Vendor;
                    recPaySuggestion: Record "Payment Suggestion";
                begin

                    /* recPaySuggestion.Reset();
                    recPaySuggestion.SetRange(Select, true);
                    recPaySuggestion.SetRange("Invoice No", rec."Invoice No");
                    recPaySuggestion.SetRange("Print Document", true);
                    recPaySuggestion.SetFilter("Remaining Amount", '<%1', 0);
                    recPaySuggestion.SetRange(Status, recPaySuggestion.Status::Approve);
                    recPaySuggestion.SetRange("Bank Voucher Created", false);
                    if recPaySuggestion.FindSet() then */
                    Vend.Reset();

                    //Vend.SetRange("No.", Rec."Vendor No");
                    if Vend.Findset() then
                        //repeat
                            Report.RunModal(50401, true, true, vend);
                    //until vend.Next() = 0;
                end;


                //end;
            }

            action("RTGS/NEFT Payment")
            {
                ApplicationArea = all;
                Caption = 'RTGS/NEFT payment HDFC';
                Image = Report;
                trigger OnAction()
                var
                    ApproPayVend: Record "Payment Suggestion";
                begin
                    ApproPayVend.Reset();
                    ApproPayVend.SetRange("Vendor No", Rec."Vendor No");
                    if ApproPayVend.FindFirst() then
                        Report.RunModal(50402, true, true, ApproPayVend);
                end;
            }

            action("Create Bank Payment Voucher")
            {
                trigger OnAction()
                var
                    rec_GenJnlLine: Record "Gen. Journal Line";
                    intLine: Integer;
                    recGenJnlLine: Record "Gen. Journal Line";
                begin
                    PayMsme.Reset();
                    PayMsme.SetRange("Create Bank Voucher", true);
                    PayMsme.SetRange("Bank Voucher Created", false);
                    if PayMsme.FindSet() then
                        repeat
                            PayMsme.TestField("Batch Name");
                            rec_GenJnlLine.RESET;
                            rec_GenJnlLine.SETRANGE("Journal Template Name", 'BANKPAYMT');
                            //rec_GenJnlLine.SETRANGE("Journal Batch Name", 'PAYSUG');
                            rec_GenJnlLine.SETRANGE("Journal Batch Name", PayMsme."Batch Name");
                            IF rec_GenJnlLine.FINDLAST THEN
                                intLine := rec_GenJnlLine."Line No.";

                            recGenJnlLine.INIT;
                            recGenJnlLine.VALIDATE("Journal Template Name", 'BANKPAYMT');
                            //recGenJnlLine.VALIDATE("Journal Batch Name", 'PAYSUG');
                            recGenJnlLine.VALIDATE("Journal Batch Name", PayMsme."Batch Name");
                            recGenJnlLine.VALIDATE("Document No.", NoSeriesMang.GetNextNo(PayMsme."Batch Name", Today, true));
                            //recGenJnlLine.VALIDATE("Document No.", NoSeriesMang.GetNextNo('PAYSUG', Today, true));//cd_DocumentNo);
                            recGenJnlLine.VALIDATE("Source Code", 'JOURNALV');
                            recGenJnlLine.VALIDATE("Document Type", recGenJnlLine."Document Type"::Payment);
                            recGenJnlLine.VALIDATE("Account Type", recGenJnlLine."Account Type"::Vendor);
                            recGenJnlLine.VALIDATE("Bal. Account Type", recGenJnlLine."Bal. Account Type"::"Bank Account");
                            recGenJnlLine."Line No." := intLine + 10000;
                            recGenJnlLine.INSERT;

                            recGenJnlLine.VALIDATE("Debit Amount", PayMsme."Amount to be Paid");

                            Vendor.RESET;
                            Vendor.GET(Rec."Vendor No");
                            recGenJnlLine.VALIDATE("Posting Date", PayMsme."Bank Payment Date");
                            recGenJnlLine.VALIDATE("Account No.", PayMsme."Vendor No");
                            recGenJnlLine.VALIDATE("Bill-to/Pay-to No.", PayMsme."Vendor No");
                            recGenJnlLine.VALIDATE("Sell-to/Buy-from No.", PayMsme."Vendor No");
                            recGenJnlLine.VALIDATE("Bal. Account No.", PayMsme."Bank Account No.");
                            recGenJnlLine."Gen. Posting Type" := 0;
                            recGenJnlLine."Gen. Bus. Posting Group" := '';
                            recGenJnlLine."Gen. Prod. Posting Group" := '';
                            recGenJnlLine."VAT Bus. Posting Group" := '';
                            recGenJnlLine."VAT Prod. Posting Group" := '';
                            //EVALUATE(decTDS, TDSTCSAmt);
                            recGenJnlLine."Manual Entry" := TRUE;
                            recGenJnlLine.VALIDATE("Shortcut Dimension 1 Code", PayMsme."Costcentre Code");
                            recGenJnlLine.VALIDATE("Shortcut Dimension 2 Code", PayMsme."Project Code");
                            tempDimSetEntry.DELETEALL;
                            tempDimSetEntry.INIT;
                            tempDimSetEntry.VALIDATE("Dimension Code", 'COSTCENTRE');
                            tempDimSetEntry.VALIDATE("Dimension Value Code", PayMsme."Costcentre Code");
                            tempDimSetEntry.INSERT;
                            tempDimSetEntry.INIT;
                            tempDimSetEntry.VALIDATE("Dimension Code", 'PROJECT');
                            tempDimSetEntry.VALIDATE("Dimension Value Code", PayMsme."Project Code");
                            tempDimSetEntry.INSERT;
                            recGenJnlLine."Dimension Set ID" := recDimSetEntry.GetDimensionSetID(tempDimSetEntry);
                            intLine := recGenJnlLine."Line No.";
                            recGenJnlLine.MODIFY;
                            PayMsme."Bank Voucher Created" := true;
                            PayMsme.Modify();
                        until PayMsme.Next() = 0;
                end;
            }

        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        RecPaymentSuggestion: Record "Payment Suggestion";
    begin
        RecPaymentSuggestion.Reset();
        RecPaymentSuggestion.SetFilter("Remaining Amount", '<%1', 0);
        RecPaymentSuggestion.SetRange(Status, RecPaymentSuggestion.Status::Approve);
        RecPaymentSuggestion.SetRange("Bank Voucher Created", false);
        RecPaymentSuggestion.SetRange("Print Document", true);
        if RecPaymentSuggestion.FindSet() then begin
            repeat
                RecPaymentSuggestion."Print Document" := false;

                RecPaymentSuggestion.Modify();
            until RecPaymentSuggestion.Next() = 0;
        end;

    end;

    var
        myInt: Integer;
        PayMsme: Record "Payment Suggestion";
        tempDimSetEntry: Record 480 temporary;
        recDimSetEntry: Record 480;
        Selection: Integer;
        Text000: Label '&MSME,&Non MSME';
        VLE: Record "Vendor Ledger Entry";
        LineNo: Integer;
        Vendor: Record Vendor;
        NoSeries: Record "No. Series";
        NoSeriesMang: Codeunit NoSeriesManagement;
}