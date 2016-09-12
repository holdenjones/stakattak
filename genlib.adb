With Ada.text_io;                  use Ada.text_io;
With Ada.integer_text_io;          use Ada.integer_text_io;
With Ada.numerics.discrete_random;
With Ada.Strings.Fixed;

Package body genlib is
  
  subtype randRange is positive range 1..2000000000;
  Package randGen is new Ada.numerics.discrete_random(result_subtype=> randRange);
  G: randGen.Generator;
  
  ----------------------------------------------------------------------
  Procedure genSeed is
  BEGIN
    randGen.reset(Gen=> G);
  END genseed;
  ----------------------------------------------------------------------
  Function genIndex(R: in integer) return integer is
    num: integer;
  BEGIN --genIndex
    num := genRand(R);
    return num+1;
  END genIndex;
  -----------------------------------------------------------------------
  Function genRand(R: in integer) return integer is  
  BEGIN --genRand
    return randGen.Random(Gen=> G) mod R;
  END genRand;
  -----------------------------------------------------------------------
  Procedure setStr(I: in out str ; S: in String) is
  BEGIN --setStr
    Ada.Strings.Fixed.Move(Source=> S, Target=> I.strb);
    I.ln:= S'Length;
  END setStr;
  -----------------------------------------------------------------------
  Function getStr(I: in str) return String is
  BEGIN --getStr
    return I.strb(1..I.ln);
  END getStr;
  -----------------------------------------------------------------------
  Function genRand_Range(R: in Integer ; O: in Integer) return Integer is
    TempRan : Integer;
  BEGIN --genRand_Range
    TempRan := ( (R-O) + genRand( (O*2)+1 ) );
    return TempRan;
  END genRand_Range;
  -----------------------------------------------------------------------
  function strR( I : IN String ) return str is
    Temp : str;
  begin
    setStr( Temp , I );
    return Temp;
  end strR;
  -----------------------------------------------------------------------
  Function "+"(O: str; T: str) return str is
  BEGIN -- "+"
    return strR(getStr(O) & getStr(T));
  END "+";
  -----------------------------------------------------------------------
End genlib;
