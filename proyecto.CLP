(defmodule MAIN(export ?ALL))

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
)







(defrule MAIN::regla-bienvenido

	(declare (salience 100))

	=>

	(printout t "Bienvenido al Sistema de ayuda a la decisión para: Elegir asignaturas o 
	itinerario en el Grado en Ingeniería Informática. " crlf crlf)
	
	(printout t "Por favor, introduzca su nombre para dirigirme a usted" crlf)	
	
	(assert (datos(nombre (read))))

)

(defrule MAIN::regla-bienvenido2

	(datos (nombre ?nombre))

=>

	(printout t crlf "De acuerdo " ?nombre ". ¿Tienes en mente elegir alguna rama en concreto o no sabes cual elegir?" crlf)
	(printout t "Opción 1: Tengo en mente una rama" crlf "Opcion 2: No se por cual rama decantarme" crlf)
	(printout t "Elija una opcion: ")
	(assert (opcion_inicial (read)))

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
	(printout t "Elija una opción: ")
	(assert (opcion_inicial_rama (read))) 

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
	(activar_software 1)
	(activar_computadores 1)
	(activar_computacion 1)
	(datos (nombre ?nombre))

=>
		(printout t "Ya vamos a terminar " ?nombre ", vamos con las ultimas:" crlf)

		(printout t "Economia: " crlf)		
		(assert (asignatura(rama "sin asignar") (nombre "Economia")(nota (read))))

		(printout t "Matematica discreta: " crlf)		
		(assert (asignatura (rama "sin asignar")(nombre "md")(nota (read))))

		(printout t "Algebra lineal: " crlf)		
		(assert (asignatura (rama "sin asignar") (nombre "al")(nota (read))))

	(assert (preguntas_extra 0))

)

(defrule extra
	(preguntas_extra 0)
	(datos (nombre ?nombre))
=>
	(printout t "Una ultima pregunta " ?nombre ". ¿Has cursado alguna asignatura más que no sea alguna de la que te he preguntado)" crlf)
	(printout t "(Si/No)" crlf)
	(assert (preguntas_extra (read)))

)

(defrule extra_2_1
	(or(or(preguntas_extra No)(preguntas_extra NO))(preguntas_extra no))
	(datos (nombre ?nombre))
=>
	(printout t "De acuerdo " ?nombre ". Hemos acabado con las preguntas. Vamos a calcular los resultados y te vamos a ofrecer un resultado" crlf)
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
	(preguntas_extra 1)
	(datos (nombre ?nombre))

=>
		(printout t "De acuerdo " ?nombre ". Vamos a preguntarte las asignaturas, RESPONDE CON 0 LAS QUE NO HAYAS CURSADO" crlf)

		(printout t "Programacion y Administracion de Sistemas: " crlf)		
		(assert (asignatura(rama "software")(nombre "pas")(nota (read))))

		(printout t "Sistemas de informacion: " crlf)		
		(assert (asignatura(rama "software")(nombre "sif")(nota (read))))

		(printout t "Estructura de datos: " crlf)		
		(assert (asignatura(rama "computacion") (nombre "ed")(nota (read))))

		(printout t "Sistemas inteligentes: " crlf)		
		(assert (asignatura(rama "computacion") (nombre "sin")(nota (read))))

		(printout t "Arquitectura de redes: " crlf)		
		(assert (asignatura(rama "computadores") (nombre "ar")(nota (read))))

		(printout t "Redes: " crlf)		
		(assert (asignatura(rama "computadores") (nombre "redes")(nota (read))))

		(printout t "Configuracion y Evaluacion de Sistemas Informaticos: " crlf)		
		(assert (asignatura(rama "computadores") (nombre "cesi")(nota (read))))

		(printout t "Programacion Web: " crlf)		
		(assert (asignatura(rama "software") (nombre "pw")(nota (read))))

		(printout t "Legislacion: " crlf)		
		(assert (asignatura(rama "software") (nombre "legislacion")(nota (read))))		

		(printout t "Proyectos: " crlf)		
		(assert (asignatura(rama "software") (nombre "proyectos")(nota (read))))

	(printout t "De acuerdo " ?nombre ". Hemos acabado con las preguntas. Vamos a calcular los resultados y te vamos a ofrecer un resultado.
	Tras realizar calculos de las medias de las asignaturas que nos has aportado el ranking	por ramas que deberias escoger es el siguiente:" crlf)

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

	(bind ?media (/ ?x ?e))
	(assert(media (rama "Computadores")(acumulador ?x)(elementos ?e)(media ?media)))
)

(defrule mostrar
	(calcular 1)
	?d1<-(media (rama ?x)(acumulador ?y)(elementos ?z)(media ?media))
	(not
		(exists
			(media (media ?m&:(> ?media ?m)))
		)
	)

=>
	(retract ?d1)
	(printout t ?x crlf)

)












(defmodule SOFTWARE (import MAIN deftemplate asignatura initial-fact))


	(defrule SOFTWARE::recoger_notas_software


	=>
		(printout t "A continuacion, introduzca las notas de las siguientes asignaturas:" crlf)
		
		(printout t "Base de datos: " crlf)		
		(assert (asignatura(rama "software") (nombre "bdd")(nota (read))))

		(printout t "Sistemas operativos: " crlf)		
		(assert (asignatura(rama "software")(nombre "so")(nota (read))))

		(printout t "Ingenieria del Software: " crlf)		
		(assert (asignatura(rama "software")(nombre "is")(nota (read))))



	)






(defmodule COMPUTACION(import MAIN deftemplate asignatura initial-fact))


	(defrule COMPUTACION::recoger_notas_computacion

	=>
		(printout t "Introduzca las notas de las siguientes asignaturas:" crlf)
		
		(printout t "Introduccion a la programacion: " crlf)		
		(assert (asignatura(rama "computacion") (nombre "ip")(nota (read))))

		(printout t "Calculo: " crlf)		
		(assert (asignatura(rama "computacion") (nombre "calculo")(nota (read))))

		(printout t "Estadistica: " crlf)		
		(assert (asignatura(rama "computacion") (nombre "estadistica")(nota (read))))

		(printout t "Metodologia de la programacion: " crlf)		
		(assert (asignatura(rama "computacion") (nombre "mp")(nota (read))))

		(printout t "Programacion Orienta a Objetos: " crlf)		
		(assert (asignatura(rama "computacion") (nombre "poo")(nota (read))))

	)



(defmodule COMPUTADORES(import MAIN deftemplate asignatura initial-fact))


	(defrule COMPUTADORES::recoger_notas_computadores

	=>
		(printout t "A continuacion, introduzca las notas de las siguientes asignaturas:" crlf)
		
		(printout t "Fisica: " crlf)		
		(assert (asignatura(rama "computadores") (nombre "fisica")(nota (read))))

		(printout t "Fundamentos y estructuras de computadores: " crlf)		
		(assert (asignatura(rama "computadores") (nombre "fec")(nota (read))))

		(printout t "Circuitos y sistemas electronicos: " crlf)		
		(assert (asignatura(rama "computadores") (nombre "cse")(nota (read))))

		(printout t "Arquitectura de computadores: " crlf)		
		(assert (asignatura(rama "computadores") (nombre "ac")(nota (read))))


	)



(defmodule NINGUNA(import MAIN deftemplate asignatura initial-fact))


	(defrule NINGUNA::todas_asignaturas

	=>
		(printout t "Vamos a empezar por las de primero" crlf)

		(printout t "Introduccion a la programacion: " crlf)	
		(assert (asignatura(rama "computacion") (nombre "ip")(nota (read))))

		(printout t "Calculo: " crlf)		
		(assert (asignatura(rama "computacion") (nombre "calculo")(nota (read))))

		(printout t "Estadistica: " crlf)		
		(assert (asignatura(rama "computacion") (nombre "estadistica")(nota (read))))

		(printout t "Fisica: " crlf)		
		(assert (asignatura(rama "computadores") (nombre "fisica")(nota (read))))

		(printout t "Fundamentos y estructuras de computadores: " crlf)		
		(assert (asignatura(rama "computadores") (nombre "fec")(nota (read))))

		(printout t "Circuitos y sistemas electronicos: " crlf)		
		(assert (asignatura(rama "computadores") (nombre "cse")(nota (read))))

		(printout t "Metodologia de la programacion: " crlf)		
		(assert (asignatura(rama "computacion") (nombre "mp")(nota (read))))		

		(printout t crlf "Vamos ahora con las de segundo:" crlf crlf)

		(printout t "Base de datos: " crlf)		
		(assert (asignatura(rama "software") (nombre "bdd")(nota (read))))

		(printout t "Sistemas operativos: " crlf)		
		(assert (asignatura(rama "software")(nombre "so")(nota (read))))

		(printout t "Ingenieria del Software: " crlf)		
		(assert (asignatura(rama "software")(nombre "is")(nota (read))))

		(printout t "Programacion Orienta a Objetos: " crlf)		
		(assert (asignatura(rama "computacion") (nombre "poo")(nota (read))))

		(printout t "Arquitectura de computadores: " crlf)		
		(assert (asignatura(rama "computadores") (nombre "ac")(nota (read))))


	)












