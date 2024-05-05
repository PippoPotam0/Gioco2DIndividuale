class Combat {
  Player[] players;
  Enemy[] enemies;
  float random;
  int randomPlayer;
  int currentPlayerIndex;
  Timer timer = new Timer(500);
  Timer timer2 = new Timer(1900);
  Timer timer3 = new Timer(1500);
  boolean isAttacking = false;
  float attackStartX;
  float attackSpeed = 10.0;
  Player tempPlayer;
  Enemy tempEnemy;
  boolean hasArrived = false;
  boolean enemyTurn = false;
  boolean hasPlayedHitSound;
  Sound battle;
  Sound hit;
  Sound win;
  Sound lose;
  int winGame = 0;
  int loseGame = 0;

  Combat(Player[] players, Enemy[] enemies, Sound battle, Sound hit, Sound win, Sound lose) {
    this.players = players;
    this.enemies = enemies;
    random = random(-5, 2);
    currentPlayerIndex = 0;
    isAttacking = false;
    tempPlayer = players[0];
    this.battle = battle;
    this.hit = hit;
    this.win = win;
    this.lose = lose;
  }

  Player getCurrentPlayer() {
    return players[currentPlayerIndex];
  }


  void nextPlayer() {
    do {
      currentPlayerIndex++;
      if (currentPlayerIndex >= players.length) {
        enemyTurn = true;
        currentPlayerIndex = 0;
      }
    } while (this.getCurrentPlayer().death);
  }


  void attack(Enemy enemy) {
    if (!enemy.death) {
      int dmg = this.getCurrentPlayer().damage;
      dmg += random;
      enemy.health -= dmg;
      if (enemy.health<=0) {
        enemy.health=0;
        enemy.death = true;
        enemy.deathImage();
      }
      endGame();
      nextPlayer();
    }
    
  }

  void enemyAttack(Enemy enemy) {
    if (!enemy.death) {
      Player targetPlayer = null;
      boolean anyPlayerAlive = false;
      for (Player player : players) {
        if (!player.death) {
          anyPlayerAlive = true;
          break;
        }
      }

      if (anyPlayerAlive) {
        do {
          println("sceglie il player");
          randomPlayer = (int) random(0, players.length);
          targetPlayer = players[randomPlayer];
        } while (targetPlayer.death);
      } else {
        return;
      }
      targetPlayer.health -= (enemy.damage + random);
      println("attacca");
      if (targetPlayer.health <= 0) {
        targetPlayer.health = 0;
        targetPlayer.death = true;
        targetPlayer.deathImage();
      }
    }
    endGame();
  }
  
  void movePlayer() {
    if (isAttacking) {
      tempPlayer.walkImage();
      float newX = tempPlayer.position.x - attackSpeed;
      if (newX == attackStartX - 250) {
        hasArrived = true;
        if(!tempPlayer.death){
          tempPlayer.attackImage();
        }
        if (hasArrived) {
          if(!hasPlayedHitSound){
            attack(tempEnemy);
            hit.play();
          }
          hasPlayedHitSound = true;
          timer.update();
          if (timer.tick()) {
            tempPlayer.position.x = attackStartX;
            isAttacking = false;
            if(!tempPlayer.death)
              tempPlayer.idleImage();
            timer.reset();
          }
        }
      } else {
          tempPlayer.position.x = newX;
      }
    }
  }
  
  void enemyTurn() {
    if (enemyTurn) {
      println("turno nemici");
        timer3.update();
        if (timer3.tick()) {
          println("attacca animazione");
          for (Enemy e : enemies) {
            if (!e.death)
              e.attackImage();
          }
          timer3.reset();
        }
        timer2.update();
        if (timer2.tick()) {
          for (Enemy e : enemies) {
             enemyAttack(e);
             if (!e.death)
             e.idleImage();
          }
          enemyTurn = false;
          timer2.reset();
      }
    }
  }
  
  void endGame(){
    winGame = 0;
    loseGame = 0;
    for(Player p : players){
      if(p.death){
        
        loseGame ++;
        println("nemici morti" + loseGame);
        
      }
    }
   for(Enemy e : enemies){
      if(e.death){
        winGame ++;
      }
    }
  }
  
  void itemDamage(Enemy enemy, int itemNumber){
    if(!enemy.death && this.getCurrentPlayer().items.get(itemNumber).quantity > 0){
      enemy.health -= this.getCurrentPlayer().items.get(itemNumber).damage;
      if(enemy.health <= 0){
        enemy.health = 0;
        enemy.death=true;
        enemy.deathImage();
      }
      
      this.getCurrentPlayer().items.get(itemNumber).quantity--;
      nextPlayer();
      endGame();
    }
  }
  
  void greatHeal(int itemNumber){ 
    if(this.getCurrentPlayer().items.get(itemNumber).quantity > 0){
      this.getCurrentPlayer().health = this.getCurrentPlayer().maxHealth;
      
      this.getCurrentPlayer().items.get(itemNumber).quantity--;
      nextPlayer();
      endGame();
    }
  }
  
  void minorHeal(int itemNumber){
    if(this.getCurrentPlayer().items.get(itemNumber).quantity > 0){
      this.getCurrentPlayer().health +=  this.getCurrentPlayer().items.get(itemNumber).damage;
      if(this.getCurrentPlayer().health > this.getCurrentPlayer().maxHealth){
        this.getCurrentPlayer().health = this.getCurrentPlayer().maxHealth;
      }
      
      this.getCurrentPlayer().items.get(itemNumber).quantity--;
      nextPlayer();
      endGame();
    }
  }
  
  void bothHeal(int itemNumber){
    if(this.getCurrentPlayer().items.get(itemNumber).quantity > 0){
      this.getCurrentPlayer().maxHealth += this.getCurrentPlayer().items.get(itemNumber).damage;
      this.getCurrentPlayer().health += this.getCurrentPlayer().items.get(itemNumber).damage;
      
      this.getCurrentPlayer().items.get(itemNumber).quantity--;
      nextPlayer();
      endGame();
    }
  }
  
  void magicDamage(Enemy enemy, int magicNumber){
    if(!enemy.death && this.getCurrentPlayer().magics.get(magicNumber).available){
      enemy.health -= this.getCurrentPlayer().magics.get(magicNumber).damage;
      if(enemy.health <= 0){
        enemy.health = 0;
        enemy.death=true;
        enemy.deathImage();
      }
      this.getCurrentPlayer().magics.get(magicNumber).available = false;
      nextPlayer();
      endGame();
    }
  }
  
  void magicGroupHeal(int magicNumber){
    if(this.getCurrentPlayer().magics.get(magicNumber).available){
     for(Player p : this.players) {
       if(!p.death)
         p.health += this.getCurrentPlayer().magics.get(magicNumber).damage;
       if(p.health > p.maxHealth){
        p.health = p.maxHealth;
        }
      }
      this.getCurrentPlayer().magics.get(magicNumber).available = false;
      nextPlayer();
      endGame();
    }
  }
  
  void magicHeal(Player player, int magicNumber){
    if(!player.death && this.getCurrentPlayer().magics.get(magicNumber).available){
     player.health +=  this.getCurrentPlayer().magics.get(magicNumber).damage;
      if(player.health > player.maxHealth){
        player.health = player.maxHealth;
      }
      this.getCurrentPlayer().magics.get(magicNumber).available = false;
      nextPlayer();
      endGame();
    }
  }

  
  
  
  
  
}
