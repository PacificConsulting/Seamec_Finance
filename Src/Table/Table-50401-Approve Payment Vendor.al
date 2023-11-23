// table 50401 "Approve Payment Vendor"
// {
//     DataClassification = ToBeClassified;

//     fields
//     {
//         field(1; "Invoice No"; Code[20])
//         {
//             DataClassification = ToBeClassified;
//             Editable = false;
//         }
//         field(2; "Invoice Date"; Date)
//         {
//             DataClassification = ToBeClassified;
//             Editable = false;
//         }
//         field(3; "Vendor No"; Code[20])
//         {
//             DataClassification = ToBeClassified;
//             Editable = false;
//             trigger OnValidate()
//             var
//                 vend: Record Vendor;
//             begin
//                 if vend.get("Vendor No") then;
//                 "Vendor Name" := vend.Name;
//             end;
//         }
//         field(4; "Vendor Name"; Text[100])
//         {
//             DataClassification = ToBeClassified;
//             Editable = false;
//         }

//         field(5; "Invoice Amount"; Decimal)
//         {
//             DataClassification = ToBeClassified;
//             Editable = false;
//         }
//         field(6; "Remaining Amount"; Decimal)
//         {
//             DataClassification = ToBeClassified;
//             Editable = false;
//         }
//         field(7; "MSME Vendor"; Boolean)
//         {
//             DataClassification = ToBeClassified;
//             Editable = false;
//         }
//         field(8; "Due Date"; Date)
//         {
//             DataClassification = ToBeClassified;
//             Editable = false;
//         }
//         field(9; "MSME Due Date"; Date)
//         {
//             DataClassification = ToBeClassified;
//             Editable = false;
//         }
//         field(11; "Amount to be Paid"; Decimal)
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(12; "Payment Release Date"; Date)
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(13; "Line No."; Integer)
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(14; Date; Date)
//         {
//             DataClassification = ToBeClassified;
//         }

//     }

//     keys
//     {
//         key(Key1; "Invoice No", "Line No.")
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