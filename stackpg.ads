-- Generic Stack Package Header

Generic

  TYPE ElementType IS PRIVATE; 

PACKAGE stackpg IS

  -- exported types
  TYPE Position IS PRIVATE;
  TYPE Stack IS PRIVATE;

  -- exported exceptions
  EmptyList : EXCEPTION;  -- raised if the list is empty

  PROCEDURE Initialize(S: IN OUT Stack);
  --Input: Non-initialized stack
  --Output: Top of stack is null
  PROCEDURE AddToStack(S: IN OUT Stack; X: in ElementType);
  --Input: Stack and what element to put on top of stack
  --Output: Stack with added element
  FUNCTION IsEmpty (S: in Stack) RETURN Boolean;
  --Input: A Stack
  --Output: Return true if stack is empty, false if not empty
  PROCEDURE Retrieve (S: IN OUT stack; X: OUT ElementType);
  --Input: A Stack
  --Output: The top element of the stack and then is delete off the stack

PRIVATE

  TYPE Node;
  TYPE Position IS ACCESS Node;

  TYPE Node IS RECORD
    Info: ElementType;
    Next: Position;
  END RECORD;
  
  TYPE Stack IS RECORD
    Top: Position;
  END RECORD;

END stackpg;
