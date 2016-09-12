with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with genlib; use genlib;
with item_pkg; use item_pkg;


procedure test_item is

    
  Test : ItemPtr;

  procedure Print_Item( T : ItemPtr ) is

  begin

    Put( getStr(T.all.Name) );
    Put( " - Tier " );
    Put( T.all.Tier , 0 );
    Put( " - Power " );
    Put( T.all.Power , 0 );
    Put( " - " );
    Put( T.all.Slot );
    Put( " - " );
    Put( AdjItem_2_Name( T.all.Adjective ) );
    Put( " - " );
    Put( AdjItem_2_Desc( T.all.Adjective ) );

  end Print_Item;

begin -- test_item;

  genSeed;
  Items_Init;

  -- --------------------------------------------------------------------------

  for I in 1..20 loop
    Test := Gen_Item( 2 );
    Print_Item( Test );
    New_Line;
  end loop;

end test_item; 
