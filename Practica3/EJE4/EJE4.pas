(* https://justpaste.it/dznzs *)
program EJE4;
type
    flor = record
        nombre:string[45];
        codigo:integer;
    end;

    maestro = file of flor;

    procedure crearMae(var mae:maestro);
    var
        f:flor;
        texto:text;
    begin
        assign(mae,'maestro');
        assign(texto,'flor.txt');
        rewrite(mae);
        reset(texto);

        while not eof(texto)do begin
            with f do begin
                readln(texto,nombre);
                readln(texto,codigo);
                write(mae,f);
            end;
        end;
        close(mae);
        close(texto);
        writeln('=== maestro creado ===');
    end;

    procedure agregarFlor(var mae:maestro; nombre:string; codigo:integer);
    var
        f,aux:flor;
        hayLugar:boolean;
        pos:integer;
    begin
        hayLugar:=false;
        assign(mae,'maestro');
        reset(mae);

        read(mae,f); // leo la cabecera
        if(f.codigo < 0)then
            hayLugar:=true;
        if(hayLugar)then begin
            pos:= f.codigo * (-1); // consigo el entero de la cabecera
            seek(mae,pos); // voy a la posicion que me dice la cabecera
            read(mae,aux); //guardo lo que habia en auxiliar para no perder el proximo borrado
            seek(mae,pos); // vuelvo a donde tengo que colocar la nueva flor
            f.nombre:= nombre;
            f.codigo:= codigo;
            write(mae,f);
            seek(mae,0); // vuelvo a la cabecera
            write(mae,aux); // escribo el auxiliar para no perder el proximo borrado
            writeln('=== habia lugar disponible y se ubico ===');
        end
        else
        begin
            seek(mae,filesize(mae)); // voy al eof
            f.nombre:= nombre;
            f.codigo:= codigo;
            write(mae,f); // escribo la nueva flor al final
            writeln('=== no habia lugar disponible y se ubico en el final del archivo ===');
        end;
        close(mae);
    end;

    procedure exportarFlores(var mae:maestro);
    var
        f:flor;
        texto:text;
    begin
        assign(mae,'maestro');
        assign(texto,'floresSinMarca.txt');
        reset(mae);
        rewrite(texto);

        while not eof(mae)do begin
            with f do begin
                read(mae,f);
                if(codigo > 0)then begin
                    writeln(texto,nombre);
                    writeln(texto,codigo);
                    writeln(texto);
                end;
            end;
        end;
        close(mae);
        close(texto);
        writeln('=== floresSinMarca.txt creado ===');
    end;


var
    mae:maestro;
    nombre:string[45];
    codigo:integer;
begin
    nombre:= 'tulipan';
    codigo:= 999;
    crearMae(mae);
    agregarFlor(mae, nombre, codigo);
    exportarFlores(mae);
end.
