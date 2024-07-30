program examen;

const 
    dimF = 30;
    valoralto = 9999;
type
    rango = 1..dimF;
    
    infoMae = record
        codMuni:integer;
        cantPositivos:integer;
        nombre:string;
    end;

    infoDet = record
        codMuni:integer;
        cantPositivos:integer;
    end;

    maestro = file of infoMae;
    detalle = file of infoDet;
    vectorDetalle = array [rango] of detalle;
    vectorRegDetalle = array[rango] of infoDet;

    procedure leer(var det:detalle; var dato:infoDet);
    begin
        if not eof(det)then
            read(det,dato);
        else
            dato.codMuni:= valoralto;
    end;

    procedure minimo(var vecDet:vectorDetalle; var vecReg:vectorRegDetalle; var min:infoDet);
    var
        i,pos:rango;
    begin
        min.codMuni:=valoralto;
        for i:= 1 to dimF do begin
            if(vecReg[i].codMuni < min.codMuni)then
                min:= vecReg[i];
                pos:= i;
        end;
        if(min.codMuni < valoralto)then
            leer(vecDet[pos],vecReg[pos]);
    end;

    procedure actualizarMaestro(var mae:maestro; var vecDet:vectorDetalle);
    var
        vecReg:vectorRegDetalle;
        mine:infoDet;
        regMae:infoMae;
        i:rango;
        total:integer
    begin
        reset(mae);
        for i:= 1 to dimF do begin
            reset(vecDet[i]);
            leer(vecDet[i],vecReg[i]);
        end;
        minimo(vecDet,vecReg,min);

        while(min.codMuni <> valoralto)do begin
            read(mae,regMae);
            while(regMae.codMuni < min.codMuni) do begin
                if(regMae.cantPositivos > 15)then
                    writeln('Municipio: ', regMae.nombre, ' - Código: ', regMae.codMuni, ' - Casos: ', regMae.cantPositivos);
                read(mae,regMae);
            end;
            total:= regMae.cantPositivos;
            while(regMae.codMuni = min.codMuni)do begin
                total:= total + min.cantPositivos;
                minimo(vecDet,vecReg,min);
            end;
            seek(mae, filepos(mae)-1);
            regMae.cantPositivos:=total;
            write(mae,regMae);
            if(regMae.cantPositivos > 15)then
                writeln('Municipio: ', regMae.nombre, ' - Código: ', regMae.codMuni, ' - Casos: ', regMae.cantPositivos);  
        end;
        for i:=1 to dimF do
            close(vecDet[i]);
        close(mae);
    end;