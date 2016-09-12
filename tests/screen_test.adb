with screen;      use screen;
with Ada.Text_IO; use Ada.Text_IO;
with genlib;      use genlib;

procedure screen_test is

  Temp : MenuArray;
  NStr : str;
begin -- screen_test

  Init_Screen;

  Set_Picture( strR("Yoo") );

  Init_Menu( Temp );
  Temp(2) := strR( "-- Hello world --" );
  Temp(3) := strR( "%WOP/Lets Go" );
  Temp(4) := strR( "%WOA/Get Out" );
  Temp(5) := strR( "%WOO/Why?" );

  NStr := MenuStart( Temp , 'T' );

  
  Put( getStr( NStr ) );

  NStr := MenuStart( Temp , 'W' );
end screen_test;
