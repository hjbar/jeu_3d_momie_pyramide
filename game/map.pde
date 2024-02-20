float map_width = 200;
float map_height = 200;

void radar(float size, int i, int j, int r, int g, int b) {
  pushMatrix();
  translate(size / 2., size / 2., size);
  
  if(i == posY && j == posX) {
    fill(r, g, b);
    noStroke();
    box(size / 3.);
    
    translate(dirX * size/3., dirY * size/3.);
    rotateZ(dirX * -PI / 2.);
    if (dirY == -1) rotateZ(dirY * PI);
    
    cursor(size/3.);
  }
  
  popMatrix();
}

void cursor(float size){
    beginShape(TRIANGLE_FAN);
    vertex(0, size/2., 0);
    vertex(-size/2., -size/2., -size/2.);
    vertex(-size/2., -size/2., size/2.);
    vertex(size/2., -size/2., size/2.);
    vertex(size/2., -size/2., -size/2.);
    endShape();
}
