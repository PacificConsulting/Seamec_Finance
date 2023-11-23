// page 50410 test
// {

//     ApplicationArea = All;
//     UsageCategory = Administration;
//     SourceTable = 271;
//     DelayedInsert = true;
//     AutoSplitKey = true;
//     PageType = ListPart;

//     layout
//     {
//         area(Content)
//         {
//             repeater(GroupName)
//             {
//                 field("Clearing Date"; Rec."Clearing Date")
//                 {
//                     ApplicationArea = All;
//                     Editable = true;

//                 }
//                 field("Posting Date"; Rec."Posting Date")
//                 {

//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             action(ActionName)
//             {
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 begin

//                 end;
//             }
//         }
//     }

//     var
//         myInt: Integer;
// }