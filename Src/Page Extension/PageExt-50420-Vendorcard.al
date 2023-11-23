pageextension 50420 Vendcard extends "Vendor Card"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("MSME Due Days"; Rec."MSME Due Days")
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