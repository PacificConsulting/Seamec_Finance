permissionset 50400 GeneratedPermission1
{
    Assignable = true;
    Permissions = tabledata "Payment Suggestion" = RIMD,
        tabledata "Project & Cost Centre Values" = RIMD,
        table "Payment Suggestion" = X,
        table "Project & Cost Centre Values" = X,
        report "Bill for Pmnt. Detail-Payment" = X,
        report "Bill for RTGS/NEFT Payment" = X,
        report "Payment Process" = X,
        report "RTGS/NEFT Payment" = X,
        codeunit Events = X,
        page "Approve Payment Vendor" = X,
        page "Payment filter" = X,
        page "Payment Suggestion" = X,
        page "Payment Suggestion Approval" = X,
        page "Project & Cost Centre Values" = X,
        page "Vendor Outstanding" = X,
        report "Update Approve Payment Vendor" = X,
        report "Update Vendor Ledger Entry" = X,
        xmlport "G/L Entry 1" = X,
        xmlport "Salary Upload1" = X,
        page "Tax Rate Modify" = X;
}