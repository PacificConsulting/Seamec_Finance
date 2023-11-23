page 50409 "Modify Approve Payment Vendor"
{
    ApplicationArea = all;
    Caption = 'Modify Approve Payment Vendor';
    PageType = List;
    SaveValues = true;
    SourceTable = "Payment Suggestion";
    //SourceTableView = where(Status = filter(Approve), "Bank Voucher Created" = filter(false), "Remaining Amount" = filter(< 0));
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
                field(Select; Rec.Select)
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
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = all;
                }
                field("Select for Approve"; Rec."Select for Approve")
                {
                    ApplicationArea = all;
                }
                field("Delay Days"; Rec."Delay Days")
                {
                    ApplicationArea = all;
                }
                field("Create Bank Voucher"; Rec."Create Bank Voucher")
                {
                    ApplicationArea = all;
                }
                field("Bank Voucher Created"; Rec."Bank Voucher Created")
                {
                    ApplicationArea = all;
                }

            }

        }

    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if Usersetup.Get(UserId) then;
        Usersetup.TestField("Modify Approve Paymnet Vendor");
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
        Usersetup: Record "User Setup";
}