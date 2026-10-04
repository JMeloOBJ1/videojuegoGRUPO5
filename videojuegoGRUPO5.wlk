import wollok.game.*


//direcciones
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

object alumno {
    var vidaRestante = terceraVida
    var property position = game.at(4,0)
    var aspecto = alumnoSano
	
	method descontarVida(){
		vidaRestante.marcarComoPerdida()
		vidaRestante = vidaRestante.vidaInferior()
		aspecto = aspecto.siguienteEtapa()
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
		return vidaRestante.cantidadDeVidas() == 0
	}

	method mover(direccion) {
		position = direccion.siguiente(position)
	  
	}
	method image() = "estudiante_" + aspecto.nombre() + ".png"
}

object unq {
    var property position = game.at(4,9) 

	method image () = "AccesoUNQ.jpg" 
}
/*
object autoADerecha {
    var property position = game.at(0,2) 
	
	method posicionInicial() = game.at(0,2) 
	
	method empezarARecorrer() {
		game.onTick(800, "moverD", {self.autoMueveDerecha()})
	}
	method image () = "auto.png" 

	method autoMueveDerecha() {
		if (position.x() < 10){
			position = position.right(1)
		}else{
			position = self.posicionInicial()
		}
	}
}

object autoAIzquierda {
    var property position = game.at(9,5) 

	method posicionInicial() = game.at(9,5) 

	method empezarARecorrer() {
	  game.onTick(300, "moverI", {self.autoMueveIzquierda()})
	}
	method image () = "auto.png" 

	method autoMueveIzquierda() {
		if (position.x() > 0){
			position = position.left(1)
		}else{
			position = self.posicionInicial()
		}
	}
}*/



//=====Sector de Vida===
//
object primeraVida{
	var property position = game.at(7,0)
	var aspecto = self

	method cantidadDeVidas() = 1

	method image() = aspecto.nombre() + "_vida.png"
	method nombre() = "primera"

	method marcarComoPerdida(){
		aspecto = self.vidaInferior()
	}
	method vidaInferior() = sinVida	
}
object segundaVida{
	var property position = game.at(8,0)
	var aspecto = self

	method cantidadDeVidas() = 2

	method image() = aspecto.nombre() + "_vida.png"
	method nombre() = "segunda"
	
	method marcarComoPerdida(){
		aspecto = sinVida
	}
		
	method vidaInferior() = primeraVida
}
object terceraVida{
	var property position = game.at(9,0)
	var aspecto = self
	
	method cantidadDeVidas() = 3
	
	method image() = aspecto.nombre()+"_vida.png"
	method nombre() = "tercera"
	
	method marcarComoPerdida(){
		aspecto = sinVida
	}
	
	method vidaInferior() = segundaVida
}
object sinVida{
	method nombre() = "sin"
	
	method vidaInferior() = self
	
	method cantidadDeVidas() = 0
}
//=====Aca finaliza===
//


//=====Sector de alumno===
//
object alumnoSano{
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
}

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
}	