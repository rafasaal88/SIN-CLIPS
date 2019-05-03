(defmodule MAIN(export ?ALL))

(deftemplate MAIN::datos
	(slot nombre(type SYMBOL))
)

(deftemplate MAIN::asignatura

	(slot nombre(type STRING))
	(slot nota(type FLOAT))
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


;esta regla está duplicada, la eliminaré en un futuro
(defrule MAIN::tiene_en_mente_elegir_2_1_1
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
		(assert (asignatura (nombre "Economia")(nota (read))))

		(printout t "Matematica discreta: " crlf)		
		(assert (asignatura (nombre "md")(nota (read))))

		(printout t "Algebra lineal: " crlf)		
		(assert (asignatura (nombre "al")(nota (read))))

)










(defmodule SOFTWARE (import MAIN deftemplate asignatura initial-fact))


	(defrule SOFTWARE::recoger_notas_software


	=>
		(printout t "A continuacion, introduzca las notas de las siguientes asignaturas:" crlf)
		
		(printout t "Base de datos: " crlf)		
		(assert (asignatura (nombre "bdd")(nota (read))))

		(printout t "Sistemas operativos: " crlf)		
		(assert (asignatura (nombre "so")(nota (read))))

		(printout t "Ingenieria del Software: " crlf)		
		(assert (asignatura (nombre "is")(nota (read))))

		;(printout t "Programacion y Administracion de Sistemas: " crlf)		
		;(assert (asignatura (nombre "pas")(nota (read))))

		;(printout t "Sistemas de informacion: " crlf)		
		;(assert (asignatura (nombre "sif")(nota (read))))

	)






(defmodule COMPUTACION(import MAIN deftemplate asignatura initial-fact))


	(defrule COMPUTACION::recoger_notas_computacion

	=>
		(printout t "Introduzca las notas de las siguientes asignaturas:" crlf)
		
		(printout t "Introduccion a la programacion: " crlf)		
		(assert (asignatura (nombre "ip")(nota (read))))

		(printout t "Calculo: " crlf)		
		(assert (asignatura (nombre "calculo")(nota (read))))

		(printout t "Estadistica: " crlf)		
		(assert (asignatura (nombre "estadistica")(nota (read))))

		(printout t "Metodologia de la programacion: " crlf)		
		(assert (asignatura (nombre "mp")(nota (read))))

		(printout t "Programacion Orienta a Objetos: " crlf)		
		(assert (asignatura (nombre "poo")(nota (read))))

		;(printout t "Estructura de datos: " crlf)		
		;(assert (asignatura (nombre "ed")(nota (read))))

		;(printout t "Sistemas inteligentes: " crlf)		
		;(assert (asignatura (nombre "sin")(nota (read))))
	)



(defmodule COMPUTADORES(import MAIN deftemplate asignatura initial-fact))


	(defrule COMPUTADORES::recoger_notas_computadores

	=>
		(printout t "A continuacion, introduzca las notas de las siguientes asignaturas:" crlf)
		
		(printout t "Fisica: " crlf)		
		(assert (asignatura (nombre "fisica")(nota (read))))

		(printout t "Fundamentos y estructuras de computadores: " crlf)		
		(assert (asignatura (nombre "fec")(nota (read))))

		(printout t "Circuitos y sistemas electronicos: " crlf)		
		(assert (asignatura (nombre "cse")(nota (read))))

		(printout t "Arquitectura de computadores: " crlf)		
		(assert (asignatura (nombre "ac")(nota (read))))

		;(printout t "Arquitectura de redes: " crlf)		
		;(assert (asignatura (nombre "ar")(nota (read))))
	)
















