pageextension 50403 OrderProccessorExt extends "Order Processor Role Center"
{
    layout
    {
        addafter(Control1901851508)
        {
            part(VendorOutstanding; "Vendor Outstanding")
            {
                ApplicationArea = All;
            }
        }
    }

    var
        myInt: Integer;
}