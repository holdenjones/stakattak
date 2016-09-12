WITH Unchecked_Deallocation;
WITH genlib;  use genlib;
package body randlists is

  --Initialize doubly linked list
  PROCEDURE Initialize(L: in out List) IS
  BEGIN
      L.First := NULL;
      L.Last := NULL;
      L.Ln := 0; --for length
  END Initialize;
  
  --Add a item to the list
  PROCEDURE AddItem (L: in out List; X: in ElementType) is
    Temp: Position;
  BEGIN
    Temp := NEW Node'(Info => X, Prev => NULL, Next => NULL);
    if L.First = NULL then
      L.First := Temp;
      L.Last := Temp;
      L.Ln := L.Ln + 1;
    else
      Temp.Prev := L.Last;
      L.Last.Next := Temp;
      L.Last := Temp;
      L.Ln := L.Ln + 1;
    end if;
  END AddItem;
  
  --Get random ElementType
  Function GetRand (L: in List) return ElementType is
    num: integer;
    Temp: Position;
  BEGIN
    Temp := L.First;
    num := genRand (L.Ln);
    while num > 0 loop
      num := num - 1;
      Temp := Temp.Next;
    end loop;
    return Temp.Info;
  END GetRand;
  
end randlists;