PShape desert;

PImage sand_img;
int s_u;
int s_v;

float grain_size = 1;

void createDesert() {
  
  // Variables
  
  float n_i;
  float n_j;
  float vi;
  float vj;
  float vii;
  float vjj;
  
  float gs = grain_size;
  float d = 125.;
  float dh = gs / d;
  
  float t = 3.5;
  float min = cote * 0.25;
  float hij;
  float hii;
  float hjj;
  float hiijj;
  
  float rd;
  
  // Creation du desert
  
  desert = createShape();
  
  // Début dessin
  
  desert.beginShape(QUADS);
  desert.noStroke();
  desert.texture(sand_img);

  for (float i = 0; i < height; i += grain_size) {
    for (float j = 0; j < width; j += grain_size) {
      
      n_i = i / d;
      n_j = j / d;
      
      vi = abs(i - height / 2.);
      vj = abs(j - width / 2.);
      vii = abs((i + gs) - height / 2.);
      vjj = abs((j + gs) - width / 2.);
      
      hij = ( pow(vi, 2) / pow(height/2,2) + pow(vj,2) / pow(width/2,2) ) * (cote * t) + min;   
      hii = ( pow(vii, 2) / pow(height/2,2) + pow(vj,2) / pow(width/2,2) ) * (cote * t) + min;
      hjj = ( pow(vi, 2) / pow(height/2,2) + pow(vjj,2) / pow(width/2,2) ) * (cote * t) + min;
      hiijj = ( pow(vii, 2) / pow(height/2,2) + pow(vjj,2) / pow(width/2,2) ) * (cote * t) + min;
      
      rd = random(100);

      if (rd < 25) {
        desert.vertex(i, j, hij * noise(n_i, n_j), 0, 0);
        desert.vertex(i + gs, j, hii * noise(n_i + dh, n_j), s_u, 0);
        desert.vertex(i + gs, j + gs, hiijj * noise(n_i + dh, n_j + dh), s_u, s_v);
        desert.vertex(i, j + gs, hjj * noise(n_i, n_j + dh), 0, s_v);
      }
      else if (rd < 50) {
        desert.vertex(i, j, hij * noise(n_i, n_j), 0, s_v);
        desert.vertex(i + gs, j, hii * noise(n_i + dh, n_j), 0, 0);
        desert.vertex(i + gs, j + gs, hiijj * noise(n_i + dh, n_j + dh), s_u, 0);
        desert.vertex(i, j + gs, hjj * noise(n_i, n_j + dh), s_u, s_v);
      }
      else if (rd < 75) {
        desert.vertex(i, j, hij * noise(n_i, n_j), s_u, s_v);
        desert.vertex(i + gs, j, hii * noise(n_i + dh, n_j), 0, s_v);
        desert.vertex(i + gs, j + gs, hiijj * noise(n_i + dh, n_j + dh), 0, 0);
        desert.vertex(i, j + gs, hjj * noise(n_i, n_j + dh), s_u, 0);
      }
      else {
        desert.vertex(i, j, hij * noise(n_i, n_j), s_u, 0);
        desert.vertex(i + gs, j, hii * noise(n_i + dh, n_j), s_u, s_v);
        desert.vertex(i + gs, j + gs, hiijj * noise(n_i + dh, n_j + dh), 0, s_v);
        desert.vertex(i, j + gs, hjj * noise(n_i, n_j + dh), 0, 0);
      }

    }
  }

  // Fin de dessin
  
  desert.endShape();

}
