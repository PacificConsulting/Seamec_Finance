page 50404 "Project & Cost Centre Values"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = 50402;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Costcentre Code"; Rec."Costcentre Code")
                {
                    ApplicationArea = All;
                }
                field("Project Code"; Rec."Project Code")
                {
                    ApplicationArea = all;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}