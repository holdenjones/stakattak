WITH Ada.Characters.Latin_1;
WITH Ada.Text_IO;
use ada.text_io;
with Text_Io;
WITH Ada.Integer_Text_IO;
PACKAGE BODY Screen2 IS
--------------------------------------------------------------
--| Body of screen-handling package
--| Author: M. B. Feldman, The George Washington University
--| Last Modified: July 1998
--------------------------------------------------------------
  package Int_IO is new Text_IO.Integer_IO (Num => Integer);

  PROCEDURE Beep IS
  BEGIN
    Ada.Text_IO.Put (Item => Ada.Characters.Latin_1.BEL);
    Ada.Text_IO.Flush;
  END Beep;

  PROCEDURE ClearScreen IS
  BEGIN
    Ada.Text_IO.Put (Item => Ada.Characters.Latin_1.ESC);
    Ada.Text_IO.Put (Item => "[2J");
    Ada.Text_IO.Flush;
  END ClearScreen;

  PROCEDURE MoveCursor (Column : Width; Row : Depth) IS
  BEGIN
    Ada.Text_IO.Flush;
    Ada.Text_IO.Put (Item => Ada.Characters.Latin_1.ESC);
    Ada.Text_IO.Put ("[");
    Ada.Integer_Text_IO.Put (Item => Row, Width => 1);
    Ada.Text_IO.Put (Item => ';');
    Ada.Integer_Text_IO.Put (Item => Column, Width => 1);
    Ada.Text_IO.Put (Item => 'f');
  END MoveCursor;
  procedure Set_Fore( Fore : Colors) is
     begin
        Ada.Text_IO.Put (Item => ASCII.ESC);
        Ada.Text_IO.Put ("[");
        case Fore is
           when Black   => Text_Io.Put("30m");
           when Red     => Text_Io.Put("31m");
           when Green   => Text_Io.Put("32m");
           when Yellow  => Text_Io.Put("33m");
           when Blue    => Text_Io.Put("34m");
           when Magenta => Text_Io.Put("35m");
           when Cyan    => Text_Io.Put("36m");
           when White   => Text_Io.Put("37m");
           --when Same    => null;
        end case;
     end Set_Fore;
  procedure Pause  is
    Instring : String (1..1);
    Length : Integer;
  begin

    Movecursor (Row =>23, Column => 15);
    Text_Io.Put (Item => "Press return to continue ");
    Text_Io.Get_line (Item => Instring, Last => length);

  end Pause;

  procedure Pause(Row :   in Depth;
                  Column: in Width;
                  Msg :   in String)  is
    Instring : String (1..1);
    Length : Integer;
  begin

    Movecursor (Row =>Row, Column => Column);
    Text_Io.Put (Item => Msg);
    Text_Io.Get_line (Item => Instring, Last => length);

  end Pause;
   procedure Set_Back( Back : Colors) is
     begin
        Text_IO.Put (Item => ASCII.ESC);
        Text_IO.Put ("[");
        case Back is
           when Black   => Text_Io.Put("40m");
           when Red     => Text_Io.Put("41m");
           when Green   => Text_Io.Put("42m");
           when Yellow  => Text_Io.Put("43m");
           when Blue    => Text_Io.Put("44m");
           when Magenta => Text_Io.Put("45m");
           when Cyan    => Text_Io.Put("46m");
           when White   => Text_Io.Put("47m");
           --when Same    => null;
        end case;
     end Set_Back;

  procedure Set_Default is
     begin
        Text_IO.Put (Item => ASCII.ESC);
        Text_IO.Put ("[0m");
     end Set_Default;
END Screen2;

