;Definicion modulo main
(defmodule MAIN(export ?ALL)) 



;Esta funcion comprueba que el parametro pasado por referencia este en un rango entre 0 y 10
(deffunction MAIN::nota (?nota)

	(while
		(not(and(numberp ?nota)(>= ?nota 0)(<= ?nota 10) ))
		
	do
		(printout t "Error!!, debe introducir un numero entre 0 y 10" crlf)
		(bind ?nota (read))
	)

	?nota
)



;Template para almacenar el nombre de usuario
(deftemplate MAIN::datos
	(slot nombre(type SYMBOL))
)


;Template para almacenar los hechos correspondientes a los datos de una asignatura
(deftemplate MAIN::asignatura

	(slot nombre(type STRING))
	(slot nota(type FLOAT))
	(slot rama(type STRING))
)



;Template para almacenar los hechos correspondientes al calculo de las notas de las asignaturas 
(deftemplate MAIN::media
	(slot rama (type STRING))
	(slot acumulador (type FLOAT))
	(slot elementos (type FLOAT))
	(slot media (type FLOAT))
)



;Hechos para almacenar el calculo de la media de las asignaturas
(deffacts medias
	(media (rama "Software")(acumulador 0.0)(elementos 0.0)(media 0.0))
	(media (rama "Computacion")(acumulador 0.0)(elementos 0.0)(media 0.0))
	(media (rama "Computadores")(acumulador 0.0)(elementos 0.0)(media 0.0))
)


;Hechos necesarios para disparar las reglas por bloques de preguntas por ramas
(deffacts hechos
	(activar_software 0)
	(activar_computacion 0)
	(activar_computadores 0)
	(contador 1)
)

;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------




;Regla inicial. Tiene máxima prioridad ya que su antecedente está vacio y es necesario que sea la primera regla que se dispare
(defrule MAIN::regla-bienvenido

	(declare (salience 100))

	=>

	(printout t crlf crlf "Bienvenido al Sistema de ayuda a la decision para: Elegir asignaturas o 
	itinerario en el Grado en Ingenieria Informatica. " crlf crlf)
	
	(printout t "Por favor, introduzca su nombre para dirigirme a usted" crlf)	
	
	(assert (datos(nombre (read))))

)


;Es la segunda regla que se dispara, ya que contiene el hecho anterior recogido
(defrule MAIN::regla-bienvenido2

	(datos (nombre ?nombre))

=>

	(printout t crlf "De acuerdo " ?nombre ". ¿Tienes en mente elegir alguna rama en concreto o no sabes cual elegir?" crlf)
	(printout t "Opcion 1: Tengo en mente una rama" crlf "Opcion 2: No se por cual rama decantarme" crlf)
	(printout t "Elija una opcion: ")
	(bind ?opcion (read))
	


	(while
		(not(or (= ?opcion 1)(= ?opcion 2)))
	
	do
		(printout t "No ha introducido una opcion correcta."crlf)
		(printout t "Opcion 1: Tengo en mente una rama" crlf "Opcion 2: No se por cual rama decantarme" crlf crlf )
		(bind ?opcion (read))
	)
	
	(assert (opcion_inicial ?opcion))


)

;Esta regla se activa si has elegido en la anterior la opcion 2. Dispara el modulo que contiene todas las preguntas
(defrule MAIN::tiene_en_mente_2

	(datos (nombre ?nombre))
	(opcion_inicial 2)

	?d1<-(activar_software 0)
	?d2<-(activar_computadores 0)
	?d3<-(activar_computacion 0)

=>
	(retract ?d1 ?d2 ?d3)	

	(printout t crlf crlf "De acuerdo " ?nombre ", no te preocupes. Me programaron para ayudarte." crlf)
 
	(focus NINGUNA) ;Llamada al modulo de todas las preguntas
	
	;Cambiamos los siguientes hechos para que se dispare la regla de preguntas extra
	(assert(activar_software 1))
	(assert(activar_computacion 1))
	(assert(activar_computadores 1))
	(assert (preguntas_extra 0))
)



;Si ha elegido que tiene una regla en mente se dispara esta regla que pregunta cual es
(defrule MAIN::tiene_en_mente

	(datos (nombre ?nombre))
	(opcion_inicial 1)

=>
	(printout t "De acuerdo " ?nombre ". ¿Puedes indicarme que rama es?" crlf)
	(printout t "Ramas disponibles en la UCO" crlf)
	(printout t "Opcion 1: Ingenieria del Software" crlf)
	(printout t "Opcion 2: Computacion" crlf)
	(printout t "Opcion 3: Ingenieria de computadores" crlf)
	(printout t "Elija una opcion: ")
	(bind ?opcion (read))
	

	;Comprobamos que no ha elegido una opcion diferente de 1-3
	(while
		(not(or (= ?opcion 1)(= ?opcion 2)(= ?opcion 3)))
	
	do
		(printout t "No ha introducido una opcion correcta."crlf)
		(printout t "Por favor " ?nombre ", elija una opcion correcta de las ramas disponibles en la UCO:" crlf)
		(printout t "Opcion 1: Ingenieria del Software" crlf)
		(printout t "Opcion 2: Computacion" crlf)
		(printout t "Opcion 3: Ingenieria de computadores" crlf)
		(printout t "Elija una opcion: ")
		(bind ?opcion (read))
	)
	
	(assert (opcion_inicial_rama ?opcion))

)

;----------------------------------------------------------------------------
;----Bloque de preguntas si ha elegido software------------------------------
;----------------------------------------------------------------------------



(defrule MAIN::tiene_en_mente_elegir_1
	(opcion_inicial 1)
	(opcion_inicial_rama 1)
	(datos (nombre ?nombre))
	
	?d1<-(activar_software 0)
	(activar_computacion 0)
	(activar_computadores 0)

	=>
	(retract ?d1)
	(printout t "Bueno " ?nombre ", primero te vas a realizar preguntas de asignaturas relacionadas con dicha rama, comencemos." crlf)
	(assert (activar_software 1))
	(focus SOFTWARE) ;Llamada al modulo de preguntas de software
	
)

(defrule MAIN::tiene_en_mente_elegir_1_1
	(opcion_inicial 1)
	(opcion_inicial_rama 1)
	(activar_software 1)
	?d1<-(activar_computacion 0)
	(activar_computadores 0)

=>
	(retract ?d1)
	(assert (activar_computacion 1))
	(printout t "Ahora vamos con las preguntas de computacion" crlf)
	(focus COMPUTACION);Llamada al modulo de preguntas de computacion
)

(defrule MAIN::tiene_en_mente_elegir_1_1_1
	(opcion_inicial 1)
	(opcion_inicial_rama 1)
	(activar_software 1)
	(activar_computacion 1)
	(datos (nombre ?nombre))
	?d1<-(activar_computadores 0)
	
=>
	(retract ?d1)
	(assert(activar_computadores 1))
	(printout t "A continuacion, vamos con las de computadores. Ya queda poco " ?nombre crlf)
	(focus COMPUTADORES);Llamada al modulo de preguntas de computadores
)




;----------------------------------------------------------------------------
;----Bloque de preguntas si ha elegido computacion---------------------------
;----------------------------------------------------------------------------



(defrule MAIN::tiene_en_mente_elegir_2
	(opcion_inicial 1)
	(opcion_inicial_rama 2)
	(datos (nombre ?nombre))
	?d1<-(activar_computacion 0)
	(activar_computadores 0)
	=>

	(retract ?d1)
	(printout t "Bueno " ?nombre ", primero te vas a realizar preguntas de asignaturas relacionadas con dicha rama, comencemos." crlf)
	(assert (activar_computacion 1))
	(focus COMPUTACION);Llamada al modulo de preguntas de computacion
	
)

(defrule MAIN::tiene_en_mente_elegir_2_1
	(opcion_inicial 1)
	(opcion_inicial_rama 2)
	(activar_computacion 1)
	?d1<-(activar_software 0)
	(activar_computadores 0)
=>
	(retract ?d1)
	(assert (activar_software 1))
	(printout t "Ahora vamos con las preguntas de software" crlf)
	(focus SOFTWARE);Llamada al modulo de preguntas de software
)


(defrule MAIN::tiene_en_mente_elegir_2_1_1
	(opcion_inicial 1)
	(opcion_inicial_rama 2)
	(activar_software 1)
	(activar_computacion 1)
	(datos (nombre ?nombre))
	?d1<-(activar_computadores 0)
	
=>
	(retract ?d1)
	(assert(activar_computadores 1))
	(printout t "A continuacion, vamos con las de computadores. Ya queda poco " ?nombre crlf)
	(focus COMPUTADORES);Llamada al modulo de preguntas de computadores
)



;----------------------------------------------------------------------------
;----Bloque de preguntas si ha elegido computadores--------------------------
;----------------------------------------------------------------------------

(defrule MAIN::tiene_en_mente_elegir_3
	(opcion_inicial 1)
	(opcion_inicial_rama 3)
	(datos (nombre ?nombre))
	
	?d1<-(activar_computadores 0)
	(activar_computacion 0)
	(activar_software 0)

	=>
	(retract ?d1)
	(printout t "Bueno " ?nombre ", primero te vas a realizar preguntas de asignaturas relacionadas con dicha rama, comencemos." crlf)
	(assert (activar_computadores 1))
	(focus COMPUTADORES);Llamada al modulo de preguntas de computadores
	
)

(defrule MAIN::tiene_en_mente_elegir_3_1
	(opcion_inicial 1)
	(opcion_inicial_rama 3)
	(activar_computadores 1)
	?d1<-(activar_software 0)
	(activar_computacion 0)

=>
	(retract ?d1)
	(assert (activar_software 1))
	(printout t "Ahora vamos con las preguntas de software" crlf)
	(focus SOFTWARE);Llamada al modulo de preguntas de software
)

(defrule MAIN::tiene_en_mente_elegir_3_1_1
	(opcion_inicial 1)
	(opcion_inicial_rama 3)
	(activar_software 1)
	(activar_computadores 1)
	(datos (nombre ?nombre))
	?d1<-(activar_computacion 0)
	
=>
	(retract ?d1)
	(assert(activar_computacion 1))
	(printout t "A continuacion, vamos con las de computacion. Ya queda poco " ?nombre crlf)
	(focus COMPUTACION);Llamada al modulo de preguntas de computacion
)


;-------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------








;Esta regla se activa al finalizar cualquiera de los tres bloque anteriores, son asignaturas que no pertenecen a ninguna rama
(defrule asignaturas_sin_rama
	(opcion_inicial 1)
	(activar_software 1)
	(activar_computadores 1)
	(activar_computacion 1)
	(datos (nombre ?nombre))

=>
	(printout t "Ya vamos a terminar " ?nombre ", vamos con las ultimas:" crlf)
	(focus SINRAMA)


	(assert (preguntas_extra 0))

)





;Una vez han finaliado cualquiera de las opciones sea tener en mente o no se pregunta si ha cursado mas asignaturas
(defrule extra
	(preguntas_extra 0)
	(datos (nombre ?nombre))
=>
	(printout t "Una ultima pregunta " ?nombre ". ¿Has cursado alguna asignatura mas que no sea alguna de las que te he preguntado)" crlf)
	(printout t "(Si/No)" crlf)
	

	(bind ?opcion (read))
	
	(while
		(not(lexemep ?opcion))
		(not(or
			(eq ?opcion Si)(eq ?opcion SI)(eq ?opcion si)(eq ?opcion No)(eq ?opcion NO)(eq ?opcion no)
			)
		)
	do
	(printout t "Error!! Una ultima pregunta " ?nombre ". ¿Has cursado alguna asignatura mas que no sea alguna de las que te he preguntado)" crlf)
	(printout t "(Si/No)" crlf)
	(bind ?opcion (read))
	)

	(assert (preguntas_extra ?opcion));Se almacena en un hecho la respuesta

)



;Si ha contestado que no, se dispara esta regla que guardara un hecho que dispara las reglas de calculo de medias
(defrule extra_2_1
	(or(or(preguntas_extra No)(preguntas_extra NO))(preguntas_extra no))
	(datos (nombre ?nombre))
=>
	(printout t "De acuerdo " ?nombre ". Hemos acabado con las preguntas." crlf)
	(printout t "Tras realizar calculos de las medias de las asignaturas que nos has aportado, el ranking por ramas que deberias escoger es el siguiente:" crlf)
	(assert (calcular 1))
	

)

;Si ha contestado que si cambiamos el hecho preguntas_extras a 1 para disparar la siguiente regla
(defrule extra_2
	(or(or(preguntas_extra Si)(preguntas_extra SI))(preguntas_extra si))
	?d1<-(preguntas_extra 0)
=>
	(retract ?d1)
	(assert (preguntas_extra 1))
	

)


;Esta regla dispara el modulo de preguntas extras
(defrule extra_3
	?d1<-(preguntas_extra 1)
	(datos (nombre ?nombre))

=>
	(printout t "De acuerdo " ?nombre ". Vamos a preguntarte las asignaturas, RESPONDE CON 0 LAS QUE NO HAYAS CURSADO" crlf)
	(assert(preguntas_extra 2));Cambiamos a 2 para disparar la regla siguiente
	(focus EXTRA);Llamada al modulo de preguntas extras

)


;Esta regla dispara otras reglas a traves de un hecho llamado calcular que hace lo que el propio nombre indicar
(defrule extra_3_1
	(preguntas_extra 2)
	(datos (nombre ?nombre))

=>

	(printout t "De acuerdo " ?nombre ". Hemos acabado con las preguntas." crlf)
	(printout t "Tras realizar calculos de las medias de las asignaturas que nos has aportado, el ranking por ramas que deberias escoger es el siguiente:" crlf)

	(assert (calcular 0))
)



;Antes de realizar el calculo se borran las asignaturas quue tienen 0 de nota ya que se consideran no cursadas
(defrule borrar
	(calcular 0)
	?d1 <- (asignatura (nombre ?x)(nota ?z&:(= ?z 0))(rama ?y))
	=>

	(retract ?d1)

)


;Una vez que no existe ninguna asignatura con un 0 se procede al calculo de la media
(defrule borrar_2
	?d1<-(calcular 0)
	(not(exists(asignatura (nombre ?x)(nota ?z&:(= ?z 0))(rama ?y))))
	=>
	(retract ?d1)
	(assert(calcular 1))

)


;Esta regla suma toda las notas de las asignaturas de software y borra el hecho que contiene la asignatura
(defrule sumar_software
	(calcular 1)
	?d1<-(asignatura (nombre ?x)(nota ?y)(rama "software"))
	?d2<-(media (rama "Software")(acumulador ?z)(elementos ?e)(media ?m))
=>
	(retract ?d1 ?d2)
	(assert (media (rama "Software")(acumulador (+ ?z ?y) )(elementos (+ ?e 1) )(media ?m)))

)


;Esta regla suma toda las notas de las asignaturas de computacion y borra el hecho que contiene la asignatura
(defrule sumar_computacion
	(calcular 1)
	?d1<-(asignatura (nombre ?x)(nota ?y)(rama "computacion"))
	?d2<-(media (rama "Computacion")(acumulador ?z)(elementos ?e)(media ?m))
=>
	(retract ?d1 ?d2)
	(assert (media (rama "Computacion")(acumulador (+ ?z ?y) )(elementos (+ ?e 1) )(media ?m)))

)

;Esta regla suma toda las notas de las asignaturas de computadores y borra el hecho que contiene la asignatura
(defrule sumar_computadores
	(calcular 1)
	?d1<-(asignatura (nombre ?x)(nota ?y)(rama "computadores"))
	?d2<-(media (rama "Computadores")(acumulador ?z)(elementos ?e)(media ?m))
=>
	(retract ?d1 ?d2)
	(assert (media (rama "Computadores")(acumulador (+ ?z ?y) )(elementos (+ ?e 1) )(media ?m)))

)


;Comprueba que ya se ha sumado todos los elementos ya que no existe ninguna asignatura de la rama de software
;Una vez realizada la comprobacion calcula la media
(defrule media_software
	(calcular 1)
	(not(exists(asignatura (nombre ?m)(nota ?n)(rama "software"))))

	
	?d1<-(media (rama "Software")(acumulador ?x)(elementos ?e)(media ?m))

	(not(test(= ?e 0)))
	(test(= ?m 0))

=>
	(retract ?d1)
	(assert(calculado_software 1))
	(bind ?media (/ ?x ?e))
	(assert(media (rama "Software")(acumulador ?x)(elementos ?e)(media ?media)))
)

;Comprueba que ya se ha sumado todos los elementos ya que no existe ninguna asignatura de la rama de computacion
;Una vez realizada la comprobacion calcula la media
(defrule media_computacion
	(calcular 1)
	(not(exists(asignatura (nombre ?m)(nota ?n)(rama "computacion"))))

	
	?d1<-(media (rama "Computacion")(acumulador ?x)(elementos ?e)(media ?m))

	(not(test(= ?e 0)))
	(test(= ?m 0))

=>
	(retract ?d1)
	(assert(calculado_computacion 1))
	(bind ?media (/ ?x ?e))
	(assert(media (rama "Computacion")(acumulador ?x)(elementos ?e)(media ?media)))
)


;Comprueba que ya se ha sumado todos los elementos ya que no existe ninguna asignatura de la rama de computadores
;Una vez realizada la comprobacion calcula la media
(defrule media_computadores
	(calcular 1)
	(not(exists(asignatura (nombre ?m)(nota ?n)(rama "computadores"))))

	
	?d1<-(media (rama "Computadores")(acumulador ?x)(elementos ?e)(media ?m))

	(not(test(= ?e 0)))
	(test(= ?m 0))

=>
	(retract ?d1)
	(assert(calculado_computadores 1))
	(bind ?media (/ ?x ?e))
	(assert(media (rama "Computadores")(acumulador ?x)(elementos ?e)(media ?media)))
)



;Esta ultima regla muestra por pantalla las ramas segun su media de mayor a menor, dando al usuario informacion de cual es mejor para el
(defrule mostrar
	
	(calculado_computadores 1)
	(calculado_computacion 1)
	(calculado_software 1)
	?d1<-(contador ?cont)



	?d2<-(media (rama ?x)(acumulador ?y)(elementos ?z)(media ?media))
	(not
		(exists
			(media (media ?m&:(> ?media ?m)))
		)
	)

=>
	(retract ?d1 ?d2)
	(assert (contador (+ ?cont 1)))
	(printout t ?cont ". " ?x crlf)

)







;--------------------------------------------------------------------------------------------------------
;--------------------------PREGUNTAS DE SOFTWARE - MODULO SOFTWARE---------------------------------------
;--------------------------------------------------------------------------------------------------------


(defmodule SOFTWARE (import MAIN deftemplate asignatura initial-fact)(import MAIN deffunction nota))


	(defrule SOFTWARE::recoger_notas_software


	=>
		(printout t "A continuacion, introduzca las notas de las siguientes asignaturas:" crlf)
		
		(printout t "Base de datos: " crlf)		
		
		(bind ?bdd (read)) ;Leemos valor por teclado
	
		(bind ?bdd (nota ?bdd));Comprobamos que esta en el rango 0-10 llamando a la funcion
	
		(assert (asignatura(rama "software") (nombre "bdd")(nota ?bdd)));Guardamos la nota



		(printout t "Sistemas operativos: " crlf)		
		
		(bind ?so (read)) ;Leemos valor por teclado
	
		(bind ?so (nota ?so));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "software") (nombre "so")(nota ?so)))




		(printout t "Ingenieria del Software: " crlf)		
		
		(bind ?is (read)) ;Leemos valor por teclado
	
		(bind ?is (nota ?is));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "software") (nombre "is")(nota ?is)))

	)



;--------------------------------------------------------------------------------------------------------
;-----------------------PREGUNTAS DE COMPUTACION - MODULO COMPUTACION------------------------------------
;--------------------------------------------------------------------------------------------------------


(defmodule COMPUTACION(import MAIN deftemplate asignatura initial-fact)(import MAIN deffunction nota))


	(defrule COMPUTACION::recoger_notas_computacion

	=>
		(printout t "Introduzca las notas de las siguientes asignaturas:" crlf)
		
		(printout t "Introduccion a la programacion: " crlf)		
		
		(bind ?ip (read)) ;Leemos valor por teclado
	
		(bind ?ip (nota ?ip));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "computacion") (nombre "ip")(nota ?ip)))



		(printout t "Calculo: " crlf)		
		
		(bind ?calculo (read)) ;Leemos valor por teclado
	
		(bind ?calculo (nota ?calculo));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "computacion") (nombre "calculo")(nota ?calculo)))



		(printout t "Estadistica: " crlf)		
		
		(bind ?estadistica (read)) ;Leemos valor por teclado
	
		(bind ?estadistica (nota ?estadistica));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "computacion") (nombre "estadistica")(nota ?estadistica)))




		(printout t "Metodologia de la programacion: " crlf)		
		
		(bind ?mp (read)) ;Leemos valor por teclado
	
		(bind ?mp (nota ?mp));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "computacion") (nombre "mp")(nota ?mp)))

		


		(printout t "Programacion Orienta a Objetos: " crlf)		
		
		(bind ?poo (read)) ;Leemos valor por teclado
	
		(bind ?poo (nota ?poo));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "computacion") (nombre "poo")(nota ?poo)))

	)




;--------------------------------------------------------------------------------------------------------
;----------------------PREGUNTAS DE COMPUTADORES - MODULO COMPUTADORES-----------------------------------
;--------------------------------------------------------------------------------------------------------


(defmodule COMPUTADORES(import MAIN deftemplate asignatura initial-fact)(import MAIN deffunction nota))


	(defrule COMPUTADORES::recoger_notas_computadores

	=>
		(printout t "A continuacion, introduzca las notas de las siguientes asignaturas:" crlf)
		

		(printout t "Fisica: " crlf)		
		
		(bind ?fisica (read)) ;Leemos valor por teclado
	
		(bind ?fisica (nota ?fisica));Comprobamos que esta en el rango 0-10 llamando a la funcion		

		(assert (asignatura(rama "computadores") (nombre "fisica")(nota ?fisica)))
		





		(printout t "Fundamentos y estructuras de computadores: " crlf)		
		
		(bind ?fec (read)) ;Leemos valor por teclado
	
		(bind ?fec (nota ?fec));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "computadores") (nombre "fec")(nota ?fec)))	

		

		(printout t "Circuitos y sistemas electronicos: " crlf)		
		
		(bind ?cse (read)) ;Leemos valor por teclado
	
		(bind ?cse (nota ?cse));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "computadores") (nombre "cse")(nota ?cse)))	


		

		(printout t "Arquitectura de computadores: " crlf)		
		
		(bind ?ac (read)) ;Leemos valor por teclado
	
		(bind ?ac (nota ?ac));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "computadores") (nombre "ac")(nota ?ac)))	

	


	)




;--------------------------------------------------------------------------------------------------------
;--------------------------TODAS LAS PREGUNTAS - MODULO NINGUNA RAMA-------------------------------------
;--------------------------------------------------------------------------------------------------------

(defmodule NINGUNA(import MAIN deftemplate asignatura initial-fact)(import MAIN deffunction nota))


	(defrule NINGUNA::todas_asignaturas

	=>
		(printout t "Vamos a empezar por las de primero" crlf)

		(printout t "Introduccion a la programacion: " crlf)		
		
		(bind ?ip (read)) ;Leemos valor por teclado
	
		(bind ?ip (nota ?ip));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "computacion") (nombre "ip")(nota ?ip)))


		(printout t "Economia: " crlf)	
		
		(bind ?economia (read))
	
		(bind ?economia (nota ?economia));Comprobamos que esta en el rango 0-10 llamando a la funcion	


		(assert (asignatura(rama "sin asignar") (nombre "Economia")(nota ?economia)))




		(printout t "Calculo: " crlf)		
		
		(bind ?calculo (read)) ;Leemos valor por teclado
	
		(bind ?calculo (nota ?calculo));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "computacion") (nombre "calculo")(nota ?calculo)))



		(printout t "Estadistica: " crlf)		
		
		(bind ?estadistica (read)) ;Leemos valor por teclado
	
		(bind ?estadistica (nota ?estadistica));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "computacion") (nombre "estadistica")(nota ?estadistica)))



		(printout t "Fisica: " crlf)		
		
		(bind ?fisica (read)) ;Leemos valor por teclado
	
		(bind ?fisica (nota ?fisica));Comprobamos que esta en el rango 0-10 llamando a la funcion		

		(assert (asignatura(rama "computadores") (nombre "fisica")(nota ?fisica)))


	

		(printout t "Fundamentos y estructuras de computadores: " crlf)		
		
		(bind ?fec (read)) ;Leemos valor por teclado
	
		(bind ?fec (nota ?fec));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "computadores") (nombre "fec")(nota ?fec)))



		(printout t "Circuitos y sistemas electronicos: " crlf)		
		
		(bind ?cse (read)) ;Leemos valor por teclado
	
		(bind ?cse (nota ?cse));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "computadores") (nombre "cse")(nota ?cse)))		



		(printout t "Metodologia de la programacion: " crlf)		
		
		(bind ?mp (read)) ;Leemos valor por teclado
	
		(bind ?mp (nota ?mp));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "computacion") (nombre "mp")(nota ?mp)))

	

		(printout t "Matematica discreta: " crlf)	
		
		(bind ?md (read))
	
		(bind ?md (nota ?md));Comprobamos que esta en el rango 0-10 llamando a la funcion	


		(assert (asignatura(rama "sin asignar") (nombre "Economia")(nota ?md)))



		(printout t "Algebra lineal: " crlf)	
		
		(bind ?al (read))
	
		(bind ?al (nota ?al));Comprobamos que esta en el rango 0-10 llamando a la funcion


			

		(printout t crlf "Vamos ahora con las de segundo:" crlf crlf)


		(printout t "Base de datos: " crlf)		
		
		(bind ?bdd (read)) ;Leemos valor por teclado
	
		(bind ?bdd (nota ?bdd));Comprobamos que esta en el rango 0-10 llamando a la funcion
	
		(assert (asignatura(rama "software") (nombre "bdd")(nota ?bdd)));Guardamos la nota




		(printout t "Sistemas operativos: " crlf)		
		
		(bind ?so (read)) ;Leemos valor por teclado
	
		(bind ?so (nota ?so));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "software") (nombre "so")(nota ?so)))





		(printout t "Ingenieria del Software: " crlf)		
		
		(bind ?is (read)) ;Leemos valor por teclado
	
		(bind ?is (nota ?is));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "software") (nombre "is")(nota ?is)))





		(printout t "Programacion Orienta a Objetos: " crlf)		
		
		(bind ?poo (read)) ;Leemos valor por teclado
	
		(bind ?poo (nota ?poo));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "computacion") (nombre "poo")(nota ?poo)))

	
		(printout t "Arquitectura de computadores: " crlf)		
		
		(bind ?ac (read)) ;Leemos valor por teclado
	
		(bind ?ac (nota ?ac));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "computadores") (nombre "ac")(nota ?ac)))




	)



;--------------------------------------------------------------------------------------------------------
;--------------------------PREGUNTAS EXTRA - MODULO PREGUNTAS EXTRA--------------------------------------
;--------------------------------------------------------------------------------------------------------


(defmodule EXTRA(import MAIN deftemplate asignatura initial-fact)(import MAIN deffunction nota))


	(defrule EXTRA::todas_asignaturas

	=>

		(printout t "Programacion y Administracion de Sistemas: " crlf)		
		
		(bind ?pas (read)) ;Leemos valor por teclado
	
		(bind ?pas (nota ?pas));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "software") (nombre "pas")(nota ?pas)))






		(printout t "Sistemas de informacion: " crlf)		
		
		(bind ?sif (read)) ;Leemos valor por teclado
	
		(bind ?sif (nota ?sif));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "software") (nombre "sif")(nota ?sif)))








		(printout t "Estructura de datos: " crlf)		
		
		(bind ?ed (read)) ;Leemos valor por teclado
	
		(bind ?ed (nota ?ed));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "computacion") (nombre "ed")(nota ?ed)))



		(printout t "Sistemas inteligentes: " crlf)		
		
		(bind ?sin (read)) ;Leemos valor por teclado
	
		(bind ?sin (nota ?sin));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "computacion") (nombre "sin")(nota ?sin)))



		(printout t "Arquitectura de redes: " crlf)		
		
		(bind ?ar (read))
	
		(bind ?ar (nota ?ar));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "computadores") (nombre "ar")(nota ?ar)))




		(printout t "Redes: " crlf)		
		
		(bind ?redes (read))
	
		(bind ?redes (nota ?redes));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "computadores") (nombre "redes")(nota ?redes)))




		(printout t "Configuracion y Evaluacion de Sistemas Informaticos: " crlf)		
		
		(bind ?cesi (read))
	
		(bind ?cesi (nota ?cesi));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "computadores") (nombre "cesi")(nota ?cesi)))




		(printout t "Programacion Web: " crlf)		
		
		(bind ?pw (read))
	
		(bind ?pw (nota ?pw));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "software") (nombre "pw")(nota ?pw)))




		(printout t "Legislacion: " crlf)		
		
		(bind ?legislacion (read))
	
		(bind ?legislacion (nota ?legislacion));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "software") (nombre "legislacion")(nota ?legislacion)))




		(printout t "Proyectos: " crlf)		
		
		(bind ?proyectos (read))
	
		(bind ?proyectos (nota ?proyectos));Comprobamos que esta en el rango 0-10 llamando a la funcion

		(assert (asignatura(rama "software") (nombre "legislacion")(nota ?proyectos)))

	)



;--------------------------------------------------------------------------------------------------------
;--------------------------PREGUNTAS SIN RAMA - MODULO PREGUNTAS SIN RAMA--------------------------------
;--------------------------------------------------------------------------------------------------------


(defmodule SINRAMA(import MAIN deftemplate asignatura initial-fact)(import MAIN deffunction nota))


	(defrule SINRAMA::asignaturas

	=>

		

		
		(printout t "Economia: " crlf)	
		
		(bind ?economia (read))
	
		(bind ?economia (nota ?economia));Comprobamos que esta en el rango 0-10 llamando a la funcion	


		(assert (asignatura(rama "sin asignar") (nombre "Economia")(nota ?economia)))



		(printout t "Matematica discreta: " crlf)	
		
		(bind ?md (read))
	
		(bind ?md (nota ?md));Comprobamos que esta en el rango 0-10 llamando a la funcion	


		(assert (asignatura(rama "sin asignar") (nombre "Economia")(nota ?md)))



		(printout t "Algebra lineal: " crlf)	
		
		(bind ?al (read))
	
		(bind ?al (nota ?al));Comprobamos que esta en el rango 0-10 llamando a la funcion	


		(assert (asignatura(rama "sin asignar") (nombre "al")(nota ?al)))




	)


