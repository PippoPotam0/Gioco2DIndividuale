/**
Classe per la gestione di un timer.
*/
class Timer {
  int delay;
  int elapsed;
  int incr;
  
  /**
  Crea un nuovo oggetto Timer.
  - delay: tempo di attesa (millisecondi).
  */
  Timer(int delay) {
    this.delay = delay;
    elapsed = 0;
    incr = 1000 / FRAME_RATE;
  }

  /**
  Reimposta il timer.
  */
  void reset() {
    elapsed = 0;
  }

  /**
  Aggiorna il timer.
  */
  void update() {
    if (elapsed < delay) {
      elapsed += incr;
    }
  }

  /**
  Verifica il tick del timer.
  - ritorna true se il timer ha eseguito un tick, altrimenti false.
  */
  boolean tick() {
    if (elapsed >= delay) {
      elapsed = 0;
      return true;
    }
    return false;
  }
}
