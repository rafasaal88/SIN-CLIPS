(defmodule MAIN)

(deftemplate MAIN::datos
	(slot nombre(type SYMBOL))
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
	(activar_computacion 1)
	?d1<-(activar_software 0)
=>
	(retract ?d1)
	(assert (activar_software 1))
	(printout t "Ahora vamos con las preguntas de software" crlf)
	(focus SOFTWARE)
)


;esta regla está duplicada, la eliminaré en un futuro
(defrule MAIN::tiene_en_mente_elegir_2_1_1
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





(defmodule SOFTWARE)


	(defrule SOFTWARE::prueba

	=>
		(printout t "SOY SOFTWARE" crlf)
	)



(defmodule COMPUTACION)


	(defrule COMPUTACION::prueba2

	=>
		(printout t "SOY COMPUTACION" crlf)
	)



(defmodule COMPUTADORES)


	(defrule COMPUTADORES::prueba3

	=>
		(printout t "SOY COMPUTADORES" crlf)
	)
















