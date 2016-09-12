with genlib; use genlib;

package item_pkg is
  
  -- --------------------------------------------------------------------------
  -- Name: item_pkg.adb
  -- Author: Holden Jones
  -- Project: Stak Attak
  -- Class: CS0458
  -- --------------------------------------------------------------------------

  -- Data Types
  -- --------------------------------------------------------------------------

  -- Enumerate adjectives for items
  type Adj_Item is ( None , Flaming , Icy , Static , Aether , Giantkiller , Vorpal );

  -- ~~ Adjectives ~~
  -- Flaming 2x vs Icy
  -- Icy 2x vs Static
  -- Static 2x vs Aether
  -- Aether 2x vs Flaming
  -- Giantkiller 2x vs Large
  -- Vorpal 2x vs Frumious

  type ItemType is record
    Name : str;
    Power : Integer;
    Tier: Integer;
    Slot : Character;
    Adjective : Adj_Item;
  end record;

  type ItemPtr is access ItemType;
  
  type Inven is array (1..10) of ItemPtr;

  -- Variables
  -- --------------------------------------------------------------------------

  Inventory : Inven;
  Gold : Integer := 0;

  -- Procedures + Functions
  -- --------------------------------------------------------------------------

  -- Adj_Item Handlers

  function AdjItem_2_Name( Input : IN Adj_Item ) return String;
  -- IN: Any type of Adj_Item
  -- OUT: String containing its name as a string

  function AdjItem_2_Desc( Input : IN Adj_Item ) return String;
  -- IN: Any type of Adj_Item
  -- OUT: String containing a description of the effect

  -- --------------------------------------------------------------------------

  -- Item Handlers
  
  procedure Items_Init;

  function Gen_Item( Tier: IN Integer ; Slot: IN Character := ' ' ) return ItemPtr;
  -- IN: Tier of the item to generate
  -- OUT: A newly generated item, containing random characteristics.
  
  function SellPrice( Item : IN ItemPtr ) return Integer;
  -- IN: A pointer to an item
  -- OUT: A calculated integer price in gold

  procedure DelItem( Item : IN OUT ItemPtr );

  -- --------------------------------------------------------------------------
  
  procedure swapSlots(O: in out ItemPtr; T: in out ItemPtr);
  function SlotItem( Item : IN ItemPtr ) return Boolean; 
  ---------------------------------------------------------------------------
  
end item_pkg;
