(*A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia*)

program EJE4;
const
    valoralto = 'ZZZZZ';
type
    datos = record
        provincia:string[20];
        cantPAlfa:integer;
        totalEncuesta:integer;
    end;

    datosDetalle = record
        provincia:string[20];
        codLocalidad:integer;
        cantPAlfa:integer;
        cantEncuestados:integer;
    end;

    detalle = file of datosDetalle;
    maestro = file of datos;

    procedure leerDatos(var d:datos);
    begin
        writeln('ingrese provincia');
        readln(d.provincia);
        if(d.provincia <> 'ZZZ')then begin
            writeln('ingrese cantidad personas alfabetizadas');
            readln(d.cantPAlfa);
            writeln('ingrese total de personas encuestadas');
            readln(d.totalEncuesta);
        end;
    end;

    procedure leerDetalle(var d:datosDetalle);
    begin
        writeln('ingrese provincia');
        readln(d.provincia);
        if(d.provincia <> 'ZZZ')then begin
            writeln('ingrese codigo de localidad');
            readln(d.codLocalidad);
            writeln('ingrese cantidad personas alfabetizadas');
            readln(d.cantPAlfa);
            writeln('ingrese cantidad encuenstados');
            readln(d.cantEncuestados);
        end;
    end;


    procedure crearDetalle(var det:detalle);
    var
        d:datosDetalle;
        nombre:string[15];
    begin
        writeln('ingrese el nombre de detalle');
        readln(nombre);
        assign(det,nombre);
        rewrite(det);

        leerDetalle(d);
        while(d.provincia <> 'ZZZ')do begin
            write(det,d);
            leerDetalle(d);
        end;
        close(det);
        writeln('------------------------------------------');
        writeln('archivo detalle creado correctamente');
        writeln('------------------------------------------');
    end;

    procedure crearMaestro(var mae:maestro);
    var
        d:datos;
    begin
        assign(mae,'maestro');
        rewrite(mae);

        leerDatos(d);
        while(d.provincia <> 'ZZZ')do begin
            write(mae,d);
            leerDatos(d);
        end;
        close(mae);
        writeln('------------------------------------------');
        writeln('archivo maestro creado correctamente');
        writeln('------------------------------------------');
    end;

    procedure leer(var det:detalle; var regd:datosDetalle);
    begin
        if not eof(det)then
            read(det,regd)
        else
        begin
            regd.provincia:=valoralto;
        end;
    end;

    procedure minimo (var det1,det2:detalle; var regd1,regd2,min:datosDetalle); begin
        if(regd1.provincia <= regd2.provincia)then begin
            min:= regd1;
            leer(det1, regd1);
        end
        else begin
            min:=regd2;
            leer(det2, regd2);
        end;
            
    end;

    procedure actualizarMaestro(var mae:maestro; var det1, det2:detalle);
    var
        regm:datos;
        regd1,regd2,min,aux:datosDetalle;
    begin
        assign(mae, 'maestro');
        assign(det1,'detalle1');
        assign(det2,'detalle2');
        reset(mae);
        reset(det1);
        reset(det2);
        
        
        leer(det1, regd1);
        leer(det2,regd2);
        minimo(det1,det2,regd1,regd2,min);

        while(min.provincia <> valoralto)do begin
            aux:= min;
            read(mae,regm);
            while(regm.provincia <> min.provincia)do
                read(mae,regm);
            while(aux.provincia = min.provincia)do begin
                regm.cantPAlfa:= regm.cantPAlfa + min.cantPAlfa;
                regm.totalEncuesta:= regm.totalEncuesta + min.cantEncuestados;
                minimo(det1,det2,regd1,regd2,min);
            end;
            seek(mae,filepos(mae)-1);
            write(mae,regm);
        end;

        close(mae);
        close(det1);
        close(det2);
        writeln('------------------------------------------');
        writeln('archivo maestro actualizado correctamente');
        writeln('------------------------------------------');

    end;


    //  ----SOLO PARA CHECK---- no lo pide el programa
    procedure exportarTXT(var mae:maestro);
    var
        d:datos;
        texto:text;
    begin
        assign(texto,'maestroActualizado.txt');
        rewrite(texto);

        assign(mae,'maestro');
        reset(mae);

        while not eof(mae)do begin
            read(mae,d);
            writeln(texto, d.provincia, ' | ',d.cantPAlfa,' | ',d.totalEncuesta);
        end;
        close(mae);
        close(texto);
        writeln('------------------------------------------');
        writeln('archivo texto creado correctamente');
        writeln('------------------------------------------');
    end;

     procedure exportarTXTDETALLE(var mae:detalle);
    var
        d:datosDetalle;
        texto:text;
    begin
        assign(texto,'detalle2.txt');
        rewrite(texto);

        assign(mae,'detalle2');
        reset(mae);

        while not eof(mae)do begin
            read(mae,d);
            writeln(texto, d.provincia, ' | ',d.cantPAlfa,' | ',d.cantEncuestados);
        end;
        close(mae);
        close(texto);
        writeln('------------------------------------------');
        writeln('archivo texto creado correctamente');
        writeln('------------------------------------------');
    end;



var
    det1,det2:detalle;
    mae:maestro;
begin
    //crearMaestro(mae);
    //crearDetalle(det1);
    //(*
    actualizarMaestro(mae,det1,det2);
    exportarTXT(mae);
    //*)
    //exportarTXTDETALLE(det2);
end.