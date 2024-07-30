program programa;
const valoralto = 9999;
type
    producto = record
        codigo:integer;
        nombre:string;
        precio_venta:real;
        stockact:integer;
        stockmin:integer;
    end;

    venta = record
        codigo:integer;
        unidades_vendidas:integer;
    end;

    archivo_maestro = file of producto;
    archivo_detalle = file of venta;

    procedure leer(var archDet:archivo_detalle; var dato:venta);
    begin
        if not eof(archDet)then begin
            read(archDet,dato);
        end else dato.codigo:= valoralto;
    end;

    procedure actualizarMae(var archMae:archivo_maestro; var archDet:archivo_detalle);
    var
        v:venta;
        p:producto;
        total:integer;
        actual:integer;
    begin
        assign(archMae,'maestro');
        assign(archDet,'detalle');
        reset(archMae);
        reset(archDet);

        read(archMae,p);
        leer(archDet,v);
        while (v.codigo <> valoralto)do begin
            actual:= v.codigo;
            total:=0;
            while (actual = v.codigo) do begin
                total:= total + v.unidades_vendidas;
                leer(archDet,v);
            end;
            while(p.codigo <> actual)do
                read(archMae,p);
            p.stockact:= p.stockact - total;
            seek(archMae, filepos(archMae)-1);
            write(archMae,p);
            if not eof(archMae) then
                read(archMae, p);
        end;
        close(archDet);
        close(archMae);
        writeln('fin de actualizar \o/');
    end;

    procedure crearMaestro(var archMae:archivo_maestro);
    var
        p:producto;
        texto:text;
    begin
        assign(archMae,'maestro');
        rewrite(archMae);
        assign(texto,'productos.txt');
        reset(texto);

        while not eof(texto)do begin
            with p do begin
                read(texto,codigo,precio_venta,stockact,stockmin,nombre);
                write(archMae,p);
            end;
        end;
        close(archMae);
        close(texto);
        writeln('maestro creado \o/');
    end;

    procedure crearDetalle(var archDet:archivo_detalle);
    var
        v:venta;
        texto:text;
    begin
        assign(archDet,'detalle');
        rewrite(archDet);
        assign(texto,'detalle.txt');
        reset(texto);

        while not eof(texto)do begin
            with v do begin
                read(texto,codigo,unidades_vendidas);
                write(archDet,v);
            end;
        end;
        close(archDet);
        close(texto);
        writeln('detalle creado \o/');
    end;

    procedure listar(var archMae:archivo_maestro);
    var
        p:producto;
    begin
        assign(archMae,'maestro');
        reset(archMae);
        while not eof(archMae)do begin
            with p do begin
                read(archMae,p);
                writeln(codigo,' ',precio_venta:2:2,' ',stockact,' ',stockmin,' ', nombre);
            end;
        end;
        close(archMae);
    end;

var
    archDet:archivo_detalle;
    archMae:archivo_maestro;
begin
    crearMaestro(archMae);
    crearDetalle(archDet);
    actualizarMae(archMae,archDet);
    listar(archMae);
end.