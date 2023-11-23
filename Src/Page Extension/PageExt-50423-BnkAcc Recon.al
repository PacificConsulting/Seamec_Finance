pageextension 50423 BankAccRecon extends "Bank Acc. Reconciliation"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter(ImportBankStatement)
        {
            action("Modify Ledger Entry")
            {
                RunObject = page "Modify Apply Bank Acc. Ledger";
                ApplicationArea = all;
                RunPageLink = "Bank Account No." = FIELD("Bank Account No."), Open = CONST(true), "Statement Status" = FILTER(Open | "Bank Acc. Entry Applied" | "Check Entry Applied");
            }
        }
    }

    var
        myInt: Integer;
}