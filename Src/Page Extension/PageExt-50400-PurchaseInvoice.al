pageextension 50400 PurchInv extends "Purchase Invoice"
{
    layout
    {
        addafter("Payment Discount %")
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
        // Add changes to page layout here
        addafter("Posting Description")
        {
            field(MSME; MSME1)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("MSME No."; MSMENO)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            begin
                RecVen.Reset();
                RecVen.SetRange("No.", Rec."Buy-from Vendor No.");
                if RecVen.FindFirst() then begin
                    MSME1 := RecVen.MSME;
                    MSMENO := RecVen."MSME No.";
                end;
            end;
        }
    }

    actions
    {
        // Add changes to page actions here
        /*modify(Post)   temp comment
        {
            trigger OnBeforeAction()
            var
                Vend: Record Vendor;
                GenPostingSet: Record "General Posting Setup";
                PL: Record "Purchase Line";
                GLAcc: Record "G/L Account";
                GLBudEntries: Record "G/L Budget Entry";
                BudgAmt: Decimal;
                LineAmt: Decimal;
                BudLedEntry: Record "Budget Ledger Entry";
                EntrNo: Integer;
                BUdLedE: Record "Budget Ledger Entry";
                FinalBudgAmt: Decimal;
                Accperiod: Record "Accounting Period";
                EndDate: Date;
                StartDate: Date;
                EndDateT: Text;
            begin
                if Vend.Get(Rec."Buy-from Vendor No.") then;
                if Vend.MSME then begin
                    Rec.TestField("Invoice Receipt Date");
                end;

                //PCPL-25/240723
                Accperiod.Reset();
                Accperiod.SetRange("New Fiscal Year", true);
                if Accperiod.FindLast() then begin
                    EndDateT := FORMAT(Accperiod."Starting Date", 0, '<Day,2>/<Month,2>/<Year4>');
                    Evaluate(EndDate, EndDateT);
                    StartDate := CalcDate('<-1Y>', EndDate);
                    EndDate := CalcDate('<-1D>', EndDate);
                end;
                // Message(Format(StartDate));
                // Message(Format(EndDate));

                PL.Reset();
                PL.SetRange("Document No.", Rec."No.");
                PL.SetRange(Type, PL.Type::"G/L Account");
                if PL.FindSet() then
                    repeat
                        clear(FinalBudgAmt);
                        GenPostingSet.Reset();
                        GenPostingSet.SetRange("Gen. Bus. Posting Group", PL."Gen. Bus. Posting Group");
                        GenPostingSet.SetRange("Gen. Prod. Posting Group", PL."Gen. Prod. Posting Group");
                        GenPostingSet.SetRange("Purch. Account", PL."No.");
                        if GenPostingSet.FindFirst() then begin
                            if GLAcc.Get(GenPostingSet."Purch. Account") then;
                            if GLAcc."Budget Mandatory" then begin
                                GLBudEntries.Reset();
                                GLBudEntries.SetRange("G/L Account No.", GLAcc."No.");
                                GLBudEntries.SetRange("Global Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                                GLBudEntries.SetRange("Global Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
                                GLBudEntries.SetRange(Date, StartDate, EndDate);
                                if GLBudEntries.FindFirst() then
                                    repeat
                                        FinalBudgAmt += GLBudEntries.Amount;
                                    until GLBudEntries.Next() = 0;

                                Clear(LineAmt);
                                LineAmt := PL."Line Amount";//PL."Unit Cost" * PL."Qty. to Receive";

                                Clear(BudgAmt);
                                BudLedEntry.Reset();
                                BudLedEntry.SetRange("GL Code", PL."No.");
                                BudLedEntry.SetRange("Costcentre Code", Rec."Shortcut Dimension 1 Code");
                                BudLedEntry.SetRange("Project Code", Rec."Shortcut Dimension 2 Code");
                                BudLedEntry.SetRange("Document Date", StartDate, EndDate);
                                if BudLedEntry.FindSet() then
                                    repeat
                                        BudgAmt += BudLedEntry.Amount;
                                    until BudLedEntry.Next = 0;

                                if (FinalBudgAmt - BudgAmt) > LineAmt then begin
                                    BUdLedE.Reset();
                                    if BUdLedE.FindLast() then
                                        EntrNo := BUdLedE."Entry No.";

                                    BudLedEntry.Reset();
                                    BudLedEntry.SetRange("Document No.", PL."Document No.");
                                    BudLedEntry.SetRange("Document Line No.", PL."Line No.");
                                    if not BudLedEntry.FindFirst() then begin
                                        BudLedEntry.Init();
                                        BudLedEntry."Entry No." := EntrNo + 1;
                                        BUdLedE."Document No." := PL."Document No.";
                                        BudLedEntry."Document Date" := Rec."Posting Date";
                                        BudLedEntry."Document Line No." := PL."Line No.";
                                        BudLedEntry."Document Type" := BudLedEntry."Document Type"::Order;
                                        BudLedEntry."GL Code" := PL."No.";
                                        BudLedEntry.Amount := LineAmt;
                                        BudLedEntry."Created By" := UserId;
                                        BudLedEntry."Created Date" := Today;
                                        BudLedEntry."Costcentre Code" := Rec."Shortcut Dimension 1 Code";
                                        BudLedEntry."Project Code" := Rec."Shortcut Dimension 2 Code";
                                        BudLedEntry.Insert();
                                    end;
                                end
                                else
                                    Error('Budget amount greater than line amount');
                            end;
                        end;
                    until PL.Next() = 0;
                //PCPL-25/240723
            end;
        } */ //PCPL-25/280723 temp comment Costcentre and paymnet suggestion
    }

    trigger OnOpenPage()
    begin
        RecVen.Reset();
        RecVen.SetRange("No.", Rec."Buy-from Vendor No.");
        if RecVen.FindFirst() then begin
            MSME1 := RecVen.MSME;
            MSMENO := RecVen."MSME No.";
        end;
    end;

    var
        myInt: Integer;
        RecVen: Record Vendor;
        MSME1: Boolean;
        MSMENO: Text;

}