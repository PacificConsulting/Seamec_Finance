tableextension 50407 vend extends Vendor
{
    fields
    {
        // Add changes to table fields here
        field(50400; "MSME Due Days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}