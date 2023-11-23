tableextension 50408 GlAccount extends "G/L Account"
{
    fields
    {
        // Add changes to table fields here
        field(50400; "Budget Mandatory"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}