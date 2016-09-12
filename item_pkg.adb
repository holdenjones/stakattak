with genlib; use genlib;
with randlists;
with Ada.Text_IO; use Ada.Text_IO;
package body item_pkg is

  -- --------------------------------------------------------------------------
  -- Name: item_pkg.adb
  -- Author: Holden Jones
  -- Project: Stak Attak
  -- Class: CS0458
  -- --------------------------------------------------------------------------

  -- Package Variables
  -- --------------------------------------------------------------------------

  package RandList is new randlists ( str );

  Wep_Name : RandList.List;
  Armor_Name : RandList.List;

  -- Procedures + Function Bodies
  -- --------------------------------------------------------------------------

  function strmake( Input : IN String ) return str is
    Temp : str;
  begin
    setStr( Temp , Input );
    return Temp;
  end strmake;

  procedure Items_Init is
  begin -- Items_Init

    RandList.Initialize( Wep_Name );

    RandList.AddItem( Wep_Name , strR("Mace") );
    RandList.AddItem( Wep_Name , strR("Sword") );
    RandList.AddItem( Wep_Name , strR("Excalibur") );
    RandList.AddItem( Wep_Name , strR("Hammer") );
    RandList.AddItem( Wep_Name , strR("Axe") );


    RandList.Initialize( Armor_Name );
    RandList.AddItem( Armor_Name , strmake("Round Shield") );
    RandList.AddItem( Armor_Name , strmake("Helmet") );
    RandList.AddItem( Armor_Name , strmake("Chainmail") );
    RandList.AddItem( Armor_Name , strmake("Platemail") );
    RandList.AddItem( Armor_Name , strmake("Tower Shield") );
    RandList.AddItem( Armor_Name , strmake("Robes") );

  end Items_Init;

  -- --------------------------------------------------------------------------

  function AdjItem_2_Name( Input: IN Adj_Item ) return String is
  begin -- AdjItem_2_Name

    case Input is
      when None =>
        return "None";
      when Flaming =>
        return "Flaming";
      when Icy =>
        return "Icy";
      when Static =>
        return "Static";
      when Aether =>
        return "Aether";
      when Giantkiller =>
        return "Giantkiller";
      when Vorpal =>
        return "Vorpal";
    end case;

  end AdjItem_2_Name;

  -- --------------------------------------------------------------------------

  function AdjItem_2_Desc( Input: IN Adj_Item ) return String is
  begin -- AdjItem_2_Desc

    case Input is
      when None =>
        return "N/A";
      when Flaming =>
        return "Highly effective against Icy foes.";
      when Icy =>
        return "Highly effective against Static foes.";
      when Static =>
        return "Highly effective against Aether foes.";
      when Aether =>
        return "Highly effective against Flaming foes.";
      when Giantkiller =>
        return "Highly effective against Giant foes.";
      when Vorpal =>
        return "Highly effective against Frumious foes.";
    end case;

  end AdjItem_2_Desc;

  -- --------------------------------------------------------------------------

  function Gen_Item( Tier: IN Integer ; Slot: IN Character := ' ') return ItemPtr is
    TempItem : ItemPtr;
    AdjChance : Integer;
    S : Character;
  begin -- Gen_Item

    S := Slot;

    TempItem := new ItemType;

    TempItem.all.Power := genRand_Range( (Tier*12) , (Tier*2) );

    if S = ' ' then
      if GenRand(2) = 1 then
        S := 'W';
      else
        S := 'A';
      end if;
    end if;

    if S = 'W' then
      TempItem.all.Slot := 'W';
      setStr( TempItem.all.Name , getStr(RandList.GetRand( Wep_Name )) ); 
    else
      TemPitem.all.Slot := 'A';
      setStr( TempItem.all.Name , getStr(RandList.GetRand( Armor_Name )) ); 
    end if;
   


    AdjChance := genIndex( 100 );
    if AdjChance >= 1 AND AdjChance < 50 then
      -- Case: 1-49
      TempItem.all.Adjective := None;
    elsif AdjChance >= 50 AND AdjChance < 80 then
      -- Case: 50-80
      AdjChance := genIndex(4);
      case AdjChance is
        when 1 =>
          TempItem.all.Adjective := Flaming;
        when 2 =>
          TempItem.all.Adjective := Icy;
        when 3 =>
          TempItem.all.Adjective := Static;
        when 4 =>
          TempItem.all.Adjective := Aether;
        when others =>
          TempItem.all.Adjective := None;
      end case;
    elsif AdjChance >= 80 AND AdjChance < 95 then
      -- Case: 80-94
      TempItem.all.Adjective := Giantkiller;
    elsif AdjChance >= 95 then
      -- Case: 95-100
      TempItem.all.Adjective := Vorpal;
    end if;

    TempItem.all.Tier := Tier;

    return TempItem;
  end Gen_Item;

  -- --------------------------------------------------------------------------

  function SellPrice( Item : in ItemPtr ) return Integer is
  begin -- SellPrice

    return Item.all.Tier * 100;

  end SellPrice;

  -- --------------------------------------------------------------------------
  
  Procedure swapSlots(O: in out ItemPtr; T: in out ItemPtr) is
    Temp: ItemPtr;
  BEGIN
    Temp:= O;
    O:= T;
    T:= Temp;
  END swapSlots;

  -- --------------------------------------------------------------------------

  procedure DelItem( Item : in out ItemPtr ) is
  begin -- DelItem

    Item := NULL;
  
  end DelItem;

  -- --------------------------------------------------------------------------

  function SlotItem( Item : in ItemPtr ) return Boolean is
  begin -- SlotItem

    for I in Inventory'Range loop

      if Inventory(I) = NULL then
        Inventory(I) := Item;
        return TRUE;
      end if;

    end loop;

    Gold := Gold + SellPrice( Item );
    return FALSE;
  end SlotItem;

  -- --------------------------------------------------------------------------

end item_pkg;
