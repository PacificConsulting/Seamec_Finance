tableextension 50402 GenJnlLine extends "Gen. Journal Line"
{
    fields
    {
        // Add changes to table fields here
        field(50400; "MSME Due Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(50401; "Project Code"; Code[20])
        {
            Caption = 'Project Code';
            TableRelation = "Project & Cost Centre Values"."Project Code" where("Costcentre Code" = field("Shortcut Dimension 1 Code"));

            trigger OnValidate()
            begin
                Rec.Validate("Shortcut Dimension 2 Code", "Project Code");
            end;
        }
        modify("Shortcut Dimension 1 Code")
        {
            trigger OnAfterValidate()
            begin
                Validate("Project Code", '');
            end;
        }

    }

    var
        myInt: Integer;
}