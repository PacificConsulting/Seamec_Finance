tableextension 50404 UserSet extends "User Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50400; "Payment Suggestion Approval 1"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            Caption = 'Payment Suggestion Approval';
        }
        field(50402; "Approve Payment Suggestion"; Boolean)
        {
            Caption = 'Approve/Reject Payment Suggestion';
            DataClassification = ToBeClassified;
        }
        field(50403; "Update Payment Approve"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50404; "Modify Approve Paymnet Vendor"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}