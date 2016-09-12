with genlib;                use genlib;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package screen is

  -- --------------------------------------------------------------------------
  -- Name: screen.ads
  -- Author: Holden Jones
  -- Project: Stak Attak
  -- Class: CS0458
  -- --------------------------------------------------------------------------

  -- Type Definitions
  -- --------------------------------------------------------------------------

  subtype PicString is string(1..78);

  type PicCurrent is array(1..14) of PicString;

  type MenuArray is array(1..22) of str;

  type ColType is ( Black , Red , Green , Yellow , Blue , Magenta , Cyan , White );
  -- Variables
  -- --------------------------------------------------------------------------

  Scrn : Unbounded_String;

  Picture : PicCurrent;

  Menu : MenuArray;

  ModeLen : Integer;

  Border_Horz : Character := '-';
  Border_Edge : Character := 'O';
  Border_Vert : Character := '|';

  Fore : ColType := White;
  Back : ColType := Black;

  Selected : str;

  -- Procedures + Functions
  -- --------------------------------------------------------------------------

  procedure Init_Menu( Input : IN OUT MenuArray);

  procedure Draw_Sep;
  procedure Draw_Pic;

  procedure Draw_Screen( Mode : IN Character );
  procedure Draw_Menu;

  function MenuStart( Input : IN MenuArray ; Mode : IN Character ) return str;
  
  procedure Set_Picture( Input : IN str );

  

end screen;
