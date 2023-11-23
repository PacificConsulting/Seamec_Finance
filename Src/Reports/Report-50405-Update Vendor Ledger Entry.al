report 50405 "Update Vendor Ledger Entry"
{
    UsageCategory = ReportsAndAnalysis;
    //ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Vendor Ledger Entry" = RM;

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            RequestFilterFields = "Document No.", "Posting Date";
            column(Document_No_; "Document No.")
            {

            }
            trigger OnPreDataItem()
            begin
                // if userSetup.Get(UserId) then;
                // userSetup.TestField("Update Payment Approve");
            end;

            trigger OnAfterGetRecord()
            begin
                PIH.Reset();
                PIH.SetRange("No.", "Vendor Ledger Entry"."Document No.");
                if PIH.FindFirst() then begin
                    if "Vendor Ledger Entry"."Bill of Entry Date" = 0D then
                        "Vendor Ledger Entry"."Bill of Entry Date" := PIH."Bill of Entry Date";
                    if "Vendor Ledger Entry"."Bill of Entry No." = '' then
                        "Vendor Ledger Entry"."Bill of Entry No." := PIH."Bill of Entry No.";
                    "Vendor Ledger Entry".Modify();
                end;
            end;
        }
    }
    trigger OnPostReport()
    var
        myInt: Integer;
    begin
        Message('Done');
    end;

    var
        myInt: Integer;
        VLE: record "Vendor Ledger Entry";
        userSetup: Record "User Setup";
        PIH: Record "Purch. Inv. Header";
}
