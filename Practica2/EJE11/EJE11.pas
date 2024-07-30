program EJE11;

const 
    valoralto = 9999;
type
    meses = 1..12;
    dias = 1..31;

    infoMae = record
        ano:integer;
        mes:meses;
        dia:dias;
        id:integer;
        tiempo:integer;
    end;

    maestro = file of infoMae;

    procedure crearMaestro(var mae:maestro);
    var
        txt:text;
        dato:infoMae;
    begin
        assign(mae,'maestro');
        rewrite(mae);
        assign(txt,'maestro.txt');
        reset(txt);
        while not eof(txt)do begin
            with dato do begin
                read(txt,ano, mes, dia, id, tiempo);
                write(mae,dato);
            end;
        end;
        close(mae);
        close(txt);
        writeln(' | MAESTRO CREADO |');
    end;

    procedure leer(var mae:maestro; var dato:infoMae);begin
        if not eof(mae)then
            read(mae,dato)
        else
            dato.ano:= valoralto;
    end;



    procedure procesarMaestro(var mae:maestro);
    var
        tiempoTDIA,tiempoTMES,tiempoTANO,tiempoUSER:integer;
        mesact,diaact,usuarioact:integer;
        dato:infoMae;
        ano:integer;
    begin
        reset(mae);
        writeln('ingrese año el cual realizar el informe');
        read(ano);
        leer(mae,dato);
        if(dato.ano <> valoralto)then begin
            // como el año puede no existir me tengo que asegurar
            while(dato.ano <> valoralto) and (dato.ano < ano) do
                leer(mae,dato);
            if(dato.ano = ano)then begin
                tiempoTANO:=0;
                writeln('Año : ', dato.ano);
                while(dato.ano = ano)do begin
                    mesact:= dato.mes;
                    tiempoTMES:=0;
                    writeln('Mes : ', dato.mes);
                    while(dato.ano = ano) and(dato.mes = mesact)do begin
                        diaact:= dato.dia;
                        tiempoTDIA:=0;
                        writeln('Dia : ', dato.dia);
                        while(dato.ano = ano) and(dato.mes = mesact) and (dato.dia = diaact)do begin
                            usuarioact:= dato.id;
                            tiempoUSER:=0;
                            while(dato.ano = ano) and(dato.mes = mesact) and (dato.dia = diaact) and (dato.id = usuarioact)do begin
                                tiempoUSER:= tiempoUSER + dato.tiempo;
                                leer(mae,dato);
                            end;
                            writeln('idUsuario ',usuarioact,'Tiempo Total de acceso ', tiempoUSER,' en el dia ',diaact, ' mes ',mesact);
                            tiempoTDIA:= tiempoTDIA + tiempoUSER;
                        end;
                        writeln('Tiempo total acceso dia ', diaact, ' mes ', mesact, ': ', tiempoTDIA);
                        tiempoTMES:= tiempoTMES + tiempoTDIA;
                    end;
                    writeln('Total tiempo de acceso de mes ', mesact, ': ', tiempoTMES);
                    tiempoTANO:= tiempoTANO + tiempoTMES;
                end;
                writeln('Total tiempo de acceso año: ', tiempoTANO);
            end
            else
                writeln('año no encontrado');
        end;
        close(mae);
    end;
var
    mae:maestro;
begin
    crearMaestro(mae);
    procesarMaestro(mae);
end.