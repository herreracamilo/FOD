 program EJE9;
 const valoralto = 9999;
 type
    infoMae = record
        cod_provincia:integer;
        cod_localidad:integer;
        num_mesa:integer;
        cantVotos:integer;
    end;

    maestro  = file of infoMae;

    procedure leer(var mae:maestro; var dato:infoMae);
    begin
        if not eof(mae)then
            read(mae,dato)
        else 
            dato.cod_provincia:= valoralto;
    end;
    
    procedure crearMaestro(var mae:maestro);
    var
        txt:text;
        dato:infoMae;
    begin
        assign(mae,'maestro');
        rewrite(mae);
        assign(txt,'votos.txt');
        reset(txt);

        while not eof(txt)do begin
            with dato do begin
                read(txt,cod_provincia,cod_localidad,num_mesa,cantVotos);
                write(mae,dato);
            end;
        end;
        writeln('maestro creado \o');
        close(mae);
        close(txt);
    end;

    procedure procesarMaestro(var mae:maestro);
    var
        totalvotos_localidad,totalvotos_provincia,totalgeneral:integer;
        provinciaact,localidadact:integer;
        dato:infoMae;
    begin
        reset(mae);
        leer(mae,dato);
        totalgeneral:=0;
        while(dato.cod_provincia <> valoralto)do begin
            provinciaact:=dato.cod_provincia;
            totalvotos_provincia:=0;
            writeln('provincia: ',provinciaact);
            while(provinciaact = dato.cod_provincia)do begin
                localidadact:=dato.cod_localidad;
                totalvotos_localidad:=0;
                writeln('localidad: ',localidadact);
                while(provinciaact = dato.cod_provincia) and (localidadact = dato.cod_localidad)do begin
                    totalvotos_localidad:= totalvotos_localidad + dato.cantVotos;
                    leer(mae,dato);
                end;
                writeln('total votos localidad: ',totalvotos_localidad);
                totalvotos_provincia:= totalvotos_provincia + totalvotos_localidad;
            end;
            totalgeneral:= totalgeneral + totalvotos_provincia;
            writeln('total votos provicia: ',totalvotos_provincia);
        end;
        writeln('total general de votos: ',totalgeneral);
        close(mae);
    end;
var
    mae:maestro;
begin
    crearMaestro(mae);
    procesarMaestro(mae);
end.