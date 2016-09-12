WITH Unchecked_Deallocation;
PACKAGE BODY stackpg IS

  --Initialize the list (Technically stack)
  PROCEDURE Initialize(S: IN OUT Stack) IS
  BEGIN
      S.Top := NULL;
  END Initialize;

  --To free up memory
  PROCEDURE Dispose IS 
    NEW Unchecked_Deallocation(Object => Node, Name => Position);
    
  PROCEDURE Deallocate (P: IN OUT Position) IS
  BEGIN
    Dispose (X => P);
  END Deallocate;
  
  --Add to top of stack
  PROCEDURE AddToStack(S: IN OUT Stack; X: in ElementType) IS
    Temp: Position;
  BEGIN
    Temp := NEW Node'(Info => X, Next => NULL);
    if S.Top = NULL then
      S.Top := Temp;
    else
      Temp.Next := S.Top;
      S.Top := Temp;
    end if;
  END AddToStack;
  
  --To check if stack is empty
  FUNCTION IsEmpty (S: in Stack) RETURN Boolean IS
  BEGIN
    RETURN S.Top = NULL;
  END IsEmpty;
  
  --To Retrieve the the top element and then delete it
  PROCEDURE Retrieve (S: IN OUT stack; X: OUT ElementType) IS
    prev : Position; --For deletion
  BEGIN
    IF IsEmpty (S) THEN
      RAISE EmptyList;
    ELSE
      X := S.Top.info;
      prev := S.Top;
      S.Top := S.Top.Next;
      Deallocate(prev);
    END IF;
  END Retrieve;
  
END stackpg;