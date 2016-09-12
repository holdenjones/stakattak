-- Include Block
with screen;     use screen;
with genlib;     use genlib;
with hero;       use hero;
with dungeon;    use dungeon;
with item_pkg;   use item_pkg;
with combat_pkg; use combat_pkg;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
-- Include Block End

procedure StakAttak is

  -- --------------------------------------------------------------------------
  -- Name: stakattak.adb
  -- Authors: Holden Jones, Bryan Babines, Aaron Waner
  -- Project: Stak Attak
  -- Class: CS0458
  -- -------------------------------------------------------------------------

  -- Screen Procedures
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------

  procedure Swap_Item( Item : in Integer ) is
    M : MenuArray;
    C : str;
  begin -- Swap_Item
    Init_Menu( M );
    M(4) := strR("-- INVENTORY --");
    M(5) := strR("Swapping Tier") + strR( Integer'Image(Inventory(Item).all.Tier) ) + strR(" ") + Inventory(Item).all.Name;
    M(7) := strR("Select an item to swap with");
    for I in 1..10 loop
      if Inventory(I) /= NULL then
        if I = Item then
          M(8+I) := strR( Integer'Image(I) ) + strR(" - **Tier") + strR( Integer'Image(Inventory(I).all.Tier) ) + strR(" ") + Inventory(I).all.Name + strR("**");
        else
          M(8+I) := strR("%W") + strR(Integer'Image(I)) + strR("/") + strR(Integer'Image(I)) + strR(" - Tier") + strR( Integer'Image(Inventory(I).all.Tier) ) + strR(" ") + Inventory(I).all.Name;
        end if;
      else
        M(8+I) := strR("%W") + strR(Integer'Image(I)) + strR("/") + strR(Integer'Image(I)) + strR(" - Nothing");
      end if;
    end loop;

    M(20) := strR("%BACK/Back to Menu");

    C := MenuStart( M , 'T' ); 
    if getStr(C)(1) = 'W' then
      swapSlots( Inventory(Integer'Value(getStr(C)(2..getStr(C)'Last))) , Inventory(Item));
    end if;
  end Swap_Item;

  -- --------------------------------------------------------------------------

  procedure Equip_Menu( Item : in ItemPtr ; N : in Integer ) is
    M : MenuArray;
    C : str;
  begin -- Equip_Menu

    Init_Menu( M );
    
    M(4) := strR("-- Which hero would you like to equip to?  --");
    M(5) := strR("Item: Tier") + strR( Integer'Image(Item.all.Tier) ) + strR(" ") + Item.all.Name;

    for I in 1..6 loop
      if Heroes(I) /= NULL then
        M(6+I) := strR("%E") + strR(Integer'Image(I)) + strR("/") + strR(Integer'Image(I)) + strR(" - ") + Heroes(I).all.Name + strR( " (Base" ) + strR( Integer'Image(Heroes(I).all.Power) ) + strR(")");
      else
          M(6+I) := strR(Integer'Image(I)) + strR(" - Empty");
      end if;
    end loop;

    M(14) := strR("%BACK/Return to item");

    C := MenuStart( M , 'T' );

    if getStr(C)(1) = 'E' then
      swapItem( Heroes( Integer'Value(getStr(C)(2..getStr(C)'Last)) ) , Inventory(N) );
    end if;
  end Equip_Menu;

  -- --------------------------------------------------------------------------

  procedure Item_Menu( N : in Integer ) is
    M : MenuArray;
    C : str;
    Item : ItemPtr;
  begin -- Item_Menu

    Item := Inventory(N);

    Init_Menu( M );

    M(4) := strR( "Name: " ) + Item.all.Name;
    M(5) := strR( "Tier " ) + strR(Integer'Image(Item.all.Tier));
    M(6) := strR( "Power: " ) + strR(Integer'Image(Item.all.Power));

    if Item.all.Slot = 'W' then
      M(7) := strR( "Slot: Weapon" );
    else
      M(7) := strR( "Slot: Armor" );
    end if;

    M(8) := strR( "Adjective: " ) + strR(Adj_Item'Image(Item.all.Adjective)) + strR(" (") +strR( AdjItem_2_Desc( Item.all.Adjective) ) + strR(")");

    M(11) := strR( "%EQU/Equip to Hero" );
    M(12) := strR( "%SEL/Sell for " ) + strR(Integer'Image( SellPrice( Item ) )) + strR("g");
    M(13) := strR( "%SWAP/Swap slots" );

    M(15) := strR( "%EXIT/Return to Inventory" );

    C := MenuStart( M , 'T' );

    if getStr(C) = "EQU" then
      Equip_Menu( Item , N );
    elsif getStr(C) = "SEL" then
      Gold := Gold + SellPrice( Item );
      DelItem( Item );
      Inventory(N) := NULL;
    elsif getStr(C) = "SWAP" then
      Swap_Item( N );
    end if;
  end Item_Menu;

  -- -------------------------------------------------------------------------- 
 
  procedure Inventory_Menu is
    M : MenuArray;
    C : str;
  begin -- Inventory_Menu
    loop
      Init_Menu( M );
      M(4) := strR("-- INVENTORY --");
      M(5) := strR( Integer'Image( Gold ) ) + strR( " Gold");
      M(7) := strR("Select an item to see options");
      for I in 1..10 loop
        if Inventory(I) /= NULL then
          M(8+I) := strR("%S") + strR(Integer'Image(I)) + strR("/") + strR(Integer'Image(I)) + strR(" - Tier") + strR( Integer'Image(Inventory(I).all.Tier) ) + strR(" ") + Inventory(I).all.Name;
        else
          M(8+I) := strR(Integer'IMage(I)) + strR(" - Nothing");
        end if;
      end loop;

      M(20) := strR("%BACK/Back to Menu");

      C := MenuStart( M , 'T' );
      if getStr(C)(1) = 'S' then
        Item_Menu( Integer'Value(getStr(C)(2..getStr(C)'Last)) );
      elsif getStr(C) = "BACK" then
        exit;
      end if;
    end loop;
  end Inventory_Menu;

  -- --------------------------------------------------------------------------

  procedure Swap_Hero( H : in Integer ) is
    M : MenuArray;
    C : str;
    T : HeroPtr;
  begin -- Swap_Hero
    Init_Menu( M );
    M(4) := strR("-- HEROES --");
    M(5) := strR("Swapping ") + Heroes(H).all.Name + strR( " (Base" ) + strR( Integer'Image(Heroes(H).all.Power) ) + strR(")");
    M(7) := strR("Select a hero to swap with");
    for I in 1..6 loop
      if Heroes(I) /= NULL then
        if I = H then
          M(8+I) := strR( Integer'Image(I) ) + strR(" - **") + Heroes(I).all.Name + strR( " (Base" ) + strR( Integer'Image(Heroes(H).all.Power) ) + strR(")") + strR("**");
        else
          M(8+I) := strR("%W") + strR(Integer'Image(I)) + strR("/") + Heroes(I).all.Name + strR( " (Base" ) + strR( Integer'Image(Heroes(H).all.Power) ) + strR(")");
        end if;
      else
        M(8+I) := strR("%W") + strR(Integer'Image(I)) + strR("/") + strR(Integer'Image(I)) + strR(" - Nothing");
      end if;
    end loop;

    M(20) := strR("%BACK/Back to Menu");

    C := MenuStart( M , 'T' ); 

    if getStr(C)(1) = 'W' then
      T := Heroes(Integer'Value(getStr(C)(2..getStr(C)'Last)));
      Heroes(Integer'Value(getStr(C)(2..getStr(C)'Last))) := Heroes(H);
      Heroes(H) := T;
    end if;
  end Swap_Hero;

  -- -------------------------------------------------------------------------- 

  procedure View_Hero( He : in Integer ) is
    M : MenuArray;
    C : str;
    Heroe : HeroPtr;
  begin -- View_Hero

    Heroe := Heroes(He);
    loop
      Init_Menu( M );

      M(4) := strR( "Name: " ) + Heroe.all.Name;
      M(5) := strR( "Base Power: " ) + strR(Integer'Image(Heroe.all.Power));

      if Heroe.all.Weapon /= NULL then
        M(7) := strR( "Weapon: Tier") + strR( Integer'Image(Heroe.all.Weapon.all.Tier) ) + strR(" ") + Heroe.all.Weapon.all.Name + StrR(" (A: ") + StrR( Adj_Item'Image(Heroe.all.Weapon.all.Adjective) ) + StrR(")");
        M(11) := strR( "%UWEP/Unequip Weapon" );
      else
        M(7) := strR( "Weapon: N/A" );
      end if;

      if Heroe.all.Armor /= NULL then
        M(8) := strR( "Armor: Tier") + strR( Integer'Image(Heroe.all.Armor.all.Tier) ) + strR(" ") + Heroe.all.Armor.all.Name + StrR(" (A: ") + StrR( Adj_Item'Image(Heroe.all.Armor.all.Adjective) ) + StrR(")");
        M(12) := strR( "%UARM/Unequip Armor" );
      else
        M(8) := strR( "Armor: N/A" );
      end if;

      M(13) := strR( "%SWAP/Swap slots" );

      M(15) := strR( "%EXIT/Return to Menu" );

      C := MenuStart( M , 'T' );

      if getStr(C) = "UWEP" then
        for I in Inventory'Range loop
          if Inventory(I) = NULL then
            Inventory(I) := Heroe.all.Weapon;
            Heroe.all.Weapon := NULL;
          end if;
        end loop;
      elsif getStr(C) = "UARM" then
        for I in Inventory'Range loop
          if Inventory(I) = NULL then
            Inventory(I) := Heroe.all.Armor;
            Heroe.all.Armor := NULL;
          end if;
        end loop;
      elsif getStr(C) = "SWAP" then
        Swap_Hero( He );
        exit;
      else
        exit;  
      end if;
    end loop;
  end View_Hero;

  -- --------------------------------------------------------------------------
  
  procedure Hire_Hero is
    M : MenuArray;
    C : str;
  begin -- Hire_Hero;

    Init_Menu( M );

    M(6) := strR("-- HEROES FOR HIRE --");
    
    if Hire1 /= NULL then
      M(8) := strR("%HIRE1/1 - ") + Hire1.all.Name + strR(" (Base" ) + strR( Integer'Image(Hire1.all.Power) ) + strR(") - ") + strR( Integer'Image(Hire1.all.Power * 50) ) + strR(" Gold");
    else
      M(8) := strR("1 - N/A");
    end if;

    if Hire2 /= NULL then
      M(9) := strR("%HIRE2/2 - ") + Hire2.all.Name + strR(" (Base" ) + strR( Integer'Image(Hire2.all.Power) ) + strR(") - ") + strR( Integer'Image(Hire2.all.Power * 50) ) + strR(" Gold");
    else
      M(9) := strR("2 - N/A");
    end if;

    if Hire3 /= NULL then
      M(10) := strR("%HIRE3/3 - ") + Hire3.all.Name + strR(" (Base" ) + strR( Integer'Image(Hire3.all.Power) ) + strR(") - ") + strR( Integer'Image(Hire3.all.Power * 50) ) + strR(" Gold");
    else
      M(10) := strR("3 - N/A");
    end if;

    M(12) := strR("%BACK/Back to Heroes");

    C := MenuStart( M , 'T' );

    if getStr(C) = "HIRE1" then
      if Gold >= (Hire1.all.Power * 50) then
        for I in Heroes'Range loop
          if Heroes(I) = NULL then
            Heroes(I) := Hire1;
            Gold := Gold - (Hire1.all.Power * 50);
            Hire1 := getHero;
            exit;
          end if;
        end loop;
      end if;
    elsif getStr(C) = "HIRE2" then
 
      if Gold >= (Hire2.all.Power * 50) then
        for I in Heroes'Range loop
          if Heroes(I) = NULL then
            Heroes(I) := Hire2;
            Gold := Gold - (Hire2.all.Power * 50);
            Hire2 := getHero;
            exit;
          end if;
        end loop;
      end if;

    elsif getStr(C) = "HIRE3" then

      if Gold >= (Hire3.all.Power * 50) then
        for I in Heroes'Range loop
          if Heroes(I) = NULL then
            Heroes(I) := Hire3;
            Gold := Gold - (Hire3.all.Power * 50);
            Hire3 := getHero;
            exit;
          end if;
        end loop;
      end if;

    end if;

  end Hire_Hero;

  -- --------------------------------------------------------------------------

  procedure Heroes_Menu is
    M : MenuArray;
    C : str;
  begin -- Heroes_Menu

    loop
      Init_Menu( M );
      M(6) := strR("-- HEROES  --");

      for I in 1..6 loop
        if Heroes(I) /= NULL then
          M(7+I) := strR("%C") + strR(Integer'Image(I)) + strR("/") + strR(Integer'Image(I)) + strR(" - ") + Heroes(I).all.Name + strR( " (Base" ) + strR( Integer'Image(Heroes(I).all.Power) ) + strR(")");
        else
            M(7+I) := strR(Integer'Image(I)) + strR(" - Empty");
        end if;
      end loop;

      M(16) := strR("%SHOP/Hire new heroes");
      M(17) := strR("%BACK/Return to Menu");

      C := MenuStart( M , 'T' );

      if getStr(C)(1) = 'C' then
        View_Hero( Integer'Value(getStr(C)(2..getStr(C)'Last)) );
      elsif getStr(C) = "SHOP" then
        Hire_Hero;
      else
        exit;
      end if;
    end loop;
  end Heroes_Menu;

  -- -------------------------------------------------------------------------- 
  Function Dungeon_Menu return Character is
    M : MenuArray;
    C : str;
  begin -- Dungeon_Menu
    Init_Menu( M );
    M(2) := StrR("To fight a dungeon, you must have a party of 3 Adventurers.");
    M(3) := StrR("The first three slots of your Heroes List will be used.");
    M(6) := StrR("%RET/Return to Menu");
    if Heroes(1) /= NULL AND Heroes(2) /= NULL AND Heroes(3) /= NULL then
      M(4) := StrR("Do you wish to proceed with your current party?");
      M(5) := StrR("%CON/Continue!");
      C := MenuStart( M , 'W' );
      if getStr(C) = "CON" then
        Init_Menu( M );
        for I in 1..Current_Tier loop
          M(I) := StrR("%D") + StrR( Integer'Image(I) ) +StrR("/T") + StrR( Integer'Image(I)) + StrR(" - ") + Dungeons(I).all.Name;
        end loop;
        M(7) := StrR("%RET/Return to Menu");
        
        C := MenuStart( M , 'W' );

        if getStr(C) /= "RET" then
          if Fight_Dungeon( Dungeons(Integer'Value(getStr(C)(2..getStr(C)'Last))) ) = 'Q' then
            return 'Q';
          end if;
        end if;
      end if;
    else
      M(4) := StrR("You do not have a valid party. Rearrange or purchase more at the Heroes menu.");
      C := MenuStart( M , 'W' ); 
    end if;
    return ' ';
  end Dungeon_Menu;
  -- -------------------------------------------------------------------------- 
  procedure Infinite_Mode is
    M : MenuArray;
    C : str;
  begin -- Infinite_Mode

    Init_Menu( M );
    M(5) := strR("-- Infinite Mode --");
    M(7) := strR("This mode is currently unavailable.");
    M(8) := strR("It will probably never be added.");
    M(10) := strR("%BACK/Press Space to return to the Main Menu");

    C := MenuStart( M , 'T' );

  end Infinite_Mode;

  -- --------------------------------------------------------------------------

  function Options_Menu return Character is
    M : MenuArray;
    C : str;
  begin -- Options_Menu

    Init_Menu( M );
    M(5) := strR("-- OPTIONS MENU --");
    M(7) := strR("%RET/Return");
    M(8) := strR("%QUIT/Quit Game");

    C := MenuStart( M , 'T' );

    if getStr(C) = "QUIT" then
      return 'Q';
    end if;
    return ' ';
  end Options_Menu;

  -- --------------------------------------------------------------------------

  function Game_Menu return Character is
    M : MenuArray;
    C : str;
  begin -- Game_Menu
    loop
      Init_Menu( M );
      M(2) := strR("-- SELECT OPTION --");
      M(3) := strR("%DUNG/Fight a dungeon");
      M(4) := strR("%HERO/Manage heroes");
      M(5) := strR("%INV/Look at inventory");
      M(6) := strR("%OPT/Options");

      C := MenuStart( M , 'W' );

      if getStr(C) = "DUNG" then
        if Dungeon_Menu = 'Q' then
          return 'Q';
        end if;  
      elsif getStr(C) = "HERO" then
        Heroes_Menu;
      elsif getStr(C) = "INV" then
        Inventory_Menu;
      elsif getStr(C) = "OPT" then
        if Options_Menu = 'Q' then
          return 'Q';
        end if;
      end if;
    end loop;
  end Game_Menu;

  -- --------------------------------------------------------------------------

  procedure Reset_Game is
  begin -- Reset_Game

    genSeed;
    Items_Init;
    InitHeroList;
    Dungeon_Init;

    Heroes(1) := genHero;
    Heroes(2) := genHero;
    Heroes(3) := genHero;

    for I in 1..3 loop
      Heroes(I).all.Weapon := Gen_Item( 1 , 'W' );
      Heroes(I).all.Weapon.all.Adjective := None;
      Heroes(I).all.Armor:= Gen_Item( 1 , 'A' );
      Heroes(I).all.Armor.all.Adjective := None;
    end loop;

    MakeHeroList;

    Hire1 := getHero;
    Hire2 := getHero;
    Hire3 := getHero;


    for I in 1..6 loop
      Dungeons(I) := Gen_Dungeon( I );
    end loop;
    Set_Picture( StrR("STAGE1") );
  end Reset_Game;

  -- --------------------------------------------------------------------------

  procedure Main_Menu is
    M : MenuArray;
    C : str;
  begin -- Main_Menu
    loop

      Set_Picture( strR("MAINMENU") );

      Init_Menu( M );
      M(2) := strR(" -- MAIN MENU -- ");
      M(3) := strR("%START/Normal Mode");
      M(4) := strR("%INFI/Infinite Mode");
      M(5) := strR("%QUIT/Quit Game");

      C := MenuStart( M , 'W' );

      if getStr(C) = "START" then
          Reset_Game;
          if Game_Menu = 'Q' then
            exit;
          end if;
      elsif getStr(C) = "INFI" then
          Infinite_Mode;
      elsif getStr(C) = "QUIT" then
          exit;
      end if;

    end loop;
  end Main_Menu;

  -- --------------------------------------------------------------------------

begin -- StakAttak

  Main_Menu;

end StakAttak;
