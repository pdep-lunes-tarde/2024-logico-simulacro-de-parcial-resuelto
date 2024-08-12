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
    personaje(Personaje, _, Oro),
    precio(permisoReal, PrecioDePermisoReal),
    Oro >= PrecioDePermisoReal.

precio(permisoReal, 50).

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



:- begin_tests(parte2).

:- end_tests(parte2).