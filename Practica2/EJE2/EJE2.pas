(*Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:
a. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado,
y se decrementa en uno la cantidad de materias sin final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.
b. Listar en un archivo de texto aquellos alumnos que tengan más materias con finales
aprobados que materias sin finales aprobados. Teniendo en cuenta que este listado
es un reporte de salida (no se usa con fines de carga), debe informar todos los
campos de cada alumno en una sola línea del archivo de texto.
NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.
*)


program EJE2;
const valoralto = 9999;
type
    alumno = record
        codigo:integer;
        nombre:string[15];
        apellido:string[15];
        aprobadasSinF:integer;
        aprobadasConF:integer;
    end;

    info_detalle = record
        cod:integer;
        cursada:string[15];
        final:string[15];
    end;

    archivo_alumno = file of alumno;
    archivo_detalle = file of info_detalle;

    procedure leoAlumno(var a:alumno);
    begin
        writeln('ingrese codigo de alumno');
        readln(a.codigo);
        if(a.codigo <> -1)then begin
            writeln('apellido');
            readln(a.apellido);
            writeln('nombre');
            readln(a.nombre);
            writeln('cursadas');
            readln(a.aprobadasSinF);
            writeln('finales');
            readln(a.aprobadasConF);
        end;
        
    end;

    procedure leoInfo(var i:info_detalle);
    begin
        writeln('codigo');
        readln(i.cod);
        if(i.cod <> -1)then begin
            writeln('cursada');
            readln(i.cursada);
            writeln('final');
            readln(i.final);
        end;
    end;

    procedure leer(var archDetalle:archivo_detalle; var regd:info_detalle);
    begin
        if not eof(archDetalle)then
            read(archDetalle,regd)
        else
        begin
            regd.cod:=valoralto;
        end;
    end;

    procedure creoArchAlumno(var archAlumno: archivo_alumno);
    var
        a:alumno;
    begin
        assign(archAlumno, 'alumno');
        rewrite(archAlumno);
        leoAlumno(a);
        while(a.codigo<>-1)do begin
            write(archAlumno,a);
            leoAlumno(a);
        end;
        close(archAlumno);
        writeln('------------------------------------------');
        writeln('archivo alumno creado correctamente');
        writeln('------------------------------------------');
    end;

    procedure creoArchDetalle(var archDetalle: archivo_detalle);
    var
        i:info_detalle;
    begin
        assign(archDetalle, 'detalle');
        rewrite(archDetalle);
        leoInfo(i);
        while(i.cod<>-1)do begin
            write(archDetalle,i);
            leoInfo(i);
        end;
        close(archDetalle);
        writeln('------------------------------------------');
        writeln('archivo detalle creado correctamente');
        writeln('------------------------------------------');
    end;

    procedure exportarTXT(var archAlumno: archivo_alumno);
    var
        texto:text;
        a:alumno;
    begin
        assign(archAlumno, 'alumno');
        reset(archAlumno);

        assign(texto,'maestro.txt');
        rewrite(texto);

        while not eof (archAlumno)do begin
            read(archAlumno, a);
            if(a.aprobadasConF>a.aprobadasSinF)then
                writeln(texto, a.codigo, ' ',a.nombre, ' ',a.apellido, ' ',a.aprobadasSinF, ' ',a.aprobadasConF);
        end;

        close(archAlumno);
        close(texto);

        writeln('------------------------------------------');
        writeln('archivo txt creado correctamente');
        writeln('------------------------------------------');
    end;
    
    procedure actualizarMaestro(var archAlumno:archivo_alumno; var archDetalle:archivo_detalle);
    var
        regm:alumno;
        regd:info_detalle;
    begin
        assign(archAlumno,'alumno');
        assign(archDetalle,'detalle');
        reset(archAlumno); // abro el maestro
        reset(archDetalle); // abro el detalle
        leer(archDetalle,regd); // leo el archivo detalle mientras no sea su fin
        while(regd.cod <> valoralto)do begin // mientras el codigo del detalle sea distinto de la constante valor alto sigo actualizando
            read(archAlumno, regm); // leo el primer alumno
            while(regd.cod<>regm.codigo)do // mientras el codigo del alumno que lei en el detalle sea <> del codigo del archivo maestro, leo el siguiente alumno
                read(archAlumno,regm); // leo el siguiente alumno hasta encontrar el mismo que el detalle
            while(regd.cod = regm.codigo)do begin // mientras el codigo del detalle sea igual al codigo del maestro sigo ejecutando la actualizacion
                if(regd.cursada = 'aprobada')then
                    regm.aprobadasSinF:= regm.aprobadasSinF + 1;
                if(regd.final = 'aprobada')then begin
                    regm.aprobadasSinF:= regm.aprobadasSinF - 1;
                    regm.aprobadasConF:= regm.aprobadasConF + 1;
                end;
                leer(archDetalle,regd); // leo el proximo del detalle, si es el mismo que el maestro voy a seguir en el while, sino salgo
            end;
            seek(archAlumno, filepos(archAlumno)-1); // me posiciono en el anterior en el maestro para actualizarlo con los datos que modifique recien
            write(archAlumno,regm); // escribo en ese alumno el nuevo regitro modificado
        end;
        close(archAlumno);// cierro el maestro
        close(archDetalle); // cierro el detalle
    end;



var
    archAlumno: archivo_alumno;
    archDetalle: archivo_detalle;
begin
    //creoArchDetalle(archDetalle); //este lo usé para crear el detalle para probar el programa
    
    creoArchAlumno(archAlumno); // este crea el maestro tambien para probar
    actualizarMaestro(archAlumno,archDetalle);
    exportarTXT(archAlumno);
    
end.