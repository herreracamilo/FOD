(*A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.
*)

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

    procedure crearDetalle(var det:detalle; var carga:text);
    var
        d:datosDetalle;
        nombre:string[20];
    begin
        writeln('ingrese el nombre de detalle');
        readln(nombre);
        assign(det,nombre);
        rewrite(det);

        reset(carga);


        while (not eof(carga)) do begin
            with d do begin
                readln(carga, codLocalidad, cantPAlfa, cantEncuestados, provincia);
                write(det,d);
            end;
        end;
        close(det);
        close(carga);
        writeln('------------------------------------------');
        writeln('archivo detalle creado correctamente');
        writeln('------------------------------------------');
    end;

    procedure crearMaestro(var mae:maestro);
    var
        d:datos;
        texto:text;
    begin
        assign(mae,'maestro');
        rewrite(mae);

        assign(texto, 'maestro.txt');
        reset(texto);
        while not eof(texto)do begin
            with d do begin
                readln(texto, cantPAlfa, totalEncuesta, provincia);
                write(mae, d);
            end;
        end;
        close(mae);
        writeln('------------------------------------------');
        writeln('archivo maestro creado correctamente');
        writeln('------------------------------------------');
    end;

    procedure leer(var det: detalle; var dato: datosDetalle);
    begin
        if(not eof(det)) then
            read(det, dato)
        else
            dato.provincia:= valoralto;
    end;

    procedure minimo(var det1, det2: detalle; var r1, r2, min: datosDetalle);
    begin
        if(r1.provincia <= r2.provincia) then
            begin
                min:= r1;
                leer(det1, r1);
            end
        else
            begin
                min:= r2;
                leer(det2, r2);
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
            read(mae,regm);
            while(regm.provincia<>min.provincia)do begin
                read(mae,regm);
            end;
            while(regm.provincia = min.provincia)do begin
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
            writeln(texto, d.cantPAlfa,' | ',d.totalEncuesta, ' | ', d.provincia);
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
    cargaDet1, cargaDet2:text;
begin
    assign(cargaDet1,'detalle1.txt');
    assign(cargaDet2,'detalle2.txt');
    crearMaestro(mae);
    crearDetalle(det1,cargaDet1);
    crearDetalle(det2,cargaDet2);
    //(*
    actualizarMaestro(mae,det1,det2);
    exportarTXT(mae);
    //*)
end.