:- use_module(begin_tests_con).


poseeCaracteristica(rin, responsable).
poseeCaracteristica(rin, pacifica).
poseeCaracteristica(atalanta, responsable).
poseeCaracteristica(atalanta, fuerte).
poseeCaracteristica(kelsier, noble).
poseeCaracteristica(thorfinn, agresivo).
poseeCaracteristica(thorfinn, fuerte).

% personaje(Nombre, Clase, Oro)
personaje(rin, mago, 20).
personaje(atalanta, mago, 30).
personaje(kelsier, luchador, 50).
personaje(thorfinn, barbaro, 15).

tiene(kelsier, permisoReal).

camaradas(UnPersonaje, OtroPersonaje):-
    personaje(UnPersonaje, Clase, _),
    personaje(OtroPersonaje, Clase, _),
    UnPersonaje \= OtroPersonaje.

caracteristicaPopular(Caracteristica, Clase):-
    personaje(_, Clase, _),
    poseeCaracteristica(_, Caracteristica),
    forall(
        personaje(Personaje, Clase, _),
        poseeCaracteristica(Personaje, Caracteristica)
    ).

puedeDisponderDePermisoReal(Personaje):-
    tiene(Personaje, permisoReal).
puedeDisponderDePermisoReal(Personaje):-
    tieneFondosParaComprar(Personaje, permisoReal).

precio(permisoReal, 50).
precio(pociones, 20).

tieneFondosParaComprar(Personaje, Objeto):-
    precio(Objeto, Precio),
    personaje(Personaje, _, Oro),
    Oro >= Precio.

:- begin_tests_con(parte1, [personaje(guybrush, pirata, 50)]).

test("Dos aventureros son camaradas si son de la misma clase"):-
    camaradas(rin, atalanta).
test("Un aventurero no puede ser camarada de si mismo"):-
    not(camaradas(rin, rin)).
test("Dos aventureros no son camaradas si son de clases distintas"):-
    not(camaradas(kelsier, rin)).

test("Una caracteristica es popular entre una clase si todos los miembros de la clase la poseen", nondet):-
    caracteristicaPopular(responsable, mago).
test("Una caracteristica NO es popular entre una clase si algun miembro no la posee"):-
    not(caracteristicaPopular(pacifico, mago)).

test("Un aventurero puede disponer de un permiso real si ya lo tiene", nondet):-
    puedeDisponderDePermisoReal(kelsier).
test("Un aventurero NO puede disponer de un permiso real si NO tiene los fondos (50 oro) para comprarlo ni posee uno"):-
    not(puedeDisponderDePermisoReal(atalanta)).
test("Un aventurero puede disponer de un permiso real si puede comprarlo (valen 50 de oro)"):-
    puedeDisponderDePermisoReal(guybrush).

:- end_tests(parte1).


% Parte 2

% conoceHechizo(Personaje, Elemento, Potencia)
conoceHechizo(rin, fuego, 20).
conoceHechizo(rin, frio, 20).
conoceHechizo(atalanta, fuego, 30).

puedeRealizar(Personaje, ayudarACruzarLaCalle):-
    personaje(Personaje, _, _).
puedeRealizar(Personaje, ayudarACortarLenia):-
    poseeCaracteristica(Personaje, fuerte).
puedeRealizar(Personaje, escoltaRealDe(diplomatico)):-
    puedeDisponderDePermisoReal(Personaje).
puedeRealizar(Personaje, escoltaRealDe(princesa)):-
    tiene(Personaje, permisoReal),
    poseeCaracteristica(Personaje, noble).
puedeRealizar(Personaje, pesadillaDeLaCueva):-
    personaje(Personaje, barbaro, _),
    poseeCaracteristica(Personaje, agresivo).
puedeRealizar(Personaje, pesadillaDeLaCueva):-
    conoceHechizoTanPoderosoComo(Personaje, fuego, 30).
puedeRealizar(Personaje, rosasHeladas(Lugar)):-
    categoria(rosasHeladas(Lugar), _),
    tieneFondosParaComprar(Personaje, pociones),
    conoceHechizoTanPoderosoComo(Personaje, frio, 20).

conoceHechizoTanPoderosoComo(Personaje, Elemento, PotenciaMinima):-
    conoceHechizo(Personaje, Elemento, Potencia),
    Potencia >= PotenciaMinima.

facil(Mision):-
    puedeRealizar(_, Mision),
    forall(
        personaje(Personaje, _, _),
        puedeRealizar(Personaje, Mision)
    ).

categoria(ayudarACruzarLaCalle, deBarrio).
categoria(ayudarACortarLenia, deBarrio).
categoria(escoltaRealDe(diplomata), aspirante).
categoria(escoltaRealDe(princesa), heroica).
categoria(pesadillaDeLaCueva, heroica).
categoria(rosasHeladas(montes), deBarrio).
categoria(rosasHeladas(altasMontanias), aspirante).

intento(kelsier, pesadillaDeLaCueva).
intento(kelsier, ayudarACortarLenia).
intento(rin, rosasHeladas(altasMontanias)).
intento(rin, escoltaRealDe(princesa)).
intento(thorfinn, pesadillaDeLaCueva).
intento(atalanta, ayudarACruzarLaCalle).
intento(atalanta, ayudarACortarLenia).

resultado(Personaje, Mision, exitoso):-
    intento(Personaje, Mision),
    puedeRealizar(Personaje, Mision).
resultado(Personaje, Mision, Resultado):-
    intento(Personaje, Mision),
    not(puedeRealizar(Personaje, Mision)),
    categoria(Mision, Categoria),
    resultadoNegativo(Categoria, Resultado).

resultadoNegativo(heroica, fatal).
resultadoNegativo(aspirante, fallido).
resultadoNegativo(deBarrio, fallido).

afortunado(Personaje):-
    personaje(Personaje, _, _),
    forall(intento(Personaje, Mision),
            resultado(Personaje, Mision, exitoso)).

:- begin_tests_con(parte2, [personaje(guybrush, pirata, 50)]).

test("Cualquier personaje puede realizar la mision 'Ayudar a cruzar la calle'", set(Personaje == [rin, atalanta, kelsier, thorfinn, guybrush])):-
    puedeRealizar(Personaje, ayudarACruzarLaCalle).
test("Solo los personajes que sean fuertes pueden realizar la mision 'Ayudar a cortar lenia'", set(Personaje == [atalanta, thorfinn])):-
    puedeRealizar(Personaje, ayudarACortarLenia).
test("Solo los personajes que pueden disponer de un permiso real pueden realizar la mision 'escolta real de un diplomatico'", set(Personaje == [kelsier, guybrush])):-
    puedeRealizar(Personaje, escoltaRealDe(diplomatico)).
test("Solo los personajes que pueden disponer de un permiso real y sean nobles pueden realizar la mision 'escolta real de un diplomatico'", set(Personaje == [kelsier])):-
    puedeRealizar(Personaje, escoltaRealDe(princesa)).
test("Si un personaje es barbaro y agresivo puede realizar la mision 'pesadilla de la cueva'", nondet):-
    puedeRealizar(thorfinn, pesadillaDeLaCueva).
test("Si un personaje conoce un hechizo de fuego de potencia mayor o igual a 30, puede realizar la mision 'pesadilla de la cueva'"):-
    puedeRealizar(atalanta, pesadillaDeLaCueva).
test("Si un personaje no es un barbaro agresivo ni conoce un hechizo de fuego de potencia mayor o igual a 30, NO puede realizar la mision 'pesadilla de la cueva'"):-
    not(puedeRealizar(rin, pesadillaDeLaCueva)).
test("Si un personaje tiene fondos para comprar pociones (20 oro) y sabe un hechizo de frio, puede realizar la mision 'rosas heladas'", set(Personaje == [rin])):-
    puedeRealizar(Personaje, rosasHeladas(altasMontanias)).

test("Una mision es facil si y solo si todos los aventureros pueden realizarla", set(Mision == [ayudarACruzarLaCalle])):-
    facil(Mision).

test("El resultado de una mision intentada es exitoso si el aventurero podia realizarla", nondet):-
    resultado(thorfinn, pesadillaDeLaCueva, exitoso).
test("El resultado de una mision inentada es fatal si el aventurero NO podia realizarla y la mision era heroica", nondet):-
    resultado(kelsier, pesadillaDeLaCueva, fatal).
test("El resultado de una mision intentada es fallido si el aventurero NO podia realizarla y la mision era de barrio o de aspirante", nondet):-
    resultado(kelsier, ayudarACortarLenia, fallido).

test("Un aventurero es afortunado si cumplio exitosamente todas las misiones que intento", set(Personaje == [atalanta, thorfinn, guybrush])):-
    afortunado(Personaje).

:- end_tests(parte2).

