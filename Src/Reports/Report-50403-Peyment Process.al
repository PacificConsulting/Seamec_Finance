report 50403 "Payment Process"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            RequestFilterFields = "Posting Date", "Vendor No.";
            DataItemTableView = where("Document Type" = filter(Invoice | " "), "Remaining Amt. (LCY)" = filter(< 0));
            column(Posting_Date; "Posting Date")
            {

            }
            trigger OnPreDataItem()
            begin
                VendorNo := "Vendor Ledger Entry".GetFilter("Vendor No.");
                PDate := "Vendor Ledger Entry".GetFilter("Posting Date");
                "Vendor Ledger Entry".SetFilter("Document Type", '%1|%2', "Document Type"::Invoice, "Document Type"::" ");
                "Vendor Ledger Entry".SetFilter("Remaining Amt. (LCY)", '<%1', 0);
                if VendorNo <> '' then
                    "Vendor Ledger Entry".SetFilter("Vendor No.", VendorNo);
                if PDate <> '' then
                    "Vendor Ledger Entry".SetFilter("Posting Date", PDate);
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                "Vendor Ledger Entry".CalcFields("Amount (LCY)", "Remaining Amt. (LCY)");
                PayMsme.Reset();
                PayMsme.SetRange("Invoice No", "Vendor Ledger Entry"."Document No.");
                if PayMsme.FindFirst() then
                    LineNo := PayMsme."Line No." + 10000
                else
                    LineNo := 10000;

                PayMsme.Reset();
                PayMsme.SetRange("Invoice No", "Vendor Ledger Entry"."Document No.");
                if not PayMsme.FindFirst() then begin
                    PayMsme.Init();
                    PayMsme."Invoice No" := "Document No.";
                    PayMsme."Line No." := LineNo;
                    PayMsme.Insert();
                    PayMsme."Invoice Date" := "Posting Date";
                    PayMsme.Date := Today;
                    PayMsme.VALIDATE("Vendor No", "Vendor No.");
                    PayMsme."Invoice Amount" := "Amount (LCY)";
                    PayMsme."Remaining Amount" := "Remaining Amt. (LCY)";
                    PayMsme."MSME Vendor" := MSME;
                    PayMsme."Due Date" := "Due Date";
                    PayMsme."MSME Due Date" := "MSME Due Date";
                    PayMsme."Costcentre Code" := "Global Dimension 1 Code";
                    PayMsme."Project Code" := "Global Dimension 2 Code";
                    if (PayMsme."MSME Due Date" <> 0D) then
                        PayMsme."Delay Days" := PayMsme."MSME Due Date" - Today
                    else
                        if (PayMsme."Due Date" <> 0D) then
                            PayMsme."Delay Days" := PayMsme."Due Date" - Today;
                    PayMsme.Modify();
                end;
            end;
        }

    }

    // requestpage
    // {
    //     layout
    //     {
    //         area(Content)
    //         {
    //             group(GroupName)
    //             {
    //                 field(Name; SourceExpression)
    //                 {
    //                     ApplicationArea = All;

    //                 }
    //             }
    //         }
    //     }

    //     actions
    //     {
    //         area(processing)
    //         {
    //             action(ActionName)
    //             {
    //                 ApplicationArea = All;

    //             }
    //         }
    //     }
    // }


    var
        myInt: Integer;
        PayMsme: Record "Payment Suggestion";
        Selection: Integer;
        Text000: Label '&MSME,&Non MSME';
        VLE: Record "Vendor Ledger Entry";
        LineNo: Integer;
        PaySuggestion: Record "Payment Suggestion";
        UserSet: Record "User Setup";
        NumberOfRecords: Integer;
        Totamt: Decimal;
        TotInvAmt: Decimal;
        pgConfrmPage: Page 50405;
        VendorNo: Text;
        FromDt: Date;
        ToDt: Date;
        PDate: Text;
}