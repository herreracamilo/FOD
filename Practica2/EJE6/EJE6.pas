program EJE6;
const 
    max_pc = 5;
    valoralto = 9999;
    fechaalta = 9999;
type   
    rango = 1..max_pc;
    infoMaestro = record
        codUsuario:integer;
        fecha:integer;
        tiempoTotalSesiones:integer;
    end;

    infoDetalle = record
        codUsuario:integer;
        fecha:integer;
        tiempoSesion:integer;
    end;

    maestro = file of infoMaestro;
    detalle = file of infoDetalle;
    vecDetalles = array [rango] of detalle;
    vecRegDetalles = array [rango] of infoDetalle;

    procedure leer(var det:detalle; var dato:infoDetalle);
    begin
        if not eof(det)then begin
            read(det,dato);
        end
        else
            dato.codigo:= valoralto;
    end;

    procedure minimo(var vec:vecDetalles; var vecR:vecRegDetalles; var min: infoDetalle);
    var
        i,pos:integer
    begin
        min.codigo:= valoralto;
        min.fecha:= fechaalta;
        for i:= 1 to max_pc do begin
            if(vecR[i].codigo < min.codigo) and (vecR[i].fecha < min.fecha)then begin
                min:= vecR[i];
                pos:= i;
            end;

            if(min.codigo<>valoralto) and (min.fecha<>fechaalta)then
                leer(vec[pos],vecR[pos]);
        end;
    end;