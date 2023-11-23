pageextension 50412 SalesCreditMemo extends "Sales Credit Memo"
{
    layout
    {
        // Add changes to page layout here
        addafter("Shortcut Dimension 1 Code")
        {
            field("Project Code"; Rec."Project Code")
            {
                ApplicationArea = all;
            }
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}