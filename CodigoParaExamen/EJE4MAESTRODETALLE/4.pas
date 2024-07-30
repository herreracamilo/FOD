program programa;

const valoralto = 999;
type
    empleado = record
        codigo:integer;
        nombre:string;
        monto_comision:real;
    end;

    archivo_maestro = file of empleado;
    archivo_detalle = file of empleado;

    procedure leer(var archDet:archivo_detalle; var e:empleado);
    begin
        if not eof(archDet)then
            read(archDet,e)
        else
            e.codigo:= valoralto;
    end;

    procedure compactar(var archMae:archivo_maestro; var archDet:archivo_detalle);
    var
        e,eMae:empleado;
        total:real;
        actual:integer;
    begin
        assign(archMae,'maestro');
        assign(archDet,'detalle');
        rewrite(archMae);
        reset(archDet);
        
        leer(archDet,e);
        while (e.codigo <> valoralto)do begin
            total:=0;
            actual:=e.codigo;
            eMae:=e;
            while(actual = e.codigo)do begin
                total:= total + e.monto_comision;
                leer(archDet,e);
            end;
            eMae.monto_comision:= total;
            write(archMae,eMae);
        end;
        close(archDet);
        close(archMae);
        writeln('fin de compactar \o/');
    end;

    procedure crearDetalle(var archDet:archivo_detalle);
    var
        e:empleado;
        texto:text;
    begin
        assign(archDet,'detalle');
        rewrite(archDet);
        assign(texto,'detalle.txt');
        reset(texto);
        while not eof(texto)do begin
            with e do begin
                read(texto, codigo, monto_comision,nombre);
                write(archDet,e);
            end;
        end;
        close(archDet);
        close(texto);
        writeln('detalle creado \o/');
    end;

    procedure listarMae(var archMae:archivo_maestro);
    var
        e:empleado;
    begin
        assign(archMae,'maestro');
        reset(archMae);

        while not eof(archMae)do begin
            read(archMae,e);
            with e do begin
                writeln(codigo,' ',monto_comision:2:2,' ',nombre);
            end;
        end;
        close(archMae);
    end;

var
    archMae:archivo_maestro;
    archDet:archivo_detalle;
begin
    crearDetalle(archDet);
    compactar(archMae,archDet);
    listarMae(archMae);
end.