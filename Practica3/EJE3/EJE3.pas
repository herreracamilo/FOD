(* https://hastebin.com/share/qolaxuleci.less

no realizo la carga por teclado para probar el programa mas rapido *)

program EJE3;
type
    novela = record
        codigo:integer;
        genero:string[20];
        nombre:string[20];
        duracion:integer;
        director:string[20];
        precio:real;
    end;
    
    maestro = file of novela;

    procedure leerNovela(var n:novela);
    begin
        with n do begin
            writeln('nombre');
            readln(nombre);
            writeln('genero');
            readln(genero);
            writeln('director');
            readln(director);
            writeln('codigo');
            readln(codigo);
            writeln('duracion');
            readln(duracion);
            writeln('precio');
            readln(precio);
        end;
        
    end;

    procedure crearMae(var mae:maestro);
    var
        n:novela;
        texto:text;
    begin
        assign(mae,'maestro');
        assign(texto,'novelasInfo.txt');
        reset(texto);
        rewrite(mae);

        while not eof (texto)do begin
            with n do begin
                readln(texto,nombre);
                readln(texto,genero);
                readln(texto,director);
                readln(texto,codigo,duracion,precio);
                write(mae,n);
            end;
        end;
        close(mae);
        close(texto);
        writeln('== maestro creado ==');
    end;

    procedure darDeAlta(var mae:maestro);
    var
        n,nuevo:novela;
        lugar:boolean;
        pos:integer;
    begin
        assign(mae,'maestro');
        reset(mae);

        lugar:=false;
        leerNovela(nuevo);
        read(mae, n);
        if(n.codigo < 0)then
            lugar:=true;
        if(lugar)then begin
            pos:= n.codigo * (-1);
            seek(mae,pos);
            read(mae,n);
            seek(mae,filepos(mae)-1);
            write(mae,nuevo);
            seek(mae,0);
            n.codigo:=0;
            write(mae,n);
            writeln('=== se encontro lugar y se realizo el alta ===');
        end
        else
        begin
            seek(mae,filesize(mae));
            write(mae,nuevo);
            writeln('=== no hubo lugar disponible y se agrego al final del archivo ===');
        end;
        close(mae);
    end;

    procedure modificarNovela(var mae:maestro);
    var
        n:novela;
        cod:integer;
        modificado:boolean;
    begin
        assign(mae,'maestro');
        reset(mae);
        
        writeln('ingrese el codigo de novela a modificar');
        readln(cod);
        modificado:=false;
        while not eof(mae) and (not modificado)do begin
            read(mae,n);
            if(n.codigo = cod)then begin
                with n do begin
                    writeln('nombre');
                readln(nombre);
                writeln('genero');
                readln(genero);
                writeln('director');
                readln(director);
                writeln('duracion');
                readln(duracion);
                writeln('precio');
                readln(precio);
                end;
                modificado:=true;
                seek(mae,filepos(mae)-1);
                write(mae,n);
                writeln('=== novela modificada ===');
            end;
        end;
        if(not modificado)then
                writeln(' !!! no se encontro novela con ese codigo !!!');
        close(mae);
    end;

    procedure borradoLogico(var mae:maestro);
    var
        n,caebecera:novela;
        cod,pos:integer;
        borrado:boolean;
    begin
        assign(mae,'maestro');
        reset(mae);

        borrado:=false;
        writeln('ingrese el codigo de la novela a eliminar');
        readln(cod);
        read(mae,caebecera);
        while not eof(mae) and (not borrado)do begin
            read(mae,n);
            if(n.codigo = cod)then begin
                borrado:=true;
                pos:= (filepos(mae) - 1);
                n.codigo:= pos *(-1);
                seek(mae,pos);
                write(mae,caebecera);
                seek(mae,0);
                write(mae,n);
                writeln('=== novela borrada correctamente ===');
            end;
        end;
        if(not borrado)then
            writeln('!!! ese codigo de novela no existe !!!');
        close(mae);
    end;

    procedure listar(var mae:maestro);
    var
        n:novela;
        texto:text;
    begin
        assign(mae,'maestro');
        assign(texto,'novelas.txt');
        reset(mae);
        rewrite(texto);

        while not eof (mae)do begin
            with n do begin
                read(mae,n);
                writeln(texto,nombre);
                writeln(texto,genero);
                writeln(texto,director);
                writeln(texto,codigo,' | ',duracion,' | ',precio:0:2);
                writeln(texto);
            end;
        end;
        writeln('=== novelas.txt creado correctamente');
        close(mae);
        close(texto);
    end;

var
    mae:maestro;
begin
    crearMae(mae);
    //darDeAlta(mae);
    //modificarNovela(mae);
    borradoLogico(mae);
    darDeAlta(mae);
    listar(mae);
end.