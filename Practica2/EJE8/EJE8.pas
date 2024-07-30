program EJE8;
const valoralto = 9999;
type

    infoMae = record
        codigo:integer;
        nomYape:string;
        ano:integer;
        mes:integer;
        dia:integer;
        monto:real;
    end;

    maestro = file of infoMae;

    procedure crearMaestro(var mae:maestro);
    var
        texto:text;
        info:infoMae;
    begin
        assign(mae,'maestro');
        rewrite(mae);
        assign(texto,'ventas.txt');
        reset(texto);

        while not eof(texto)do begin
            with info do begin
                read(texto,codigo,ano,mes,dia, monto,nomYape);
                write(mae,info);
            end;
        end;
        writeln('Archivo maestro creado');
        close(mae);
        close(texto);
    end;

    procedure leer(var mae:maestro; var dato:infoMae);
    begin
        if not eof(mae)then
            read(mae,dato)
        else
            dato.codigo:= valoralto;
    end;

    procedure procesarMaestro(var mae:maestro);
    var
        montoTotalVentas,montoTotalano,montoMes:real;
        dato:infoMae;
        codigoact,anoact,mesact:integer;
    begin
        assign(mae,'maestro');
        reset(mae);
        montoTotalVentas:=0;
        leer(mae,dato);
        while(dato.codigo <> valoralto)do begin
            with dato do begin
                writeln('Codigo: ',codigo,' Nombre: ',nomYape);
                codigoact:= codigo;
            end;
            while(codigoact = dato.codigo)do begin
                anoact:= dato.ano;
                montoTotalano:=0;
                writeln('Año: ',dato.ano);
                while(codigoact = dato.codigo) and(anoact = dato.ano)do begin
                    mesact:= dato.mes;
                    montoMes:=0;
                    while(codigoact = dato.codigo) and(anoact = dato.ano) and (mesact=dato.mes)do begin
                        montoMes:= montoMes + dato.monto;
                        leer(mae,dato);
                    end;
                    if(montoMes<>0)then begin
                        writeln('Mes: ',mesact, ' se generó: $',montoMes:0:2);
                        montoTotalano:= montoTotalano + montoMes;
                    end;
                end;
                writeln('Gastó en el año ', anoact,' $', montoTotalano:0:2);
                montoTotalVentas:= montoTotalVentas + montoTotalano;
            end;
        end;
        writeln('La empresa ganó: $', montoTotalVentas:0:2);
        close(mae);
    end;

var
    mae:maestro;
begin
    crearMaestro(mae);
    procesarMaestro(mae);
end.