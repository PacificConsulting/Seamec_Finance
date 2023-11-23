pageextension 50421 GLAccountCard extends "G/L Account Card"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("Budget Mandatory"; Rec."Budget Mandatory")
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