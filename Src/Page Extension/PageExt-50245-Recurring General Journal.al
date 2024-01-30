pageextension 50245 MyExtension extends "Recurring General Journal"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Line")
        {
            action("Voucher Narration")
            {


                ApplicationArea = Basic, Suite;
                Caption = 'Voucher Narration';
                Image = LineDescription;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Select this option to enter narration for the voucher.';

                trigger OnAction()
                var
                    GenNarration: Record "Gen. Journal Narration";
                    VoucherNarration: Page "Voucher Narration";
                begin
                    GenNarration.Reset();
                    GenNarration.SetRange("Journal Template Name", rec."Journal Template Name");
                    GenNarration.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    GenNarration.SetRange("Document No.", rec."Document No.");
                    GenNarration.SetFilter("Gen. Journal Line No.", '%1', 0);
                    VoucherNarration.SetTableView(GenNarration);
                    VoucherNarration.RunModal();

                    // ShowOldNarration();
                    //  VoucherFunctions.ShowOldNarration(Rec);
                    CurrPage.Update(true);
                end;

            }
        }
    }

    var
        myInt: Integer;
}