(* https://justpaste.it/26vk3 *)

program EJE5;
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
        nombre:string;
    begin
        assign(mae,'maestro');
        writeln('ingrese nombre para el archivo a exportar');
        readln(nombre);
        assign(texto,nombre+'.txt');
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

    procedure eliminarFlor(var mae:maestro; f:flor);
    var
        cabecera,aux:flor;
        encontrado:boolean;
        pos:integer;
    begin
        assign(mae,'maestro');
        reset(mae);

        encontrado:=false;
        read(mae,cabecera); // leo el contenido de la cabecera
        while not eof(mae) and (not encontrado) do begin
            with aux do begin
                read(mae,aux);
                if(aux.codigo = f.codigo)then begin
                    encontrado:=true;
                    pos:= (filepos(mae) -1); // guardo la posicion de donde encontre la flor a eliminar
                    seek(mae, pos); // me posiciono en la posicion
                    write(mae, cabecera); // escribo en la posicion a borrar el contenido de la cabecera
                    aux.codigo:= pos * (-1); // pongo en el codigo de la flor a eliminar la posicion en la que se encuentra en negativo
                    seek(mae,0); // me posiciono en la cabecera
                    write(mae,aux); // escribo el registro borrado en la cabecera con su posicion en el registro de codigo
                    writeln('=== flor eliminada ===');
                end;
            end;
        end;
        if(not encontrado)then
            writeln('=== la flor a eliminar no existe ===');
        close(mae);
    end;


var
    mae:maestro;
    nombre:string[45];
    codigo:integer;
    f:flor;
begin
    nombre:= 'tulipan';
    codigo:= 999;
    crearMae(mae);
    agregarFlor(mae, nombre, codigo);
    exportarFlores(mae);
    f.codigo:= codigo;
    f.nombre:=nombre;
    eliminarFlor(mae,f);
    exportarFlores(mae);
end.
