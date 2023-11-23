pageextension 50402 VendledEntry extends "Vendor Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Due Date")
        {
            field("MSME Due Date"; Rec."MSME Due Date")
            {
                ApplicationArea = all;
            }
        }
        addlast(Control1)
        {
            field("Bill of Entry No."; Rec."Bill of Entry No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Bill of Entry Date"; Rec."Bill of Entry Date")
            {
                ApplicationArea = all;
                Editable = false;
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