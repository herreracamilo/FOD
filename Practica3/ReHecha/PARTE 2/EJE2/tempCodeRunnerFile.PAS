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
                    esta:=true
            end;
            if(esta)then begin
                iaux.cant:= iaux.cant + i.cant;
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