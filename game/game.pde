int fps = 20;

void setup() { 
  
  frameRate(fps);
  size(1000, 1000, P3D);
  
  rd = new Random();
  cote = float(width) / MAX_LAB_SIZE;
  
  wall_img = loadImage("src/stonewall.jpg");
  w_u = wall_img.width;
  w_v = wall_img.height;
  
  floor_img = loadImage("src/stones.jpg");
  f_u = floor_img.width;
  f_v = floor_img.height;
  
  sand_img = loadImage("src/sand.jpg");
  s_u = sand_img.width;
  s_v = sand_img.height;
  
  socle_tp_violet = loadShape("src/socle_tp_violet.obj");
  socle_tp_cyan = loadShape("src/socle_tp_cyan.obj"); 
  
  initTabLab();
  createLab();
  createExterieur();
  createBoussole(100);
  boussole.rotateZ(PI);
  
  momies = new Momie[tabLab.length];
  momies[CUR_MOMIE] = new Momie(0.2*cote, 0.2*cote, 3*cote/2.,posX_sortie, posY_sortie, tabLab[LAB_INDICE]);
  
  updateState(state.InLab);
  z = cote / 4. * 3.;
}

void draw() {
  
  ++timer_momie;
  if (timer_momie % fps == 1){
    // deplacement dans le modele
    if (CUR_MOMIE != LAB_INDICE){
      CUR_MOMIE = LAB_INDICE;
      
      if (momies[CUR_MOMIE] == null)
        momies[CUR_MOMIE] = new Momie(0.2*cote, 0.2*cote, 3*cote/2.,posX_sortie, posY_sortie, tabLab[LAB_INDICE]);
    }
    momies[CUR_MOMIE].moveMomie();  
  } else  // deplacement dans la vue
    momies[CUR_MOMIE].updateMomie();

  if (anim > 0) {
    anim--;
  }
    
  // Pour pouvoir rester appuyer et ne pas pouvoir "spam"
  if(keyPressed && anim == 0) {
    Move();
  }
    
  float x = cote * posX + cote / 2.;
  float y = cote * posY + cote / 2.;
      
  float x2 = dirX * cote / 2;
  float y2 = dirY * cote / 2;
  float z2 = -1 * cote / 8. + 0.1 * (width/2. - mouseY);
    
  float d = 0;
  float t = 0;
  
  float x_momie = cote * momies[CUR_MOMIE].getX() + cote / 2.;
  float y_momie = cote * momies[CUR_MOMIE].getY() + cote / 2.;
    
  d = anim / float(nbFrameUp);
  t = 0.5 * sin(PI * d);
    
  if(animTrans) {
   if (gameState == state.EnterPyr || gameState == state.ExitPyr){
      x += cote * (dirX-d*dirX);
      y += cote * (dirY-d*dirY);
   } else {
      x = cote * (posX - d * dirX) + cote / 2.;
      y = cote * (posY - d * dirY) + cote / 2.;
      z = cote / 4. * 3.;
    }
  } else {
   if (gameState == state.EnterPyr || gameState == state.ExitPyr){
      x2 = (dirX * (nbFrameUp - anim) + tmpX * anim) / float(nbFrameUp) * cote / 2;
      y2 = (dirY * (nbFrameUp - anim) + tmpY * anim) / float(nbFrameUp) * cote / 2;
   } else { 
      x2 = (dirX * (nbFrameCote - anim) + tmpX * anim) / float(nbFrameCote) * cote / 2;
      y2 = (dirY * (nbFrameCote - anim) + tmpY * anim) / float(nbFrameCote) * cote / 2;
   }
  } 
  
  camera(x, y, z + t, x + x2, y + y2, z + z2, 0, 0, -1);
  perspective(PI / 3.0, float(width) / float(height), 1.0, z * 30.0);
    
  if(gameState == state.InLab || gameState == state.OnTpEntree || gameState == state.OnTpExit) {
    background(255);
    if (abs(momies[CUR_MOMIE].getX() - posX) <= 2 || abs(momies[CUR_MOMIE].getY() - posY) <= 2){
      pushMatrix();
      translate( x_momie, y_momie, 0);
      momies[CUR_MOMIE].drawMomie();
      popMatrix();
    }
    
    // Ligths
    float l = 0.35;
    lightFalloff(l, l/1000, l/10000);
    pointLight(255, 255, 255, x, y, cote / 4. * 5.);
    
    // Grand laby
    beginCamera();
    laby(cote, false);
    endCamera();
    
    // Petit laby == la map
    pushMatrix();
    beginCamera();
    
    camera();
    perspective();
    noLights();
    
    translate(cote / 2., cote / 2.);
    // On n'utilise pas une variable globale parce que les labyrinthes vont varier en taille
    float map_size = map_width / float(LAB_SIZE); 
    laby(map_size, true);
    
    endCamera();
    popMatrix();
    
    // Boussole
    pushMatrix();
    beginCamera();
      
    camera();
    perspective();
    noLights();
      
    translate(cote * 2.5, height - cote * 2, 0);
    shape(boussole);
      
    endCamera();
    popMatrix();    
    
    updateTPstate();
    if (keyPressed && keyCode == ENTER) {
      teleportPlayer();
    }
    
    if (LAB_SIZE == MAX_LAB_SIZE && posX == posX_sortie && posY == posY_sortie && anim == 0) {
      exitPyrSetup();
    }
    
    if ( gameState == state.OnTpExit ){
      beginCamera();
      TpText("sortie");
      endCamera();      
    } else if ( gameState == state.OnTpEntree ){
      beginCamera();
      TpText("entree");
      endCamera();    
    } 
  }
  // On est dehors
  else if (gameState == state.OutLab || gameState == state.EnterPyr || gameState == state.ExitPyr){
    background(119, 181, 254);
    noLights();
    
    float dir;
    float clr;

    // Light1 
    pushMatrix();
    translate(2 * width, 2 * height, (width + height) * 0.75);
    
    dir = -1;
    clr = 255;
    directionalLight(clr, clr, clr, dir, dir, -0.25);
    
    popMatrix();
    
    // Light2
    pushMatrix();
    translate(width, height * 0.75, (width + height) * 0.25);
    
    dir = -1;
    clr = 210;
    directionalLight(clr, clr, clr, dir, 0, -0.75);
    
    popMatrix();
    
    // Light3
    pushMatrix();
    translate(width * 0.75, height, (width + height) * 0.25);
    
    dir = -1;
    clr = 210;
    
    directionalLight(clr, clr, clr, 0, dir, -0.75);
    
    popMatrix();
    
    lightSpecular(clr, clr, clr);
 
    shape(exterieur);
    
    if ( gameState == state.ExitPyr){
      exitPyrAnim();
      if (anim_timer == 0){
        exitPyrReset();
      }       
    } else if (gameState == state.EnterPyr){
      enterPyrAnim();
      if (anim_timer == 0){
        enterPyrReset();
      }      
    } else if (posX == posX_pyramide && posY == posY_pyramide && dirY == -1){
        TpText("entreePyr");
        if (keyPressed && keyCode == ENTER){
          enterPyrSetup();
        }
    }
  } else if (gameState == state.InTpEntree){
    transition(0.25, 0.5, 0.5);
    if (transition_timer == 0)
      updateState(state.OnTpEntree);
  } else if (gameState == state.InTpExit){
    transition(0.5, 0.25, 0.5);
    if (transition_timer == 0)
      updateState(state.OnTpExit);
  }
  
}
