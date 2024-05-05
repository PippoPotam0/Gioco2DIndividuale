Background background;
Player p[];
Enemy e[];
HUD hud;
Item dagger;
Item greatPotion;
Item minorPotion;
Item bothHealPotion;
Magic heal;
Magic fireBall;
Magic groupHeal;
Combat combat;
Sound battle;
Sound hit;
Sound win;
Sound lose;


void settings(){
  size(WIDTH, HEIGHT);
}

void setup() {
  background = new Background(BACKGROUND, WIDTH, HEIGHT);
  battle = new Sound(this, ASSET_BATTLE);
  hit = new Sound(this, ASSET_HIT);
  win = new Sound(this, ASSET_WIN);
  lose = new Sound(this, ASSET_LOSE);
  p = new Player[4];
  e = new Enemy[3];
  
  for(int i=0; i<p.length; i++){
    p[i] = new Player(PLAYERS_IDLE[i], 90, 90, "", 1, 1, i);
    p[i].position = new PVector(720, 150+(i*90));
  }
  p[0].name = "Thalia Ironheart";
  p[0].setMaxHealth(100);
  p[0].damage = 10;
  p[1].name = "Auron Evershade";
  p[1].setMaxHealth(50);
  p[1].damage = 18;
  p[2].name = "Elric Shadowthorn";
  p[2].setMaxHealth(70);
  p[2].damage = 13;
  p[3].name = "Lysa Stormgazer";
  p[3].setMaxHealth(90);
  p[3].damage = 12;
  
  for(int i=0; i<e.length; i++){
    e[i] = new Enemy(ENEMIES_IDLE[0], 90, 90, "Bracchiavolcano", 1, 1, i);
    e[i].position = new PVector(400, 200+(i*90));
  }
  e[0].setMaxHealth(170);
  e[0].damage = 12;
  e[1].setMaxHealth(130);
  e[1].damage = 11;
  e[2].setMaxHealth(195);
  e[2].damage = 13;
  
  
  
  
  dagger = new ItemDagger("Daga", "Una daga di un ladro che infligge danni moderati", 27, 2);
  p[0].items.add(dagger);
  minorPotion = new ItemMinorPotion("Pozione minore di cura", "Una pozione minore che cura solo se stessi", 15, 1);
  p[0].items.add(minorPotion);
  bothHealPotion = new ItemPotionOfHealing("Pozione di cura", "Aumenta a se stessi la vita massima oltre l'attuale", 20, 2);
  p[1].items.add(bothHealPotion);
  greatPotion = new ItemGreatPotion("Pozione grande di cura", "Una pozione che cura solo se stessi", 2);
  p[3].items.add(greatPotion);

  
  heal = new MagicHeal("Heal", 40, "Magia elementare per curare un alleato o se stessi");
  p[2].magics.add(heal);
  fireBall = new MagicFireBall("Fireball", 50, "Magia di fuoco semplice che infligge ingenti danni");
  p[2].magics.add(fireBall);
  groupHeal = new MagicGroupHeal("Heal di gruppo", 20, "Magia curatica ad area che cura tutto il party");
  p[2].magics.add(groupHeal);

  combat = new Combat(p, e, battle, hit, win, lose);
  hud = new HUD(ASSET_HUD1, WIDTH, HEIGHT, ASSET_FONT, p, e, combat);
  battle.play();
  battle.loop();
  }

  void update(){
    for(int i=0; i<p.length; i++) p[i].update();
    for(int i=0; i<e.length; i++) e[i].update();
  }

  void draw() {
    update();
    background(0);
    background.draw();
    for(int i=0; i<p.length; i++) p[i].draw();
    for(int i=0; i<e.length; i++) e[i].draw();
    hud.draw();
    combat.movePlayer();
    combat.enemyTurn();
    //combat.enemyAttack();
  }
  
  void mousePressed() {
    hud.mousePressed();
  }
