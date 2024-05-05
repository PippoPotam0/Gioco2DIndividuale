class Player extends Sprite {
  String name;
  String path;
  int maxHealth;
  int health;
  int damage;
  ArrayList<Magic> magics = new ArrayList<Magic>();
  ArrayList<Item> items = new ArrayList<Item>();
  int number;
  boolean death;
  
  Player(String path, int width, int height, String name, int maxHealth, int damage, int number) {
     super(path, width, height);
     this.name = name;
     this.maxHealth = maxHealth;
     this.health = maxHealth;
     this.damage = damage;
     this.number = number;
     this.death = false;
  }
  
  void setMaxHealth(int value){
    this.maxHealth = value;
     this.health = value;
  }
  
  void addMagic(Magic magic){
    magics.add(magic);
  }
  
  void addItem(Item item){
    items.add(item);
  }
  
  void idleImage(){
    super.changeImage(PLAYERS_IDLE[number]);
  }
  
  void attackImage(){
    super.changeImage(PLAYERS_ATTACK[number]);
  }
  
  void deathImage(){
    super.changeImage(PLAYERS_DEATH[number]);
  }
  
  void walkImage(){
    super.changeImage(PLAYERS_WALK[number]);
  }
  
  void update() {

  }
}
