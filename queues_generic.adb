PACKAGE BODY Queues_Generic IS
------------------------------------------------------------------------
--| Body of Generic Queues Package, Array Implementation 
--| Linear Queue                                    
------------------------------------------------------------------------

  PROCEDURE MakeEmpty (Q : IN OUT queue) IS
  BEGIN
    Q.Tail := 0;
  END MakeEmpty;

  PROCEDURE Enqueue (Q : IN OUT Queue;
		     E : IN Element) IS
  BEGIN
    IF Q.Tail = Q.Capacity THEN
      RAISE QueueFull;
    ELSE
      Q.Tail           := Q.Tail + 1;
      Q.Store (Q.Tail) := E;
    END IF;
  END Enqueue;

  PROCEDURE Dequeue (Q : IN OUT Queue; item : out element) IS
  BEGIN
    IF Q.Tail = 0 THEN
      RAISE QueueEmpty;
    ELSE
      item := Q.store(1);
      Q.Store (1..Q.Tail - 1) := Q.Store (2..Q.Tail); -- slice
      Q.Tail := Q.Tail -1;
    END IF;
  END Dequeue;

  FUNCTION First (Q : IN Queue) RETURN Element IS
  BEGIN
    IF Q.Tail = 0 THEN
      RAISE QueueEmpty;
    ELSE
      RETURN Q.Store (1);
    END IF;
  END First;

  FUNCTION IsEmpty (Q : IN Queue) RETURN Boolean IS
  BEGIN
    RETURN Q.Tail = 0;
  END IsEmpty;

  FUNCTION IsFull (Q : IN Queue) RETURN Boolean IS
  BEGIN
    RETURN Q.Tail = Q.Capacity;
  END IsFull;
  
  FUNCTION queuesize(Q : in queue) return integer is
   
  size : integer := 0;  

  begin
     
    for i in 1..Q.tail loop
       size := size + 1;
    end loop;
    return size;
  end queuesize;
  
  FUNCTION printqueue(Q : in queue; index : in integer) return element is
  value : element;
  begin
     value := Q.store(index);
     return value;
  end printqueue;
END Queues_Generic;
