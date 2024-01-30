page 50406 "Payment Suggestion Approval"
{
    ApplicationArea = all;
    Caption = 'Payment Suggestion Approval';
    PageType = List;
    SaveValues = true;
    SourceTable = 50400;
    SourceTableView = where(Status = filter("Pending Approval"));
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
                field("Select for Approve"; Rec."Select for Approve")
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
                field(Remark; Rec.Remark)
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
                    PayMsme.SetRange("Select for Approve", false);
                    PayMsme.SetFilter(Status, '%1', PaySuggestion.Status::"Pending Approval");//, PaySuggestion.Status::Reject);
                    if PayMsme.FindSet() then
                        repeat
                            PayMsme.Validate("Select for Approve", true);
                            PayMsme.Modify();
                        until PayMsme.Next() = 0;
                    Message('Done');
                    CurrPage.Update();
                end;
            }
            action("Reset All")
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    PayMsme.Reset();
                    PayMsme.SetRange("Select for Approve", true);
                    PayMsme.SetFilter(Status, '%1', PaySuggestion.Status::"Pending Approval");//, PaySuggestion.Status::Reject);
                    if PayMsme.FindSet() then
                        repeat
                            PayMsme.Validate("Select for Approve", false);
                            PayMsme.Modify();
                        until PayMsme.Next() = 0;
                    Message('Done');
                    CurrPage.Update();
                end;
            }
            action("Approve")
            {
                ApplicationArea = all;
                Image = Approval;
                trigger OnAction()
                begin
                    if not Confirm('Do you want to Approve selected lines', true) then
                        exit;
                    if UserSet.Get(UserId) then;
                    UserSet.TestField("Approve Payment Suggestion");
                    PaySuggestion.Reset();
                    PaySuggestion.SetRange("Select for Approve", true);
                    PaySuggestion.SetFilter(Status, '%1', PaySuggestion.Status::"Pending Approval");
                    if PaySuggestion.FindFirst() then
                        repeat
                            PaySuggestion.Status := PaySuggestion.Status::Approve;
                            PaySuggestion.Modify();
                        until PaySuggestion.Next() = 0;
                    Message('Approve process complete successfully');
                    CurrPage.Update();
                end;
            }
            action("Reject")
            {
                ApplicationArea = all;
                Image = Reject;
                trigger OnAction()
                begin
                    if not Confirm('Do you want to reject selected lines', true) then
                        exit;
                    if UserSet.Get(UserId) then;
                    UserSet.TestField("Approve Payment Suggestion");
                    PaySuggestion.Reset();
                    PaySuggestion.SetRange("Select for Approve", true);
                    PaySuggestion.SetFilter(Status, '%1', PaySuggestion.Status::"Pending Approval");
                    if PaySuggestion.FindFirst() then
                        repeat
                            PaySuggestion.TestField(Remark);
                            PaySuggestion.Status := PaySuggestion.Status::Reject;
                            PaySuggestion."Select for Approve" := false;
                            PaySuggestion.Modify();
                        until PaySuggestion.Next() = 0;
                    Message('Reject process complete successfully');
                    CurrPage.Update();
                end;
            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        Clear(NumberOfRecords);
        Clear(TotInvAmt);
        Clear(Totamt);
        PaySuggestion.Reset();
        PaySuggestion.SetRange("Select for Approve", true);
        PaySuggestion.SetFilter(Status, '%1', PaySuggestion.Status::"Pending Approval");
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