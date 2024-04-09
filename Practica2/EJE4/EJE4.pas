(*A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia*)

program EJE4;

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

    detalle = file of datosDetalle;
    maestro = file of datos;

    procedure crearDetalle(var det:detalle);
    var
        d:datos;
        nombre:string[15];
    begin
        writeln('ingrese el nombre de detalle');
        readln(nombre);
        assign(nombre,det);
        rewrite(det);

        leerDatos(d);
        while(d.provincia <> 'ZZZ')do begin
            write(det,d);
            leerDatos(d);
        end;
        close(det);
    end;

    procedure crearMaestro(var mae:maestro);
    var
        d:datos;
    begin
        assign(mae,'maestro');
        rewrite(mae);

        

    end;