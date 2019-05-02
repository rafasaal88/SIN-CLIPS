(deftemplate datos
	(slot nombre(type SYMBOL))
	(slot edad (type INTEGER))
)



(defrule regla-bienvenido


(declare (salience 100))

=>
	(printout t "Bienvenido al Sistema de ayuda a la decisión para: Elegir asignaturas o 
	itinerario en el Grado en Ingeniería Informática. " crlf crlf)
	
	(printout t "Por favor, introduzca su nombre para dirigirme a usted" crlf)
	
	
	(assert (datos(edad (read))))

	
)
hh
