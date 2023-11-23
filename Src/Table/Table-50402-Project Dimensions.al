table 50402 "Project & Cost Centre Values"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Costcentre Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));
        }
        field(2; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));
        }
    }

    keys
    {
        key(Key1; "Costcentre Code", "Project Code")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;


}