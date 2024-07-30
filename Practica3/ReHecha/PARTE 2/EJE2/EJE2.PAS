program eje2;

type
    info = record
        codigo:integer;
        mesa:integer;
        cant:integer;
    end;

    maestro = file of info;

    procedure crearMaestro(var mae:maestro);
    var
        i:info;
        txt:text;
    begin
        assign(mae,'maestro');
        rewrite(mae);
        assign(txt,'maestro.txt');
        reset(txt);

        while not eof(txt)do begin
            with i do begin
                readln(txt,codigo,mesa,cant);
                write(mae,i);
            end;
        end;
        close(txt);
        close(mae);
        writeln('| maestro creado |');
    end;

    procedure listado(var mae,aux:maestro; var cant_total:integer);
    var
        i,iaux:info;
        esta:boolean;
    begin
        assign(mae,'maestro');
        reset(mae);
        assign(aux,'maestro_aux');
        rewrite(aux);

        while not eof(mae)do begin
            read(mae,i);
            seek(aux,0);
            esta:=false;
            while not eof(aux) and not (esta) do begin
                read(aux,iaux);
                if(iaux.codigo = i.codigo)then
                    esta:=true;
            end;
            if(esta)then begin
                iaux.cant:= iaux.cant + i.cant;
                writeln('CANT AUX; ',iaux.cant, 'localidad: ',iaux.codigo);
                seek(aux,filepos(aux)-1);
                write(aux,iaux);
            end
            else
                write(aux,i);
            cant_total:= cant_total + i.cant;
        end;
        close(mae);
        close(aux);
    end;

    procedure imprimir(var mae:maestro; cant_total:integer);
    var
        i:info;
    begin
        reset(mae);

        while not eof(mae)do begin
            with i do begin
                read(mae,i);
                writeln('Codigo de Localidad: ',codigo,' |  Total de Votos: ',cant);
            end;
        end;
        writeln('Total General de Votos: ',cant_total);
        close(mae);
    end;

var
    mae,aux:maestro;
    cant_total:integer;
begin
    crearMaestro(mae);
    listado(mae,aux,cant_total);
    imprimir(aux,cant_total);
end.