report 50404 "Update Approve Payment Vendor"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Payment Suggestion" = RM;

    dataset
    {
        dataitem("Payment Suggestion"; "Payment Suggestion")
        {
            DataItemTableView = where(Status = filter(Approve), "Bank Voucher Created" = filter(false));
            RequestFilterFields = "Invoice Date", "Invoice No", "Vendor No";
            column(Invoice_No; "Invoice No")
            {

            }
            trigger OnPreDataItem()
            begin
                if userSetup.Get(UserId) then;
                userSetup.TestField("Update Payment Approve");
            end;

            trigger OnAfterGetRecord()
            begin
                VLE.Reset();
                VLE.SetRange("Document No.", "Payment Suggestion"."Invoice No");
                if VLE.FindFirst() then begin
                    "Payment Suggestion".Validate("Remaining Amount", VLE."Remaining Amt. (LCY)");
                    "Payment Suggestion".Validate("Amount to be Paid", "Payment Suggestion"."Remaining Amount");
                    if "Payment Suggestion"."Remaining Amount" = 0 then
                        "Payment Suggestion".Validate("Print Document", false);
                    "Payment Suggestion".Modify();
                end;
            end;
        }
    }

    trigger OnPostReport()
    begin
        Message('Done');
    end;

    var
        myInt: Integer;
        VLE: record "Vendor Ledger Entry";
        userSetup: Record "User Setup";
}
