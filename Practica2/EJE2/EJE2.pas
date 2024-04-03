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
            writeln(texto, a.codigo, ' ',a.nombre, ' ',a.apellido, ' ',a.aprobadasSinF, ' ',a.aprobadasConF);
        end;

        close(archAlumno);
        close(texto);

        writeln('------------------------------------------');
        writeln('archivo txt creado correctamente');
        writeln('------------------------------------------');
    end;

var
    archAlumno: archivo_alumno;
    archDetalle: archivo_detalle;
begin
    creoArchAlumno(archAlumno);
    creoArchDetalle(archDetalle);
    exportarTXT(archAlumno);
end.