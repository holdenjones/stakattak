with stackpg;
with genlib; use genlib;
with item_pkg;  use item_pkg;
Package dungeon is
  
  --types
  type EnemyAdj is ( None , Flaming , Icy , Static , Aether, Giant , Frumious);
  type adjlist is array (1..2) of EnemyAdj;
  
  --Monster record
  TYPE Monster IS RECORD
    Name : str;
    Power : integer;
    Adj : adjlist;
    tier  : integer;
    difficulty : integer;
  END RECORD;
  
  --pointer and new package
  type MonsterPtr is access Monster;
  package mon is new stackpg(MonsterPtr);
  
  --dungeon record
  type DungeonType is record
    Mons : Mon.Stack;
    Def_Mons : Mon.Stack;
    Current : MonsterPtr;
    runs : integer := 0;
    name : str;
    tier : integer;
  end record;
  
  --Pointer
  type DungeonPtr is access DungeonType;
  
  --functions
  procedure Dungeon_Init;
  
  function Gen_Monster (T: in integer; D: in integer) return MonsterPtr;
  --Input: A tier and difficulty
  --Output: Random generated monster with tier and difficulty
  function Gen_Dungeon (T: in integer) return DungeonPtr;
  --Input: A tier
  --Output: Random Generated dungeon with certain amount of monsters
  function checkempty (S: in Mon.stack) return boolean;
  --Input: A stack
  --Output: true if empty or false if not empty
  procedure GetNext (S: in out Mon.stack; temp: in out MonsterPtr);
  --Input:  a stack
  --Output: A monster Ptr to a monster retrieved off the stack 
  function isWeak (A: in Adj_Item ; M: in MonsterPtr) return boolean;
  --Input: adjectives and a monster ptr
  --Output: if a creature is weak or not to a adj
  procedure KillMonster (M: in out MonsterPtr);
  --Input:  monster ptr
  --Output: Deallocate the monster ptr
  

end dungeon;
