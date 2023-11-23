page 50402 "Payment Suggestion"
{
    ApplicationArea = all;
    Caption = 'Payment Suggestion';
    PageType = List;
    //PromotedActionCategories = 'New,Process,Report,Bank,Application,Payroll,Approve,Page,Post/Print,Line,Account';
    SaveValues = true;
    SourceTable = 50400;
    SourceTableView = where(Status = filter(Open | Reject));
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
                field(Select; Rec.Select)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Amount to be Paid"; Rec."Amount to be Paid")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Payment Release Date"; Rec."Payment Release Date")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Delay Days"; Rec."Delay Days")
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

            group(Control30)
            {
                ShowCaption = false;
                fixed(Control1901776101)
                {
                    ShowCaption = false;
                    group("Number of Lines")
                    {
                        Caption = 'Number of Lines';
                        field(NumberOfJournalRecords; NumberOfRecords)
                        {
                            ApplicationArea = All;
                            //AutoFormatType = 1;
                            ShowCaption = false;
                            Editable = false;
                            ToolTip = 'Specifies the number of lines in the current journal batch.';
                        }
                    }
                    group(Control1902759701)
                    {
                        Caption = 'Amount to be Paid';
                        field("Total Amount to be Paid"; Totamt)
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Total Amount to be Paid';
                            Editable = false;
                            ToolTip = 'Specifies the balance that has accumulated in the general journal on the line where the cursor is.';
                            //Visible = BalanceVisible;
                        }
                    }
                    group("Total Invoice Amount")
                    {
                        Caption = 'Invoice Amount';
                        field(TotalBalance; TotInvAmt)
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Total Invoice Amount';
                            Editable = false;
                            ToolTip = 'Specifies the total balance in the general journal.';
                            //Visible = TotalBalanceVisible;
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Select All")
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    PayMsme.Reset();
                    PayMsme.SetRange(Select, false);
                    PayMsme.SetFilter(Status, '%1', PaySuggestion.Status::Open);//, PaySuggestion.Status::Reject);
                    if PayMsme.FindSet() then
                        repeat
                            PayMsme.Validate(Select, true);
                            PayMsme.Modify();
                        until PayMsme.Next() = 0;
                    Message('Done');
                    CurrPage.Update();
                end;
            }
            action("Process")
            {
                ApplicationArea = all;
                Image = Report;
                trigger OnAction()
                var
                    VLE: Record "Vendor Ledger Entry";
                begin
                    VLE.Reset();
                    // VLE.SetFilter("Document Type", '%1|%2', VLE."Document Type"::Invoice, VLE."Document Type"::" ");
                    // VLE.SetFilter("Remaining Amt. (LCY)", '<%1', 0);
                    if VLE.FindFirst() then
                        Report.RunModal(50403, true, true, VLE);
                end;
            }
            /*
            action(Process)
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    CLEAR(pgConfrmPage);
                    Clear(VendorNo);
                    Clear(ToDt);
                    Clear(FromDt);
                    IF pgConfrmPage.RUNMODAL = ACTION::Yes THEN BEGIN
                        IF pgConfrmPage.RetVendoNo <> '' THEN
                            VendorNo := pgConfrmPage.RetVendoNo;
                        IF pgConfrmPage.RetFromDate <> 0D THEN
                            FromDt := pgConfrmPage.RetFromDate;
                        IF pgConfrmPage.RetToDate <> 0D THEN
                            ToDt := pgConfrmPage.RetToDate;
                        //                    END;
                        // For MSME
                        VLE.Reset();
                        VLE.SetFilter("Document Type", '%1|%2', VLE."Document Type"::Invoice, VLE."Document Type"::" ");
                        VLE.SetFilter("Remaining Amt. (LCY)", '<%1', 0);
                        if VendorNo <> '' then
                            VLE.SetRange("Vendor No.", VendorNo);
                        if (FromDt <> 0D) and (ToDt <> 0D) then
                            VLE.SetRange("Posting Date", FromDt, ToDt);
                        // VLE.SetRange(MSME, true);
                        // VLE.SetFilter("MSME Due Date", '<%1', Today);
                        if VLE.FindSet() then
                            repeat
                                VLE.CalcFields("Amount (LCY)", "Remaining Amt. (LCY)");
                                PayMsme.Reset();
                                PayMsme.SetRange("Invoice No", VLE."Document No.");
                                if PayMsme.FindFirst() then
                                    LineNo := PayMsme."Line No." + 10000
                                else
                                    LineNo := 10000;
                                PayMsme.Reset();
                                PayMsme.SetRange("Invoice No", VLE."Document No.");
                                if not PayMsme.FindFirst() then begin
                                    PayMsme.Init();
                                    PayMsme."Invoice No" := VLE."Document No.";
                                    PayMsme."Line No." := LineNo;
                                    PayMsme.Insert();
                                    PayMsme."Invoice Date" := VLE."Posting Date";
                                    PayMsme.Date := Today;
                                    PayMsme.VALIDATE("Vendor No", VLE."Vendor No.");
                                    PayMsme."Invoice Amount" := VLE."Amount (LCY)";
                                    PayMsme."Remaining Amount" := VLE."Remaining Amt. (LCY)";
                                    PayMsme."MSME Vendor" := VLE.MSME;
                                    PayMsme."Due Date" := VLE."Due Date";
                                    PayMsme."MSME Due Date" := VLE."MSME Due Date";
                                    PayMsme."Costcentre Code" := VLE."Global Dimension 1 Code";
                                    PayMsme."Project Code" := VLE."Global Dimension 2 Code";
                                    if (Rec."MSME Due Date" <> 0D) then
                                        Rec."Delay Days" := Rec."MSME Due Date" - Today
                                    else
                                        if (Rec."Due Date" <> 0D) then
                                            Rec."Delay Days" := Rec."Due Date" - Today;
                                    PayMsme.Modify();
                                end;
                            until VLE.Next() = 0;

                        //For non msme
                        /*VLE.Reset();
                        VLE.SetFilter("Document Type", '%1|%2', VLE."Document Type"::Invoice, VLE."Document Type"::" ");
                        VLE.SetFilter("Remaining Amt. (LCY)", '<%1', 0);
                        VLE.SetRange(MSME, false);
                        VLE.SetFilter("Due Date", '<%1', Today);
                        if VLE.FindSet() then
                            repeat
                                VLE.CalcFields("Amount (LCY)", "Remaining Amt. (LCY)");
                                PayMsme.Reset();
                                PayMsme.SetRange("Invoice No", VLE."Document No.");
                                if PayMsme.FindFirst() then
                                    LineNo := PayMsme."Line No." + 10000
                                else
                                    LineNo := 10000;
                                PayMsme.Reset();
                                PayMsme.SetRange("Invoice No", VLE."Document No.");
                                if not PayMsme.FindFirst() then begin
                                    PayMsme.Init();
                                    PayMsme."Invoice No" := VLE."Document No.";
                                    PayMsme."Line No." := LineNo;
                                    PayMsme.Insert();
                                    PayMsme."Invoice Date" := VLE."Posting Date";
                                    PayMsme.Date := Today;
                                    PayMsme.VALIDATE("Vendor No", VLE."Vendor No.");
                                    PayMsme."Invoice Amount" := VLE."Amount (LCY)";
                                    PayMsme."Remaining Amount" := VLE."Remaining Amt. (LCY)";
                                    PayMsme."MSME Vendor" := VLE.MSME;
                                    PayMsme."Due Date" := VLE."Due Date";
                                    PayMsme."MSME Due Date" := VLE."MSME Due Date";
                                    PayMsme.Modify();
                                end;
                            until VLE.Next() = 0; */
            //             Message('Data update successfully');
            //         END;
            //     end;
            // }

            action("Send for approval")
            {
                ApplicationArea = all;
                Image = Approval;
                trigger OnAction()
                begin
                    if not Confirm('Do you want to send for approval', true) then
                        exit;
                    if UserSet.Get(UserId) then;
                    //UserSet.TestField("Payment Suggestion Approval 1");   //PCPL-25/240823
                    PaySuggestion.Reset();
                    PaySuggestion.SetRange(Select, true);
                    PaySuggestion.SetFilter(Status, '%1|%2', PaySuggestion.Status::Open, PaySuggestion.Status::Reject);
                    if PaySuggestion.FindFirst() then
                        repeat
                            PaySuggestion.Status := PaySuggestion.Status::"Pending Approval";
                            //PaySuggestion."Payment Approval ID" := UserSet."Payment Suggestion Approval 1";  //PCPL-25/240823
                            PaySuggestion.Remark := '';
                            PaySuggestion.Modify();
                        until PaySuggestion.Next() = 0;
                    Message('Send for approval process complete successfully');
                    CurrPage.Update();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        PaySuggestion.Reset();
        PaySuggestion.SetFilter(Status, '%1|%2', PaySuggestion.Status::Open, PaySuggestion.Status::Reject);
        if PaySuggestion.FindFirst() then
            repeat
                if PaySuggestion."MSME Due Date" <> 0D then
                    PaySuggestion."Delay Days" := PaySuggestion."MSME Due Date" - Today
                else
                    if PaySuggestion."Due Date" <> 0D then
                        PaySuggestion."Delay Days" := PaySuggestion."Due Date" - Today;
                PaySuggestion.Modify();
            until PaySuggestion.Next() = 0;
    end;

    trigger OnAfterGetRecord()
    begin
        Clear(NumberOfRecords);
        Clear(TotInvAmt);
        Clear(Totamt);
        PaySuggestion.Reset();
        PaySuggestion.SetRange(Select, true);
        PaySuggestion.SetFilter(Status, '%1|%2', PaySuggestion.Status::Open, PaySuggestion.Status::Reject);
        if PaySuggestion.FindFirst() then
            repeat
                NumberOfRecords += 1;
                Totamt += PaySuggestion."Amount to be Paid";
                TotInvAmt += PaySuggestion."Invoice Amount";
            until PaySuggestion.Next() = 0;
    end;

    var
        myInt: Integer;
        PayMsme: Record "Payment Suggestion";
        Selection: Integer;
        Text000: Label '&MSME,&Non MSME';
        VLE: Record "Vendor Ledger Entry";
        LineNo: Integer;
        PaySuggestion: Record "Payment Suggestion";
        UserSet: Record "User Setup";
        NumberOfRecords: Integer;
        Totamt: Decimal;
        TotInvAmt: Decimal;
        pgConfrmPage: Page 50405;
        VendorNo: Code[20];
        FromDt: Date;
        ToDt: Date;
}