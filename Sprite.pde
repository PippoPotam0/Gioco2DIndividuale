/**
Classe per la gestione di uno sprite.
*/
class Sprite {
  PImage texture;
  int width;
  int height;
  PVector position;
  
  /**
  Crea un nuovo oggetto Sprite.
  - path: percorso della risorsa.
  - width: larghezza dello sprite.
  - height: altezza dello sprite.
  */
  Sprite(String path, int width, int height) {
    this.width = width;
    this.height = height; 
    position = new PVector();
    texture = loadImage(path);
  }
  
  void changeImage(String newPath) {
    texture = loadImage(newPath);
  }
   
  /**
  Disegna lo sprite.
  */  
  void draw() {
    image(texture, position.x, position.y, width, height);  
  }
}
