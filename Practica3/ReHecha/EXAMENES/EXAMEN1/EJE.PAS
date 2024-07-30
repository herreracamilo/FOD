program eje;

type

    empleado = record 
        dni:integer;
        nombre:string;
        edad:integer;
        domicilio:string;
        nacimiento:string;
    end;

    maestro = file of empleado;

    procedure crearMaestro(var mae:maestro);
    var
        e:empleado;
        txt:text;
    begin
        assign(mae,'maestro');
        rewrite(mae);

        assign(txt,'datos.txt');
        reset(txt);

        while not eof(txt)do begin
            with e do begin
                readln(txt,dni,edad,nombre);
                readln(txt,nacimiento);
                readln(txt,domicilio);
                write(mae,e);
            end;
        end;
        close(mae);
        writeln('| maestro creado |');
    end;

    function existeEmpleado(var mae:maestro; dni:integer):boolean;
    var
        e:empleado;
        encontrado:boolean;
    begin

        encontrado:=false;
        while not eof(mae) and (not encontrado)do begin
            read(mae,e);
            if(e.dni = dni)then
                encontrado:=true;
        end;
        
        existeEmpleado:= encontrado;

    end; 

    procedure leerEmpleado(var e:empleado);
begin
    writeln('Ingrese el DNI del empleado:');
    readln(e.dni);
    
    writeln('Ingrese el nombre del empleado:');
    readln(e.nombre);
    
    writeln('Ingrese la edad del empleado:');
    readln(e.edad);
    
    writeln('Ingrese el domicilio del empleado:');
    readln(e.domicilio);
    
    writeln('Ingrese la fecha de nacimiento del empleado:');
    readln(e.nacimiento);
end;


    procedure agregarEmpleado(var mae:maestro);
    var
        nue,cab,aux:empleado;
        pos:integer;
    begin
        assign(mae,'maestro');
        reset(mae);

        leerEmpleado(nue);
        if(existeEmpleado(mae,nue.dni))then
            writeln('el empleado ya existe')
        else
        begin
            read(mae,cab); // leo la cabecera
            if(cab.dni = 0)then
                write(mae,nue)
            else
                begin
                    pos:= cab.dni * -1; // agarro la posicion que tiene la cabecera
                    seek(mae,pos); // voy a la pos
                    read(mae,aux); // leo lo que habia en la poscion borrada
                    seek(mae,pos); // vuelvo para escribir 
                    write(mae,nue); // escribo el nuevo
                    seek(mae,0); // vuelvo a la cabecera
                    write(mae,aux); // escribo el nuevo dni
                end;
        end;
        close(mae);
    end;

    procedure eliminar(var mae:maestro);
    var
        e,cab:empleado;
        dni:integer;
    begin
        assign(mae,'maestro');
        reset(mae);

        read(mae,cab); // leo la cabecera
        writeln('ingrese dni a eliminar');
        readln(dni);
        if(existeEmpleado(mae,dni))then begin
            seek(mae,dni);
            read(mae,e); // tengo el borrado
            seek(mae,dni); // vuelvo
            write(mae,cab); // escribo la cabecera
            seek(mae,0); // voy a la cabecera
            e.dni:= e.dni * -1;
            write(mae,e);
        end
        else
            writeln('el empleado no existe');
        close(mae);
    end;

    procedure listar(var mae: maestro);
var
    e: empleado;
begin
    assign(mae,'maestro');
    reset(mae);
    writeln('Listado de empleados:');
    while not eof(mae) do
    begin
        read(mae, e);
        if e.dni > 0 then // Ignorar los registros marcados como eliminados
        begin
            writeln('DNI: ', e.dni);
            writeln('Nombre: ', e.nombre);
            writeln('Edad: ', e.edad);
            writeln('Domicilio: ', e.domicilio);
            writeln('Fecha de Nacimiento: ', e.nacimiento);
            writeln('-------------------------');
        end;
    end;
    close(mae);
end;

var
    mae:maestro;
begin
    //crearMaestro(mae);
    agregarEmpleado(mae);
    eliminar(mae);
    eliminar(mae);
    listar(mae);
end.