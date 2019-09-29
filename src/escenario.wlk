import wollok.game.*
import cursor.*
import comandantes.*
import unidades.*

object escenario {

	method configurar() {
		// CONFIGURACIÓN DEL JUEGO
		game.title("Langradigmas")
		game.height(17)
		game.width(31)
		//game.ground("original.gif")
		//game.boardGround("algo.gif")
		movimiento.configurarFlechas(cursor)

		
		keyboard.s().onPressDo { cursor.seleccionar() }	
		keyboard.a().onPressDo { cursor.atacar() }	
		keyboard.d().onPressDo { cursor.atacarEspecial() }
		
			
		// Pruebas
		var comandanteBueno = new Comandante(position = game.at(0,8), image = "comandanteBueno.png")
		game.addVisual(comandanteBueno)	
		var unArqueroBueno = new Arquero(position = game.at(1,9), image = "arqueroBueno.png", comandante = comandanteBueno)
		game.addVisual(unArqueroBueno)
		var otroArqueroBueno = new Arquero(position = game.at(1,7), image = "arqueroBueno.png", comandante = comandanteBueno)
		game.addVisual(otroArqueroBueno)
		
		var comandanteMalo = new Comandante(position = game.at(game.width()-1,8), image = "comandanteMalo.png")
		game.addVisual(comandanteMalo)	
		var unCaballeroMalo = new Arquero(position = game.at(game.width()-2,9), image = "ejemplo.png", comandante = comandanteBueno)
		game.addVisual(unCaballeroMalo)		
		var unSoldadoMalo = new Arquero(position = game.at(game.width()-2,7), image = "soldier.png", comandante = comandanteBueno)
		game.addVisual(unSoldadoMalo)		
		
		
		
		
		game.addVisual(cursor)
	}
	
}


