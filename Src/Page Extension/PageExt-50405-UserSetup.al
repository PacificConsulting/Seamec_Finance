pageextension 50405 UserSet extends "User Setup"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("Payment Suggestion Approval 1"; Rec."Payment Suggestion Approval 1")
            {
                ApplicationArea = all;
            }
            field("Approve Payment Suggestion"; Rec."Approve Payment Suggestion")
            {
                ApplicationArea = all;
            }
            field("Update Payment Approve"; Rec."Update Payment Approve")
            {
                ApplicationArea = all;
            }
            field("Modify Approve Paymnet Vendor"; Rec."Modify Approve Paymnet Vendor")
            {
                ApplicationArea = all;

            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}