int transition_timer;
final int transition_sec = 1;

int anim_timer;

void transitionSec(float centre, float r, float g, float b){
    // ecran de transition lorsque le joueur se teleporte
    loadPixels();
    for (int i = 0; i < width; ++i){
      for (int j = 0; j < height; ++j){
        float re = (255 - (1 - r) * abs( centre - dist(width/2., height/2., i, j)) / 2.) % 256;
        float gr = (255 - (1 - g) * abs( centre - dist(width/2., height/2., i, j)) / 2.) % 256;
        float bl = (255 - (1 - b) * abs( centre - dist(width/2., height/2., i, j)) / 2.) % 256;
        color pxl_color = color(re, gr, bl);
        pixels[j * width + i] = pxl_color;
      }
    }
    updatePixels();
}

void transition(float r, float g, float b){
  transitionSec(width/((transition_timer % 10) + 1), r, g, b);
  --transition_timer;
}

void enterPyrAnim(){
  --anim_timer;
  if (anim_timer >= 4 * nbFrameUp){
    animTrans = true;
    z += 0.375 * cote / nbFrameUp;
    if (anim == 0){
      posX += dirX;
      posY += dirY;      
    }
  } else if (anim_timer >= 3 * nbFrameUp){
    animTrans = false;
    tmpX = dirX;
    tmpY = dirY;
    dirX = -1;
    dirY = 0;
  } else {
    if (anim == 0){
      posX += dirX;
      posY += dirY;      
    }
    animTrans = true;    
  }
  if (anim == 0){
    anim = nbFrameUp;  
  }
}

void exitPyrAnim(){
 --anim_timer;
 if (anim_timer >= 6 * nbFrameUp){
    animTrans = false;
    tmpX = dirX;
    tmpY = dirY;
    dirX = 1;
    dirY = 0;
  } else if (anim_timer >= 3 * nbFrameUp){
    animTrans = true;
    if (anim == 0){
      posX += dirX;
      posY += dirY;      
    }
  } else if (anim_timer >= 2 * nbFrameUp){
    animTrans = false;
    tmpX = dirX;
    tmpY = dirY;
    dirX = 0;
    dirY = 1;
  } else {
    animTrans = true; 
    if (anim == 0){
      posX += dirX;
      posY += dirY;      
    }
    z -= 0.375 * cote / nbFrameUp;   
  }
  
  if (anim == 0){
    anim = nbFrameUp;  
  }
}

void enterPyrReset(){
  nbFrameUp = nbFrameUpFast;
  updateState(state.InLab);
  posX = LAB_SIZE - 2;
  posY = LAB_SIZE - 2;
  dirX = -1;  
  dirY = 0;
  animTrans = false;
  z = cote / 4. * 3.;  
}

void exitPyrReset(){
  nbFrameUp = nbFrameUpFast;
  updateState(state.OutLab);
  animTrans = false;
  z = cote / 4. * 3.; 
}

void exitPyrSetup(){
  updateState(state.ExitPyr);
  posX = 6;
  posY = 10;
  tmpX = dirX;
  tmpY = dirY; 
  dirX = 0;
  dirY = 1; 
  nbFrameUp = 10;
  anim_timer = 7*nbFrameUp;  
  anim = nbFrameUp;
  z = 1.5 * cote;  
}

void enterPyrSetup(){
  updateState(state.EnterPyr);
  nbFrameUp = 10;
  anim_timer = 6*nbFrameUp;
  anim = nbFrameUp;  
}
