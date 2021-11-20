import wollok.game.*

class Persona {

	const property elementosCercanos = []
	const property comidas = []
	var property criterioParaDarElemento = sordo
	const posiciones = []
	var property criterioDeComida = vegetariano

	method posicion(nuevaPosicion) {
		posiciones.add(nuevaPosicion)
	}

	method posicion() = posiciones.last()

	method tieneElemento(elemento) = elementosCercanos.contains(elemento)

	method agregarElementos(elementos) {
		elementosCercanos.addAll(elementos)
	}

	method darElemento(elemento, personaQuePide) {
		if (!self.tieneElemento(elemento)) {
			throw new DomainException(message = "No tengo cerca el elemento" + elemento)
		}
		criterioParaDarElemento.pasarElemento(elemento, self, personaQuePide)
	}

	method comer(comida) {
		if (criterioDeComida.acepta(comida)) {
			comidas.add(comida)
		}
	}

	method quitarElementos(elementos) {
		elementosCercanos.removeAllSuchThat{ elementoCercano => elementos.contains(elementoCercano)}
	}

	method primerElementoCercano() = elementosCercanos.head()

	method estaPipon() = comidas.any{ comida => comida.esPesada() }

	method comioAlgo() = !comidas.isEmpty()

	method laPasaBien() = self.comioAlgo() && self.lapasaBienPersonalmente()

	method lapasaBienPersonalmente()

}

object osky inherits Persona {

	override method lapasaBienPersonalmente() = true

}

object moni inherits Persona {

	override method lapasaBienPersonalmente() = posiciones.contains(game.at(1, 1))

}

object facu inherits Persona {

	override method lapasaBienPersonalmente() = comidas.any{ comida => comida.esCarne() }

}

object vero inherits Persona {

	override method lapasaBienPersonalmente() = elementosCercanos.size() <= 3

}

class Comida {

	const property calorias = 100
	const property esCarne = false

	method esPesada() = calorias > 500

}

class CriterioAPasarElementos {

	method pasarElemento(elemento, personaQueDa, personaQueRecibe) {
		const elementosAPasar = self.elementosAPasar(elemento, personaQueDa)
		personaQueRecibe.agregarElementos(elementosAPasar)
		personaQueDa.quitarElementos(elementosAPasar)
	}

	method elementosAPasar(elemento, personaQueDa)

}

object sordo inherits CriterioAPasarElementos {

	override method elementosAPasar(elemento, personaQueDa) = [ personaQueDa.primerElementoCercano() ]

}

object irritable inherits CriterioAPasarElementos {

	override method elementosAPasar(elemento, personaQueDa) = personaQueDa.elementosCercanos()

}

object movedizo {

	method pasarElemento(elemento, personaQueDa, personaQuePide) {
		const posicionDeLaQuePide = personaQuePide.posicion()
		personaQuePide.posicion(personaQueDa.posicion())
		personaQueDa.posicion(posicionDeLaQuePide)
	}

}

object obediente inherits CriterioAPasarElementos {

	override method elementosAPasar(elemento, personaQueDa) = [elemento]

}

object vegetariano {

	method acepta(comida) = not comida.esCarne()

}

object dietetico {

	var property limiteDeCalorias = 500

	method acepta(comida) = comida.calorias() < limiteDeCalorias

}

class Alternado {

	var quiero = false

	method acepta(comida) {
		quiero = !quiero
		return not quiero
	}

}

class AceptacionCombinada {

	const property criteriosDeAceptacion = []

	method agregarCriterios(criterios) = criteriosDeAceptacion.addAll(criterios)

	method acepta(comida) = criteriosDeAceptacion.all{ criterio => criterio.acepta(comida) }

}

