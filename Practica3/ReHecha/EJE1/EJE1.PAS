program eje1;
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

    procedure eliminar(var arch:archivo_empleado);
    var
        e,aux:empleado;
        nombre_archivo,nombre:string;
        borrado:boolean;
    begin
        borrado:=false;
        writeln('ingresa el nombre del archivo en el cual buscar ');
        readln(nombre_archivo);
        assign(arch,nombre_archivo);
        reset(arch); // abro el archivo

        writeln('ingrese el nombre ');
        read(nombre);

        seek(arch,filesize(arch)-1); // voy a la ultima posicion
        read(arch,aux); // copio el ultimo
        seek(arch,0); // vuelvo al primero

        while not eof(arch) and not (borrado) do begin
            read(arch,e);
            if(e.ApeNom = nombre)then begin
                borrado:=true;
                seek(arch,filepos(arch)-1);
                write(arch,aux);
                seek(arch,filesize(arch)-1);
                write(arch,e);
                seek(arch,filesize(arch)-1);
                truncate(arch);
            end;
        end;
        if not(borrado)then
            writeln('no se encontro el nombre de la persona');
        close(arch);
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
    writeln('para eliminar ingrese: b');
    writeln(' ');
    writeln('----------------------------------------------------');
    readln(opcion);
    
    if(opcion = 'c')then
        crear(arch) // opcion c crear
    else
        if(opcion = 'i')then begin
            buscar(arch);
        end
        else
            if(opcion = 'ii')then
                listar(arch)
            else
                if(opcion = 'iii')then
                    jubilado(arch)
                else
                    if(opcion = 'b')then
                    eliminar(arch)
                    else
                        writeln('error, opcion incorrecta');
end.