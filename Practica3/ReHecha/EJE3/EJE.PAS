program eje3;

type
    novela = record
        codigo:integer;
        genero:string;
        nombre:string;
        duracion:integer;
        director:string;
        precio:real;
    end;

    maestro = file of novela;

    procedure crearMaestro(var mae:maestro);
    var
        n:novela;
        txt:text;
    begin
        assign(mae,'maestro');
        rewrite(mae);

        assign(txt,'novelas.txt');
        reset(txt);

        while not eof(txt)do begin
            with n do begin
                readln(txt,codigo,precio,duracion,nombre);
                readln(txt,genero);
                readln(txt,director);
                write(mae,n);
            end;
        end;
        close(mae);
        close(txt);
        writeln('| maestro creado |');
    end;

    procedure leer(var n:novela);
    begin
        with n do begin
            writeln('ingrese codigo');
            readln(codigo);
            writeln('ingrese precio');
            readln(precio);
            writeln('ingrese duracion');
            readln(duracion);
            writeln('ingrese nombre');
            readln(nombre);
            writeln('ingrese genero');
            readln(genero);
            writeln('ingrese director');
            readln(director);
        end;
        
    end;

    procedure alta(var mae:maestro);
    var
        nue,aux,cab:novela;
        pos:integer;

    begin
        assign(mae,'maestro');
        reset(mae);

        leer(nue);
        read(mae,cab);
        if(cab.codigo = 0)then begin // si el 0 esta en la cabecera entonces no borre ninguno
            seek(mae,filesize(mae)); // voy al final
            write(mae,nue); // escribo el nuevo
        end
        else
        begin
            pos:= cab.codigo * -1; // consigo la posicion de la cabecera
            seek(mae,pos); // me voy a la posicion
            read(mae,aux); // leo el dato que habia para no perderlo
            seek(mae,filepos(mae)-1); // vuelvo para atras para escribir en esa pos
            write(mae,nue); // escribo en la posicion
            seek(mae,0); // vuelvo a la cabecera
            write(mae,aux); // escribo en la cabecera
        end;
        close(mae);
    end;

    procedure baja(var mae:maestro);
    var
        n,cab:novela;
        codigo:integer;
    begin
        assign(mae,'maestro');
        reset(mae);

        writeln('ingrese codigo a borrar');
        readln(codigo);
        read(mae,cab); // leo la cabecera
        seek(mae,codigo); // voy a la pos a borrar
        read(mae,n); // leo el que voy a borrar
        seek(mae,codigo); // vuelvo a la pos a borrar
        write(mae,cab); // escribo la cabecera
        seek(mae,0); // voy a la cabecera
        n.codigo:= n.codigo * -1; // pongo en negativo la pos que borre
        write(mae,n); // y lo escribo en la cabecera
        close(mae);
    end;

    procedure exportar(var mae:maestro);
    var
        txt:text;
        n:novela;
    begin
        assign(mae,'maestro');
        reset(mae);

        assign(txt,'exportados.txt');
        rewrite(txt);

        while not eof(mae)do begin
            with n do begin
                read(mae,n);
                writeln(txt,codigo,' ',precio:0:2,' ',duracion,' ', nombre);
                writeln(txt,genero);
                writeln(txt,director);
            end;
        end;
        close(mae);
        close(txt);
        writeln('| exportado correcto |');
    end;

var
    mae:maestro;
begin
    crearMaestro(mae);
    alta(mae);
    baja(mae);
    baja(mae);
    alta(mae);
    exportar(mae);
end.