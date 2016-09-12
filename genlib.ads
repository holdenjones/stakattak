With Ada.integer_text_io;

Package genlib is
  
  type str is private;
  
  Procedure genSeed;
  --Resets the random number generator.
    
  Function genIndex(R: in integer) return integer;
  --Input: Takes in an integer as the max number of the range.
  --Output: Returns a randomly genereated number for the range.
  
  Function genRand(R: in integer) return integer;
  --Input: Takes in an integer as the max number of the range, EX: 120 makes 1..120
  --Output: Returns a randomly generated number based on the time.
  
  Procedure setStr(I: in out str; S: in String);
  --Input: Takes in a string from 1..100 and a string length.
  --Output: None.
   
  Function getStr(I: in str) return String;
  --Input: None.
  --Output: Returns a string and its length.
  
  Function genRand_Range(R: in Integer ; O: in Integer) return Integer;
  --Input: An integer and the offset.
  --Output: Generates a number from a range around the offset IE: R=50 and O=4 would generate a number from 46-54.

  Function strR( I: in String ) return str;
  --Input: A string of any length
  --Output: A str record version of that object
  
  Function "+"(O: str; T: str) return str;
  --Input: Takes in two str strings and concatenates them into one str.
  --Output: Returns the concatenated str.
  
PRIVATE
  
  subtype strbody is string (1..100);
  
  Type str is record
    strb: strbody;
    ln: integer;
  end record;
  
end genlib;
