int nbFrameUpSlow = 12;
int nbFrameCoteSlow = 10;

int nbFrameUpFast = 5;
int nbFrameCoteFast = 3;

boolean modeFast = true;
int nbFrameUp = nbFrameUpFast;
int nbFrameCote = nbFrameCoteFast;

int anim = 0;

boolean animTrans;

int posX = 1;
int posY = 1;

int tmpX;
int tmpY;

int dirX = 0;
int dirY = 1;

float z;

boolean verif_coord_lab(int x, int y, int dx, int dy) {
  return (y + dy >= 0 && y + dy < LAB_SIZE && x + dx >= 0 && x + dx < LAB_SIZE);
}

boolean verif_coord_momie(int x, int y, int dx, int dy) {
  return x+dx != momies[LAB_INDICE].getRealX() || y+dy != momies[LAB_INDICE].getRealY();
}

boolean verif_coord_desert(int x, int y, int dx, int dy) {
  boolean cond1 = y + dy >= 6 && y + dy < MAX_LAB_SIZE - 6;
  boolean cond2 = x + dx >= 8 && x + dx < MAX_LAB_SIZE - 5;
  
  boolean cond3 = true;
  
  if (x + dx >= 11 && y + dy <= 11) {
    cond3 = x + dx != 11;
  }
  else if (y + dy >= 11 && x + dx <= 11) {
    cond3 = y + dy != 11;
  }
  
  return (cond1 && cond2 && cond3);
}

void Move() {
  boolean inlab = gameState == state.InLab || gameState == state.OnTpExit || gameState == state.OnTpEntree;
  boolean outlab = gameState == state.OutLab;
  
  // Dans le laby on avance
  if ( inlab && keyCode == UP && verif_coord_lab(posX, posY, dirX, dirY) && labyrinthe[posY + dirY][posX + dirX] != '#' && verif_coord_momie(posX, posY, dirX, dirY) ) {
    posX += dirX;
    posY += dirY;
    
    animTrans = true;
    anim = nbFrameUp;
  }
  
  // Dehors on avance
  else if (outlab && keyCode == UP && verif_coord_desert(posX, posY, dirX, dirY)) {
    posX += dirX;
    posY += dirY;
    animTrans = true;
    anim = nbFrameUp;
  }
  
  // On tourne
  else {
    
    tmpX = dirX;
    tmpY = dirY;
    animTrans = false;
  
    if (keyCode == LEFT) {
      int tmp = -dirX;
      dirX = dirY;
      dirY = tmp;
      
      boussole.rotateZ(PI / 2.);
    }
    
    else if (keyCode == RIGHT) {
      int tmp = dirX;
      dirX = -dirY;
      dirY = tmp;
      
      boussole.rotateZ(-PI / 2.);
    }
    
    else {
      return;
    }
    
    anim = nbFrameCote;
  
  }
  
  // On devoile la minimap on fur et a mesure
  for (int k = -1; k <= 1; k++) {
    for (int l = -1; l <= 1; l++) {
      if(verif_coord_lab(posY, posX, l, k)) {
         sides[posY + l][posX + k][4] = 1;
      }
    }
  }
  
}

void keyPressed() {
  
  if (keyCode == CONTROL && anim == 0) {
    
    if (modeFast) {
      nbFrameUp = nbFrameUpSlow;
      nbFrameCote = nbFrameCoteSlow;
      modeFast = false;
    }
    else {
      nbFrameUp = nbFrameUpFast;
      nbFrameCote = nbFrameCoteFast;
      modeFast = true;
    }
    
  }
  
}
