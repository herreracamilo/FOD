program EJE10;
const valoralto = 9999;
type
    infoMae = record
        departamento:integer;
        division:integer;
        num_empleado:integer;
        categoria:integer;
        cant_horasextra:integer;
    end;

    maestro = file of infoMae;
    arreglo_horas = array[1..3] of real;

    procedure leer(var mae:maestro; var dato:infoMae);
    begin
        if not eof(mae)then
            read(mae,dato)
        else
            dato.departamento:= valoralto;
    end;

    procedure crearMaestro(var mae:maestro; var vector_horas:arreglo_horas);
    var
        txt,txt1:text;
        dato:infoMae;
        p:real;
        i:integer;
    begin
        assign(mae,'maestro');
        rewrite(mae);
        assign(txt,'empleados.txt');
        reset(txt);
        assign(txt1,'valorhoras.txt');
        reset(txt1);
        i:=1;
        while not eof(txt)do begin
            with dato do begin
                read(txt, departamento,division,num_empleado,categoria,cant_horasextra);
                write(mae,dato);
            end;
        end;
        while not eof(txt1)do begin
            read(txt1,p);
            vector_horas[i]:=p;
            i:= i + 1;
        end;
        writeln('maestro y vector creados \o/');
        close(mae);
        close(txt);
    end;



    procedure procesarMaestro(var mae:maestro; vector:arreglo_horas);
    var
        dato:infoMae;
        totalhoras_division,totalhoras_departamento:integer;
        montototal_division,montototal_departamento,monto:real;
        departamentoact,divisionact:integer;
    begin
        reset(mae);
        leer(mae,dato);
        while(dato.departamento <> valoralto)do begin
            departamentoact:= dato.departamento;
            montototal_departamento:=0;
            totalhoras_departamento:=0;
            writeln('departamento: ',departamentoact);
            while(dato.departamento = departamentoact)do begin
                divisionact:= dato.division;
                montototal_division:=0;
                totalhoras_division:=0;
                writeln('division: ',departamentoact);
                while(dato.departamento = departamentoact)and(dato.division = divisionact)do begin
                    monto:=(vector[dato.categoria]*dato.cant_horasextra);
                    writeln('empleado: ',dato.num_empleado,' total de hs: ',dato.cant_horasextra,' importe a cobrar: ',monto:0:2);
                    montototal_division:=montototal_division + monto;
                    totalhoras_division:= totalhoras_division + dato.cant_horasextra;
                    leer(mae,dato);
                end;
                writeln('Total de horas división: ',totalhoras_division);
                writeln('Monto total por división: ',montototal_division:0:2);
                montototal_departamento:= montototal_departamento + montototal_division;
                totalhoras_departamento:= totalhoras_departamento + totalhoras_division;
            end;
            writeln('Total horas departamento: ',totalhoras_departamento);
            writeln('Monto total departamento: ',montototal_departamento:0:2);
        end;
        close(mae);
    end;

var
    vector:arreglo_horas;
    mae:maestro;
begin
    crearMaestro(mae,vector);
    procesarMaestro(mae,vector);
end.