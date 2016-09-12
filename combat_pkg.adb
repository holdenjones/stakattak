With Ada.text_io; use Ada.text_io;
With Ada.integer_text_io; use Ada.integer_text_io;
With genlib; use genlib;
With hero; use hero;
With dungeon; use dungeon;
With screen; use screen;

Package body combat_pkg is
  
  -------------------------------------------------------
  Function CalcPower(M: MonsterPtr) return integer is
    groupPower: integer:= 0;
  BEGIN
    for i in 1..3 loop
      groupPower:= groupPower + heroPower(Heroes(i),M.all.Tier,M);
    end loop;
    return groupPower;
  END CalcPower;
  -------------------------------------------------------
  Function heroPower(H: heroPtr; T: integer; M: MonsterPtr) return integer is
    Total: integer:= 0;
  BEGIN
    --Base power added
    Total:= H.all.Power * T;
    
    --Weapon power added
    if H.all.Weapon /= NULL then
      Total:= Total+(H.all.Weapon.all.Power * Weakness(H.Weapon , M));    
    end if;
    --Armor power added
    if H.all.Armor /= NULL then
      Total:= Total+(H.all.Armor.all.Power * Weakness(H.Armor , M));
    end if;
    return Total;
  END heroPower;
  -------------------------------------------------------
  Function Weakness(I: ItemPtr; M: MonsterPtr) return Integer is
    EAd : EnemyAdj;
    EAd2 : EnemyAdj;
    IAd : Adj_Item;
  BEGIN -- Weakness
    IAd := I.all.Adjective;
    EAd := M.all.Adj(1);
    EAd2 := M.all.Adj(2);

    case IAd is
      when Flaming =>
        if EAd = Icy OR EAd2 = Icy then
          return 3;
        end if;
      when Icy =>
        if EAd = Static OR EAd2 = Static then
          return 3;
        end if;
      when Static =>
        if EAd = Aether OR EAd2 = Aether then
          return 3;
        end if;
      when Aether =>
        if EAd = Flaming OR EAd2 = Flaming then
          return 3;
        end if;
      when Giantkiller =>
        if EAd = Giant OR EAd2 = Giant then
          return 3;
        end if;
      when Vorpal =>
        if EAd = Frumious OR EAd2 = Frumious then
          return 3;
        end if;
      when None =>
        return 1;
    end case;
    return 1;
  END weakness;
  -------------------------------------------------------
  Function combat(P: integer; M: MonsterPtr) return boolean is
    outcome: boolean;
    percent: integer;
    random: integer;
  BEGIN

    percent:= integer(((float(P)/float(M.all.Power))*100.0));
    
    random:= genIndex(100);
    
    if random <= percent then
      outcome:= true;
    else
      outcome:= false;
    end if;
    return outcome;
  END combat;
  -------------------------------------------------------
  Procedure loot(T: integer; D: integer) is
    M: MenuArray;
    C: str;
    lootGold: integer;
    lootItem: ItemPtr;
    lootSlot: boolean;
  BEGIN
    Init_Menu(M);
    
    M(2) :=  strR(" -- LOOT -- ");

    if D=1 then
      -- difficulty 1
      lootGold:= T*50;
      M(3):= strR("You got") + strR(Integer'Image(lootGold)) + strR(" gold. ");
      Gold := Gold + lootGold;
    elsif D=2 then
      -- difficulty 2
      lootGold:= T*100;
      M(3):= strR("You got") + strR(Integer'Image(lootGold)) + strR(" gold. ");

      lootItem:= Gen_Item(T+1);
      lootSlot:= SlotItem(lootItem);
      M(4) := strR("Tier") + strR( Integer'Image(lootItem.all.Tier) ) + strR(" ") + lootItem.all.Name + strR(" (A: ") + strR( Adj_Item'Image(lootItem.all.Adjective) ) + strR(")");
      if lootSlot=false then
        M(4):= M(4) + strR(" (No room, converted to gold)");
        lootGold := lootGold + SellPrice( lootItem );
      end if;

      lootItem:= Gen_Item(T+1);
      lootSlot:= SlotItem(lootItem);
      M(5) := strR("Tier") + strR( Integer'Image(lootItem.all.Tier) ) + strR(" ") + lootItem.all.Name + strR(" (A: ") + strR( Adj_Item'Image(lootItem.all.Adjective) ) + strR(")");
      if lootSlot=false then
        M(5):= M(5) + strR(" (No room, converted to gold)");
        lootGold := lootGold + SellPrice( lootItem );
      end if;

      Gold := Gold + lootGold;
    elsif D=3 then
      -- difficulty 3
      lootGold:= T*200;
      M(3):= strR("You got") + strR(Integer'Image(lootGold)) + strR(" gold. ");

      lootItem:= Gen_Item(T+1);
      lootSlot:= SlotItem(lootItem);
      M(4) := strR("Tier") + strR( Integer'Image(lootItem.all.Tier) ) + strR(" ") + lootItem.all.Name + strR(" (A: ") + strR( Adj_Item'Image(lootItem.all.Adjective) ) + strR(")");
      if lootSlot=false then
        M(4):= M(4) + strR(" (No room, converted to gold)");
        lootGold := lootGold + SellPrice( lootItem );
      end if;
      lootItem:= Gen_Item(T+1);
      lootSlot:= SlotItem(lootItem);
      M(5) := strR("Tier") + strR( Integer'Image(lootItem.all.Tier) ) + strR(" ") + lootItem.all.Name + strR(" (A: ") + strR( Adj_Item'Image(lootItem.all.Adjective) ) + strR(")");
      if lootSlot=false then
        M(5):= M(5) + strR(" (No room, converted to gold)");
        lootGold := lootGold + SelLPrice( lootItem );
      end if;

      Gold := Gold + lootGold;
    end if;
    M(6) := strR("%BACK/Continue");

    C := MenuStart( M , 'W');
  END loot;
  -------------------------------------------------------
  Function Name_Monst( Mon : IN MonsterPtr ) return Str is
  begin -- Name_Monst

    if Mon.all.Adj(1) = None AND Mon.all.Adj(2) = None then
      return Mon.all.Name;
    elsif Mon.all.Adj(1) /= None AND Mon.all.Adj(2) = None then 
      return StrR( EnemyAdj'Image(Mon.all.Adj(1)) ) + StrR(" ") + Mon.all.Name;
    elsif Mon.all.Adj(1) /= None AND Mon.all.Adj(2) /= None then
      return StrR( EnemyAdj'Image(Mon.all.Adj(1)) ) + StrR(" ") + StrR( EnemyAdj'Image(Mon.all.Adj(2)) ) + StrR(" ") + Mon.all.Name;    
    end if;

    return Mon.all.Name;

  end Name_Monst;
  -------------------------------------------------------
  Procedure Restack ( D : IN DungeonPtr ) is
  begin -- Restack

    if D.all.Current /= NULL then
      mon.AddToStack( D.all.mons , D.all.Current );
      D.all.Current := NULL;
    end if;

    while not checkempty( D.all.Def_Mons ) loop

      GetNext( D.all.Def_Mons , D.all.Current );

      mon.AddToStack( D.all.Mons , D.all.Current );
      D.all.Current := NULL;

    end loop;

  end Restack;
  -------------------------------------------------------
  Function Fight_Dungeon( D : IN DungeonPtr ) return Character is
    M : MenuArray;
    C : str;
    I : Integer := 0;
    P : Integer;
  begin -- Fight_Dungeon

    Init_Menu(M);

    M(2) := StrR("As your party approaches the dungeon, they notice a sign:");
    M(3) := StrR("'") + D.all.Name + StrR("'");
    if D.all.Runs <= 0 then
      M(4) := StrR("A dark aura still curses the land here..");
    else
      M(4) := StrR("We've defeated the evil here") + StrR( Integer'Image(D.all.Runs) ) + StrR(" time(s).");
    end if;
    M(5) := StrR("%CON/Continue..");

    C := MenuStart( M , 'W' );

    while not checkempty( D.all.Mons ) loop

      Init_Menu(M);

      if D.all.Current = NULL then
        GetNext( D.all.Mons , D.all.Current );
      end if;


      M(2) := strR("You face a ") + Name_Monst( D.all.Current ) + strR(" in the dungeon!");


      M(3) := StrR("Your party charges towards it!");
      P := integer((float(CalcPower(D.all.Current))/float(D.all.Current.all.Power)*100.0));
      if P > 100 then
        M(4) := StrR("It looks like an easy fight.");
      elsif P > 80 then
        M(4) := StrR("It looks rather equal in power.");
      elsif P > 50 then
        M(4) := StrR("It looks like it might be tough..");
      else
        M(4) := StrR("It looks deathly powerful!");
      end if;
      M(5) := StrR("%CON/Continue..");

      C := MenuStart( M , 'W' );

      Init_Menu(M);

      if combat( CalcPower(D.all.Current) , D.all.Current ) then
        -- Party win
        M(2) := StrR("The ") + Name_Monst( D.all.Current ) + StrR(" falls dead to the ground!");
        M(3) := StrR("Your party stands victorious!");

        M(5) := StrR("%CON/Continue..");

        C := MenuStart( M , 'W');

        loot( D.all.Current.all.Tier , D.all.Current.all.Difficulty );
        mon.AddToStack( D.all.Def_Mons, D.all.Current );
        D.all.Current := NULL;     

      else
        -- Party fail
        M(2) := StrR("Your party is defeated!");
        M(3) := StrR("The ") + Name_Monst( D.all.Current ) + StrR(" was too powerful..");

        if integer((float(CalcPower(D.all.Current))/float(D.all.Current.all.Power)*100.0)) < 50 then
          if genIndex(2) = 1 then
            I := GenIndex(3);
            M(4) := Heroes(I).all.Name + StrR(" was lost in the one-sided battle...");
            Heroes(I) := NULL;
          end if;
        end if;

        M(6) := StrR("%CON/Continue..");

        C := MenuStart( M , 'W' );
        
        exit;
      end if;

    end loop;
    if D.all.Current = NULL then
      D.all.Runs := D.all.Runs + 1;
      if Current_Tier = D.all.Tier then
        Current_Tier := Current_Tier + 1;
        if Current_Tier >= 7 then
          Init_Menu( M );
          M(2) := StrR("At the defeat of their creator, the dungeons crumble to the ground.");
          M(3) := StrR("You have defeated the evil that was here!");
          M(4) := StrR("You are victorious!");
          M(5) := StrR("%WIN/Press Space to Exit");

          C := MenuStart( M , 'W' );
          return 'Q';
        end if;
      end if;
    end if;
    Restack( D );
    return ' ';
  end Fight_Dungeon;
  
End combat_pkg;
