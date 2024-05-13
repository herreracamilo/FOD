# Ejercicio 7 
## Arbol inicial
![original](https://github.com/herreracamilo/FOD/assets/89228921/096f8064-f119-4662-8734-9f2a8c78bfb2)
## Operación 1 --> +320
-Leo la raiz N2.

-Leo el N1.

-Overflow N1, genero el N6,hago el split. Tengo 225 | 241 | 320 | 331 | 360 |, el 225 y el 241 van N1 (escritura), el 320 se promociona (escritura) al N2 (genera overflow) y el 331 y 360 van al N6 (escritura).

-Soluciono el overflow de N2 creando el N7 y N8, tengo 220|320||390|455|541, el 220 y 320 van al N2, 455 y 541 van al N7, el 390 sube como raiz al N8.
![operacion 1](https://github.com/herreracamilo/FOD/assets/89228921/2ca8e35d-4e72-4255-9930-bdf3e1dbe181)

## Operación 2 --> -390
-Leo la raiz, el 390 se encuentra en la raiz.

-Si tengo que eliminar en la raiz hay que intercambiar por un elemento terminal, este puede ser con la mayor de sus claves menores o la menor de sus claves mayores. En el libro aclara que es conveniente la menor de sus claves mayores.

-Leo el N7, leo el N4, tengo que promocionar el 400 al N8 (escritura). Esto genera underflow en el N4, como el N5 no me puede prestar tengo que fusionar con el padre (455) y el N5.
![operacion 1 - copia](https://github.com/herreracamilo/FOD/assets/89228921/27ee17dd-059a-4d73-ab83-1ec02a37b468)

-Escribo la fusion en el N4 y el arbol queda de la siguiente manera:
![operacion 2](https://github.com/herreracamilo/FOD/assets/89228921/451b9732-fc12-4964-a798-eb313b6c9ba2)

## Operación 3 --> -400
-Leo la raiz, encuentro el 400

-Como el 400 esta en la raiz tengo que subir a la clave menor de las mayores, escribo el 407 en donde estaba el 400.
![operacion 3](https://github.com/herreracamilo/FOD/assets/89228921/6f3a3bfd-3ffe-4748-a358-d975bb227177)

## Operación 4 --> -533
-Leo la raiz

-Voy al puntero 4, leo el N4

-Borro el 533
![operacion 4](https://github.com/herreracamilo/FOD/assets/89228921/6f8becd9-1c26-4ed9-8a71-575998008e0b)

