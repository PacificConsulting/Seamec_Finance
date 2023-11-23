// page 50407 "Budget Ledger Entries"
// {
//     PageType = List;
//     //ApplicationArea = All;
//     UsageCategory = Lists;
//     SourceTable = "Budget Ledger Entry";

//     layout
//     {
//         area(Content)
//         {
//             repeater(GroupName)
//             {
//                 field("Entry No."; Rec."Entry No.")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field("Document Date"; Rec."Document Date")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field("Document Type"; Rec."Document Type")
//                 {
//                     ApplicationArea = All;
//                 }

//                 field("Document Line No."; Rec."Document Line No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Amount; Rec.Amount)
//                 {

//                 }
//                 field("Costcentre Code"; Rec."Costcentre Code")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Project Code"; Rec."Project Code")
//                 {
//                     ApplicationArea = all;

//                 }

//             }

//         }
//         area(Factboxes)
//         {

//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             action(ActionName)
//             {
//                 ApplicationArea = All;

//                 trigger OnAction();
//                 begin

//                 end;
//             }
//         }
//     }
// }