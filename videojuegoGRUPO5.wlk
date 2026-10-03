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
gi
object alumno {
    var vida = 3
    var position = game.at(0,4)
    var estado = alumnoBien 
}