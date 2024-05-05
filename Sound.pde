import processing.sound.*;

/**
Classe per la gestione di un suono.
*/
class Sound extends SoundFile {
  /**
  Crea un nuovo oggetto Sound.
  - parent: componente parent del suono.
  - path: percorso della risorsa.
  */  
  Sound(PApplet parent, String path) {
    super(parent, path);
  }
}
