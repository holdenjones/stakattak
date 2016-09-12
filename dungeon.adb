with stackpg;
with randlists;
WITH Unchecked_Deallocation;
with genlib;  use genlib;
with item_pkg;  use item_pkg;
with Ada.Text_IO; use Ada.Text_IO;
with ada.integer_text_io; use ada.integer_text_io;
package body dungeon is


  --To free up memory
  PROCEDURE Dispose IS 
    NEW Unchecked_Deallocation(Object => Monster, Name => MonsterPtr);
    
  PROCEDURE Deallocate (P: IN OUT MonsterPtr) IS
  BEGIN
    Dispose (X => P);
  END Deallocate;

  --initialize generic stack
  package RandList is new randlists ( str );

  MonsterName : RandList.List;
  DungeonName : RandList.List;
  -------------------------------------------------------
  procedure Dungeon_Init is
  begin -- Dungeon_Init
  
    RandList.Initialize( MonsterName );

    RandList.AddItem( MonsterName , strR("Ogre") );
    RandList.AddItem( MonsterName , strR("Skogre") );
    RandList.AddItem( MonsterName , strR("Mimic") );
    RandList.AddItem( MonsterName , strR("Homunculus") );
    RandList.AddItem( MonsterName , strR("Fairy") );
    RandList.AddItem( MonsterName , strR("Vampire") );
    RandList.AddItem( MonsterName , strR("Siren") );
    RandList.AddItem( MonsterName , strR("Beholder") );
    RandList.AddItem( MonsterName , strR("Harpy") );
    RandList.AddItem( MonsterName , strR("Slime") );
    RandList.AddItem( MonsterName , strR("Heather") );
    RandList.AddItem( MonsterName , strR("Zombie") );
    RandList.AddItem( MonsterName , strR("Orc") );
    RandList.AddItem( MonsterName , strR("Fairy") );
    RandList.AddItem( MonsterName , strR("Shaman") );
    RandList.AddItem( MonsterName , strR("Hedgehog") );
    RandList.AddItem( MonsterName , strR("Barbarian") );
    RandList.AddItem( MonsterName , strR("Assassin") );
    RandList.AddItem( MonsterName , strR("Wizard") );
    RandList.AddItem( MonsterName , strR("Balrog") );

    RandList.Initialize( DungeonName );

    RandList.AddItem( DungeonName , strR("Mount Doom") );
    RandList.AddItem( DungeonName , strR("Caverns of Peganon") );
    RandList.AddItem( DungeonName , strR("Under Dome") );
    RandList.AddItem( DungeonName , strR("Castle of Zendikar") );
    RandList.AddItem( DungeonName , strR("Swiss Gear Emporium") );
    RandList.AddItem( DungeonName , strR("To-ota") );
    RandList.AddItem( DungeonName , strR("Hellgate") );
    RandList.AddItem( DungeonName , strR("Something Castle") );
    RandList.AddItem( DungeonName , strR("The Pit of Eternal Spikes") );
    RandList.AddItem( DungeonName , strR("Aincrad") );
    RandList.AddItem( DungeonName , strR("The Swamp of Mild Allowance") );
    RandList.AddItem( DungeonName , strR("The Swamp of Mild Annoyance") );
    RandList.AddItem( DungeonName , strR("Pittsburgh Roadways") );
    RandList.AddItem( DungeonName , strR("The Dark Cloud") );
    RandList.AddItem( DungeonName , strR("Windy Woodlands") );
    RandList.AddItem( DungeonName , strR("Frazzle Rock") );
    RandList.AddItem( DungeonName , strR("Doomed Isle") );
    RandList.AddItem( DungeonName , strR("Caverns of Time") );
    RandList.AddItem( DungeonName , strR("Mt. Hyjal") );
    RandList.AddItem( DungeonName , strR("Space Temple") );
    RandList.AddItem( DungeonName , strR("Water Temple") );





  end Dungeon_Init;
  ------------------------------------------------------------
  function genAdj return EnemyAdj is
    AdjChance : integer;
  begin --genAdj
    AdjChance := genIndex( 50 );
    if AdjChance >= 1 AND AdjChance < 30 then
      -- Case: 1-30
      AdjChance := genIndex(4);
      case AdjChance is
        when 1 =>
          return Flaming;
        when 2 =>
          return Icy;
        when 3 =>
          return Static;
        when 4 =>
          return Aether;
        when others =>
          return None;
      end case;
    elsif AdjChance >= 30 AND AdjChance < 45 then
      -- Case: 30-45
      return Giant;
    elsif AdjChance >= 45 then
      -- Case: 45-50
      return Frumious;
    end if;
    return None;
  end genAdj;
  
  ------------------------------------------------
  function Gen_Monster (T: in integer; D: in integer) return MonsterPtr is
    temp : MonsterPtr;
  begin --Gen_Monster
    
    Temp := new Monster;
    temp.all.Name := RandList.GetRand (MonsterName);
    
    temp.all.tier := T;
    if T = 1 OR T = 2 then
      if D = 1 then
        temp.all.Power := genRand_Range( Integer(Float(85*T) * 1.1) , T*2 );
        temp.all.adj(1) := None;
        temp.all.adj(2) := None;
      elsif D = 2 then
        temp.all.Power := genRand_Range( Integer(Float(100*T) * 1.1) , T*2 );
        temp.all.adj(1) := genAdj;
        temp.all.adj(2) := None;
      end if;
    else 
      if D = 1 then
        temp.all.Power := genRand_Range( Integer(Float(85*T) * 1.1) , T*2 );
        temp.all.adj(1) := None;
        temp.all.adj(2) := None;
      elsif D = 2 then
        temp.all.Power := genRand_Range( Integer(Float(100*T) * 1.1) , T*2 );
        temp.all.adj(1) := genAdj;
        temp.all.adj(2) := None;
      elsif D = 3 then
        temp.all.Power := genRand_Range( Integer(Float(130*T) * 1.1) , T*2 );
        temp.all.adj(1) := genAdj;
        temp.all.adj(2) := genAdj;
      end if;
    end if;
    
    temp.all.Difficulty := D;
    return temp;
  end Gen_Monster;
  ------------------------------------------------
  function Gen_Dungeon (T: in integer) return DungeonPtr is
    temp : DungeonPtr;
  begin --Gen_Dungeon
    temp := new DungeonType;
    mon.Initialize( temp.all.mons );
    if T = 1 OR T = 2 then
      mon.AddToStack ( temp.all.mons, Gen_Monster(T,2) );
      mon.AddToStack ( temp.all.mons, Gen_Monster(T,1) );
      mon.AddToStack ( temp.all.mons, Gen_Monster(T,1) );
    else
      mon.AddToStack ( temp.all.mons, Gen_Monster(T,3) );
      mon.AddToStack ( temp.all.mons, Gen_Monster(T,1) );
      mon.AddToStack ( temp.all.mons, Gen_Monster(T,2) );
      mon.AddToStack ( temp.all.mons, Gen_Monster(T,1) );
      mon.AddToStack ( temp.all.mons, Gen_Monster(T,1) );
    end if;
    Temp.all.runs := 0;
    temp.all.Name := RandList.GetRand (DungeonName);
    temp.all.tier := T;
    return temp;
  end Gen_Dungeon;
  ------------------------------------------------------
  function checkempty (S: in Mon.stack) return boolean is
  begin --checkempty
    return mon.IsEmpty(S);
  end checkempty;
  ------------------------------------------------
  procedure GetNext (S: in out Mon.stack; temp: in out MonsterPtr) is
  begin --GetNext
      mon.Retrieve (S,temp);
  end GetNext;
  ---------------------------------------------------
  function WeakGet( A: in Adj_Item ; B: in EnemyAdj ) return Boolean is
  begin
    case A is
    
      when Flaming =>
        if B = Icy then
          return TRUE;
        else
          return FALSE;
        end if;
        
      when Icy =>
        if B = Static then
          return TRUE;
        else
          return FALSE;
        end if;
        
      when Static =>
        if B = Aether then
          return TRUE;
        else
          return FALSE;
        end if;
        
      when Aether =>
        if B = Flaming then
          return TRUE;
        else
          return FALSE;
        end if;
        
      when Giantkiller =>
        if B = Giant then
          return TRUE;
        else 
          return FALSE;
        end if;
        
      when Vorpal =>
        if B = Frumious then
          return TRUE;
        else
          return FALSE;
        end if;
        
      when others =>
        return FALSE;
        
    end case;
  end WeakGet;
  ---------------------------------------------------
  function isWeak (A: in Adj_Item ; M: in MonsterPtr) return boolean is
    
  begin --isWeak
  
    if WeakGet( A , M.all.Adj(1) ) then
      return TRUE;
    end if;
    
    if WeakGet( A , M.all.Adj(2) ) then
      return TRUE;
    end if;
    
    return FALSE;
    
  end isWeak;
  ----------------------------------------------------
  procedure KillMonster (M: in out MonsterPtr) is
  begin --KillMonster
    Deallocate(M);
  end KillMonster;
end dungeon;
