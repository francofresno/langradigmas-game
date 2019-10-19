import wollok.game.*
import utilidades.distancia.*
import utilidades.visuals.*
import utilidades.estadoSeleccionCursor.*
import utilidades.estadoEspecialCursor.*
import utilidades.acciones.*
import utilidades.comentarios.*
import unidades.unidad.*
import escenario.casillas.*
import jugadores.*
import turnos.*

object cursor {
	var property unidad = null
	var property position = game.center()
	var property image = turnoManager.getJugadorActual().cursorImage()
	var enemigosAtacables = []
	var rangoMarcadoPorUnidad = []
	var property estadoSeleccion = estadoVacio
	var property estadoEspecial = estadoNoEspecial

	method seleccionar() {
		estadoSeleccion.accion(self)
	}
	
	method atacar(){
		self.verificarLaUnidadPuedaAtacar()
		var unidadAtacada = self.unidadEn(position)
		unidad.combatir(unidadAtacada)
		unidadAtacada.combatir(unidad)
		unidad.cambiarSprite(deseleccion)
		turnoManager.yaAtaco(unidad)
		estadoSeleccion = estadoVacio
		self.descaptarEnemigosCercanos()
		self.borrarRango()
		unidad = null		
	}
	
	method usarHabilidadEspecial() {
		self.verificarHabilidadEspecialDisponible()
		estadoEspecial.accion(self)
	}
	
	method captarEnemigosCercanos() {
		enemigosAtacables = self.posicionesAmenazantes()
		enemigosAtacables.forEach{enemigo => game.addVisual(new Visual(image="atacable.png", position = enemigo.position()))}
	}
	method descaptarEnemigosCercanos() {
		var espadasDeAtaque = []
		enemigosAtacables.forEach{
			enemigo => espadasDeAtaque.add(
				game.getObjectsIn(enemigo.position()).filter{obj => obj.image() == "atacable.png"}.head()
			)
		}
		enemigosAtacables.clear()
		espadasDeAtaque.forEach{espada => game.removeVisual(espada)}
	}
	method posicionesAmenazantes() {
		var posicionesCerca = [position.right(1),position.left(1),position.up(1),position.down(1)]
		var enemigos = []
		posicionesCerca.filter{pos => self.hayEnemigoEn(pos)}.forEach{
			pos =>
			enemigos.add(self.unidadEn(pos))
		}
		return enemigos
	}
	method hayEnemigoEn(pos) = self.unidadEn(pos) != null and !turnoManager.esDelJugadorActual(self.unidadEn(pos))
	method noHayEnemigosCerca() = enemigosAtacables.isEmpty()
	
	method mostrarRango(rango, marca){
		var casillasAMarcar = mapManager.getInternas().filter { 
			casilla =>
			distancia.distanciaEntre(casilla.position(), unidad.position()) <= rango
		}
		casillasAMarcar.forEach { casilla =>
			var visual = new Visual(image = marca, position = casilla.position())
			rangoMarcadoPorUnidad.add(visual)
			game.addVisual(visual)
		}
	}
	method borrarRango() = rangoMarcadoPorUnidad.forEach { visual => 
		game.removeVisual(visual)
		rangoMarcadoPorUnidad.remove(visual)
	}
	method enRangoEspecial() = !rangoMarcadoPorUnidad.filter{visual => visual.position() == self.position()}.isEmpty()
	
	method unidadEn(posicion) { 
		var lista = game.getObjectsIn(posicion).filter({objeto => objeto.esSeleccionable()})
		return if(lista.size() > 0) lista.head() else null
	}
	
	method esCasillaOcupable() = self.unidadEn(position) == null and mapManager.estaEnInternas(position)


	method esSeleccionable() = false
	
	// Chequeo de errores
	method verificarLaUnidadPuedaAtacar() {
		if ( unidad == null ) 
			self.error(error.msgSinUnidadSeleccionada())
		if ( !enemigosAtacables.map{enemigo => enemigo.position()}.contains(position) or !turnoManager.puedeAtacar(unidad) )
			unidad.error(error.msgAtaqueInvalido())
	}
	
	method verificarHabilidadEspecialDisponible() {
		if ( unidad == null ) 
			self.error(error.msgSinUnidadSeleccionada())
		if (!unidad.habilidadEspecialDisponible())
			unidad.error(error.msgEspecialEnCooldown())
	}
}

