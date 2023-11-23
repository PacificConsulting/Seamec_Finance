pageextension 50422 applypostcustledentry extends "Apply Bank Acc. Ledger Entries"
{

    layout
    {
        // Add changes to page layout here
        addafter("Posting Date")
        {
            field("Clearing Date"; Rec."Clearing Date")
            {
                ApplicationArea = all;
                Editable = true;
                AccessByPermission = TableData "Bank Account Ledger Entry" = RIMD;

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