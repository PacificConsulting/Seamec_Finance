enum 50400 "Payment Status"
{
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; "Pending Approval")
    {
        Caption = 'Pending Approval';
    }
    value(2; Approve)
    {
        Caption = 'Approve';
    }
    value(3; Reject)
    {
        Caption = 'Reject';
    }
}