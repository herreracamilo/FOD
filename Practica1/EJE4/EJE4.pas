(*
Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
un número de empleado ya registrado (control de unicidad).
b. Modificar la edad de un empleado dado.
c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado.
*)

program EJE4;
type
    empleado = record
        numEmp:integer;
        ApeNom:String[25];
        edad:integer;
        dni:integer;
    end;

    archivo_empleado = file of empleado;


    procedure leoEmp(var e:empleado);
    begin
        writeln('Ingrese apellido y nombre ');
        readln(e.ApeNom);
        if(e.ApeNom <> 'fin')then begin
            writeln('Ingrese num empleado');
            readln(e.numEmp);
            writeln('Ingrese edad');
            readln(e.edad);
            writeln('Ingrese dni');
            readln(e.dni);
        end;
    end;

    procedure imprimo(var e:empleado); begin
        writeln('Nombre y apellido');
        writeln(e.ApeNom);
        writeln('Num empleado');
        writeln(e.numEmp);
        writeln('Edad');
        writeln(e.edad);
        writeln('Dni');
        writeln(e.dni);
        writeln(' ');
    end;

    procedure crear(var arch:archivo_empleado);
    var
        e:empleado;
        nom:string;
    begin
        writeln('ingrese nombre para el archivo');
        readln(nom);
        assign(arch, nom);
        rewrite(arch); // creo el archivo
        writeln('--------------------------');
        writeln('archivo creado ',nom);
        writeln('--------------------------');

        leoEmp(e);
        while(e.ApeNom<>'fin')do begin
            write(arch,e);
            leoEmp(e);
        end;
        close(arch); //cierro el archivo
        writeln('------------------------------');
        writeln('archivo cargado correctamente');
        writeln('------------------------------');
    end;

    procedure buscar(var arch:archivo_empleado);
    var
        e:empleado;
        nom,nombre_archivo:string;
    begin
        writeln('ingresa el nombre del archivo en el cual buscar ');
        readln(nombre_archivo);
        assign(arch,nombre_archivo);
        reset(arch); // abro el archivo
        writeln('ingrese nombre y apellido a buscar');
        readln(nom);
        while not eof (arch)do begin
            read(arch,e);
            if(e.ApeNom = nom)then begin
                imprimo(e);
            end;
        end;
        close(arch);
        writeln('archivo cerrado');
    end;

    procedure listar(var arch:archivo_empleado);
    var
        e:empleado;
        nombre_archivo:string;
    begin
        writeln('ingresa el nombre del archivo en el cual buscar ');
        readln(nombre_archivo);
        assign(arch,nombre_archivo);
        reset(arch); // abro el archivo
        while not eof (arch)do begin
            read(arch,e);
            imprimo(e);
        end;
        close(arch);
        writeln('archivo cerrado');
        
    end;

    procedure jubilado (var arch:archivo_empleado);
    var
        e:empleado;
        nombre_archivo:string;
    begin
        writeln('ingresa el nombre del archivo en el cual buscar ');
        readln(nombre_archivo);
        assign(arch,nombre_archivo);
        reset(arch); // abro el archivo
        while not eof (arch)do begin
            read(arch,e);
            if(e.edad > 70)then
                imprimo(e);
        end;
        close(arch);
        writeln('archivo cerrado');
    end;

    procedure agregar_empleado(var arch: archivo_empleado);
    var
        j: empleado;
        e:empleado;
        nombre_archivo: string;
        repetido: boolean;
        sigo: integer;
        empLeido: integer;
    begin
        sigo := 1;
        writeln('ingresa el nombre del archivo en el cual buscar: ');
        readln(nombre_archivo);
        assign(arch, nombre_archivo);
        reset(arch);
    
        while sigo <> 0 do begin
            repetido := false; // lo reinicio para cada pibe
            leoEmp(j);
            empLeido := j.numEmp;

            while not eof(arch) do begin
                read(arch, e);
                if (e.numEmp = empLeido) and (not repetido) then begin
                    writeln('el empleado ya está ingresado.');
                    repetido := true;
                end;
            end;

            if not repetido then begin
                seek(arch, filesize(arch)); // voy a la ultima posicion o sea al eof
                write(arch, j);
                writeln('el empleado fue registrado correctamente.');
            end;
        
            writeln('ingresa 1 para continuar agregando o 0 para finalizar: ');
            readln(sigo);
        end;
    
        close(arch);
    end;


    procedure modificar_edad(var arch:archivo_empleado);
    var
        nuevaEdad:integer;
        numEmp:integer;
        encontrado:boolean;
        nombre_archivo:string;
        e:empleado;
    begin
        encontrado:=false;
        writeln('ingresa el nombre del archivo en el cual buscar ');
        readln(nombre_archivo);
        assign(arch,nombre_archivo);
        reset(arch);
        writeln('ingrese el numero de empleado al cual quiere modificar la edad');
        readln(numEmp);
        while not eof (arch)do begin
            read(arch,e);
            if(e.numEmp = numEmp)then begin
                writeln('ingrese la nueva edad');
                readln(nuevaEdad);
                encontrado:= true;
                e.edad:= nuevaEdad;
                seek(arch, filesize(arch) - 1); // lo posiciono uno atras que es donde va
                write(arch,e);
                writeln('edad modificada correctamente');
            end;
            if not encontrado then begin
                writeln('el empleado no fue encontrado');
            end;
        end;
        close(arch);
    end;

    procedure exportar (var arch:archivo_empleado);
    var
        nombre_archivo:string;
        archtxt:text;
        e:empleado;
    begin
        writeln('ingresa el nombre del archivo a exportar ');
        readln(nombre_archivo);
        assign(arch,nombre_archivo);
        reset(arch);

        assign(archtxt, 'todos_empleados.txt');
        rewrite(archtxt);

        while not eof (arch)do begin
            read(arch,e);
            writeln(archtxt, 'nombre y apellido: ', e.ApeNom);
            writeln(archtxt, 'num empleado: ', e.numEmp);
            writeln(archtxt, 'edad: ', e.edad);
            writeln(archtxt, 'dni: ', e.dni);
            writeln(archtxt);
        end;
        close(arch);
        close(archtxt);
        writeln('el archivo se exporto correctamente');
    end;

    procedure exportar_dni00(var arch:archivo_empleado);
    var
        nombre_archivo:string;
        archtxt:text;
        e:empleado; 
    begin
        writeln('ingresa el nombre del archivo en el cual buscar ');
        readln(nombre_archivo);
        assign(arch,nombre_archivo);
        reset(arch);

        assign(archtxt, 'faltaDNIEmpleado.txt');
        rewrite(archtxt);

        while not eof (arch)do begin
            read(arch,e);
            if(e.dni = 00)then begin
                writeln(archtxt, 'nombre y apellido: ', e.ApeNom);
                writeln(archtxt, 'num empleado: ', e.numEmp);
                writeln(archtxt, 'edad: ', e.edad);
                writeln(archtxt, 'dni: ', e.dni);
                writeln(archtxt);
            end;
        end;
        close(arch);
        close(archtxt);
        writeln('el archivo fue creado correctamente');
    end;


var
    arch:archivo_empleado;
    opcion:string[25];
begin
    writeln('----------------------------------------------------');
    writeln('para crear un archivo ingrese: c');
    writeln(' ');
    writeln('para listar en pantalla los datos de empleados que tengan un nombre o apellido');
    write('determinado, el cual se proporciona desde el teclado ingrese: i');
    writeln(' ');
    writeln('para listar en pantalla los empleados de a uno por línea ingrese: ii');
    writeln(' ');
    writeln('para listar en pantalla los empleados mayores de 70 años, próximos a jubilarse ingrese: iii');
    writeln(' ');
    writeln('para agregar mas empleados ingrese: iiii');
    writeln(' ');
    writeln('para modificar la edad de un empleado ingrese: iiiii');
    writeln(' ');
    writeln('para exportar el contenido del archivo a un archivo de texto llamado todos_empleados.txt ingrese: iiiiii');
    writeln(' ');
    writeln('para exportar a un archivo de texto llamado: faltaDNIEmpleado.txt, los empleados que no tengan cargado el DNI (DNI en 00). ingrese: iiiiiii');
    writeln(' ');
    writeln('----------------------------------------------------');
    readln(opcion);
    
    case opcion of
        'c': crear(arch);
        'i': buscar(arch);
        'ii': listar(arch);
        'iii': jubilado(arch);
        'iiii': agregar_empleado(arch);
        'iiiii': modificar_edad(arch);
        'iiiiii': exportar(arch);
        'iiiiiii': exportar_dni00(arch);
    else
        writeln('error, opción incorrecta');
    end;

end.