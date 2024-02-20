PImage wall_img;
int w_u;
int w_v;

float sphere_size = 4;

void wall(float c, float h, int i, int j, boolean map) { 
  
  r = float(i) / LAB_SIZE * 255;
  g = float(j) / LAB_SIZE * 255;
  b = abs(255 - r - g);
  
  if (map) {
    fill(0);
    stroke(15);
  }
  else {
    noStroke();
  }
   
  // Mur haut && Rouge
  if ((i > 0 && labyrinthe[i - 1][j] != '#') || i == 0) {
     
    if(!map && i != 0 && sides[i][j][3] == 1 && posX == j) {
      
      // On verifie qu'il n'y a pas trop de lumiere deja affichees
      try {
        sphere_lumiere(sphere_size, cote / 2, sphere_size / 2., cote * 1.25, 0, -sphere_size, 0, 255, 0, 0);
      }
      catch (Exception e) {
        println("Trop de lumières pour affichage");
        popMatrix();
      }
      
    }
       
    beginShape(QUADS);
    texture(wall_img);
    tint(r, g, b);
    
    vertex(0, 0, 0, 0, 0);
    vertex(c, 0, 0, w_u, 0);
    vertex(c, 0, h, w_u, w_v);
    vertex(0, 0, h, 0, w_v);
    
    endShape();
  }
   
  // Mur droite && Jaune
  if(!map && sides[i][j][2] == 1 && posY == i) {
    
    // On verifie qu'il n'y a pas trop de lumiere deja affichees
    try {
      sphere_lumiere(sphere_size, cote + sphere_size / 2., cote / 2, cote * 1.25, sphere_size, 0, 0, 255, 255, 0);
    }
    catch (Exception e) {
      println("Trop de lumières pour affichage");
      popMatrix();
    }
    
  }
    
  beginShape(QUADS);
  texture(wall_img);
  tint(r, g, b);
         
  vertex(c, 0, 0, 0, 0);
  vertex(c, c, 0, w_u, 0);
  vertex(c, c, h, w_u, w_v);
  vertex(c, 0, h, 0, w_v);
    
  endShape();
   
  // Mur bas && Vert
  if(!map && sides[i][j][0] == 1 && posX == j) {
    
    // On verifie qu'il n'y a pas trop de lumiere deja affichees
    try {
      sphere_lumiere(sphere_size, cote / 2, cote - sphere_size / 2., cote * 1.25, 0, sphere_size, 0, 0, 255, 0);
    }
    catch (Exception e) {
      println("Trop de lumières pour affichage");
      popMatrix();
    }
    
  }
  
  beginShape(QUADS);
  texture(wall_img);
  tint(r, g, b);
       
  vertex(0, c, 0, 0, 0);
  vertex(c, c, 0, w_u, 0);
  vertex(c, c, h, w_u, w_v);
  vertex(0, c, h, 0, w_v);
  
  endShape();
   
  // Mur gauche && Bleu
  if((j > 0 && labyrinthe[i][j - 1] != '#') || j == 0) {
     
    if(!map && j != 0 && sides[i][j][1] == 1 && posY == i) {
      
      // On verifie qu'il n'y a pas trop de lumiere deja affichees
      try {
        sphere_lumiere(sphere_size, -1 * sphere_size / 2., cote / 2, cote * 1.25, -sphere_size, 0, 0, 0, 0, 255);
      }
      catch (Exception e) {
        println("Trop de lumières pour affichage");
        popMatrix();
      }
    
    }
    
    beginShape();
    texture(wall_img);
    tint(r, g, b);
    
    vertex(0, 0, 0, 0, 0);
    vertex(0, c, 0, w_u, 0);
    vertex(0, c, h, w_u, w_v);
    vertex(0, 0, h, 0, w_v);
    
    endShape();
  }
  
}

void sphere_lumiere(float size, float s_x, float s_y, float s_z, float l_x, float l_y, float l_z, int r, int g, int b) {
  pushMatrix();
  
  translate(s_x, s_y, s_z);    
  fill(r, g, b);
  
  pushMatrix();
  
  if((r==255 && g==255 && b==0) || (r==0 && g==0 && b==255)) {
    rotateY(-PI / 2);
    rotateX(-PI / 2);
    rotateY(-PI / 6);
  }
  
  sphereDetail(6);
  sphere(size);
  
  popMatrix();
  
  translate(l_x, l_y, l_z); 
  float l = 0.30;
  
  lightFalloff(l, l/100, l/1000);
  pointLight(r, g, b, 0, 0, 0);
  
  popMatrix();
}
