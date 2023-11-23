tableextension 50403 PurchInvHead extends "Purch. Inv. Header"
{
    fields
    {
        // Add changes to table fields here
        field(50009; "Invoice Receipt Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
    }

    var
        myInt: Integer;
}