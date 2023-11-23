// table 50403 "Budget Ledger Entry"
// {
//     DataClassification = ToBeClassified;

//     fields
//     {
//         field(1; "Entry No."; Integer)
//         {
//             DataClassification = ToBeClassified;
//             AutoIncrement = true;
//         }

//         field(2; "GL Code"; Code[20])
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(3; "Document Type"; Enum "Budget Type")
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(4; "Document Line No."; Integer)
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(5; "Amount"; Decimal)
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(6; "Created By"; Code[50])
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(7; "Created Date"; Date)
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(8; "Costcentre Code"; Code[20])
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(9; "Project Code"; Code[20])
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(10; "Document Date"; Date)
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(11; "Document No."; Code[20])
//         {
//             DataClassification = ToBeClassified;
//         }

//     }

//     keys
//     {
//         key(Key1; "Entry No.")
//         {
//             Clustered = true;
//         }
//     }

//     var
//         myInt: Integer;

//     trigger OnInsert()
//     begin

//     end;

//     trigger OnModify()
//     begin

//     end;

//     trigger OnDelete()
//     begin

//     end;

//     trigger OnRename()
//     begin

//     end;

// }