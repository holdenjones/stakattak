with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Fixed;
with Ada.Strings.Unbounded.Text_IO;
package body screen is
 
  -- --------------------------------------------------------------------------
  -- Name: screen.adb
  -- Author: Holden Jones
  -- Project: Stak Attak
  -- Class: CS0458
  -- --------------------------------------------------------------------------

  SameColor : ColType;

  -- Procedures + Functions
  -- --------------------------------------------------------------------------

  procedure SPut( I : IN Character ) is
  begin -- SPut

    Append( Scrn , I );

  end SPut;

  -- --------------------------------------------------------------------------
  procedure SPut( I : IN String ) is
  begin -- SPut

    Append( Scrn , I );

  end SPut;

  -- --------------------------------------------------------------------------

  procedure Render is
  begin -- Render

    Ada.Strings.Unbounded.Text_IO.Put( Scrn );
    Delete( Scrn , 1 , Length( Scrn ) );

  end Render; 
  
  -- --------------------------------------------------------------------------

  procedure F_Col ( C: IN ColType ) is

  begin -- F_Col
    SPut( ASCII.ESC );
    SPut( "[" );
    case C is
      when Black   => SPut("30m");
      when Red     => SPut("31m");
      when Green   => SPut("32m");
      when Yellow  => SPut("33m");
      when Blue    => SPut("34m");
      when Magenta => SPut("35m");
      when Cyan    => SPut("36m");
      when White   => SPut("37m"); 
    end case;
  end F_Col;

  -- --------------------------------------------------------------------------

  procedure B_Col ( C: IN ColType ) is

  begin -- B_Col
    SPut( ASCII.ESC );
    SPut( "[" );
    case C is
      when Black   => SPut("40m");
      when Red     => SPut("41m");
      when Green   => SPut("42m");
      when Yellow  => SPut("43m");
      when Blue    => SPut("44m");
      when Magenta => SPut("45m");
      when Cyan    => SPut("46m");
      when White   => SPut("47m"); 
    end case;
  end B_Col;

  -- --------------------------------------------------------------------------

  procedure LineBreak is
  begin -- LineBreak

    F_Col( Black );
    B_Col( White );

    SPut( ASCII.LF );

    F_Col( Fore );
    B_Col( Back );

  end LineBreak;

  -- --------------------------------------------------------------------------

  procedure Draw_Sep is
  begin -- Draw_Sep
    
    SPut( Border_Edge );
    for I in 1..78 loop
      SPut( Border_Horz );
    end loop;
    SPut( Border_Edge );

    LineBreak;

  end Draw_Sep;

  -- --------------------------------------------------------------------------

  procedure ColPrint( I : IN ColType ) is
  begin -- ColPrint

    if SameColor /= I then
      F_Col( I );
      B_Col( I );

      SameColor := I;
    end if;

    SPut( " " );

  end ColPrint;

  -- --------------------------------------------------------------------------

  procedure SetColors( F : IN ColType ; B : IN ColType ) is
  begin -- SetColors

    Fore := F;
    Back := B;

    F_Col( F );
    B_Col( B );

  end SetColors;

  -- --------------------------------------------------------------------------

  procedure Draw_Pic is
    TempCol : Character;
  begin -- Draw_Pic
    F_Col( Black );
    B_Col( Black );
    SameColor := Black;

    for I in Picture'Range loop
      F_Col( Fore );
      B_Col( Back );
      SPut( Border_Vert );
      F_Col( Black );
      B_Col( Black );
      SameColor := Black;

      for J in PicString'Range loop
        TempCol := Character( Picture(I)(J) );

        case TempCol is
          when '0' => ColPrint( Black );
          when 'R' => ColPrint( Red );
          when 'G' => ColPrint( Green );
          when 'Y' => ColPrint( Yellow );
          when 'B' => ColPrint( Blue );
          when 'M' => ColPrint( Magenta );
          when 'C' => ColPrint( Cyan );
          when others => ColPrint( White );
        end case;

      end loop;
      F_Col( Fore );
      B_Col( Back );
      SPut( Border_Vert );
      LineBreak;
    end loop;
    F_Col( Fore );
    B_Col( Back );
  end Draw_Pic;

  -- --------------------------------------------------------------------------

  procedure Init_Menu ( Input : IN OUT MenuArray ) is
  begin -- Init_Menu

    for I in 1..22 loop

      Input(I) := strR( "" );

    end loop;

  end Init_Menu;

  -- --------------------------------------------------------------------------

  procedure Draw_Screen( Mode : IN Character ) is
  begin -- Draw_Screen

    SetColors( White , Black );
    Put( ASCII.ESC );
    Put( "[2J" );

    Put( ASCII.ESC );
    Put( "[1;1f" );

    SetColors( White , Black );

    Draw_Sep;

    if Mode = 'W' then

      Draw_Pic;

      Draw_Sep;

    end if;

    Draw_Menu;

    Draw_Sep;

    Render;

    SetColors( White , Black );
  end Draw_Screen;

  -- --------------------------------------------------------------------------

  function CatString_First( InMenu : IN MenuArray ) return str is
    TempStr : str;
    TempInt : Integer;
  begin -- CatString_First

    for I in 1..ModeLen loop
      if getStr(InMenu(I))'Length > 0 then

        if getStr(InMenu(I))(1) = '%' then
          -- Found CatString option, parse it

          TempInt := Ada.Strings.Fixed.Index( getStr(InMenu(I)) , "/" );
          if TempInt > 0 then
            setStr( TempStr , getStr(InMenu(I))(2..TempInt-1) );
            return TempStr;
          end if;

        end if;

      end if;

    end loop;
    return StrR("");
  end CatString_First;
  
  -- --------------------------------------------------------------------------

  function Find_CatString( InMenu : IN MenuArray ; InStr : IN str ) return Integer is
    IntT : Integer;
  begin -- Find_CatString

    IntT := getStr( InStr )'Length;

    for I in 1..ModeLen loop

      if getStr(InMenu(I))'Length > 0 then 

        if getStr(InMenu(I))(1) = '%' then

          if getStr(InMenu(I))(2..(1+IntT)) = getStr( InStr ) then

            return I;

          end if;

        end if;

      end if;

    end loop;

    return 0;

  end Find_CatString;

  -- --------------------------------------------------------------------------
  
  function MenuStart( Input : IN MenuArray ; Mode : IN Character ) return str is
    ret : Boolean := FALSE;
    charIn : Character;
    Temp : Integer;
    TempInt : Integer;
  begin -- MenuStart

    if Mode = 'T' then
      ModeLen := 22;
    else
      ModeLen := 7;
    end if;

    Menu := Input;

    Selected := CatString_First( Menu );

    loop

      Draw_Screen( Mode );

      Temp := Find_CatString( Menu , Selected );


      Get_Immediate( charIn );

      if charIn = 'A' then

        for I in reverse 1..Temp-1 loop
          if getStr(Menu(I))'Length > 0 then

            if getStr(Menu(I))(1) = '%' then
              -- Found CatString option, parse it

              TempInt := Ada.Strings.Fixed.Index( getStr(Menu(I)) , "/" );
              if TempInt > 0 then
                setStr( Selected , getStr(Menu(I))(2..TempInt-1) );
                exit;
              end if;

            end if;

          end if;
        end loop;

      elsif charIn = 'B' then

        for I in Temp+1..ModeLen loop
          if getStr(Menu(I))'Length > 0 then

            if getStr(Menu(I))(1) = '%' then
              -- Found CatString option, parse it

              TempInt := Ada.Strings.Fixed.Index( getStr(Menu(I)) , "/" );
              if TempInt > 0 then
                setStr( Selected , getStr(Menu(I))(2..TempInt-1) );
                exit;
              end if;

            end if;

          end if;
        end loop;

      elsif charIn = ' ' then
        ret := TRUE;     
      end if;

      exit when ret = TRUE;

    end loop;

    return Selected;

  end MenuStart;

  -- --------------------------------------------------------------------------

  procedure Set_Picture( Input : IN str ) is
  begin -- Set_Picture

    Picture := (
               "CCCCCCCYCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC" ,
               "CCCCYCYYYCYCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC" ,
               "CCCCCYYYYYCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC" ,
               "CCCCCYYYYYCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC" ,
               "CCCCYCYYYCYCCCCCCCCCCCCCCCCBBBBBBBBBBBBBBBBBBBBCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC" ,
               "CCCCCCCYCCCCCCCCCCCCCBBBBBBBBBBBBWWWWWWWWWBBBBBBBBBBBCCCCCCCCCCCCCCCCCCCCCCCCC" ,
               "CCCCCBBBBBBBBBBBBBBBBBBBBBBBBBBBBWBBBBBBBWBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBCCCCC" ,
               "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBWBBBBBBBWBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB" ,
               "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBWWWWWWWWWWWWWWWBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB" ,
               "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBWBBBBBBBBBBBBBWBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB" ,
               "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBWBBBBBBBBBBBBBWBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB" ,
               "BBBBBBBBBBBBBBBBBBBBBBBBBBBWWWWWWWWWWWWWWWWWWWWWBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB" ,
               "BBBBBBBBBBBBBBBBBBBBBBBBBBBWBBBBBBBBBBBBBBBBBBBWBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB" ,
               "BBBBBBBBBBBBBBBBBBBBBBBBBBBWBBBBBBBBBBBBBBBBBBBWBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB" 
               );
    if getStr( Input ) = "MAINMENU" then
      Picture := (
                "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW" ,
                "WWWBWWWWWWWWWWWWWWWWWWWWWWWWWWWW00R000R000R0R0RWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW" ,
                "WWWWBWWWWWWWWWWWWWWWWWWWWWWWWWWW0RWW0RW0R0R0R0RWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW" ,
                "WWBWBWWBWWWWWWWWWWWWWWWWWWWWWWWW00RW0RW0R0R00RWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW" ,
                "WWWBBBBWWWWWWWWWWWWWWWWWWWWWWWWWW0RW0RW000R0R0RWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW" ,
                "WWWBBBBCCCCCCCCCCCCCCCCCCCCCCCCC00RC0RC0R0R0R0RCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCW" ,
                "BBBBWWBCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCWCWW" ,
                "BBBBWWBCCCWWWWWWWWWWWWWWWWWWW000R000R000R000R0R0RWWWWWWWWWWWWWWWWWWWWWWWWWCWWW" ,
                "WWWBBBBCCCCCCCCCCCCCCCCCCCCCC0R0RC0RCC0RC0R0R0R0RCCCCCCCCCCCCCCCCCCCCCCCCCWWWW" ,
                "WWWBBBBWWWWWWWWWWWWWWWWWWWWWW0R0RW0RWW0RW0R0R00RWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW" ,
                "WWBWBWWWWWWWWWWWWWWWWWWWWWWWW000RW0RWW0RW000R0R0RWWWWWWWWWWWWWWWWWWWWWWWWWWWWW" ,
                "WWWWBWWWWWWWWWWWWWWWWWWWWWWWW0R0RW0RWW0RW0R0R0R0RWWWWWWWWWWWWWWWWWWWWWWWWWWWWW" ,
                "WWWBWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW" ,
                "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
                );
    end if;
  end Set_Picture;

  -- --------------------------------------------------------------------------

  procedure PutSpaces( Num : IN Integer ) is
    Temp : String(1..Num);
  begin -- PutSpaces

    for I in 1..Num loop
      Temp(I) := ' ';
    end loop;

    SPut( Temp );

  end PutSpaces;

  -- --------------------------------------------------------------------------

  procedure Draw_Menu is
    TempI : Integer;
    TempEnd : Integer;
    NumSpace : Integer;
  begin -- Draw_Menu
    for I in 1..ModeLen loop
      
      SPut( Border_Vert );
      if Find_CatString( Menu , Selected ) = I then
        SetColors( Black , Cyan );
      else
        SetColors( Cyan , Black );
      end if;

      if getStr( Menu(I) )'Length > 0 then
        if getStr( Menu(I) )(1) = '%' then
          TempI := Ada.Strings.Fixed.Index( getStr(Menu(I)) , "/" );
          TempEnd := getStr(Menu(I))'Length;
          NumSpace := (77 - (TempEnd-(TempI+1)) ) / 2 ;
          PutSpaces( NumSpace );
          SPut( getStr(Menu(I))(TempI+1..TempEnd) );
          PutSpaces( (78 - NumSpace - (TempEnd-(TempI)) ) );
        else
          NumSpace := (77 - getStr( Menu(I) )'Length) / 2;
          PutSpaces( NumSpace );
          SPut( getStr( Menu(I) ) );
          PutSpaces( (78 - NumSpace - getStr( Menu(I) )'Length ) );
        end if;
      else
        PutSpaces( 78 );
      end if;

      SetColors( White , Black );

      SPut( Border_Vert );

      LineBreak;
    end loop;
  end Draw_Menu;

  -- --------------------------------------------------------------------------
end screen; 
