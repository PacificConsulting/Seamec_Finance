page 50408 "Tax Rate Modify"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Tax Rate";

    layout
    {
        area(Content)
        {
            repeater(control001)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                }
                field("Tax Type"; Rec."Tax Type")
                {
                    ApplicationArea = all;
                }
                field("Tax Setup ID"; Rec."Tax Setup ID")
                {
                    ApplicationArea = all;
                }
                field("Tax Rate ID"; Rec."Tax Rate ID")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    // actions
    // {
    //     area(Processing)
    //     {
    //         action(ActionName)
    //         {
    //             ApplicationArea = All;

    //             trigger OnAction()
    //             begin

    //             end;
    //         }
    //     }
    // }

    var
        myInt: Integer;
}