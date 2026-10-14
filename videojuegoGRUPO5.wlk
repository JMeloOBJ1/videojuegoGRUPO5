import wollok.game.*

// =====================================================================
//  ALUMNO: PERSONAJE PRINCIPAL
// =====================================================================
object alumno {
    const vidasRestantes = salud
    var property position = game.at(4,0)
	
	method descontarVida(){
		vidasRestantes.perderUnaVida()
	}
   
	method serAtropellado() {
		if (not self.estaMuerto()) {
			self.descontarVida()
			
			self.volverAlInicio()
			self.fueDerrotado()
		}
		
	}
	method fueDerrotado(){
		if(self.estaMuerto()){
			self.anunciarDerrota()
		}
	}

	method anunciarDerrota() {
		   game.say(self, "me morí") 
	}

	method volverAlInicio() { position = game.at(4,0) }

	method estaMuerto() {
		return !vidasRestantes.hayVidas()
	}

	method mover(direccion) {
		position = direccion.siguiente(position)
	  
	}
	method image() = "estudiante_" + vidasRestantes.cuantasVidasHay() + "vida.png"
	
	//interacciones con colisiones:
	method interactuar(algo){
		algo.interaccion(self)
	}
}

// =====================================================================
//  VIDAS DEL PERSONAJE PRINCIPAL
// =====================================================================
class Vida{
	var property position
	const nombre
	const cantidadDeVidas
	var aspecto = conVida
	
	method cantidadDeVidas() = cantidadDeVidas
	
	method image() = aspecto.nombreDeVida(nombre) + "_vida.png"
	
	method marcarComoPerdida(){
		aspecto = sinVida
	}
	
	method marcarComoRecuperada(){
		aspecto = conVida
	}
	
	method estaPerdida() = aspecto.estaPerdida()
}
object salud {
	//Es en orden descendente, es decir, de la vida mas alta (3) hasta la mas baja (1)
	const vidas = [
        new Vida(position = game.at(9,0), nombre = "tercera",   cantidadDeVidas = 3),
        new Vida(position = game.at(8,0), nombre = "segunda",   cantidadDeVidas = 2),
		new Vida(position = game.at(7,0), nombre = "primera",   cantidadDeVidas = 1)
    ]

    method iniciar() {
        vidas.forEach({ vida => game.addVisual(vida) })
    }

	method cuantasVidasHay() = 
		if (self.hayVidas()) {self.encontrarVidaNoPerdida().cantidadDeVidas()}
		else { 0 }
	method hayVidas() = vidas.any({vida => !vida.estaPerdida()})
	method encontrarVidaNoPerdida() = vidas.find({vida => !vida.estaPerdida()})
	
	method perderUnaVida(){
		if(self.hayVidas()){
			self.encontrarVidaNoPerdida().marcarComoPerdida()
		}
	}
	
	method ganarUnaVida(){
		self.validarGanarVida()
		self.encontrarVidaPerdida().marcarComoRecuperada()
	}
	method validarGanarVida(){
		if(!self.hayAlgunaVidaPerdida()){
			self.error("Tengo las vidas llenas")
		}
	}
	method hayAlgunaVidaPerdida() = vidas.any({vida => vida.estaPerdida()})
	method encontrarVidaPerdida() = vidas.filter({vida => vida.estaPerdida()}).last()
}

//Objetos de tipo estadoDeVida que son usados por salud
object sinVida{
	method nombreDeVida(nombre) = "sin"
	
	method estaPerdida() = true
}

object conVida{
	method nombreDeVida(nombre) = nombre
	
	method estaPerdida() = false
}


// =====================================================================
//  ESTADOS/ASPECTOS DEL PERSONAJE PRINCIPAL
// =====================================================================
//salud se encargan por el momento de representar el estado del alumno
/*object alumnoSano{
	method nombre() = "3vidas"
	
	method siguienteEtapa() = alumnoLastimado
}
object alumnoLastimado{
	method nombre() = "2vidas"
	
	method siguienteEtapa() = alumnoMalherido
}
object alumnoMalherido{
	method nombre() = "1vida"
	
	method siguienteEtapa() = alumnoFallecido
}

object alumnoFallecido{
	method nombre() = "0vida"
	
	method siguienteEtapa() = self
}*/

// =====================================================================
//  DIRECCIONES del PERSONAJE PRINCIPAL
// =====================================================================
object izquierda {

    method siguiente(posicion) {
        self.validarSiguiente(posicion)
        return posicion.left(1)
    }
    method validarSiguiente(posicion) {
        if (not self.puedeAvanzar(posicion)) {
            self.error('No se puede mover a la izquierda')
        }
    }
	
	method puedeAvanzar(posicion) = posicion.x() > 0
	
	method primeraCelda() = game.width() - 1
}
object derecha {
    method siguiente(posicion) {
        self.validarSiguiente(posicion)
        return posicion.right(1)
    }
    method validarSiguiente(posicion) {
        if (not self.puedeAvanzar(posicion)) {
            self.error('No se puede mover a la derecha')
        }
    }
	
	method puedeAvanzar(posicion) = posicion.x() < game.width() - 1
	
	method primeraCelda() = 0
}
object arriba {
    method siguiente(posicion) {
        self.validarSiguiente(posicion)
        return posicion.up(1)
    }
    method validarSiguiente(posicion) {
        if(posicion.y() == game.height() - 1 ) {
            self.error('No se puede mover hacia arriba')
        }
    }
}
object abajo {
    method siguiente(posicion) {
        self.validarSiguiente(posicion)
        return posicion.down(1)
    }
        method validarSiguiente(posicion) {
        if(posicion.y() == 0 ) {
            self.error('No se puede mover hacia abajo')
        }
    }
}

// =====================================================================
//  VEHICULO: Obstaculo para el PERSONAJE PRINCIPAL
// =====================================================================
class Vehiculo {
    const posicionInicial
    const direccion
    const intervaloEnMs
    var property position = posicionInicial

    method image() = "auto.png"

    method empezarARecorrer() {
        const tick = game.tick(intervaloEnMs, { self.avanzar() }, false)
        tick.start()
    }

    method avanzar() {
        if (direccion.puedeAvanzar(position)) {
            position = direccion.siguiente(position)
        } else {
            position = posicionInicial
        }
    }
	
	method interaccion(algo){
		algo.serAtropellado()
	}
}

class Carril {
    const fila
    const direccion
    const intervaloEnMs

    method arrancar() {
        const vehiculo = new Vehiculo(
            posicionInicial = game.at(direccion.primeraCelda(), fila),
            direccion = direccion,
            intervaloEnMs = intervaloEnMs
        )
        game.addVisual(vehiculo)
        vehiculo.empezarARecorrer()
    }
}

object autopista {
    const carriles = [
        new Carril(fila = 2, direccion = derecha,   intervaloEnMs = 800),
        new Carril(fila = 3, direccion = derecha,   intervaloEnMs = 400),
        new Carril(fila = 4, direccion = derecha,   intervaloEnMs = 900),
        new Carril(fila = 5, direccion = izquierda, intervaloEnMs = 300),
        new Carril(fila = 6, direccion = izquierda, intervaloEnMs = 600),
        new Carril(fila = 7, direccion = izquierda, intervaloEnMs = 500)
    ]

    method arrancar() {
        carriles.forEach({ carril => carril.arrancar() })
    }
}

// =====================================================================
// COMIDAS: Dara mecanicas al juego, ademas para cargar vidas
// =====================================================================
class Comida{
	const vidasQueRecupera 
	
	method interaccion(algo){
		algo.serAtropellado()
	}
}


// =====================================================================
//  META: FINAL DEL JUEGO
// =====================================================================
object unq {
    var property position = game.at(4,9) 

	method image () = "AccesoUNQ.jpg" 
}

//tick(intervalo, acción, ejecutarInmediatamente)
//Devuelve un objeto tick que se utilizará para la ejecución de una acción durante un intervalo de tiempo.
//El intervalo está en milisegundos y la acción es un bloque sin parámetros.

//onTick(milisegundos, nombre, acción)
//Agrega un bloque con un nombre específico que se ejecutará cada n milisegundos.
//El bloque no espera ningún argumento.Ten cuidado de no configurarlo con demasiada frecuencia :)