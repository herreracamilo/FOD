(*El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.
b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.*)

program EJE3;
const
    valoralto = 9999;
type
    producto = record
        codigo:integer;
        nombre:string[20];
        precio_venta:real;
        stock_actual:integer;
        stock_minimo:integer;
    end;

    info_detalle = record
        codigo:integer;
        unidades_vendidas:integer;
    end;

    maestro = file of producto;
    detalle = file of info_detalle;


    procedure leerProducto(var p:producto);
    begin
        writeln('ingrese codigo');
        readln(p.codigo);
        if(p.codigo <> -1)then begin
            writeln('ingrese nombre');
            readln(p.nombre);
            writeln('ingrese precio venta');
            readln(p.precio_venta);
            writeln('ingrese stock minimo');
            readln(p.stock_minimo);
            writeln('ingrese stock actual');
            readln(p.stock_actual);
        end;
    end;

    procedure leerInfoDetalle(var i:info_detalle);
    begin
        writeln('ingrese codigo');
        readln(i.codigo);
        if(i.codigo <> -1)then begin
            writeln('ingrese unidades vendidas');
            readln(i.unidades_vendidas);
        end;
    end;

    procedure crearMaestro(var mae:maestro);
    var
        p:producto;
    begin
        assign(mae,'maestro'); // le asigno a mae el nombre maestro
        rewrite(mae); // creo el maestro
        
        leerProducto(p); // leo un producto
        while(p.codigo <> -1)do begin // mientras el codigo no sea -1
            write(mae,p); // lo escribo en el maestro
            leerProducto(p); // leo otro producto
        end;
        close(mae); // cierro el maestro
        writeln('------------------------------------------');
        writeln('archivo maestro creado correctamente');
        writeln('------------------------------------------');
    end;

    procedure crearDetalle(var det:detalle);
    var
        i:info_detalle;
    begin
        assign(det, 'detalle'); // asigno el nombre detalle al archivo det
        rewrite(det); // creo el archivo

        leerInfoDetalle(i); // lo informacion para el detalle
        while(i.codigo<> -1)do begin //mientras el codigo sea distinto de -1 sigo
            write(det,i); //escribo en det la info leida
            leerInfoDetalle(i); // leo otra info
        end;
        close(det);
        writeln('------------------------------------------');
        writeln('archivo detalle creado correctamente');
        writeln('------------------------------------------');
    end;

    procedure leer(var det:detalle; var regd:info_detalle);
    begin
        if not eof(det)then
            read(det,regd)
        else
        begin
            regd.codigo:=valoralto;
        end;
    end;
    
    procedure actualizarMaestro(var mae:maestro; var det:detalle);
    var
        regd:info_detalle;
        regm:producto;
    begin
        assign(mae,'maestro');
        assign(det,'detalle');
        reset(mae);
        reset(det);

        leer(det,regd);
        while(regd.codigo <> valoralto)do begin
            read(mae, regm);
            while(regm.codigo <> regd.codigo)do begin
                read(mae,regm);
            end;
            while(regm.codigo = regd.codigo)do begin
                regm.stock_actual:= regm.stock_actual - regd.unidades_vendidas;
                leer(det,regd);
            end;
            seek(mae, filepos(mae)-1);
            write(mae,regm);
        end;
        close(mae);
        close(det);
        writeln('------------------------------------------');
        writeln('archivo maestro actualizado correctamente');
        writeln('------------------------------------------');
    end;

    procedure exportarTXT(var mae:maestro);
    var
        p:producto;
        texto:text;
    begin
        assign(texto,'stock_minimo.txt');
        rewrite(texto);

        assign(mae,'maestro');
        reset(mae);

        while not eof(mae)do begin
            read(mae,p);
            if(p.stock_actual < p.stock_minimo)then
                writeln(texto, p.codigo, ' | ',p.nombre,' | $',p.precio_venta:2:0,' | actual ',p.stock_actual,' | minimo ',p.stock_minimo);
        end;
        close(mae);
        close(texto);
        writeln('------------------------------------------');
        writeln('archivo texto creado correctamente');
        writeln('------------------------------------------');
    end;

var
    det:detalle;
    mae:maestro;
begin
    //crearMaestro(mae);
    //crearDetalle(det);
    //actualizarMaestro(mae,det);
    exportarTXT(mae);
end.