tableextension 50405 PurchHead extends "Purchase Header"
{
    fields
    {
        // Add changes to table fields here
        field(50400; "Project Code"; Code[20])
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