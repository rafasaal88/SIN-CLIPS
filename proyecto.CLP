(defmodule MAIN(export ?ALL)) 

(deffunction MAIN::nota (?nota)

	(while
		(not(and(numberp ?nota)(>= ?nota 0)(<= ?nota 10) ))
		
	do
		(printout t "Error!!, debe introducir un numero entre 0 y 10" crlf)
		(bind ?nota (read))
	)

	?nota
)



(deftemplate MAIN::datos
	(slot nombre(type SYMBOL))
)



(deftemplate MAIN::asignatura

	(slot nombre(type STRING))
	(slot nota(type FLOAT))
	(slot rama(type STRING))
)

(deftemplate MAIN::media
	(slot rama (type STRING))
	(slot acumulador (type FLOAT))
	(slot elementos (type FLOAT))
	(slot media (type FLOAT))
)

(deffacts medias
	(media (rama "Software")(acumulador 0.0)(elementos 0.0)(media 0.0))
	(media (rama "Computacion")(acumulador 0.0)(elementos 0.0)(media 0.0))
	(media (rama "Computadores")(acumulador 0.0)(elementos 0.0)(media 0.0))
)



(deffacts hechos

	(activar_software 0)
	(activar_computacion 0)
	(activar_computadores 0)
	(contador 1)
)







(defrule MAIN::regla-bienvenido

	(declare (salience 100))

	=>

	(printout t "Bienvenido al Sistema de ayuda a la decision para: Elegir asignaturas o 
	itinerario en el Grado en Ingenieria Informatica. " crlf crlf)
	
	(printout t "Por favor, introduzca su nombre para dirigirme a usted" crlf)	
	
	(assert (datos(nombre (read))))

)




(defrule MAIN::regla-bienvenido2

	(datos (nombre ?nombre))

=>

	(printout t crlf "De acuerdo " ?nombre ". �Tienes en mente elegir alguna rama en concreto o no sabes cual elegir?" crlf)
	(printout t "Opcion 1: Tengo en mente una rama" crlf "Opcion 2: No se por cual rama decantarme" crlf)
	(printout t "Elija una opcion: ")
	(bind ?opcion (read))
	


	(while
		(not(or (= ?opcion 1)(= ?opcion 2)))
	
	do
		(printout t "No ha introducido una opcion correcta."crlf)
		(printout t "Opcion 1: Tengo en mente una rama" crlf "Opcion 2: No se por cual rama decantarme" crlf)
		(bind ?opcion (read))
	)
	
	(assert (opcion_inicial ?opcion))


)


(defrule MAIN::tiene_en_mente_2

	(datos (nombre ?nombre))
	(opcion_inicial 2)

	?d1<-(activar_software 0)
	?d2<-(activar_computadores 0)
	?d3<-(activar_computacion 0)

=>
	(retract ?d1 ?d2 ?d3)	

	(printout t "De acuerdo " ?nombre ", no te preocupes. Me programaron para ayudarte." crlf)
 
	(focus NINGUNA)
	
	(assert(activar_software 1))
	(assert(activar_computacion 1))
	(assert(activar_computadores 1))

	(assert (preguntas_extra 0))
)




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
	(focus SOFTWARE)
	
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
	(focus COMPUTACION)
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
	(focus COMPUTADORES)
)


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
	(focus COMPUTACION)
	
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
	(focus SOFTWARE)
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
	(focus COMPUTADORES)
)


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
	(focus COMPUTADORES)
	
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
	(focus SOFTWARE)
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
	(focus COMPUTACION)
)

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
	(printout t "Error!! Una ultima pregunta " ?nombre ". �Has cursado alguna asignatura mas que no sea alguna de las que te he preguntado)" crlf)
	(printout t "(Si/No)" crlf)
	(bind ?opcion (read))
	)

	(assert (preguntas_extra ?opcion))

)

(defrule extra_2_1
	(or(or(preguntas_extra No)(preguntas_extra NO))(preguntas_extra no))
	(datos (nombre ?nombre))
=>
	(printout t "De acuerdo " ?nombre ". Hemos acabado con las preguntas." crlf)
	(printout t "Tras realizar calculos de las medias de las asignaturas que nos has aportado, el ranking por ramas que deberias escoger es el siguiente:" crlf)
	(assert (calcular 1))
	

)


(defrule extra_2
	(or(or(preguntas_extra Si)(preguntas_extra SI))(preguntas_extra si))
	?d1<-(preguntas_extra 0)
=>
	(retract ?d1)
	(assert (preguntas_extra 1))
	

)

(defrule extra_3
	?d1<-(preguntas_extra 1)
	(datos (nombre ?nombre))

=>
	(printout t "De acuerdo " ?nombre ". Vamos a preguntarte las asignaturas, RESPONDE CON 0 LAS QUE NO HAYAS CURSADO" crlf)
	(assert(preguntas_extra 2))
	(focus EXTRA)

)

(defrule extra_3_1
	(preguntas_extra 2)
	(datos (nombre ?nombre))

=>

	(printout t "De acuerdo " ?nombre ". Hemos acabado con las preguntas." crlf)
	(printout t "Tras realizar calculos de las medias de las asignaturas que nos has aportado, el ranking por ramas que deberias escoger es el siguiente:" crlf)

	(assert (calcular 0))
)




(defrule borrar
	(calcular 0)
	?d1 <- (asignatura (nombre ?x)(nota ?z&:(= ?z 0))(rama ?y))
	=>

	(retract ?d1)

)

(defrule borrar_2
	?d1<-(calcular 0)
	(not(exists(asignatura (nombre ?x)(nota ?z&:(= ?z 0))(rama ?y))))
	=>
	(retract ?d1)
	(assert(calcular 1))

)



(defrule sumar_software
	(calcular 1)
	?d1<-(asignatura (nombre ?x)(nota ?y)(rama "software"))
	?d2<-(media (rama "Software")(acumulador ?z)(elementos ?e)(media ?m))
=>
	(retract ?d1 ?d2)
	(assert (media (rama "Software")(acumulador (+ ?z ?y) )(elementos (+ ?e 1) )(media ?m)))

)

(defrule sumar_computacion
	(calcular 1)
	?d1<-(asignatura (nombre ?x)(nota ?y)(rama "computacion"))
	?d2<-(media (rama "Computacion")(acumulador ?z)(elementos ?e)(media ?m))
=>
	(retract ?d1 ?d2)
	(assert (media (rama "Computacion")(acumulador (+ ?z ?y) )(elementos (+ ?e 1) )(media ?m)))

)

(defrule sumar_computadores
	(calcular 1)
	?d1<-(asignatura (nombre ?x)(nota ?y)(rama "computadores"))
	?d2<-(media (rama "Computadores")(acumulador ?z)(elementos ?e)(media ?m))
=>
	(retract ?d1 ?d2)
	(assert (media (rama "Computadores")(acumulador (+ ?z ?y) )(elementos (+ ?e 1) )(media ?m)))

)

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


