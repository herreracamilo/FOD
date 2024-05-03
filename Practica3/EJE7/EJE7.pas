(* https://justpaste.it/f8nrr *)

program EJE7;

type
    ave = record
        codigo:integer;
        nombre:string[50];
        familia:string[50];
        descripcion:string[50];
        zona:integer;
    end;

    maestro = file of ave;

    procedure leerAve(var a:ave);
    begin
        with a do begin
            writeln('codigo');
            readln(codigo);
            if(codigo <> 5000)then begin
                writeln('nombre');
                readln(nombre);
                (* PARA PROBAR SACO ESTOS DATOS
                writeln('familia');
                readln(familia);
                writeln('descripcion');
                readln(descripcion);
                writeln('zona');
                readln(zona);
                *)
            end;
        end;
    end;

    procedure crearMaestro(var mae:maestro);
    var
        a:ave;
    begin
        assign(mae,'maestro');
        rewrite(mae);
        with a do begin
            leerAve(a);
            while(a.codigo<>5000)do begin
                write(mae,a);
                leerAve(a);
            end;
        end;
        close(mae);
        writeln('== maestro creado ==');
    end;

    procedure borradoLogico(var mae:maestro);
    var
        aux,a:ave;
        encontrado:boolean;
    begin
        reset(mae);

        leerAve(aux);

        while(aux.codigo<>5000)do begin
            encontrado:=false;
            while not eof(mae) and (not encontrado) do begin
                read(mae,a);
                if(aux.codigo = a.codigo)then begin
                    encontrado:=true;
                    seek(mae,filepos(mae)-1);
                    a.nombre:= '***';
                    write(mae,a);
                end;
            end;
            if(not encontrado)then
                writeln('== el ave no se encuentra para ser borrada ==')
            else
                writeln('== borrado logico correcto ==');
            leerAve(aux);
        end;
        
        close(mae);
    end;

    procedure borradoFisico(var mae:maestro);
    var
        a,aux:ave;
        pos,pos2:integer;
        esta:boolean;
    begin
        esta:=false;

        reset(mae);
        
        while not eof(mae)and(not esta)do begin
            read(mae,a);
            if(a.nombre = '***')then
                esta:=true;
        end;
        if(esta)then begin
            pos:= filepos(mae)- 1; // guardo la posicion en la que esta la primera ocurrencia del borrado logico
            seek(mae,filesize(mae)-1); // lo posicione en el final
            read(mae,aux); // en aux tengo el ultimo del archivo
            if(aux.nombre <> '***')then // si no esta borrado el ultimo tengo que hacer intercambio con el que esta en pos
                begin
                    seek(mae,pos); // voy a la posicion que estaba el borrado
                    write(mae,aux); // escribo el que estaba ultimo
                    seek(mae,filesize(mae)-1); // me posicione en el ultimo
                    write(mae,a); // escribo el borrado en el ultimo
                    truncate(mae); // trunco el ultimo
                    writeln('== borrado fisico correctamente ==');
                end
                else
                begin
                    seek(mae,filepos(mae)-2); // voy a la anteultima posicion porque el ultimo tambien se tiene que borrar
                    read(mae,aux); // leo el anteultimo y sino sigo buscando hasta encontrar uno que no este marcado
                    while(aux.nombre = '***')do begin
                        seek(mae,filepos(mae)-2);
                        read(mae,aux);
                    end;
                    pos2:= filepos(mae)- 1;
                    seek(mae,pos); // voy a la posicion que estaba el borrado
                    write(mae,aux); // escribo el que acabo de encontrar 
                    seek(mae,pos2); // vuelvo a la posicion donde estaba el NO marcado
                    write(mae,a);   // escribo el primero marcado que encontre
                    seek(mae,filepos(mae)-1);
                    Truncate(mae); // y trunco a partir de ahi
                    writeln('== borrado fisico correctamente ==');   
                end;
            end;
        close(mae);
    end;

    procedure imprimir(var mae:maestro);
    var
        a:ave;
    begin
        assign(mae,'maestro');
        reset(mae);

        while not eof(mae)do begin
            read(mae,a);
            with a do begin
                write('codigo --> ');
                write(codigo);
                writeln(' ');
                write('nombre --> ');
                write(nombre);
                writeln(' ');
            end;
        end;
    end;

var
    mae:maestro;
begin
    //crearMaestro(mae);
    //imprimir(mae);
    //borradoLogico(mae);
    imprimir(mae);
    borradoFisico(mae);
    writeln('');
    imprimir(mae);

end.