(*Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.*)

program tienda;
type
    celular = record
        codigo:integer;
        nombre:string;
        descripcion:string;
        marca:string;
        precio:real;
        stock_minimo:integer;
        stock_disponible:integer;
    end;

    archivo_celulares = file of celular;

    procedure cargarBinario(var txt:text; var arch:archivo_celulares);
    var
        c:celular;
        nombre:string;
    begin
        writeln('ingrese nombre del binario a crear');
        readln(nombre);
        assign(arch,nombre); // le pongo el nombre
        rewrite(arch); // lo creo

        reset(txt); // abro el texto porque ya esta creado
        while not eof(txt)do begin
            readln(txt, c.codigo,c.precio,c.marca);
            readln(txt,c.stock_disponible,c.stock_minimo,c.descripcion);
            readln(txt,c.nombre);
            write(arch,c);
        end;
        writeln('archivo binario creado correctamente :)');
        close(arch);
        close(txt);
    end;
    
    procedure leoCelu(var c:celular);
     begin
        writeln('codigo');
        readln(c.codigo);
        writeln('precio');
        readln(c.precio);
        writeln('marca');
        readln(c.marca);
        writeln('stock disponible');
        readln(c.stock_disponible);
        writeln('stock minimo');
        readln(c.stock_minimo);
        writeln('descrpcion');
        readln(c.descripcion);
        writeln('nombre');
        readln(c.nombre);
    end;

    procedure imprimirC(c:celular);
    begin
        writeln('codigo');
        writeln(c.codigo);
        writeln('precio');
        writeln(c.precio);
        writeln('marca');
        writeln(c.marca);
        writeln('stock disponible');
        writeln(c.stock_disponible);
        writeln('stock minimo');
        writeln(c.stock_minimo);
        writeln('descrpcion');
        writeln(c.descripcion);
        writeln('nombre');
        writeln(c.nombre);
    end;

    procedure listarStockMenor(var celulares:text; var arch:archivo_celulares);
    var
        nombre_archivo:string;
        c:celular;

    begin
        writeln('ingrese nombre del archivo en el cual buscar');
        readln(nombre_archivo);
        if(nombre_archivo = 'celulares.txt')then begin
            assign(celulares,nombre_archivo);
            reset(celulares);
            while not eof(celulares)do begin
                readln(celulares, c.codigo,c.precio,c.marca);
                readln(celulares,c.stock_disponible,c.stock_minimo,c.descripcion);
                readln(celulares,c.nombre);
                if(c.stock_disponible<c.stock_minimo)then
                    imprimirC(c);
            end;
            close(celulares);
        end
        else
        begin
            assign(arch,nombre_archivo);
            reset(arch);
            while not eof(arch)do begin
                read(arch,c);
                if(c.stock_disponible < c.stock_minimo)then
                    imprimirC(c);
            end;
            close(arch);
        end;
    end;    
    

    procedure listarDescripcion(var celulares:text; var arch:archivo_celulares);
    var
        nombre_archivo:string;
        c:celular;
        desc_buscar:string;
    begin
        writeln('ingrese nombre del archivo en el cual buscar');
        readln(nombre_archivo);
        writeln('ingrese la descripcion a buscar');
        readln(desc_buscar);
        if(nombre_archivo = 'celulares.txt')then begin
            assign(celulares,nombre_archivo);
            reset(celulares);
            while not eof(celulares)do begin
                readln(celulares, c.codigo,c.precio,c.marca);
                readln(celulares,c.stock_disponible,c.stock_minimo,c.descripcion);
                readln(celulares,c.nombre);
                if(c.descripcion = desc_buscar)then
                    imprimirC(c);
            end;
            close(celulares);
        end
        else
        begin
            assign(arch,nombre_archivo);
            reset(arch);
            while not eof(arch)do begin
                read(arch,c);
                if(c.descripcion = desc_buscar)then
                    imprimirC(c);
            end;
            close(arch);
        end;
    end;

    procedure exportarTXT(var arch:archivo_celulares);
    var
        nombreB:string;
        c:celular;
        texto:text;
    begin
        writeln('ingrese nombre del binario a exportar a txt');
        readln(nombreB);
        assign(arch,nombreB);
        reset(arch);

        assign(texto,'celularess.txt');
        rewrite(texto);

        while not eof(arch)do begin
            read(arch,c);
            writeln(texto, c.codigo,' ',c.precio,' ',c.marca);
            writeln(texto,c.stock_disponible,' ',c.stock_minimo,' ',c.descripcion);
            writeln(texto,c.nombre);
            writeln(texto);
        end;
        writeln('el archivo fue creado correctamente');
        close(arch);
        close(texto);
        
    end;

    procedure addCelular(var arch:archivo_celulares);
    var
        c:celular;
        nombre_archivo:string;
        sigo:integer;
    begin
        sigo:=1;
        writeln('ingrese el nombre del archivo en el cual agregar');
        readln(nombre_archivo);
        assign(arch,nombre_archivo);
        reset(arch);
        while sigo <> 0 do begin
            writeln('ingrese datos del celular');
            leoCelu(c);
            seek(arch,filesize(arch));
            write(arch,c);
            writeln('ingresa 1 para continuar agregando o 0 para finalizar: ');
            readln(sigo);
        end;
        
        close(arch);
    end;

    procedure modificar_stock(var arch:archivo_celulares);
    var
        nombre_archivo,nombre_celu:string;
        c:celular;
        stock:integer;
    begin
        writeln('ingrese el nombre del archivo a modificar stock');
        readln(nombre_archivo);
        assign(arch,nombre_archivo);
        reset(arch);

        writeln('ingrese nombre del celular al cual modificar el stock');
        readln(nombre_celu);
        while not eof(arch)do begin
            read(arch,c);
            if(c.nombre = nombre_celu)then begin
                writeln('ingrese stock');
                readln(stock);
                c.stock_disponible:= stock;
                seek(arch, filesize(arch) - 1); // aca vuelvo al que tengo que borrar, sino pisas el siguiente
                write(arch,c);
            end;
        end;
        writeln('el stock fue actualizado correctamente');
        close(arch);
    end;

    procedure exportarSinStock(var arch:archivo_celulares);
    var
        nombre_archivo:string;
        c:celular;
        texto:text;
    begin
        writeln('ingrese el nombre del archivo en cual buscar');
        readln(nombre_archivo);
        assign(arch,nombre_archivo);
        reset(arch);

        assign(texto,'SinStock.txt');
        rewrite(texto);
        while not eof(arch)do begin
            read(arch,c);
            if(c.stock_disponible = 0)then begin
                writeln(texto, c.codigo,' ',c.precio,' ',c.marca);
                writeln(texto,c.stock_disponible,' ',c.stock_minimo,' ',c.descripcion);
                writeln(texto,c.nombre);
                writeln(texto);
            end;
        end;
        writeln('el archivo fue creado correctamente');
        close(arch);
        close(texto);
    end;


    var
        celulares:text; // tipo txt
        arch:archivo_celulares; // tipo binario
        nombreArchivoTexto:string;
        opcion:char;
    begin
        assign(celulares,'celulares.txt');
        writeln('===============================MENU=====================================');
        writeln('ingrese A para crear un archivo de registros desde un archivo de texto denominado celulares.txt');
        writeln('');
        writeln('ingrese B para listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock minimo');
        writeln('');
        writeln('ingrese C para listar en pantalla los celulares del archivo cuya descripcion sea = a una descripcion ingresada');
        writeln('');
        writeln('ingrese D para exportar el archivo creado en el inciso a) a un archivo de texto denominado celularess.txt con todos los celulares del mismo');
        writeln('');
        writeln('ingrese E para anadir uno o mas celulares al final del archivo con sus datos ingresados por teclado');
        writeln('');
        writeln('ingrese F para modificiar stock de un celular');
        writeln('');
        writeln('ingrese G para exportar a SinStock.txt los productos con stock = 0');
        writeln('========================================================================');
        readln(opcion);
        case opcion of
            'A': cargarBinario(celulares,arch);
            'B': listarStockMenor(celulares,arch);
            'C': listarDescripcion(celulares,arch);
            'D': exportarTXT(arch);
            'E': addCelular(arch);
            'F': modificar_stock(arch);
            'G':exportarSinStock(arch);
        else
            writeln('error, opcion incorrecta');
    end;
    end.