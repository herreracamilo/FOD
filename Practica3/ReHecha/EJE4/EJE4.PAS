program EJE4;
type
    reg_flor = record
        nombre: String[45];
        codigo:integer;
    end;
    
    tArchFlores = file of reg_flor;

    procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer); 
    var
        f:reg_flor;
    begin
        assign(a,'flores');
        reset(a);

        read(a,f); //leo la flor
        if(f.codigo = 0)
    end;