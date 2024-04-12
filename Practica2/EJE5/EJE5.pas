(*Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.
*)


program EJE5;
const
    sucu = 4;
    valoralto = 9999;
    
type
    rango = 1..sucu;
    producto = record
        codigo:integer;
        nombre:string[20];
        desc:string[50];
        stockDisponible:integer;
        stockMinimo:integer;
        precio:real;
    end;

    infoDetalle = record
        codigo:integer;
        cantVendida:integer;
    end;

    maestro = file of producto;
    detalle = file of infoDetalle;
    vecDetalles = array [rango] of detalle;
    vecRegDetalles = array [rango] of infoDetalle;

    procedure leer(var det:detalle; var dato:infoDetalle);
    begin
        if not eof(det)then begin
            read(det,dato);
        end
        else
            dato.codigo:= valoralto;
    end;

    procedure minimo(var vec:vecDetalles; var vecR:vecRegDetalles; var min:infoDetalle);
    var
        i,pos:integer;
    begin
        min.codigo:= valoralto;
        for i:= 1 to sucu do begin
            if(vecR[i].codigo < min.codigo)then begin
                min:= vecR[i];
                pos:= i;
            end;
        end;
        if(min.codigo<>valoralto)then
            leer(vec[pos],vecR[pos]);
    end;

    procedure actualizarMaestro(var mae:maestro ; var vec:vecDetalles);
    var
        min:infoDetalle;
        regm:producto;
        vecR:vecRegDetalles;
        i,cant,actual:integer;
    begin
        assign(mae, 'maestro');
        reset(mae);

        for i:= 1 to sucu do begin
            reset(vec[i]);
            leer(vec[i],vecR[i]);
        end;
        minimo(vec,vecR,min);
        while(min.codigo <> valoralto)do begin
            actual:= min.codigo;
            cant:=0;
            while(min.codigo <> valoralto) and( min.codigo = actual)do begin
                cant:= cant + min.cantVendida;
                minimo(vec,vecR,min);
            end;
            read(mae,regm);
            while(regm.codigo <> actual)do begin
                read(mae,regm);
            end;
            seek(mae,filepos(mae)-1);
            regm.stockDisponible:= regm.stockDisponible - cant;
            write(mae, regm);
        end;
        close(mae);
        for i:= 1 to sucu do
            close(vec[i]);
    end;

    procedure crearMaestro(var mae:maestro);
    var
        p:producto;
        texto:text;
    begin
        assign(texto, 'maestro.txt');
        assign(mae,'maestro');
        reset(texto);
        rewrite(mae);

        while not eof(texto)do begin
            with p do begin
                readln(texto, codigo, stockDisponible, stockMinimo, precio, nombre);
                readln(texto, desc);
                write(mae, p);
            end;
        end;
        close(mae);
        close(texto);
        writeln('------------------------------------------');
        writeln('archivo maestro creado correctamente');
        writeln('------------------------------------------');
    end;

    procedure crearDetalle(var det:detalle);
    var
        i:infoDetalle;
        texto:text;
        nombre:string[15];
    begin
        writeln('ingrese nombre del detalle');
        readln(nombre);
        assign(det,nombre);
        assign(texto,(nombre+'.txt'));
        rewrite(det);
        reset(texto);
        while not eof(texto)do begin
            with i do begin
                readln(texto, codigo, cantVendida);
                write(det,i);
            end;
        end;
        close(det);
        close(texto);
        writeln('------------------------------------------');
        writeln('archivo detalle creado correctamente');
        writeln('------------------------------------------');
    end;

    procedure crearVecDetalles(var vecDet: vecDetalles);
    var
        i:integer;
    begin
        for i:= 1 to sucu do begin
            crearDetalle(vecDet[i]);
        end;
    end;


    procedure exportarTEST(var mae:maestro);
    var
        d:producto;
        texto:text;
    begin
        assign(texto,'maestroComprobar.txt');
        rewrite(texto);

        assign(mae,'maestro');
        reset(mae);

        while not eof(mae)do begin
            read(mae,d);
            writeln(texto,d.nombre);
            writeln(texto, d.codigo,' | ',d.stockDisponible, ' | ', d.stockMinimo, ' | ', d.desc);
        end;
        close(mae);
        close(texto);
        writeln('------------------------------------------');
        writeln('archivo comprobar creado correctamente');
        writeln('------------------------------------------');
    end;

    procedure exoportarMenoresMinimo(var mae:maestro);
    var
        d:producto;
        texto:text;
    begin
        assign(texto,'informeMenoresMinimo.txt');
        rewrite(texto);

        assign(mae,'maestro');
        reset(mae);

        while not eof(mae)do begin
                read(mae,d);
                if(d.stockDisponible < d.stockMinimo)then begin
                    writeln(texto,d.nombre);
                    writeln(texto, d.desc,' | ',d.codigo, ' | ', d.stockDisponible, ' | ');
            end;
        end;
        close(mae);
        close(texto);
        writeln('-----------------------------------------------------');
        writeln('archivo exoportarMenoresMinimo creado correctamente');
        writeln('-----------------------------------------------------');
    end;

(*
    procedure exportarDTXT(var mae:detalle);
    var
        d:infoDetalle;
        texto:text;
    begin
        assign(texto,'dddd.txt');
        rewrite(texto);

        assign(mae,'detalle1');
        reset(mae);

        while not eof(mae)do begin
            read(mae,d);
            writeln(texto, d.codigo,' | ',d.cantVendida);
        end;
        close(mae);
        close(texto);
        writeln('------------------------------------------');
        writeln('archivo dddd creado correctamente');
        writeln('------------------------------------------');
    end;
*)
    var
        mae:maestro;
        vecDet:vecDetalles;
    begin
        crearMaestro(mae);
        crearVecDetalles(vecDet);
        actualizarMaestro(mae,vecDet);
        exoportarMenoresMinimo(mae);
    end.