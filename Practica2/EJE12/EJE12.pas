program eje12;
const
    valoralto = 9999;
type

    infoMaestro = record
        nroUsuario:integer;
        nombreUsuario:string;
        nomyape:string;
        cantEnviados:integer;
    end;

    infoDetalle = record
        nroUsuario:integer;
        cuentaDestino:string;
        cuerpoMensaje:string;
    end;

    maestro = file of infoMaestro;
    detalle = file of infoDetalle;

    procedure crearMaestro(var mae:maestro);
    var
        txt:text;
        dato:infoMaestro;
    begin
        assign(mae,'maestro');
        rewrite(mae);
        assign(txt,'log.txt');
        reset(txt);

        while not eof(txt)do begin
            with dato do begin
                readln(txt,nroUsuario,cantEnviados,nombreUsuario);
                readln(txt,nomyape);
                write(mae,dato);
            end;
        end;
        close(mae);
        close(txt);
        writeln('| maestro creado |');
    end;

    procedure crearDetalle(var det:detalle);
    var
        txt:text;
        dato:infoDetalle;
    begin
        assign(det,'detalle');
        rewrite(det);
        assign(txt,'infoDetalle.txt');
        reset(txt);

        while not eof(txt)do begin
            with dato do begin
                readln(txt,nroUsuario,cuentaDestino);
                readln(txt,cuerpoMensaje);
                write(det,dato);
            end;
        end;
        close(det);
        close(txt);
        writeln('| detalle creado |');
    end;

    procedure leer(var det:detalle; var dato:infoDetalle);
    begin
        if not eof(det)then
            read(det,dato)
        else
            dato.nroUsuario:= valoralto;
    end;

    procedure actualizarLog(var mae:maestro; var det:detalle);
    var
        datoMae:infoMaestro;
        datoDet:infoDetalle;
        txt:text;
    begin
        reset(mae);
        reset(det);
        assign(txt,'OPCION_II.txt');
        rewrite(txt);
        leer(det,datoDet);
        while(datoDet.nroUsuario <> valoralto)do begin
            read(mae,datoMae);
            while(datoDet.nroUsuario <> datoMae.nroUsuario)do begin
                leer(det,datoDet);
            end;
            while(datoDet.nroUsuario = datoMae.nroUsuario)do begin
                datoMae.cantEnviados:= datoMae.cantEnviados + 1;
                leer(det,datoDet);
            end;
            writeln(txt,datoMae.nroUsuario,' ...... ',datoMae.cantEnviados);
            seek(mae,filepos(mae)-1); // voy uno para atras para escribir la nueva cantidad de enviados
            write(mae,datoMae); // escribo la nueva cantidad
        end;
        close(mae);
        close(det);
        close(txt);
        writeln('| log actualizado y OPCION_II.txt exportada |');
    end;

    procedure exportarTXT(var mae:maestro);
    var
        dato:infoMaestro;
        txt:text;
    begin
        reset(mae);
        assign(txt,'OPCION_I.txt');
        rewrite(txt);
        while not eof(mae)do begin
            with dato do begin
                read(mae,dato);
                writeln(txt, nroUsuario,' ...... ',cantEnviados);
            end;
        end;
        close(mae);
        close(txt);
        writeln('| exportado OPCION_I.txt correctamente ');
    end;

var
    det:detalle;
    mae:maestro;
begin
    crearMaestro(mae);
    crearDetalle(det);
    actualizarLog(mae,det);
    exportarTXT(mae);    
end.
