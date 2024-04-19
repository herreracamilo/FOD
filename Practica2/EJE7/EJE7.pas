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
                readln(texto,codLocalidad, codCepa,cantCasosActivos,cantCasosNuevos,cantRecuperados,cantFallecidos);
                write(det,i);
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

    procedure minimo(var vecDet:vectorDetalles; var vecR:vectorRegistroDet ;var min:infoDetalle);
    var
        i,pos:integer;
    begin
        min.codLocalidad:= valoralto;
        min.codCepa:= valoralto;
        for i:= 1 to DF do begin
            if(vecR[i].codLocalidad < min.codLocalidad) or ((vecR[i].codLocalidad = min.codLocalidad) and (vecR[i].codCepa < min.codCepa))then begin
                min:= vecR[i];
                pos:= i;
            end;
        end;
        if(min.codLocalidad <> valoralto)then
            leer(vecDet[pos],vecR[pos]);
    end;

    procedure actualizarMaestro(var mae:maestro; var vecDet:vectorDetalles);
    var
        i:integer;
        vecR:vectorRegistroDet;
        min:infoDetalle;
        regm:infoMaestro;
    begin
        assign(mae,'maestro');
        reset(mae);
        for i:= 1 to DF do begin
            reset(vecDet[i]);
            leer(vecDet[i],vecR[i]);
        end;
        minimo(vecDet,vecR,min);
        while(min.codLocalidad<>valoralto)do begin
            read(mae,regm);
            while(regm.codLocalidad <> min.codLocalidad)do begin
                read(mae,regm);
            end;
            while(regm.codLocalidad = min.codLocalidad)do begin
                while(regm.codCepa <> min.codCepa)do
                    read(mae,regm);
                while(regm.codLocalidad = min.codLocalidad) and(regm.codCepa = min.codCepa)do begin
                    regm.cantCasosActivos:= regm.cantCasosActivos + min.cantCasosActivos;
                    regm.cantCasosNuevos:= regm.cantCasosNuevos + min.cantCasosNuevos;
                    regm.cantRecuperados:= regm.cantRecuperados + min.cantRecuperados;
                    regm.cantFallecidos:= regm.cantFallecidos + min.cantFallecidos;
                    minimo(vecDet,vecR,min);
                end;
                seek(mae,filepos(mae)-1);
                write(mae,regm);
            end;
        end;
        close(mae);
        for i:= 1 to DF do
            close(vecDet[i]);
        writeln(' ========== MAESTRO ACTUALIZADO =========')
    end;

    procedure imprimirMae(var mae:maestro);
    var
        i:infoMaestro;
    begin
        assign(mae,'maestro');
        reset(mae);
        while not eof(mae) do begin
            with i do begin
                read(mae,i);
                writeln(codLocalidad, nomLocalidad);
                writeln(codCepa, nomCepa);
                writeln(' A ',cantCasosActivos,' N ', cantCasosNuevos,' R ', cantRecuperados,' F ', cantFallecidos);
            end;
        end;
        close(mae);
    end;

var
    mae:maestro;
    vecDet:vectorDetalles;
begin
    crearMaestro(mae);
    crearDetalles(vecDet);
    actualizarMaestro(mae, vecDet);
    imprimirMae(mae);
end.