With Ada.text_io;
With Ada.integer_text_io;
With item_pkg;
Use item_pkg;
With randlists;
With queues_generic;
With genlib;
Use genlib;

Package body hero is
  
  --Variables.
  Package queueG is new queues_generic(heroPtr);
  Package RandList is new randlists(str);
  hero_Name: RandList.List;
  Q: queueG.Queue(10);
  ------------------------------------------------
  Function genHero return heroPtr is
    TempName: str;
    H : heroPtr;
  BEGIN
    H := new adventurer;
    setStr(TempName, getStr(RandList.GetRand(hero_Name)));
    H.all.Name := TempName;
    H.all.Power := genRand_Range(6,2); --integer
    H.all.Weapon := NULL; --ItemPtr
    H.all.Armor := NULL; --ItemPtr
    return H;
  END genHero;
  ------------------------------------------------
  Procedure swapItem(H: in out heroPtr; I: in out ItemPtr) is
    Temp: ItemPtr;
  BEGIN
    if I.all.Slot='W' then
      Temp:= H.Weapon;
      H.Weapon:= I;
      I:= Temp;
    elsif I.all.Slot='A' then
      Temp:= H.Armor;
      H.Armor:= I;
      I:= Temp;
    end if;
  END swapItem;
  ------------------------------------------------
  Procedure initHeroList is
  BEGIN
    RandList.Initialize(hero_Name);
    
    RandList.AddItem(hero_Name, strR("Arthur"));
    RandList.AddItem(hero_Name, strR("Vivex"));
    RandList.AddItem(hero_Name, strR("Tarkir"));
    RandList.AddItem(hero_Name, strR("Lilidan"));
    RandList.AddItem(hero_Name, strR("Sara"));
    RandList.AddItem(hero_Name, strR("Jasper"));
    RandList.AddItem(hero_Name, strR("Tigtone"));
    RandList.AddItem(hero_Name, strR("Craig"));
    RandList.AddItem(hero_Name, strR("Pat"));
    RandList.AddItem(hero_Name, strR("Amanda"));
    RandList.AddItem(hero_Name, strR("Holden"));
    RandList.AddItem(hero_Name, strR("Bryan"));
    RandList.AddItem(hero_Name, strR("Aaron"));
    RandList.AddItem(hero_Name, strR("Taylor"));
    RandList.AddItem(hero_Name, strR("Elcor"));
    RandList.AddItem(hero_Name, strR("Kimi"));
    RandList.AddItem(hero_Name, strR("Darmic"));
    RandList.AddItem(hero_Name, strR("Viktor"));
    RandList.AddItem(hero_Name, strR("Nero"));
    RandList.AddItem(hero_Name, strR("Thalnos"));
    RandList.AddItem(hero_Name, strR("Setus"));
    RandList.AddItem(hero_Name, strR("Horus"));
    RandList.AddItem(hero_Name, strR("Brendan"));
    RandList.AddItem(hero_Name, strR("Osma"));

  END initHeroList;
  ------------------------------------------------
  Procedure makeHeroList is
    hero_Q: heroPtr;
  BEGIN
    for i in 1..10 loop
      hero_Q:= genHero;
      queueG.Enqueue(Q, hero_Q);
    end loop;
  END makeHeroList;
  ------------------------------------------------
  Function getHero return heroPtr is
    hero_Q: heroPtr;
  BEGIN
    queueG.Dequeue(Q, hero_Q);
    return hero_Q;
  END getHero;
  ------------------------------------------------
  
End hero;
