import wollok.game.*
import distancia.*
import jugadores.*

object cursor {
	var jugadorActual = jugador1
	var unidad = null
	var property position = game.center()

	method image() = "cursorGood.png"

	method seleccionar() {
		if (unidad == null) {
			unidad = self.agarrarUnidadDeLaPosicionActual()
		} else {
			var distanciaEnMovimientos = new Distancia(position = unidad.position())
			
			if (self.esCasillaValida() && unidad.puedeLlegar(distanciaEnMovimientos.distanciaA(position))) {
				unidad.mover(position)
				game.say(unidad,"Me movi " + distanciaEnMovimientos.distanciaA(position).toString() + "casillas :)")
			} else { // este else es solo de testing
				game.say(unidad,"Está lejos o me quedé sin movimientos :(")
			}
			unidad = null
		}
	}
	
	method agarrarUnidadDeLaPosicionActual() { 
		var lista = game.getObjectsIn(self.position()).filter({objeto => objeto.esSeleccionable()})
		return if(lista.size() > 0) lista.head() else null
	}
	
	method esCasillaValida() = self.agarrarUnidadDeLaPosicionActual() == null //Acá poner los limites del mapa tmb

	method atacar() {}
	
	method atacarEspecial() {}

	method esSeleccionable() = false

}

object movimiento {

	method configurarFlechas(visual) {
		keyboard.up().onPressDo    { self.mover(arriba, visual)}
		keyboard.down().onPressDo  { self.mover(abajo, visual)}
		keyboard.left().onPressDo  { self.mover(izquierda, visual)}
		keyboard.right().onPressDo { self.mover(derecha, visual)}
		
//		NO DAR BOLA A ESTO, SOLO ESTOY BOLUDEANDO
//      var activado = false 
//		keyboard.shift().onPressDo{
//			keyboard.up().onPressDo{ 
//				if (!activado) {
//					activado = true; 
//					game.onTick(500, "movimiento", { self.mover(arriba, visual)})
//				} else {
//					activado = false;
//					game.removeTickEvent("movimiento");
//				}
//				
//			}
//		}
	}

	method mover(direccion, cursor) {
		cursor.position(direccion.siguiente(cursor.position()))
	}

}

object izquierda {

	method siguiente(position) = position.left(1)

}

object derecha {

	method siguiente(position) = position.right(1)

}

object abajo {

	method siguiente(position) = position.down(1)

}

object arriba {

	method siguiente(position) = position.up(1)

}

