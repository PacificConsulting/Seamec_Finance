table 50400 "Payment Suggestion"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Invoice No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Vendor No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            var
                vend: Record Vendor;
            begin
                if vend.get("Vendor No") then;
                "Vendor Name" := vend.Name;
            end;
        }
        field(4; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(5; "Invoice Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Remaining Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "MSME Vendor"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "MSME Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; Select; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if Select then
                    "Amount to be Paid" := "Remaining Amount"
                else
                    "Amount to be Paid" := 0;
            end;
        }
        field(11; "Amount to be Paid"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "Amount to be Paid" > 0 then
                    Error('Please update correct amount');
            end;
        }
        field(12; "Payment Release Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(14; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Payment Approval ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(16; Status; Enum "Payment Status")
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18; Remark; Text[1024])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Select for Approve"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Print Document"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Delay Days"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22; "Costcentre Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
            //                                            Blocked = CONST(false));
        }
        field(23; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Project & Cost Centre Values"."Project Code" where("Costcentre Code" = field("Costcentre Code"));
        }

        field(24; "Bank Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account"."No.";
        }
        field(25; "Bank Payment Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Create Bank Voucher"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Rec.TestField("Bank Account No.");
                Rec.TestField("Bank Payment Date");
            end;
        }
        field(27; "Bank Voucher Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(30; "Batch Name"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = filter('BANKPAYMT'));
        }
    }

    keys
    {
        key(Key1; "Invoice No", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}