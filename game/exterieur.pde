PShape exterieur;

void createExterieur() {
  exterieur = createShape(GROUP);
  
  createPyramide();
  
  exterieur.addChild(pyramide);
  
  pyramide.translate(cote, cote, -8);
  
  createDesert();
  
  exterieur.addChild(desert);

}
