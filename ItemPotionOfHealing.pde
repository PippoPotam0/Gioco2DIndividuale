class ItemPotionOfHealing extends Item{
  String name;
  String description;
  int quantity;
  int damage;

  ItemPotionOfHealing(String name, String description, int damage, int quantity){
    super(name, description, damage, quantity);
  }

}
