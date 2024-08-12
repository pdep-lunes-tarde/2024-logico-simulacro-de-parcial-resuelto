:- use_module(begin_tests_con).


poseeCaracteristica(rin, responsable).
poseeCaracteristica(rin, pacifica).
poseeCaracteristica(atalanta, responsable).
poseeCaracteristica(atalanta, fuerte).
poseeCaracteristica(kelsier, noble).
poseeCaracteristica(thorfinn, agresivo).
poseeCaracteristica(thorfinn, fuerte).

% aventurero(Nombre, Clase, Oro)
aventurero(rin, mago, 20).
aventurero(atalanta, mago, 30).
aventurero(kelsier, luchador, 50).
aventurero(thorfinn, barbaro, 15).

tiene(kelsier, permisoReal).

camaradas(UnAventurero, OtroAventurero):-
    aventurero(UnAventurero, Clase, _),
    aventurero(OtroAventurero, Clase, _),
    UnAventurero \= OtroAventurero.

caracteristicaPopular(Caracteristica, Clase):-
    aventurero(_, Clase, _),
    poseeCaracteristica(_, Caracteristica),
    forall(
        aventurero(Aventurero, Clase, _),
        poseeCaracteristica(Aventurero, Caracteristica)
    ).

puedeDisponderDePermisoReal(Aventurero):-
    tiene(Aventurero, permisoReal).
puedeDisponderDePermisoReal(Aventurero):-
    tieneFondosParaComprar(Aventurero, permisoReal).

precio(permisoReal, 50).
precio(pociones, 20).

tieneFondosParaComprar(Aventurero, Objeto):-
    precio(Objeto, Precio),
    aventurero(Aventurero, _, Oro),
    Oro >= Precio.

:- begin_tests_con(parte1, [aventurero(guybrush, pirata, 50)]).

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

% conoceHechizo(Aventurero, Elemento, Potencia)
conoceHechizo(rin, fuego, 20).
conoceHechizo(rin, frio, 20).
conoceHechizo(atalanta, fuego, 30).

puedeRealizar(Aventurero, ayudarACruzarLaCalle):-
    aventurero(Aventurero, _, _).
puedeRealizar(Aventurero, ayudarACortarLenia):-
    poseeCaracteristica(Aventurero, fuerte).
puedeRealizar(Aventurero, escoltaRealDe(diplomatico)):-
    puedeDisponderDePermisoReal(Aventurero).
puedeRealizar(Aventurero, escoltaRealDe(princesa)):-
    tiene(Aventurero, permisoReal),
    poseeCaracteristica(Aventurero, noble).
puedeRealizar(Aventurero, pesadillaDeLaCueva):-
    aventurero(Aventurero, barbaro, _),
    poseeCaracteristica(Aventurero, agresivo).
puedeRealizar(Aventurero, pesadillaDeLaCueva):-
    conoceHechizoTanPoderosoComo(Aventurero, fuego, 30).
puedeRealizar(Aventurero, rosasHeladas(Lugar)):-
    categoria(rosasHeladas(Lugar), _),
    tieneFondosParaComprar(Aventurero, pociones),
    conoceHechizoTanPoderosoComo(Aventurero, frio, 20).

conoceHechizoTanPoderosoComo(Aventurero, Elemento, PotenciaMinima):-
    conoceHechizo(Aventurero, Elemento, Potencia),
    Potencia >= PotenciaMinima.

facil(Mision):-
    puedeRealizar(_, Mision),
    forall(
        aventurero(Aventurero, _, _),
        puedeRealizar(Aventurero, Mision)
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

resultado(Aventurero, Mision, exitoso):-
    intento(Aventurero, Mision),
    puedeRealizar(Aventurero, Mision).
resultado(Aventurero, Mision, Resultado):-
    intento(Aventurero, Mision),
    not(puedeRealizar(Aventurero, Mision)),
    categoria(Mision, Categoria),
    resultadoNegativo(Categoria, Resultado).
% resultado(Aventurero, Mision, fatal):-
%     intento(Aventurero, Mision),
%     not(puedeRealizar(Aventurero, Mision)),
%     categoria(Mision, heroica).
% resultado(Aventurero, Mision, fallido):-
%     intento(Aventurero, Mision),
%     not(puedeRealizar(Aventurero, Mision)),
%     categoria(Mision, Categoria),
%     Categoria \= heroica.

resultadoNegativo(heroica, fatal).
resultadoNegativo(aspirante, fallido).
resultadoNegativo(deBarrio, fallido).

afortunado(Aventurero):-
    aventurero(Aventurero, _, _),
    forall(intento(Aventurero, Mision),
            resultado(Aventurero, Mision, exitoso)).

murio(Aventurero):-
    resultado(Aventurero, _, fatal).

recompensaEnOro(Aventurero, 0):-
    murio(Aventurero).
recompensaEnOro(Aventurero, RecompensaTotal):-
    aventurero(Aventurero, _, _),
    not(murio(Aventurero)),
    findall(Recompensa, (resultado(Aventurero, Mision, exitoso), oroPorRealizar(Mision, Recompensa)), Recompensas),
    sum_list(Recompensas, RecompensaTotal).

oroPorRealizar(Mision, Oro):-
    categoria(Mision, Categoria),
    oroSegunCategoria(Categoria, Oro).

oroSegunCategoria(deBarrio, 2).
oroSegunCategoria(aspirante, 15).
oroSegunCategoria(heroica, 50).

masRecompensado(Aventurero):-
    recompensaEnOro(Aventurero, Recompensa),
    forall(
        (
            recompensaEnOro(OtroAventurero, RecompensaDelOtro),
            OtroAventurero \= Aventurero
        ),
        Recompensa > RecompensaDelOtro
    ).

:- begin_tests_con(parte2, [aventurero(guybrush, pirata, 50)]).

test("Cualquier aventurero puede realizar la mision 'Ayudar a cruzar la calle'", set(Aventurero == [rin, atalanta, kelsier, thorfinn, guybrush])):-
    puedeRealizar(Aventurero, ayudarACruzarLaCalle).
test("Solo los aventureros que sean fuertes pueden realizar la mision 'Ayudar a cortar lenia'", set(Aventurero == [atalanta, thorfinn])):-
    puedeRealizar(Aventurero, ayudarACortarLenia).
test("Solo los aventureros que pueden disponer de un permiso real pueden realizar la mision 'escolta real de un diplomatico'", set(Aventurero == [kelsier, guybrush])):-
    puedeRealizar(Aventurero, escoltaRealDe(diplomatico)).
test("Solo los aventureros que pueden disponer de un permiso real y sean nobles pueden realizar la mision 'escolta real de un diplomatico'", set(Aventurero == [kelsier])):-
    puedeRealizar(Aventurero, escoltaRealDe(princesa)).
test("Si un aventurero es barbaro y agresivo puede realizar la mision 'pesadilla de la cueva'", nondet):-
    puedeRealizar(thorfinn, pesadillaDeLaCueva).
test("Si un aventurero conoce un hechizo de fuego de potencia mayor o igual a 30, puede realizar la mision 'pesadilla de la cueva'"):-
    puedeRealizar(atalanta, pesadillaDeLaCueva).
test("Si un aventurero no es un barbaro agresivo ni conoce un hechizo de fuego de potencia mayor o igual a 30, NO puede realizar la mision 'pesadilla de la cueva'"):-
    not(puedeRealizar(rin, pesadillaDeLaCueva)).
test("Si un aventurero tiene fondos para comprar pociones (20 oro) y sabe un hechizo de frio, puede realizar la mision 'rosas heladas'", set(Aventurero == [rin])):-
    puedeRealizar(Aventurero, rosasHeladas(altasMontanias)).

test("Una mision es facil si y solo si todos los aventureros pueden realizarla", set(Mision == [ayudarACruzarLaCalle])):-
    facil(Mision).

test("El resultado de una mision intentada es exitoso si el aventurero podia realizarla", nondet):-
    resultado(thorfinn, pesadillaDeLaCueva, exitoso).
test("El resultado de una mision inentada es fatal si el aventurero NO podia realizarla y la mision era heroica", nondet):-
    resultado(kelsier, pesadillaDeLaCueva, fatal).
test("El resultado de una mision intentada es fallido si el aventurero NO podia realizarla y la mision era de barrio o de aspirante", nondet):-
    resultado(kelsier, ayudarACortarLenia, fallido).

test("Un aventurero es afortunado si cumplio exitosamente todas las misiones que intento", set(Aventurero == [atalanta, thorfinn, guybrush])):-
    afortunado(Aventurero).

test("Un aventurero no obtiene nada de oro si murio (obtuvo un resultado fatal) en alguna mision", set(Oro == [0])):-
    recompensaEnOro(rin, Oro).
test("El oro que obtiene un aventurero que no murio es la suma del oro obtenido por cada una de sus misiones exitosas"):-
    recompensaEnOro(thorfinn, 50).

test("El oro que corresponde por una mision de barrio es 2"):-
    oroPorRealizar(ayudarACruzarLaCalle, 2).
test("El oro que corresponde por una mision de aspirante es 15"):-
    oroPorRealizar(escoltaRealDe(diplomata), 15).
test("El oro que corresponde por una mision heroica es 50"):-
    oroPorRealizar(pesadillaDeLaCueva, 50).

test("El aventurero mas recompensado es aquel que mas oro debe cobrar como recompensa"):-
    masRecompensado(thorfinn).

:- end_tests(parte2).

