pageextension 50404 postedpurchinv extends "Posted Purchase Invoice"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("Invoice Receipt Date"; Rec."Invoice Receipt Date")
            {
                ApplicationArea = all;
                Caption = 'Invoice/Good Receipt Date';
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