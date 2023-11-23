tableextension 50401 VendorLedEntry extends "Vendor Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50400; "MSME Due Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(50401; MSME; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.MSME where("No." = field("Vendor No.")));
        }
        field(50402; "Bill of Entry No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50403; "Bill of Entry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}