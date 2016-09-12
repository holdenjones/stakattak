with ada.text_io; use ada.text_io;
PACKAGE Screen2 IS
--------------------------------------------------------------
--| Procedures for drawing pictures on ANSI Terminal Screen
--| Author: M. B. Feldman, The George Washington University
--| Last Modified: July 1998
--------------------------------------------------------------

  -- constants; the number of rows and columns on the terminal

  ScreenDepth : CONSTANT Integer := 42;
  ScreenWidth : CONSTANT Integer := 200;

  -- subtypes giving the ranges of acceptable inputs
  -- to the cursor-positioning operation

  SUBTYPE Depth IS Integer RANGE 1..ScreenDepth;
  SUBTYPE Width IS Integer RANGE 1..ScreenWidth;
  
  type Colors is ( Black, Red, Green, Yellow, Blue, Magenta, Cyan, White);

  procedure Set_Fore( Fore : Colors);
  -- Pre:
  -- Post: Sets the foreground (text) to the specified color

  PROCEDURE Beep;
  -- Pre:  None
  -- Post: Terminal makes its beep sound once

  PROCEDURE ClearScreen;
  -- Pre:  None
  -- Post: Terminal Screen is cleared

  PROCEDURE MoveCursor (Column : Width; Row : Depth);
  -- Pre:  Column and Row have been assigned values
  -- Post: Cursor is moved to the given spot on the screen
  procedure Pause;
  -- Pre: none
  -- Post: the message "Press return to continue" is display on row 23
  --           and the program waits for the return key

  procedure Pause(Row :    in Depth;
                  Column : in Width;
                  Msg :    in String);
  -- Pre: Row, Column must be within defined screen boundries
  --           or Constraint_Error will be raised
  -- Post: the message Msg is display on row Row, column Column,
  --           and the program waits for the return key

  procedure Set_Back( Back : Colors);
  -- Pre:
  -- Post: Sets the background to the specified color

  procedure Set_Default;
  -- Pre:
  -- Post: Returns both the foreground and background to default colors


END Screen2;


