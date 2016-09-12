With Ada.text_io; use Ada.text_io;
With genlib; use genlib;
With Ada.integer_text_io; use Ada.integer_text_io;
With hero; use hero;
With dungeon; use dungeon;
With item_pkg; use item_pkg;
With screen; use screen;

Package combat_pkg is
 
  type DunList is array(1..6) of DungeonPtr;
  

  Current_Tier : Integer := 1;
  Dungeons : DunList;


  Function CalcPower(M: MonsterPtr) return integer;
  --Input: An array of hero pointers and a monster record.
  --Output: Calls heroPower for each hero in the array, returns their total 
  --power against a monster.
  
  Function heroPower(H: heroPtr; T: integer; M: MonsterPtr) return integer;
  --Input: Hero pointer and monster record.
  --Output: Returns the heroes power against that monster.
  
  Function Weakness(I: ItemPtr; M: MonsterPtr) return integer;
  --Input: An item pointer and a monster record to compare adjectives.
  --Output: Returns a boolean value based on if there is a weakness.
  
  Function combat(P: integer; M: MonsterPtr) return boolean;
  --Input: Takes in the party's total power and a monster pointer.
  --Output: Returns a boolean of whether the party succeeded combat.
 

  Procedure loot(T: Integer ; D: Integer);
 
  Function Fight_Dungeon( D: IN DungeonPtr ) return Character;

End combat_pkg;
