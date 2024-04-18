program EJE7;
const
    DF = 5;
    valoralto = 9999;
type
    rango = 1..DF;
    infoMaestro = record
        codLocalidad:integer;
        nomLocalidad:string[50];
        codCepa:integer;
        nomCepa:string[50];
        cantCasosActivos:integer;
        cantCasosNuevos:integer;
        cantRecuperados:integer;
        cantFallecidos:integer;
    end;

    infoDetalle = record
        codLocalidad:integer;
        codCepa:integer;
        cantCasosActivos:integer;
        cantCasosNuevos:integer;
        cantRecuperados:integer;
        cantFallecidos:integer;
    end;

    maestro = file of infoMaestro;
    detalle = file of infoDetalle;
    vectorDetalles = array [rango] of detalle;
    vectorRegistroDet = array[rango] of infoDetalle;

    procedure crearDetalle(var det:detalle);
    var
        i:infoDetalle;
        nombre:string[50];
        texto:text;
    begin
        writeln('ingrese nombre detalle');
        readln(nombre);
        assign(det,nombre);
        assign(texto,nombre+'.txt');
        reset(texto);
        rewrite(det);

        while not eof(texto) do begin
            with i do begin
                read(texto,codLocalidad, codCepa,cantCasosActivos,cantCasosNuevos,cantRecuperados,cantFallecidos);
                writeln(det,i);
            end;
        end;
        close(texto);
        close(det);
        writeln('------------------------------------------');
        writeln('archivo detalle creado correctamente');
        writeln('------------------------------------------');
    end;

    procedure crearDetalles(var vecDet:vectorDetalles);
    var
        i:integer;
    begin
        for i:= 1 to DF do begin
            crearDetalle(vecDet[i]);
        end;
    end;

    procedure crearMaestro(var mae:maestro);
    var
        i:infoMaestro;
        texto:text;
    begin
        assign(mae,'maestro');
        assign(texto,'maestro.txt');
        reset(texto);
        rewrite(mae);
        
        while not eof (texto) do begin
            with i do begin
                readln(texto,codLocalidad,nomLocalidad);
                readln(texto,codCepa,nomCepa);
                readln(texto, cantCasosActivos, cantCasosNuevos, cantRecuperados, cantFallecidos);
                write(mae,i);
            end;
        end;
        close(mae);
        close(texto);
        writeln('------------------------------------------');
        writeln('archivo maestro creado correctamente');
        writeln('------------------------------------------');
    end;

    procedure leer(var det:detalle; var dato:infoDetalle);
    begin
        if not eof(det)then
            read(det,dato)
        else
            dato.codLocalidad:=valoralto;
    end;

    procedure minimo(var vecDet:vectorDetalles; var vecR:vectorRegistroDet var min:infoDetalle);
    var
        i,pos:integer;
    begin
        min.codLocalidad:= valoralto;
        min.codCepa:= valoralto;
        for i:= 1 to DF do begin
            if(vecR[i].codLocalidad < min.codLocalidad) or ((vecR[i].codLocalidad = min.codLocalidad) and (vecR[i].codCepa < min.codCepa))then begin
                
            end;
        end;
    end;