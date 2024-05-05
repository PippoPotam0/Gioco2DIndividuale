class Enemy extends Sprite {
  String name;
  int damage;
  int health;
  int maxHealth;
  boolean death;
  int number;
  
  Enemy(String path, int width, int height, String name, int damage, int maxHealth, int number){
     super(path, width, height);
     this.name = name;
     this.damage = damage;
     this.maxHealth = maxHealth;
     this.health = maxHealth;
     this.number = number;
     this.death = false;
  }
  
  void setMaxHealth(int value){
    this.maxHealth = value;
     this.health = value;
  }
  
  void idleImage(){
    super.changeImage(ENEMIES_IDLE[number]);
  }
  
  void attackImage(){
    super.changeImage(ENEMIES_ATTACK[number]);
  }
  
  void deathImage(){
    super.changeImage(ENEMIES_DEATH[number]);
  }
  
  void update(){
  }
}
