With Ada.text_io;
With Ada.integer_text_io;
With item_pkg;
Use item_pkg;
With randlists;
With queues_generic;
With genlib;
Use genlib;

Package hero is
 
  type adventurer is record
    Name: str;
    Power: integer;
    Weapon: ItemPtr;
    Armor: ItemPtr;
  end record; 
 
  type heroPtr is access adventurer;
  
  type heroArr is array (1..6) of heroPtr;

  Heroes : heroArr;
  Hire1 : HeroPtr;
  Hire2 : HeroPtr;
  Hire3 : HeroPtr;

  Function genHero return heroPtr;
  --Input: Takes in a hero pointer, fills it with randomly generated data.
  --Output: Returns the hero pointer.
  
  Procedure swapItem(H: in out heroPtr; I: in out ItemPtr);
  --Input: Takes in an adventurer and a new item to equip them with.
  --Output: Swaps their current item and the new one, returns the item.
  
  Procedure initHeroList;
  --Input: None.
  --Output: Creates a list and fills it with names.
  
  Procedure makeHeroList;
  --Input: None.
  --Output: Generates 10 heroes and puts them into a queue.
  
  Function getHero return heroPtr;
  --Input: None.
  --Output: Dequeues a hero and returns it.
  
end hero;
