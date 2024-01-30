report 50401 "Bill for Pmnt. Detail-Payment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Src/Report Layout/PurchBillforPmntDetail1 - NEW.rdl';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            PrintOnlyIfDetail = true;
            column(Vendor_Name; Vendor.Name)
            {
            }
            column(Date; 'Date : ' + FORMAT(TODAY))
            {
            }
            column(ComName; recCompInfo.Name)
            {
            }
            dataitem("Approve Payment Vendor"; "Payment Suggestion")
            {
                DataItemLink = "Vendor No" = FIELD("No.");
                DataItemTableView = SORTING("Vendor No") where("Print Document" = FILTER('Yes'), "Remaining Amount" = filter(< 0), Status = filter('Approve'));//, "Posting Date", "Currency Code",Status=filter('Approve'))

                // WHERE(Open = FILTER(false),
                //       "Print Document" = FILTER(false));
                RequestFilterFields = "Invoice No";//"Document No.";
                column(BillNo; VLE."External Document No.")
                {
                }
                column(DocDate; VLE."Document Date")
                {
                }
                column(GrossAmount; dataGrossAmnt)
                {
                }
                column(TDSDeduction; dataTDSAmnt)
                {
                }
                column(NetAmount; dataNetAmnt)
                {
                }
                column(payableAmount; -"Remaining Amount")
                {
                }
                column(Project; VLE."Global Dimension 2 Code")
                {
                }
                column(OurRef; "Approve Payment Vendor"."Invoice No")//"Vendor Ledger Entry"."Document No.")
                {
                }
                column(NetAmtTotal; dataTotalNetAmnt)
                {
                }
                column(PayAmtTotal; -dataTotalPayableAmnt)
                {
                }
                column(OriginalAmtLCY_VendorLedgerEntry; VLE."Original Amt. (LCY)")
                {
                }
                column(AmountLCY_VendorLedgerEntry; -VLE."Amount (LCY)")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Approve Payment Vendor".Status <> "Approve Payment Vendor".Status::Approve then
                        CurrReport.Skip();
                    VLE.Reset();
                    VLE.SetRange("Document No.", "Approve Payment Vendor"."Invoice No");
                    if VLE.FindFirst() then;
                    Clear(dataGrossAmnt);
                    Clear(dataTDSAmnt);
                    Clear(dataNetAmnt);
                    recTDSEntry.RESET;
                    recTDSEntry.SETCURRENTKEY("Document No.", "Posting Date");
                    recTDSEntry.SETRANGE(recTDSEntry."Document No.", "Invoice No");//"Vendor Ledger Entry"."Document No.");
                    recTDSEntry.SETRANGE(recTDSEntry."Posting Date", "Invoice Date");//"Vendor Ledger Entry"."Posting Date");
                    //recTDSEntry.SETRANGE(recTDSEntry."Party Code", "Vendor No");//"Vendor Ledger Entry"."Vendor No.");
                    IF recTDSEntry.FIND('-') THEN
                        Repeat
                            dataGrossAmnt += recTDSEntry."Invoice Amount";
                            dataTDSAmnt += recTDSEntry."Total TDS Including SHE CESS";
                            dataNetAmnt += dataGrossAmnt - dataTDSAmnt;
                            cnttds += 1;
                        until recTDSEntry.Next() = 0;

                    if cnttds = 0 then BEGIN
                        VLE.CALCFIELDS("Original Amount");
                        dataGrossAmnt := -VLE."Original Amount";
                        dataTDSAmnt := 0;
                        dataNetAmnt := dataGrossAmnt - dataTDSAmnt;
                    END;

                    //Section Code VLE Body

                    VLE.CALCFIELDS(VLE."Remaining Amount");
                    VLE.CALCFIELDS("Amount (LCY)");
                    dataTotalNetAmnt := dataTotalNetAmnt + dataNetAmnt;
                    dataTotalPayableAmnt := dataTotalPayableAmnt + VLE."Remaining Amount";
                    //Section Code VLE Body
                end;

                trigger OnPreDataItem()
                begin
                    /*
                    //dataTotalNetAmnt := 0;
                    dataGrossAmnt := 0;
                    dataTDSAmnt := 0;
                    //dataTotalPayableAmnt := 0;
                    */

                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        recCompInfo.GET;
    end;

    var
        recCompInfo: Record 79;
        recTDSEntry: Record "TDS Entry";//13729;
        dataTDSAmnt: Decimal;
        dataGrossAmnt: Decimal;
        dataNetAmnt: Decimal;
        dataTotalNetAmnt: Decimal;
        dataTotalPayableAmnt: Decimal;
        VLE: Record "Vendor Ledger Entry";
        cnttds: Integer;
}

