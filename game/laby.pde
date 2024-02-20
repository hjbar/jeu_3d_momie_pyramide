import java.util.Random;
Random rd;

int MAX_LAB_SIZE = 21;
int MIN_LAB_SIZE = 9;

int LAB_SIZE = MIN_LAB_SIZE;
int LAB_INDICE = 0;

boolean tabCreate [];
int tabSortie [][];
char tabLab [][][];
char tabSides [][][][];
char labyrinthe [][];
char sides [][][];

int posX_entree = 1;
int posY_entree = 1;
int posX_sortie;
int posY_sortie;

float r = 0;
float g = 0;
float b = 0;

void laby(float c, boolean map) {
  for (int i = 0; i < LAB_SIZE; i++) {
    for (int j = 0; j < LAB_SIZE; j++) {
      
      pushMatrix();
      translate(j * c, i * c);
      
      if(!map) {
        
        if(labyrinthe[i][j] == '#') {
          wall(c, 1.5 * c, i, j, map);
        }
        else {
          plaque(c, 0, false, map);
          plaque(c, 1.5 * c, true, map);
        }
        
        if(i == posY_sortie && j == posX_sortie && LAB_SIZE != MAX_LAB_SIZE) {
          teleport(c, "violet", gameState == state.OnTpExit);
        }
        
        else if(i == posY_entree && j == posX_entree && LAB_SIZE != MIN_LAB_SIZE) {
          teleport(c, "cyan", gameState == state.OnTpEntree);
        }
        
      }
      
      else {
        
        if(sides[i][j][4] == 1) {
          
          if (labyrinthe[i][j] == '#') {
            wall(c, 1.5 * c, i, j, map);
            plaque(c, 1.5 * c, true, map);
          }
          else {
            plaque(c, 1.5 * c / 2., false, map);
          }
          
        }
        radar(c, i, j, 0, 255, 0);
        
      }
      
      popMatrix();
      
    }
  }
}

void resetLab(int nb, String lieu) {
  LAB_SIZE += nb;
  
  createLab();
  
  posX_entree = 1;
  posY_entree = 1;
  
  if (LAB_SIZE == MAX_LAB_SIZE) {
    posY_sortie = LAB_SIZE - 2;
    posX_sortie = LAB_SIZE - 1;
  }
  else {
    do{
      posY_sortie = tabSortie[LAB_INDICE][0];
      posX_sortie = tabSortie[LAB_INDICE][1];
    } while (tabLab[LAB_INDICE][posY_sortie][posX_sortie] == '#');
  }
  
  if (lieu == "entree") {
    posX = posX_entree;
    posY = posY_entree;
  }
  else if (lieu == "sortie") {
    posX = posX_sortie;
    posY = posY_sortie;
  }
  else {
    println("Mauvais lieu.");
    exit();
  }

}

void createLab() {
  
  if (tabCreate[LAB_INDICE] == false) {
    
    labyrinthe = new char[LAB_SIZE][LAB_SIZE];
    sides = new char[LAB_SIZE][LAB_SIZE][5];
    
    int todig = 0;
    for (int j=0; j<LAB_SIZE; j++) {
      for (int i=0; i<LAB_SIZE; i++) {
        for (int k = 0; k < 4; k++) {
          sides[j][i][k] = 0;
        }
        
        if (i == 0 || j == 0 || i == LAB_SIZE - 1 || j == LAB_SIZE - 1) {
          sides[j][i][4] = 1;
        }
        else {
          sides[j][i][4] = 0;
        }
        
        if (j%2==1 && i%2==1) {
          labyrinthe[j][i] = '.';
          todig ++;
        } else
          labyrinthe[j][i] = '#';
      }
    }
    
    int gx = 1;
    int gy = 1;
    while (todig>0 ) {
      int oldgx = gx;
      int oldgy = gy;
      int alea = floor(random(0, 4)); // selon un tirage aleatoire
      if      (alea==0 && gx>1)          gx -= 2; // le fantome va a gauche
      else if (alea==1 && gy>1)          gy -= 2; // le fantome va en haut
      else if (alea==2 && gx<LAB_SIZE-2) gx += 2; // .. va a droite
      else if (alea==3 && gy<LAB_SIZE-2) gy += 2; // .. va en bas
  
      if (labyrinthe[gy][gx] == '.') {
        todig--;
        labyrinthe[gy][gx] = ' ';
        labyrinthe[(gy+oldgy)/2][(gx+oldgx)/2] = ' ';
      }
    }
  
    labyrinthe[0][1]                   = ' '; // entree
    labyrinthe[LAB_SIZE-2][LAB_SIZE-1] = ' '; // sortie
  
    for (int j=1; j<LAB_SIZE-1; j++) {
      for (int i=1; i<LAB_SIZE-1; i++) {
        if (labyrinthe[j][i]==' ') {
          if (labyrinthe[j-1][i]=='#' && labyrinthe[j+1][i]==' ' &&
            labyrinthe[j][i-1]=='#' && labyrinthe[j][i+1]=='#')
            sides[j-1][i][0] = 1;// c'est un bout de couloir vers le haut 
          if (labyrinthe[j-1][i]==' ' && labyrinthe[j+1][i]=='#' &&
            labyrinthe[j][i-1]=='#' && labyrinthe[j][i+1]=='#')
            sides[j+1][i][3] = 1;// c'est un bout de couloir vers le bas 
          if (labyrinthe[j-1][i]=='#' && labyrinthe[j+1][i]=='#' &&
            labyrinthe[j][i-1]==' ' && labyrinthe[j][i+1]=='#')
            sides[j][i+1][1] = 1;// c'est un bout de couloir vers la droite
          if (labyrinthe[j-1][i]=='#' && labyrinthe[j+1][i]=='#' &&
            labyrinthe[j][i-1]=='#' && labyrinthe[j][i+1]==' ')
            sides[j][i-1][2] = 1;// c'est un bout de couloir vers la gauche
        }
      }
    }
    
    labyrinthe[0][1] = '#'; // entree
    
    if (LAB_SIZE != MAX_LAB_SIZE) {
      labyrinthe[LAB_SIZE-2][LAB_SIZE-1] = '#'; // sortie
      do{
        posY_sortie = LAB_SIZE / 2 + rd.nextInt(LAB_SIZE / 2-1);
        posX_sortie = LAB_SIZE / 2 + rd.nextInt(LAB_SIZE / 2-1);
      } while (labyrinthe[posY_sortie][posX_sortie] == '#');
      tabSortie[LAB_INDICE][0] = posY_sortie;
      tabSortie[LAB_INDICE][1] = posX_sortie;
    }
    
    tabLab[LAB_INDICE] = labyrinthe;
    tabSides[LAB_INDICE] = sides;
    tabCreate[LAB_INDICE] = true;
    
  }
  
  else {
   labyrinthe = tabLab[LAB_INDICE];
   sides = tabSides[LAB_INDICE];
  }
}

void initTabLab() {
  int taille = int( (MAX_LAB_SIZE - MIN_LAB_SIZE) / 4. + 1);
  
  tabLab = new char[taille][LAB_SIZE][LAB_SIZE];
  tabSortie = new int[taille-1][2];
  tabSides = new char[taille][LAB_SIZE][LAB_SIZE][5];
  tabCreate = new boolean[taille];
  
  for (int k = 0; k < taille; k++) {
    tabCreate[k] = false;
  }
  
}
