program EJE1;

type
    infoMae = record
        codigo:integer;
        nombre:string;
        precio:real;
        stock_actual:integer;
        stock_minimo:integer;
    end;

    infoDet = record
        codigo:integer;
        cantidad_vendida:integer;
    end;

    maestro = file of infoMae;
    detalle = file of infoDet;

    procedure crearMaestro(var mae:maestro);
    var
        dato_mae:infoMae;
        txt:text;
    begin
        assign(mae,'maestro');
        rewrite(mae);
        assign(txt,'maestro.txt');
        reset(txt);

        while not eof(txt)do begin
            with dato_mae do begin
                readln(txt,codigo,precio,stock_actual,stock_minimo,nombre);
                write(mae,dato_mae);
            end;
        end;
        close(mae);
        close(txt);
        writeln('maestro creado');
    end;

    procedure crearDetalle(var det:detalle);
    var
        dato_det:infoDet;
        txt:text;
    begin
        assign(det,'detalle');
        rewrite(det);
        assign(txt,'detalle.txt');
        reset(txt);

        while not eof(txt)do begin
            with dato_det do begin
                readln(txt,codigo,cantidad_vendida);
                write(det,dato_det);
            end;
        end;
        close(det);
        close(txt);
    end;


    procedure actualizo(var mae:maestro; var det:detalle);
    var
        dato_mae:infoMae;
        dato_det:infoDet;
        cant:integer;
    begin
        assign(mae,'maestro');
        reset(mae);
        assign(det,'detalle');
        reset(det);

        while not eof(mae)do begin
            read(mae,dato_mae);
            cant:=0;
            while not eof(det)do begin
                read(det,dato_det);
                if(dato_mae.codigo = dato_det.codigo)then
                    cant:= cant + dato_det.cantidad_vendida;
            end;
            seek(det,0);
            if(cant > 0)then begin
                dato_mae.stock_actual:= dato_mae.stock_actual - cant;
                seek(mae,filepos(mae)-1);
                write(mae,dato_mae);
            end;
        end;
        close(mae);
        close(det);
        writeln('| maestro actualizado |');
    end;


    procedure listar(var mae:maestro);
    var
        dato_mae:infoMae;
    begin
        assign(mae,'maestro');
        reset(mae);
        while not eof(mae)do begin
            with dato_mae do begin
                read(mae,dato_mae);
                writeln(' nombre:',nombre,' cod: ',codigo,' sActual: ',stock_actual,' sMinimo: ',stock_minimo);
            end;
        end;
        close(mae);
    end;
var
    mae:maestro;
    det:detalle;
begin
    crearMaestro(mae);
    crearDetalle(det);
    actualizo(mae,det);
    listar(mae);
end.