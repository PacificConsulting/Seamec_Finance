page 50405 "Payment filter"
{
    PageType = ConfirmationDialog;

    layout
    {
        area(content)
        {
            field("Vendor No"; VendNo)
            {
                TableRelation = Vendor."No.";
                ApplicationArea = All;
            }
            field("From Date"; fromDate)
            {
                Caption = 'From Date';
                ApplicationArea = All;
            }
            field("To Date"; ToDate)
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
    }

    var
        Qty: Decimal;
        decQty: Decimal;
        BatchSize: Decimal;
        NoOfDrum: Integer;
        SBatchSize: Text;
        VendNo: Code[20];
        fromDate: Date;
        ToDate: Date;


    procedure RetVendoNo(): Code[20]
    begin
        EXIT(VendNo);
    end;

    procedure RetFromDate(): Date
    begin
        EXIT(fromDate);
    end;

    procedure RetToDate(): Date
    begin
        EXIT(ToDate);
    end;

}

