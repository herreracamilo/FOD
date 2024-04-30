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

    procedure leerAve(a:ave);
    begin
        with a do begin
            writeln('codigo');
            readln(codigo);
            if(codigo <> 5000)then begin
                writeln('nombre');
                readln(nombre);
                writeln('familia');
                readln(familia);
                writeln('descripcion');
                readln(descripcion);
                writeln('zona');
                readln(zona);
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
        assign(mae,'maestro');
        reset(mae);
        
        leerAve(aux);
        while(a.codigo<>5000)do begin
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
            leerAve(aux);
        end;
    end;

    procedure borradoFisico(var mae:maestro);
    var
        
    begin
        
    end;

var
    mae:maestro;
begin
    crearMaestro(mae);
end.