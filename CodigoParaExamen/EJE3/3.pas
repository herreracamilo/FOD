program programa;
type
    empleado = record
        num_emp:integer;
        apellido:string;
        nombre:string;
        edad:integer;
        dni:integer;
    end;

    archivo_empleados = file of empleado;

    procedure leerEmpleado(var e:empleado);
    begin
        with e do begin
            writeln('numero emp');
            readln(num_emp);
            writeln('apellido');
            readln(apellido);
            writeln('nombre');
            readln(nombre);
            writeln('edad');
            readln(edad);
            writeln('dni');
            readln(dni);
        end;
    end;

    procedure crearArchivo(var arch:archivo_empleados);
    var
        e:empleado;
    begin
        assign(arch,'empleados');
        rewrite(arch);

        leerEmpleado(e);
        while(e.apellido <> 'fin')do begin
            write(arch,e);
            leerEmpleado(e);
        end;
        close(arch);
        writeln('archivo generado \o/');
    end;

    procedure imprimirEmp(e:empleado);
    begin
        with e do begin
            writeln(num_emp);
            writeln(apellido);
            writeln(nombre);
            writeln(edad);
            writeln(dni);
        end;
        
    end;

    procedure listarEnPantalla(var arch:archivo_empleados);
    var
        e:empleado;
        nombre:string;
        apellido:string;
        ok:boolean;
    begin
        ok:=false;
        assign(arch,'empleados');
        reset(arch);
        writeln('ingrese nombre a buscar');
        readln(nombre);
        writeln('ingrese apellido a buscar');
        readln(apellido);

        while not eof(arch) and not (ok) do begin
            read(arch,e);
            if(e.nombre = nombre) and (e.apellido = apellido)then begin
                ok:= true;
                imprimirEmp(e);
            end;
        end;
        if not(ok)then
            writeln('empleado no encontrado');
        close(arch);

        writeln('fin de listado \o/');
    end;

    procedure listarEnUnaLinea(var arch:archivo_empleados);
    var
        e:empleado;
    begin
        assign(arch,'empleados');
        reset(arch);

        while not eof(arch)do begin
            read(arch,e);
            with e do begin
                write(nombre,' ');
                writeln(apellido,' ',num_emp,' ',edad,' ',dni);
            end;
        end;
        close(arch);
        writeln('fin de listado \o/');
    end;

    procedure listarMayoresA70(var arch:archivo_empleados);
    var 
        e:empleado;
    begin
        assign(arch,'empleados');
        reset(arch);

        while not eof(arch)do begin
            read(arch,e);
            if(e.edad > 70)then
                with e do begin
                    write(nombre,' ');
                    writeln(apellido,' ',num_emp,' ',edad,' ',dni);
                end;
                
        end;
        close(arch);
        writeln('fin de listado mayores 70 \o/');
    end;

    procedure agregarAlFinal(var arch:archivo_empleados);
    var
        e,act:empleado;
        sigo:integer;
        repetido:boolean;
    begin
        assign(arch,'empleados');
        reset(arch);

        sigo:=1;
        

        while (sigo <> 0)do begin
           repetido:=false;
           leerEmpleado(e); // leo el empleado para agregar
            while not eof(arch) and not (repetido) do begin // recorro para chequear que no esta repetido
                read(arch,act); // leo el archivo
                if(act.num_emp = e.num_emp)then
                    repetido:= true;
            end;
            if not(repetido)then begin
                seek(arch, filesize(arch)); // voy a la ultima posicion
                write(arch,e);
                writeln('el empleado fue agregado exitosamente \o/');
            end else writeln('el empleado ya esta repetido y no es posible agregarlo');
            writeln('si quiere agregar otro empleado ingrese 1, para salir ingrese 0');
            readln(sigo);
        end;
        close(arch);
        writeln('fin de agregar empleados \o/');
    end;

    procedure modificarEdad(var arch:archivo_empleados);
    var
        e:empleado;
        edad:integer;
        esta:boolean;
        nombre,apellido:string;
    begin
        assign(arch,'empleados');
        reset(arch);

        writeln('ingrese nombre a modificar edad');
        readln(nombre);
        writeln('ingrese apellido a modificar edad');
        readln(apellido);
        esta:=false;
        while not eof(arch) and not (esta)do begin
            read(arch,e);
            if(e.nombre = nombre) and (e.apellido = apellido)then begin
                writeln('ingrese la edad ');
                readln(edad);
                e.edad:= edad;
                seek(arch,filepos(arch)-1);
                write(arch,e);
                writeln('edad modificada \o/');
                esta:=true;
            end;
        end;
        if not(esta)then
            writeln('el empleado no existe y no se pudo modificar');
        close(arch);
        writeln('fin de modificar edad \o/');
    end;

    procedure exportTXT(var arch:archivo_empleados);
    var
        texto:text;
        e:empleado;
    begin
        assign(arch,'empleados');
        reset(arch);

        assign(texto,'todos_empleados.txt');
        rewrite(texto);

        while not eof(arch)do begin
            read(arch,e);
            with e do begin
                write(texto,nombre,' ');
                writeln(texto,apellido,' ',num_emp,' ',edad,' ',dni);
            end;
        end;

        close(arch);
        close(texto);
        writeln('fin de exportar \o/');
    end;

var
    arch:archivo_empleados;
begin
    //crearArchivo(arch);
    //listarEnPantalla(arch);
    //listarEnUnaLinea(arch);
    //agregarAlFinal(arch);
    //modificarEdad(arch);
    exportTXT(arch);
end.