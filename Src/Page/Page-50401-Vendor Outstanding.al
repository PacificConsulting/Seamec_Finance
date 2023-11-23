page 50401 "Vendor Outstanding"
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            cuegroup("MSME Vendor")
            {
                field(MSME; MSMETotal_RemainingAmt)
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        VenLedEntry: Record 25;
                        T25: Record 25;
                        Vend: Record Vendor;
                        vNo: Text;
                    Begin
                        T25.Reset();
                        T25.SetFilter("Remaining Amt. (LCY)", '>%1', 0);
                        T25.SetFilter("MSME Due Date", '<%1', Today);
                        T25.SetRange(MSME, true);
                        If T25.FindSet() then
                            repeat
                                T25.Mark(true);
                            until T25.Next() = 0;
                        T25.MarkedOnly(true);
                        IF Page.RunModal(29, T25) = Action::None then;
                    End;
                }
            }
            cuegroup("Non MSME Vendor")
            {
                field("Non MSME"; NonMSMETotal_RemainingAmt)
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        VenLedEntry: Record 25;
                        T25: Record 25;
                        vend: Record Vendor;
                        vNo: Text;
                    Begin
                        T25.Reset();
                        T25.SetFilter("Remaining Amt. (LCY)", '>%1', 0);
                        T25.SetFilter("Due Date", '<%1', Today);
                        T25.SetRange(MSME, false);
                        If T25.FindSet() then
                            repeat
                                T25.Mark(true);
                            until T25.Next() = 0;
                        T25.MarkedOnly(true);
                        IF Page.RunModal(29, T25) = Action::None then;
                    End;
                }
            }

        }
    }

    trigger OnOpenPage()
    begin
        Rec_VLE.Reset();
        Rec_VLE.SetFilter("Remaining Amt. (LCY)", '>%1', 0);
        Rec_VLE.SetFilter("MSME Due Date", '<%1', Today);
        Rec_VLE.SetRange(MSME, true);
        If Rec_VLE.FindSet() then
            repeat
                Rec_VLE.CalcFields("Remaining Amt. (LCY)");
                MSMETotal_RemainingAmt += Rec_VLE."Remaining Amt. (LCY)";
            until Rec_VLE.Next() = 0;

        VLE.Reset();
        VLE.SetFilter("Remaining Amt. (LCY)", '>%1', 0);
        VLE.SetFilter("Due Date", '<%1', Today);
        VLE.SetFilter("Vendor No.", vend1."No.");
        VLE.SetRange(MSME, false);
        If VLE.FindSet() then
            repeat
                VLE.CalcFields("Remaining Amt. (LCY)");
                NonMSMETotal_RemainingAmt += VLE."Remaining Amt. (LCY)";
            until VLE.Next() = 0;

    end;

    var
        Rec_VLE: Record "Vendor Ledger Entry";
        VLE: Record "Vendor Ledger Entry";
        MSMETotal_RemainingAmt: Decimal;
        NonMSMETotal_RemainingAmt: Decimal;
        vend1: Record Vendor;
        vendNo: Text;
        VNo1: Text;
        cnt: Integer;
}