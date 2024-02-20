PImage floor_img;
int f_u;
int f_v;

float cote = 0; // valeur evaluee dans le setup en fonction de width/height

void plaque(float c, float h, boolean toit, boolean map) {
  
  beginShape(QUADS);
  noStroke();
  texture(floor_img);
    
  if (!map) {
    tint(128);
  }
  else if(toit) {
    tint(r, g, b);
  }
  else {
    tint(255);
  }
    
  vertex(0, 0, h, 0, 0);
  vertex(c, 0, h, f_u, 0);
  vertex(c, c, h, f_u, f_v);
  vertex(0, c, h, 0, f_v);
  
  endShape(QUADS);
  
}
