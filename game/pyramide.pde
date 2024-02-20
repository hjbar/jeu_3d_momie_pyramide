PShape pyramide;
PShape base;
PShape toit;

final int posX_pyramide = 8;  
final int posY_pyramide = 12;

void createPyramide() {
  
  // Creation de la pyramide
  
  pyramide = createShape(GROUP);
  
  // Variables 
  
  int nb_rect = MAX_LAB_SIZE * 2;
  
  float c = cote / 8.;
  float rect_long = c * 2;
  float rect_larg = c;
  float rect_z_bas = 0;
  float rect_z_haut = c;

  float x0 = 0;
  float y0 = 0;
  float x = x0;
  float y = y0;
  
  createPyramideBase(nb_rect, c, rect_long, rect_larg, rect_z_bas, rect_z_haut, x, y, x0, y0);
  
  x0 = c * nb_rect;
  y0 = c * nb_rect;
  rect_z_bas = c * nb_rect;
  rect_z_haut = c * (nb_rect + 1);
  
  createToitPyramide(x0 - c, y0 - c - c, c, rect_long, rect_z_bas + c, rect_z_haut + c * 2);
  
  pyramide.addChild(base);
  pyramide.addChild(toit);
}

void createPyramideBase(int nb_rect, float c, float rect_long, float rect_larg, float rect_z_bas, float rect_z_haut, float x, float y, float x0, float y0) {
  
  // Pour creer la porte
  float decal = 0;
  
  base = createShape();
  
  // les etages
  for (int k = nb_rect; k >= 1; k--) {
    
    nb_rect = k;
    rect_z_bas += c;
    rect_z_haut += c;
  
  // les 4 cotes
    for (int i = 0; i < 4; i++) {
      
      if (i == 0) {
        x = x0;
        y = y0;
        dessineLongueurRectanglePyramide(x, y, nb_rect, rect_larg, rect_long, rect_z_bas, rect_z_haut);
        dessineCubePyramide(x, y + nb_rect * rect_long, c, rect_z_bas, 'g');
      }
      
      else if(i == 1) {
        x = x0 + c;
        y = y0 + rect_long * nb_rect;
        
        // Emplacement de la porte
        if (28 <= k && k <= 32) {
          dessineLateralRectanglePyramide(x, y, nb_rect, rect_larg, rect_long, rect_z_bas, rect_z_haut, true, decal);
          decal += 0.5;
        }
        else {
          dessineLateralRectanglePyramide(x, y, nb_rect, rect_larg, rect_long, rect_z_bas, rect_z_haut, false, decal);
        }
        
        dessineCubePyramide(x + nb_rect * rect_long, y, c, rect_z_bas, 'b');
      }
      
      else if (i == 2) {
        x = x0 + rect_long * nb_rect + c;
        y = y0 - c;
        dessineCubePyramide(x, y, c, rect_z_bas, 'd');
        dessineLongueurRectanglePyramide(x, y + c, nb_rect, rect_larg, rect_long, rect_z_bas, rect_z_haut);
      }
      
      else {
        x = x0;
        y = y0 - c ;
        dessineCubePyramide(x, y, c, rect_z_bas, 'h');
        dessineLateralRectanglePyramide(x + c, y, nb_rect, rect_larg, rect_long, rect_z_bas, rect_z_haut, false, decal); 
      }
      
    }
    
    x0 += c;
    y0 += c;
    
  }
  
}

void dessineLongueurRectanglePyramide(float x, float y, int n, float r_larg, float r_long, float bas, float haut) {
  
      base.beginShape(QUADS);
      base.noStroke();
      base.texture(floor_img);
      base.tint(213, 175, 126);
  
      for (int j = 0; j < n; j++) {
        
        float b = r_long * j;
        
        // face gauche
        base.vertex(x + r_larg, y + b, bas, 0, 0);
        base.vertex(x + r_larg, y + b + r_long, bas, f_u, 0);
        base.vertex(x + r_larg, y + b + r_long, haut, f_u, f_v);
        base.vertex(x + r_larg, y + b, haut, 0, f_v);
        
        // face droite
        base.vertex(x, y + b, bas, 0, 0);
        base.vertex(x, y + b + r_long, bas, f_u, 0);
        base.vertex(x, y + b + r_long, haut, f_u, f_v);
        base.vertex(x, y + b, haut, 0, f_v);
        
        // face haute
        base.vertex(x, y + b, haut, 0, 0);
        base.vertex(x, y + b + r_long, haut, f_u, 0);
        base.vertex(x + r_larg, y + b + r_long, haut, f_u, f_v);
        base.vertex(x + r_larg, y + b, haut, 0, f_v);
      
      }
    
    base.endShape();
}

void dessineLateralRectanglePyramide(float x, float y, int n, float r_larg, float r_long, float bas, float haut, boolean porte, float decal) {
  
      base.beginShape(QUADS);
      base.noStroke();
      base.texture(floor_img);
      base.tint(213, 175, 126);
      
      // Indice de la porte
      int ind = 5 - int(decal);
  
      for (int j = 0; j < n; j++) {
      
        // Si c'est pas la porte, on trace
        if (! ( porte && ( j == ind) ) ) {
          
          float b = r_long * j;
          
          // face back
          base.vertex(x + b, y, bas, 0, 0);
          base.vertex(x + b + r_long, y, bas, f_u, 0);
          base.vertex(x + b + r_long, y, haut, f_u, f_v);
          base.vertex(x + b, y, haut, 0, f_v);
          
          // face top
          base.vertex(x + b, y + r_larg, bas, 0, 0);
          base.vertex(x + b + r_long, y + r_larg, bas, f_u, 0);
          base.vertex(x + b + r_long, y + r_larg, haut, f_u, f_v);
          base.vertex(x + b, y + r_larg, haut, 0, f_v);
          
          // face haut
          base.vertex(x + b, y, haut, 0, 0);
          base.vertex(x + b + r_long, y, haut, f_u, 0);
          base.vertex(x + b + r_long, y + r_larg, haut, f_u, f_v);
          base.vertex(x + b, y + r_larg, haut, 0, f_v);
      
      }
      
    }
    
    base.endShape();
}

void dessineCubePyramide(float x, float y, float c, float bas, char dir) {
  
    base.beginShape(QUADS);
    base.noStroke();
    base.texture(floor_img);
    base.tint(213, 175, 126);
    
    // Face droite
    base.vertex(x + c, y, bas, 0, 0);
    base.vertex(x + c, y + c, bas, f_u, 0);
    base.vertex(x + c, y + c, bas + c, f_u, f_v);
    base.vertex(x + c, y, bas + c, 0, f_v);
    
    // Face gauche
    base.vertex(x, y, bas, 0, 0);
    base.vertex(x, y + c, bas, f_u, 0);
    base.vertex(x, y + c, bas + c, f_u, f_v);
    base.vertex(x, y, bas + c, 0, f_v);
    
    // Face back
    base.vertex(x, y, bas, 0, 0);
    base.vertex(x + c, y, bas, f_u, 0);
    base.vertex(x + c, y, bas + c, f_u, f_v);
    base.vertex(x, y, bas + c, 0, f_v);
    
    // Face top
    base.vertex(x, y + c, bas, 0, 0);
    base.vertex(x + c, y + c, bas, f_u, 0);
    base.vertex(x + c, y + c, bas + c, f_u, f_v);
    base.vertex(x, y + c, bas + c, 0, f_v);
    
    // Face haute (selon l'angle, il faut adapter la texture)
    if (dir == 'h') {
      base.vertex(x, y, bas + c, 0, f_v);
      base.vertex(x, y + c, bas + c, f_u, f_v);
      base.vertex(x + c, y + c, bas + c, f_u, 0);
      base.vertex(x + c, y, bas + c, f_u, f_v);
    }
    else if (dir == 'd') {
      base.vertex(x, y + c, bas + c, f_u, 0);
      base.vertex(x, y, bas + c, f_u, f_v);
      base.vertex(x + c, y, bas + c, 0, f_v);
      base.vertex(x + c, y + c, bas + c, f_u, f_v);
    }
    else if (dir == 'g') {
      base.vertex(x, y + c, bas + c, 0, f_v);
      base.vertex(x, y, bas + c, f_u, f_v);
      base.vertex(x + c, y, bas + c, f_u, 0);
      base.vertex(x + c, y + c, bas + c, f_u, f_v);
    }
    else if (dir == 'b') {
      base.vertex(x, y, bas + c, f_u, 0);
      base.vertex(x, y + c, bas + c, f_u, f_v);
      base.vertex(x + c, y + c, bas + c, 0, f_v);
      base.vertex(x + c, y, bas + c, f_u, f_v);
    }
    else {
      println("mauvaise direction dans la construction du cube");
      exit();
    }
    
    base.endShape();
    
}

void createToitPyramide(float x, float y, float c, float r_long, float r_bas, float r_haut) {
  
  toit = createShape();
  
  toit.beginShape(TRIANGLES);
  toit.noStroke();
  toit.texture(floor_img);
  toit.tint(213, 175, 126);
  
  // Face top
  toit.vertex(x, y, r_bas, 0, 0);
  toit.vertex(x + c + r_long + c, y, r_bas, f_u, 0);
  toit.vertex(x + c + r_long / 2., y + c + r_long / 2., r_haut, f_u / 2., f_v / 2.);
    
  // Face back
  toit.vertex(x, y + c + r_long + c, r_bas, 0, 0);
  toit.vertex(x + c + r_long + c, y + c + r_long + c, r_bas, f_u, 0);
  toit.vertex(x + c + r_long / 2., y + c + r_long / 2., r_haut, f_u / 2., f_v / 2.);
  
  // Face droite
  toit.vertex(x + c + r_long + c, y, r_bas, 0, 0);
  toit.vertex(x + c + r_long + c, y + c + r_long + c, r_bas, f_u, 0);
  toit.vertex(x + c + r_long / 2., y + c + r_long / 2., r_haut, f_u / 2., f_v / 2.);
  
  // Face gauche
  toit.vertex(x, y, r_bas, 0, 0);
  toit.vertex(x, y + c + r_long + c, r_bas, f_u, 0);
  toit.vertex(x + c + r_long / 2., y + c + r_long / 2., r_haut, f_u / 2., f_v / 2.); 
  
  toit.endShape();
  
}
