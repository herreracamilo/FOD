program eje2;

type

    asistente = record
        nro:integer;
        nombre:string;
    end;

    maestro = file of asistente;

    procedure crearMaestro(var mae:maestro);
    var
        a:asistente;
        txt:text;
    begin
        assign(mae,'maestro');
        rewrite(mae);
        assign(txt,'asistentes.txt');
        reset(txt);

        while not eof(txt)do begin
            with a do begin
                read(txt,nro,nombre);
                write(mae,a);
            end;
        end;
        close(txt);
        close(mae);
        writeln('| maestro creado |');
    end;

    procedure borradoLogico(var mae:maestro);
    var
        a:asistente;
        aux:string;
    begin
        assign(mae,'maestro');
        reset(mae);
        while not eof(mae)do begin
            read(mae,a);
            if(a.nro < 1000)then begin
                a.nombre:= '@'+a.nombre;
                seek(mae,filepos(mae)-1);
                write(mae,a);
            end;
        end;
        close(mae);
        writeln('| menores borrados |');
    end;

    procedure listar(var mae:maestro);
    var
        a:asistente;
        tienearroba:boolean;
    begin
        reset(mae);
        while not eof(mae)do begin
            with a do begin
                read(mae,a);
                tienearroba:= (Copy(a.nombre,1,1) = '@'); // filtro la primer letra del nombre entonces solo imprimo los que no estan borrados.
                if not (tienearroba)then
                    writeln(' nro: ',nro,' nombre: ',nombre);
            end;
        end;
        close(mae);
    end;

var
    mae:maestro;
begin
    crearMaestro(mae);
    borradoLogico(mae);
    listar(mae);
end.