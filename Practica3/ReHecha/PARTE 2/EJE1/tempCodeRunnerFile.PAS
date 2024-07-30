procedure listar(var mae:maestro);
    var
        dato_mae:infoMae;
    begin
        assign(mae,'maestro');
        reset(mae);
        while not eof(mae)do begin
            with dato_mae do begin
                read(mae,dato_mae);
                writeln(' nombre: ',nombre,' cod: ',codigo,' sActual: ',stock_actual,' sMinimo: ',stock_minimo);
            end;
        end;
        close(mae);
    end;