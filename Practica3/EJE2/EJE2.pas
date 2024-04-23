(*Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.*)

program EJE2;
type
    asistente = record
        num:integer;
        apellido:string[20];
        nombre:string[20];
        email:string[70];
        telefono:integer;
        dni:integer;
    end;
    
    maestro = file of asistente;

    procedure leerAsis(var a:asistente);
    begin
        with a do begin
            writeln('ingrese numero de asistente');
            readln(num);
            writeln('ingrese apellido');
            readln(apellido);
            writeln('ingrese nombre');
            readln(nombre);
            writeln('ingrese email');
            readln(email);
            writeln('ingrese tel');
            readln(telefono);
            writeln('ingrese dni');
            readln(dni);
        end;
    end;

    procedure crearMae(var mae:maestro);
    var
        a:asistente;
        texto:text;
    begin
        assign(mae,'maestro');
        assign(texto,'asistente.txt');
        rewrite(mae);
        reset(texto);

        while not eof (texto)do begin
            with a do begin
                readln(texto,apellido);
                readln(texto,nombre);
                readln(texto,num,telefono,dni,email);
                write(mae,a);
            end;
        end;
        close(mae);
        close(texto);
        writeln('=== maestro creado ===');
    end;

    procedure exportar (var mae:maestro);
    var
        texto:text;
        a:asistente;
        pregunta:string;
    begin
        assign(mae,'maestro');
        reset(mae);

        writeln('como se va a llamar el archivo exportado');
        readln(pregunta);
        assign(texto, pregunta);
        rewrite(texto);

        while not eof (mae)do begin
            with a do begin
                read(mae,a);
                writeln(texto, 'apellido: ', apellido);
                writeln(texto, 'nombre: ', nombre);
                writeln(texto, 'num empleado: ', num);
                writeln(texto, 'email: ', email);
                writeln(texto, 'telefono: ', telefono);
                writeln(texto, 'dni: ', dni);
                writeln(texto);
            end;
        end;
        close(mae);
        close(texto);
        writeln('=== el archivo se exporto correctamente ===');
    end;

    procedure borradoLogico(var mae:maestro);
    var
        a:asistente;
        aux:string;
    begin
        assign(mae,'maestro');
        reset(mae);

        while not eof(mae)do begin
            read(mae,a);
            if(a.num < 1000)then begin
                aux:='@'+a.nombre;
                a.nombre:=aux;
                seek(mae,filepos(mae)-1);
                write(mae,a);
            end;
        end;
        close(mae);
        writeln('=== borrados logicos con exito ===');
    end;

var
    mae:maestro;
begin
    crearMae(mae);
    exportar(mae);
    borradoLogico(mae);
    exportar(mae);
end.