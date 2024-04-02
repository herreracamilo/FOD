(*Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.
*)

program EJE1;
type
    empleado = record 
        codigo:integer;
        nombre:string[50];
        monto:real;
    end;

    detalle = file of empleado;
    maestro = file of empleado;

    procedure leerEmpleado(var e:empleado);
    begin
        writeln('Ingrese apellido y nombre ');
        readln(e.nombre);
        if(e.nombre <> 'fin')then begin
            writeln('Ingrese num empleado');
            readln(e.codigo);
            writeln('Ingrese monto de comision');
            readln(e.monto);
        end;
    end;

    procedure imprimo(var e:empleado); begin
        writeln('Nombre y apellido');
        writeln(e.nombre);
        writeln('Num empleado');
        writeln(e.codigo);
        writeln('Monto de comision');
        writeln(e.monto:2:0);
        writeln(' ');
    end;

    procedure listar(var arch: maestro);
    var
        e:empleado;
    begin
        assign(arch,'maestro');
        reset(arch); // abro el archivo
        while not eof (arch)do begin
            read(arch,e);
            imprimo(e);
        end;
        close(arch);
        writeln('-------------------');
        writeln('archivo cerrado');
        writeln('-------------------');
        
    end;

    procedure creoArchivo(var archDeta: detalle);
    var
        e:empleado;
        nom:string;
    begin
        writeln('ingrese nombre para el archivo');
        readln(nom);
        assign(archDeta, nom);
        rewrite(archDeta); // creo el archivo
        writeln('--------------------------');
        writeln('archivo creado ',nom);
        writeln('--------------------------');

        leerEmpleado(e);
        while(e.nombre<>'fin')do begin
            write(archDeta,e);
            leerEmpleado(e);
        end;
        close(archDeta); //cierro el archivo
        writeln('------------------------------');
        writeln('archivo cargado correctamente');
        writeln('------------------------------');
    end;

    procedure creoMaestro(var archDeta: detalle; var archMaes: maestro);
    var 
        eD,eM:empleado;
        codigoActual:integer;
        montoAcumulado:real;
        nombreActual:string[50];
    begin
        // asigno y abro el maestro
        assign(archDeta, 'detalle');
        reset(archDeta);

        // asigno y creo el maestro
        assign(archMaes, 'maestro');
        rewrite(archMaes);

        codigoActual:= -1;
        montoAcumulado:=0;

        while not eof(archDeta) do begin
            read(archDeta, eD);
            if (eD.codigo <> codigoActual) then begin
                if (codigoActual <> -1) then begin
                    eM.codigo := codigoActual;
                    eM.nombre := nombreActual; // usar el nombre actualizado
                    eM.monto := montoAcumulado;
                    write(archMaes, eM);
                end;
                codigoActual := eD.codigo;
                nombreActual := eD.nombre; // actualizar el nombre actual
                montoAcumulado := 0;
            end;
            montoAcumulado := montoAcumulado + eD.monto;
        end;
        // este es para meter el último
        if (codigoActual <> -1) then begin
            eM.codigo := codigoActual;
            eM.nombre := eD.nombre; 
            eM.monto := montoAcumulado;
            write(archMaes, eM);
        end;
       
        close(archDeta);
        close(archMaes);
        writeln('----------------------------------');
        writeln('archivo compactado exitosamente.');
        writeln('----------------------------------');
    end;


var
    archDeta: detalle;
    archMaes: maestro;
begin
    creoArchivo(archDeta);
    creoMaestro(archDeta,archMaes);
    listar(archMaes);
end.