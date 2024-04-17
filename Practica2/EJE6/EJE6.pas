program EJE6;

const
    DF = 5;
    valoralto = 9999;
    fechaalta = 'ZZZZZ';
type
    rango = 1..5;

    info = record
        codigo:integer;
        tiempo:integer;
        fecha:string;
    end;

    maestro = file of info;
    detalle = file of info;
    vectorDetalle = array [rango] of detalle;
    vectorRegistros = array [rango] of info;

    procedure crearDetalle(var det:detalle);
    var
        nombre:string;
        texto:text;
        d:info;
    begin
        writeln('ingrese nombre para el detalle');
        readln(nombre);
        assign(det,nombre);
        assign(texto,nombre + '.txt');
        rewrite(det);
        reset(texto);

        while not eof(texto)do begin
            read(texto, d.codigo, d.tiempo, d.fecha);
            write(det,d);
        end;

        close(texto);
        close(det);
        writeln('------------------------------------------');
        writeln('archivo detalle creado correctamente');
        writeln('------------------------------------------');
    end;

    procedure crearVectorDet(var vecDet: vectorDetalle);
    var
        i:integer;
    begin
        for i:= 1 to DF do begin
            crearDetalle(vecDet[i]);
        end;
    end;

    procedure leer(var det:detalle; var d:info);
    begin
        if not eof(det)then
            read(det,d)
        else
            d.codigo:= valoralto;
    end;

    procedure minimo(var vecDet:vectorDetalle; var vecR:vectorRegistros; var min:info);
    var
        i,pos:integer;
    begin
        min.codigo:= valoralto;
        min.fecha:= fechaalta;
        for i:= 1 to DF do begin
            if(vecR[i].codigo < min.codigo) or ((vecR[i].codigo = min.codigo) and (vecR[i].fecha < min.fecha))then begin
                min:= vecR[i];
                pos:= i;
            end;
        end;
        if(min.codigo <> valoralto)then
            leer(vecDet[pos],vecR[pos]);
    end;

    procedure crearMaestro(var mae:maestro; var vecDet:vectorDetalle);
    var
        vecR:vectorRegistros;
        i:integer;
        min,aux:info;
    begin
        assign(mae,'maestro');
        rewrite(mae);

        for i:= 1 to DF do begin
            reset(vecDet[i]);
            leer(vecDet[i],vecR[i]);
        end;
        minimo(vecDet, vecR, min);
        while(min.codigo <> valoralto)do begin
            aux.codigo:= min.codigo;
            while(aux.codigo = min.codigo)do begin
                aux.fecha:= min.fecha;
                aux.tiempo:= 0;
                while(aux.codigo = min.codigo) and (aux.fecha = min.fecha)do begin
                    aux.tiempo:= aux.tiempo + min.tiempo;
                    minimo(vecDet,vecR,min);
                end;
                write(mae,aux);
            end;
        end;
        for i:= 1 to DF do begin
            close(vecDet[i]);
        end;
        close(mae);
        writeln('------------------------------------------');
        writeln('archivo maestro creado correctamente');
        writeln('------------------------------------------');
    end;

    procedure imprimoMae(var mae:maestro);
    var
        d:info;
    begin
        assign(mae,'maestro');
        reset(mae);
        while not eof(mae)do begin
            read(mae,d);
            writeln('| codigo= ',d.codigo,' | fecha= ',d.fecha,' | tiempo total= ',d.tiempo);
        end;
        close(mae);
    end;

var
    mae:maestro;
    vecDet:vectorDetalle;
begin
    crearVectorDet(vecDet);
    crearMaestro(mae, vecDet);
    imprimoMae(mae);
end.