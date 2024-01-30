pageextension 50424 vendor_list extends "Vendor List"
{
    layout
    {
        addafter("Payments (LCY)")
        {
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = ALL;
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}