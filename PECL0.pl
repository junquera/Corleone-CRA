hombre('Antonio Andolini').
hombre('Vito Corleone').
hombre('Michael Corleone').
hombre('Sonny Corleone').
hombre('Fredo Corleone').
hombre('Tom Hagen').
hombre('Anthony Corleone').
hombre('Vincent Mancini').
hombre('Santino Jr. Corleone').
hombre('Frank Corleone').
hombre('Carlo Rizzi').
hombre('Victor Rizzi').
hombre('Michael Francis Rizzi').

mujer('Signora Andolini').
mujer('Carmella').
mujer('Connie Corleone').
mujer('Kay Adams').
mujer('Apollonia Vitelli').
mujer('Mary Corleone').
mujer('Lucy Mancini').
mujer('Sandra').
mujer('Francesca Corleone').
mujer('Kathryn Corleone').
mujer('Deanna Dunn').
mujer('Theresa').

esposos('Antonio Andolini','Signora Andolini').
esposos('Signora Andolini','Antonio Andolini').
esposos('Vito Corleone','Carmella').
esposos('Carmella','Vito Corleone').
esposos('Michael Corleone', 'Kay Adams').
esposos('Kay Adams','Michael Corleone').
esposos('Apollonia Vitelli','Michael Corleone').
esposos('Michael Corleone', 'Apollonia Vitelli').
esposos('Sonny Corleone','Sandra').
esposos('Sandra','Sonny Corleone').
esposos('Connie Corleone','Carlo Rizzi').
esposos('Carlo Rizzi','Connie Corleone').
esposos('Fredo Corleone','Deanna Dunn').
esposos('Deanna Dunn','Fredo Corleone').
esposos('Tom Hagen','Theresa').
esposos('Theresa','Tom Hagen').

amantes('Sonny Corleone', 'Lucy Mancini').
amantes('Lucy Mancini','Sonny Corleone').

progenitor('Antonio Andolini','Vito Corleone').
progenitor('Signora Andolini','Vito Corleone').
progenitor('Vito Corleone','Michael Corleone').
progenitor('Carmella','Michael Corleone').
progenitor('Vito Corleone','Sonny Corleone').
progenitor('Carmella','Sonny Corleone').
progenitor('Vito Corleone','Connie Corleone').
progenitor('Carmella','Connie Corleone').
progenitor('Vito Corleone','Fredo Corleone').
progenitor('Carmella','Fredo Corleone').
progenitor('Vito Corleone','Tom Hagen').
progenitor('Carmella','Tom Hagen').
progenitor('Michael Corleone','Anthony Corleone').
progenitor('Kay Adams','Anthony Corleone').
progenitor('Michael Corleone','Mary Corleone').
progenitor('Kay Adams','Mary Corleone').
progenitor('Sonny Corleone','Vincent Mancini').
progenitor('Lucy Mancini','Vincent Mancini').
progenitor('Sonny Corleone','Santino Jr. Corleone').
progenitor('Sandra','Santino Jr. Corleone').
progenitor('Sonny Corleone','Francesca Corleone').
progenitor('Sandra','Francesca Corleone').
progenitor('Sonny Corleone','Kathryn Corleone').
progenitor('Sandra','Kathryn Corleone').
progenitor('Sonny Corleone','Frank Corleone').
progenitor('Sandra','Frank Corleone').
progenitor('Connie Corleone','Victor Rizzi').
progenitor('Carlo Rizzi','Victor Rizzi').
progenitor('Connie Corleone','Michael Francis Rizzi').
progenitor('Carlo Rizzi','Michael Francis Rizzi').
progenitor('Tom Hagen','Frank Hagen').
progenitor('Theresa','Frank Hagen').
progenitor('Tom Hagen','Andrew Hagen').
progenitor('Theresa','Andrew Hagen').

ancestro(X, Y):- progenitor(X, Y).
ancestro(X, Y):- progenitor(X, Z), ancestro(Z, Y).


hermano(X, Y):-progenitor(Z, X), progenitor(Z, Y), not(X==Y).

tio(X, Y):-hermano(X, Z), progenitor(Z, Y).
sobrino(X, Y):- tio(Y, X).

nieto(X, Y):- progenitor(Y, Z), progenitor(Z, X).
abuelo(X, Y):- nieto(Y, X).

suegro(X, Y):- esposos(Y, Z), progenitor(X, Z).
cunado(X, Y):- esposos(Y, Z), hermano(X, Z).

yerno(X, Y):- suegro(Y, X), hombre(X).
nuera(X, Y):- suegro(Y, X), mujer(X).

hijo(X, Y):- progenitor(Y, X).
descendiente(X, Y):-hijo(X, Y).
descendiente(X, Y):-hijo(X, Z), descendiente(Z, Y).
lista_descendientes(X, Y):- descendientes_aux(X, [], Y).
% ! indica que si es capaz de terminar una lista, tiene que parar
descendientes_aux(X, Z, Y):- descendiente(X1, X),
                              not(member(X1, Z)),
                              descendientes_aux(X, [X1|Z], Y), !.
descendientes_aux(_,X,X).

relaciones([esposos, amantes, progenitor, ancestro, hermano, tio, sobrino, nieto, abuelo, suegro, cunado, yerno, nuera, hijo, descendiente]).
relacion(X, Y, Relacion):- relaciones(L),
                            member(Relacion, L),
                            Z=..[Relacion, X, Y],
                            call(Z).

genera_lista_parientes(Relacion, X, Y):- parientes_aux(Relacion, X, [], Y).
parientes_aux(Relacion, X, Z, Y):- N=..[relacion, X1, X, Relacion],
                                    call(N),
                                    not(member(X1, Z)),
                                    parientes_aux(Relacion, X, [X1|Z], Y), !.
parientes_aux(_,_,X,X).

lista_esposos(X, Y):- genera_lista_parientes(esposos, X, Y).
lista_amantes(X, Y):- genera_lista_parientes(amantes, X, Y).
lista_progenitores(X, Y):- genera_lista_parientes(progenitor, X, Y).
lista_ancestros(X, Y):- genera_lista_parientes(ancestro, X, Y).
lista_hermanos(X, Y):- genera_lista_parientes(hermano, X, Y).
lista_tios(X, Y):- genera_lista_parientes(tio, X, Y).
lista_sobrinos(X, Y):- genera_lista_parientes(sobrino, X, Y).
lista_nietos(X, Y):- genera_lista_parientes(nieto, X, Y).
lista_abuelos(X, Y):- genera_lista_parientes(abuelo, X, Y).
lista_suegros(X, Y):- genera_lista_parientes(suegro, X, Y).
lista_cunados(X, Y) :- genera_lista_parientes(cunado, X, Y).
lista_yernos(X, Y) :- genera_lista_parientes(yerno, X, Y).
lista_nueras(X, Y) :- genera_lista_parientes(nuera, X, Y).
lista_hijos(X, Y) :- genera_lista_parientes(hijo, X, Y).
lista_descendientes(X, Y) :- genera_lista_parientes(descendiente, X, Y).
