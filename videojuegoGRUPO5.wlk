import wollok.game.*


//direcciones
object izquierda {

    method siguiente(posicion) {
        self.validarSiguiente(posicion)
        return posicion.left(1)
    }
    method validarSiguiente(posicion) {
        if(posicion.x() == 0) {
            self.error('No se puede mover a la izquierda')
        }
    }
}
object derecha {
    method siguiente(posicion) {
        self.validarSiguiente(posicion)
        return posicion.right(1)
    }
    method validarSiguiente(posicion) {
        if(posicion.x() == game.width() - 1 ) {
            self.error('No se puede mover a la derecha')
        }
    }
}
object arriba {
    method siguiente(posicion) {
        self.validarSiguiente(posicion)
        return posicion.up(1)
    }
    method validarSiguiente(posicion) {
        if(posicion.y() == game.height() - 1 ) {
            self.error('No se puede mover a la arriba')
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
            self.error('No se puede mover a la abajo')
        }
    }
}

object alumno {
    var property vida = 3
    var property position = game.at(4,0)
    //var estado = alumnoBien 
    
method colision() {
    vida = vida - 1
} 

method perderVida() {
    self.colision()
    position = game.at(4,0)
 
}
method perder() {
    if (self.meMori()){
       game.say(self, "me morí") 
    } 
}


method meMori() {
    return vida == 0
  
}












method mover(direccion) {
    position = direccion.siguiente(position)
  
}
method image() = "player.png"

//method image() = "m-player-normal.png" 
method text() {
    return "vida: " + vida
  
}




}

object unq {
    var property position = game.at(4,9) 

method image () = "AccesoUNQ.jpg" 
}

object autoADerecha {
    var property position = game.at(0,2) 

method moverDerecha() {
  game.onTick(800, "moverD", {self.autoMueveDerecha()})
}
method image () = "auto.png" 

method autoMueveDerecha() {
    if (position.x() < 10){
        position = position.right(1)
    }else{
        position = game.at(0,2)
    }
}
method perderVida() {
    alumno.perderVida()
} 
}

object autoAIzquierda {
    var property position = game.at(9,5) 

method moverIzquierda() {
  game.onTick(300, "moverI", {self.autoMueveIzquierda()})
}
method image () = "auto.png" 

method autoMueveIzquierda() {
    if (position.x() > 0){
        position = position.left(1)
    }else{
        position = game.at(9,5)
    }
}
method perderVida() {
    alumno.perderVida()
} 
}