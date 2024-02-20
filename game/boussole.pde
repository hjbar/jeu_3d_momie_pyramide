PShape boussole;
PShape base_bouss;
PShape aiguille;
PShape base_aig;

void createBoussole(int size) {
  
  boussole = createShape(GROUP);
  
  base_bouss = createShape(ELLIPSE, 0, 0, size, size);
  base_bouss.setFill(color(164, 140, 62));
  
  aiguille = createShape(LINE, 0, 0, 0, 0, -size / 2., 0);
  aiguille.setStroke(color(255, 0, 0));
  
  base_aig = createShape(SPHERE, size / 30.);
  base_aig.setFill(color(0, 0, 0));
  base_aig.setStroke(false);
  
  boussole.addChild(base_bouss);
  boussole.addChild(aiguille);
  boussole.addChild(base_aig);
}
