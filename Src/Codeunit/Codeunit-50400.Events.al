codeunit 50400 Events
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        PurPay: Record "Purchases & Payables Setup";
        vend: Record Vendor;
        Msmetext: Text;
    //CU 12 start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeVendLedgEntryInsert', '', true, true)]
    local procedure OnBeforeVendLedgEntryInsert(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register")
    begin
        VendorLedgerEntry."MSME Due Date" := GenJournalLine."MSME Due Date";
        VendorLedgerEntry."Bill of Entry Date" := GenJournalLine."Bill of Entry Date"; //PCPL-25/060923
        VendorLedgerEntry."Bill of Entry No." := GenJournalLine."Bill of Entry No.";   //PCPL-25/060923

    end;
    //CU 12 end

    //Table 81 start
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeader', '', true, true)]
    local procedure OnAfterCopyGenJnlLineFromPurchHeader(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        PurPay.Get();
        if vend.Get(PurchaseHeader."Buy-from Vendor No.") then;
        //GenJournalLine."MSME Due Date" := CalcDate(format(PurPay."MSME Due Days") + 'D', PurchaseHeader."Invoice Receipt Date");
        if Vend."MSME Due Days" <> 0 then
            GenJournalLine."MSME Due Date" := CalcDate(format(Vend."MSME Due Days") + 'D', PurchaseHeader."Invoice Receipt Date")
        else
            GenJournalLine."MSME Due Date" := PurchaseHeader."Invoice Receipt Date";

        GenJournalLine."Bill of Entry Date" := PurchaseHeader."Bill of Entry Date";
        GenJournalLine."Bill of Entry No." := PurchaseHeader."Bill of Entry No.";

    end;
    //Table 81 end


}