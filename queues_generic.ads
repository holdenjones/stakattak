GENERIC

  TYPE Element IS PRIVATE;

PACKAGE Queues_Generic IS
------------------------------------------------------------------------
--| Specification for Generic FIFO Queues Package                                     
------------------------------------------------------------------------
  -- type definition

  TYPE Queue (Capacity: Positive) IS PRIVATE;

  -- exported exceptions

  QueueFull  : EXCEPTION;
  QueueEmpty : EXCEPTION;

  -- constructors

  PROCEDURE MakeEmpty (Q : IN OUT Queue);
  -- Pre:    Q is defined
  -- Post:   Q is empty

  PROCEDURE Enqueue (Q : IN OUT Queue; E : IN Element);
  -- Pre:    Q and E are defined
  -- Post:   Q is returned with E as the top Element
  -- Raises: QueueFull if Q already contains Capacity Elements

  PROCEDURE Dequeue (Q : IN OUT Queue; item : out element);
  -- Pre:    Q is defined
  -- Post:   Q is returned with the top Element discarded
  -- Raises: QueueEmpty if Q contains no Elements

  -- selector

  FUNCTION First (Q : IN Queue) RETURN Element;
  -- Pre:    Q is defined
  -- Post:   The first Element of Q is returned
  -- Raises: QueueEmpty if Q contains no Elements

  -- inquiry operations

  FUNCTION IsEmpty (Q : IN Queue) RETURN Boolean;
  -- Pre:    Q is defined
  -- Post:   returns True if Q is empty, False otherwise

  FUNCTION IsFull  (Q : IN Queue) RETURN Boolean;
  -- Pre:    Q is defined
  -- Post:   returns True if Q is full, False otherwise
  
  FUNCTION queuesize(Q : in queue) return integer;
  
  FUNCTION printqueue(Q : in queue; index : in integer) return element;

PRIVATE

  TYPE List IS ARRAY (Positive RANGE <>) OF Element;
  TYPE Queue (Capacity: Positive) IS RECORD
    Tail  : Natural := 0;
    Store : List(1..Capacity);
  END RECORD;

END Queues_Generic;
