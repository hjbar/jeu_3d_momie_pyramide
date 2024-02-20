PShape socle_tp_violet;
PShape socle_tp_cyan;

void teleport(float c, String type, boolean onTP) {  
  
  // La base du teleporter
  pushMatrix();
  translate(c / 2., c / 2.);
  rotateX(PI / 2.);
  scale(150);
  
  int r = 0;
  int g = 0;
  int b = 0;
  
  float Pr = 0.225;
  float Gr = 0.5;
  
  if (type == "violet") {
    shape(socle_tp_violet);
    r = 128;
    g = 64;
    b = 128;
  }
  else if (type == "cyan") {
    shape(socle_tp_cyan);
    r = 64;
    g = 128;
    b = 128;
  }
  else {
    println("mauvais type de TP.");
    exit();
  }
  
  popMatrix();
  
  // Le haut du teleporter
  pushMatrix();
  translate(c / 2., c / 2., c / 2.);
  sphereDetail(4);
  
  for (int i = 1; i < 9; i++) {
    fill(r - 7.5 * i, g - 7.5 * i, b - 7.5 * i);
    rotateX(PI / i);
    
    if (onTP) {
      sphere(c * Pr);
    }
    else {
      sphere(c * Gr);
    }
    
  }
  
  popMatrix();
  
}

void teleportPlayer() {
  
  if (gameState == state.OnTpEntree && LAB_SIZE > MIN_LAB_SIZE) {
    LAB_INDICE--;
    resetLab(-4, "sortie");
    updateState(state.InTpEntree);
  }
  
  else if (gameState == state.OnTpExit && LAB_SIZE < MAX_LAB_SIZE) {
    LAB_INDICE++;
    resetLab(4, "entree");
    updateState(state.InTpExit);
  }
  
}

void updateTPstate() {
  
  if (posX == posX_entree && posY == posY_entree) {
    if (LAB_INDICE > 0)
      updateState(state.OnTpEntree);
  } else if (posX == posX_sortie && posY == posY_sortie) {
    if (LAB_SIZE != MAX_LAB_SIZE)
      updateState(state.OnTpExit);
  } else {
      updateState(state.InLab);
  }
  
}
void TpText(String tpType){
  
  if (  tpType == "sortie" ) {
    
      noLights();
      camera();
      perspective();
      
      textAlign(CENTER);
      textSize(32);
      
      fill(255, 128, 255);
      text("Press", width/2.-48, 0.6*height);
      fill(255, 255, 128);
      text(" Enter", width/2.+28, 0.6*height);
      fill(255, 128, 255);
      text(" to teleport", width/2.+140, 0.6*height); 
      
  }
  
  else if (tpType == "entree" ) {
    
      noLights();
      camera();
      perspective();
      
      textAlign(CENTER);
      textSize(32);
      
      fill(128, 255, 255);
      text("Press", width/2.-48, 0.6*height);
      fill(255, 255, 128);
      text(" Enter", width/2.+28, 0.6*height);
      fill(128, 255, 255);
      text(" to teleport", width/2.+140, 0.6*height);   
      
  }
  
  else if (tpType == "entreePyr") {
    
      noLights();
      camera();
      perspective();
      
      textAlign(CENTER);
      textSize(32);
      
      fill(0, 0, 0);
      text("Press", width/2.-48, 0.6*height);
      fill(255, 0, 0);
      text(" Enter", width/2.+28, 0.6*height);
      fill(0, 0, 0);
      text(" to go back inside", width/2.+180, 0.6*height);
      
  }
  
  else {
    
    println("mauvais type de TP.");
    exit();
    
  } 
  
}
