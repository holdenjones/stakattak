Generic

  Type ElementType is private;

Package randlists is

  TYPE List IS PRIVATE;

  PROCEDURE Initialize(L: in out List);
  --Input: Non-initialized list
  --Output: Initialized list
  PROCEDURE AddItem (L: in out List; X: in ElementType);
  --Input: List and ElementType
  --Output: Added ElementType to end of list and Ln of list is increased
  Function GetRand (L: in List) return ElementType;
  --Input: List
  --Output: Random ElementType from the list
  
PRIVATE

  TYPE Node;
  TYPE Position IS ACCESS Node;

  TYPE Node IS RECORD
    Info: ElementType;
    Prev: Position;
    Next: Position;
  END RECORD;
  
  TYPE List IS RECORD
    First: Position;
    Last: Position;
    Ln: integer;
  END RECORD;
  
end randlists;