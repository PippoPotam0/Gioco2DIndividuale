class HUD extends Sprite {
  Player[] players;
  Enemy[] enemies;
  PFont font;
  int textSize;
  int firstClick = 0;
  PImage originalTexture;
  String[] displayedTexts;
  Combat combat;
  int ctrl = 0;
  int bagSelection = 0;
  boolean playerSelection = false;
  boolean showDescription = false;
  boolean enemySelection = false;
  boolean soundActive = true;
  Timer timerEnd = new Timer(5000);

  HUD(String path, int width, int height, String pathFont, Player[] players, Enemy[] enemies, Combat combat) {
    super(path, width, height);
    font = createFont(pathFont, 15);
    this.players = players;
    this.enemies = enemies;
    originalTexture = texture;
    displayedTexts = new String[players.length + enemies.length];
    this.combat = combat;
  }

  void draw() {
    super.draw();
    textFont(font);
    fill(255);

    if(firstClick==0){
      for (int i = 0; i < players.length; i++) {
        Player player = players[i];
        String text = player.name + ": " + player.health + "/" + player.maxHealth;
        text(text, 830, 580 + (i*50));
        
        if (player == this.combat.getCurrentPlayer()) {
          drawTriangle(810, 575 + (i * 50));
        }
        displayedTexts[i] = text;
      }
  
      for (int i = 0; i < enemies.length; i++) {
        Enemy enemy = enemies[i];
        String text = enemy.name + ": " + enemy.health + "/" + enemy.maxHealth;
        text(text, 370, 580 + (i*50) + (players.length + i));
        displayedTexts[players.length + i] = text;
      } 
    } else if(firstClick==1){
        int i=0;
        ArrayList<Item> items = this.combat.getCurrentPlayer().items;
        for (Item item : items) {
        String itemInfo = "- " + item.name + " x" + item.quantity;
        text(itemInfo, 350, 580 + (i*50));
        i++;
      }
    } else if(firstClick==2){
      int i=0;
      ArrayList<Magic> magics = this.combat.getCurrentPlayer().magics;
      for (Magic magic : magics) {
      String magicInfo = "- " + magic.name;
      if(magic.available){
        text("Disponibile", 750, 580 + (i*50));
      } else {
        text("Già utilizzata", 750, 580 + (i*50));
      }
      text(magicInfo, 370, 580 + (i*50));
      i++;
      }
    } 
    
    if(firstClick==1 && bagSelection >= 0 && bagSelection < this.combat.getCurrentPlayer().items.size()){
      if(showDescription){
        drawWrappedText(this.combat.getCurrentPlayer().items.get(bagSelection).description, 1015, 560, 200, 40);
      }else {
        drawWrappedText("tasto destro sull'elemento della bag", 1015, 560, 200, 40);
      }
    } else if(firstClick==2 && bagSelection >= 0 && bagSelection < this.combat.getCurrentPlayer().magics.size()){
      if(showDescription){
        drawWrappedText(this.combat.getCurrentPlayer().magics.get(bagSelection).description, 1015, 560, 200, 40);
      } else{
        drawWrappedText("tasto destro sull'elemento della bag", 1015, 560, 200, 40);
      }
    }
    
    if(enemySelection){
      drawWrappedText("*Per selezionare un nemico e un membro del party cliccare sulla sua figura", 100, 30, 10000, 1);
    }
    
    if(combat.loseGame == players.length){
      hud.firstClick = 3;
      hud.changeImage(ASSET_HUDEND);
      text("HAI PERSO!", 600, 350);
      timerEnd.update();
      battle.stop();
      if(soundActive) {
        lose.play();
        soundActive = false;
      }
      if(timerEnd.tick()){
        timerEnd.reset();
        exit();
      }
      
    } else if(combat.winGame == enemies.length){
      hud.firstClick = 3;
      hud.changeImage(ASSET_HUDEND);
      text("HAI VINTO!", 600, 350);
      timerEnd.update();
      battle.stop();
      if(soundActive) {
        win.play();
        soundActive = false;
      }
      if(timerEnd.tick()){
        timerEnd.reset();
        exit();
      }
    }
    
  }

  void mousePressed() {
    if(!combat.isAttacking && !combat.enemyTurn){
    if (mouseButton == LEFT && mouseX >= 180 && mouseX <= 297 && mouseY >= 630 && mouseY <= 650) {
      if (firstClick != 1) {
        changeImage(ASSET_HUD2);
        firstClick = 1;
        stroke(255);
        line(187, 655, 292, 655);
      }
    } else if (mouseButton == LEFT && mouseX >= 180 && mouseX <= 297 && mouseY >= 675 && mouseY <= 700) {
      if (firstClick != 2) {
        changeImage(ASSET_HUD2);
        firstClick = 2;
        stroke(255);
        line(187, 705, 292, 705);
      }
    } else if (mouseButton == LEFT && mouseX >= 180 && mouseX <= 297 && mouseY >= 580 && mouseY <= 600) {
      if (firstClick != 0) {
        restoreOriginalImage();
        firstClick = 0;
        stroke(255);
        line(187, 605, 292, 605);
      }
    }
    
    if(firstClick == 0){
      if (mouseButton == LEFT && mouseX >= 370 && mouseX <= 600) {
        for (int i = 0; i < enemies.length; i++) {
          if (mouseY >= 550 + (i * 50) && mouseY <= 600 + (i * 50)) {
            stroke(255);
            line(370, 600 + (i * 50), 600, 600 + (i * 50));
            if(!enemies[i].death && !this.combat.getCurrentPlayer().death){
              combat.tempEnemy = enemies[i];
              combat.tempPlayer = this.combat.getCurrentPlayer();
              combat.isAttacking = true;
              combat.hasPlayedHitSound = false;
              combat.attackStartX = this.combat.getCurrentPlayer().position.x;
            } else if(this.combat.getCurrentPlayer().death){
              this.combat.nextPlayer();
            }
          }
        }
      }
    } else if(firstClick == 1){
      if (mouseButton == LEFT && mouseX >= 370 && mouseX <= 600) {
        for (int i = 0; i < this.combat.getCurrentPlayer().items.size(); i++) {
          if (mouseY >= 550 + (i * 50) && mouseY <= 600 + (i * 50)) {
            bagSelection = i;
            playerSelection = true;
            stroke(255);
            line(370, 600 + (i * 50), 600, 600 + (i * 50));
          }
        }
      } else if (mouseButton == RIGHT && mouseX >= 370 && mouseX <= 600) {
        for (int i = 0; i < this.combat.getCurrentPlayer().items.size(); i++) {
          if (mouseY >= 550 + (i * 50) && mouseY <= 600 + (i * 50)) {
            showDescription = true;
            bagSelection = i;
          }
        }
      }
      if(playerSelection == true){
        if(this.combat.getCurrentPlayer().items.get(bagSelection) instanceof ItemDagger){
          enemySelection = true;
          if(mouseButton == LEFT && mouseX >= 400 && mouseX <= 490){
            for (int i = 0; i < enemies.length; i++) {
              if (mouseY >= 200+(i*90) && mouseY <= 290+(i*90)) {
                if(this.combat.getCurrentPlayer().items.get(bagSelection).quantity > 0){
                  this.combat.itemDamage(enemies[i], bagSelection);
                  restoreOriginalImage();
                  firstClick = 0;
                  playerSelection = false;
                  enemySelection = false;
                  showDescription = false;
                }
              }
            }
          }
        } else if(!(this.combat.getCurrentPlayer().items.get(bagSelection) instanceof ItemDagger)){
          if(this.combat.getCurrentPlayer().items.get(bagSelection) instanceof ItemGreatPotion){
            if(mouseButton == LEFT && mouseX >= 370 && mouseX <= 600 && mouseY >= 550 + (bagSelection * 50) && mouseY <= 600 + (bagSelection * 50)){
              if(this.combat.getCurrentPlayer().items.get(bagSelection).quantity > 0){
              this.combat.greatHeal(bagSelection);
              restoreOriginalImage();
              firstClick = 0;
              playerSelection = false;
              showDescription = false;
              }
            }
          } 
          else if(this.combat.getCurrentPlayer().items.get(bagSelection) instanceof ItemMinorPotion){
            if(mouseButton == LEFT && mouseX >= 370 && mouseX <= 600 && mouseY >= 550 + (bagSelection * 50) && mouseY <= 600 + (bagSelection * 50)){
              if(this.combat.getCurrentPlayer().items.get(bagSelection).quantity > 0){
              this.combat.minorHeal(bagSelection);
              restoreOriginalImage();
              firstClick = 0;
              playerSelection = false;
              showDescription = false;
              }
            }
          } else if(this.combat.getCurrentPlayer().items.get(bagSelection) instanceof ItemPotionOfHealing){
            if(mouseButton == LEFT && mouseX >= 370 && mouseX <= 600 && mouseY >= 550 + (bagSelection * 50) && mouseY <= 600 + (bagSelection * 50)){
              if(this.combat.getCurrentPlayer().items.get(bagSelection).quantity > 0){
              this.combat.bothHeal(bagSelection);
              restoreOriginalImage();
              firstClick = 0;
              playerSelection = false;
              showDescription = false;
              }
            }
          }
        }
      }
    } else if(firstClick == 2){
      if (mouseButton == LEFT && mouseX >= 370 && mouseX <= 600) {
        for (int i = 0; i < this.combat.getCurrentPlayer().magics.size(); i++) {
          if (mouseY >= 550 + (i * 50) && mouseY <= 600 + (i * 50)) {
            bagSelection = i;
            playerSelection = true;
            stroke(255);
            line(370, 600 + (i * 50), 600, 600 + (i * 50));
          }
        }
      } else if (mouseButton == RIGHT && mouseX >= 370 && mouseX <= 600) {
        for (int i = 0; i < this.combat.getCurrentPlayer().magics.size(); i++) {
          if (mouseY >= 550 + (i * 50) && mouseY <= 600 + (i * 50)) {
            showDescription = true;
            bagSelection = i;
          }
        }
      }
      if(playerSelection == true){
        if(this.combat.getCurrentPlayer().magics.get(bagSelection) instanceof MagicFireBall){
          enemySelection = true;
          if(mouseButton == LEFT && mouseX >= 400 && mouseX <= 490){
            for (int i = 0; i < enemies.length; i++) {
              if (mouseY >= 200+(i*90) && mouseY <= 290+(i*90)) {
                if(this.combat.getCurrentPlayer().magics.get(bagSelection).available == true){
                  this.combat.magicDamage(enemies[i], bagSelection);
                  restoreOriginalImage();
                  firstClick = 0;
                  playerSelection = false;
                  enemySelection = false;
                  showDescription = false;
                }
              }
            }
          }
        } else if(!(this.combat.getCurrentPlayer().magics.get(bagSelection) instanceof MagicFireBall)){
            if(this.combat.getCurrentPlayer().magics.get(bagSelection) instanceof MagicHeal){
              enemySelection = true;
              if(mouseButton == LEFT && mouseX >= 720 && mouseX <= 810){
                for (int i = 0; i < players.length; i++) {
                  if (mouseY >= 150+(i*90) && mouseY <= 240+(i*90)) {
                    if(this.combat.getCurrentPlayer().magics.get(bagSelection).available == true){
                      this.combat.magicHeal(players[i], bagSelection);
                      restoreOriginalImage();
                      firstClick = 0;
                      playerSelection = false;
                      enemySelection = false;
                      showDescription = false;
                    }
                  }
                }
              }
            } else if(this.combat.getCurrentPlayer().magics.get(bagSelection) instanceof MagicGroupHeal){
              if(mouseButton == LEFT && mouseX >= 370 && mouseX <= 600 && mouseY >= 550 + (bagSelection * 50) && mouseY <= 600 + (bagSelection * 50)){
                if(this.combat.getCurrentPlayer().magics.get(bagSelection).available == true){
                  this.combat.magicGroupHeal(bagSelection);
                  restoreOriginalImage();
                  firstClick = 0;
                  playerSelection = false;
                  showDescription = false;
                }
              }
            }
          }
        }
      }
    }
  }

  void restoreOriginalImage() {
    texture = originalTexture;
  }
  
  void drawWrappedText(String text, float x, float y, float maxWidth, float lineHeight) {
    String[] parole = split(text, ' ');
    String riga = "";
    
    for (String parola : parole) {
        String tentativoRiga = riga + parola + " ";
        float larghezzaRiga = textWidth(tentativoRiga);
        
        if (larghezzaRiga < maxWidth) {
            riga = tentativoRiga;
        } else {
            text(riga, x, y);
            y += lineHeight;
            riga = parola + " ";
        }
    }
    if (!riga.equals("")) {
        text(riga, x, y);
    }
  }
  
  void drawTriangle(float x, float y) {
    float triangleSize = 8;
    float triangleHeight = triangleSize * sqrt(3) / 2;
    fill(255);
    beginShape();
    vertex(x + triangleHeight / 2, y);
    vertex(x - triangleHeight / 2, y - triangleSize);
    vertex(x - triangleHeight / 2, y + triangleSize);
    endShape(CLOSE);
  }
}
