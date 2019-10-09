import wollok.game.*
import distancia.*
import jugadores.*
import unidad.*
import visuals.*

object cursor {
	var jugadorActual = jugador1
	var unidad = null
	var property position = game.center()
	var posicionesAtacables = []

	method image() = jugadorActual.cursorImage()

	method seleccionar() {
		if (unidad == null) {
			unidad = self.unidadEn(position)
			if (unidad != null && unidad.puedeAtacar())
				self.captarEnemigosCercanos()
			else
				unidad = null
		} else {
			var distanciaEnMovimientos = new Distancia(position = unidad.position())
			
			if (self.esCasillaOcupable() && unidad.puedeLlegar(distanciaEnMovimientos.distanciaA(position))) {
				self.descaptarEnemigosCercanos()
				unidad.mover(position)
				self.captarEnemigosCercanos()
			} else if (unidad.position() == position ) { 
				self.descaptarEnemigosCercanos()
				unidad = null
			} else { game.say(unidad,"No puedo llegar allí :(") }
		}
	}
	
	method atacar(){
		if ( unidad == null || !posicionesAtacables.contains(position) || !unidad.puedeAtacar()) {
			self.error("No puedo hacer eso")
		}
		var unidadAtacada = self.unidadEn(position)
		unidad.combatir(unidadAtacada)
		unidadAtacada.combatir(unidad)
		unidad.puedeAtacar(false)
		unidad.puedeMoverse(false)
		unidad.cambiarSprite(ataque)
		unidadAtacada.cambiarSprite(ataque)
		unidadAtacada.chequearMuerte()
		unidad.chequearMuerte()
		unidad = null
		self.descaptarEnemigosCercanos()
		
	}
	
	method atacarEspecial() {}
	
	method captarEnemigosCercanos() {
		var posicionesCerca = [position.right(1),position.left(1),position.up(1),position.down(1)]
		posicionesAtacables = posicionesCerca.filter{pos => self.unidadEn(pos) != null}
		posicionesAtacables.forEach{pos => game.addVisual(new Visual(image="atacable.png", position = pos))}
	}
	
	method descaptarEnemigosCercanos() {
		var espadasDeAtaque = []
		posicionesAtacables.forEach({pos => espadasDeAtaque.add(game.getObjectsIn(pos).filter({objeto => objeto.image() == "atacable.png"}).head())})
		posicionesAtacables.clear()
		espadasDeAtaque.forEach({espada => game.removeVisual(espada)})
	}
	
	method mostrarRangoTransitable(){
		
	}
	
	method unidadEn(posicion) { 
		var lista = game.getObjectsIn(posicion).filter({objeto => objeto.esSeleccionable()})
		return if(lista.size() > 0) lista.head() else null
	}
	
	method esCasillaOcupable() = self.unidadEn(position) == null //Acá poner los limites del mapa tmb


	method esSeleccionable() = false
}

