Momie momies[];
int CUR_MOMIE;

// à chaque frame la momie doit etre mise a jour
// on doit appeler moveMomie avant updateMomie, sans quoi la momie sera mal place et traversera des murs
// On le remet a 0 lorsque l'on crée une momie et lorsque timer_momie % 2 == 1, on met l'orientation ou 
// la position dans le labyrinthe de la momie
int timer_momie;

// Change le nombre de face d'une bandelette
final int DETAIL = 64;

final float d1 = 0.5;
final float d2 = 0.75;

final float rm = 178;
final float gm = 157;
final float bm = 20;

final float RED_BODY = rm * 1.35 * d1;
final float D_RED_BODY = (rm / 5.) * 0.65 * d2;
final float GREEN_BODY = gm * 1.15 * d1;
final float D_GREEN_BODY = (gm / 5.) * 0.85 * d2;
final float BLUE_BODY = bm * 1.25 * d1;
final float D_BLUE_BODY = (bm / 5.) * 0.75 * d2;

final float RED_GLB = 0;
final float GREEN_GLB = 0;
final float BLUE_GLB = 0;
final float RED_PUPIL = 128;
final float GREEN_PUPIL = 0;
final float BLUE_PUPIL = 0;

class Momie{
  
    private PShape momie;
    // labyrinthe dans lequel se trouve la momie
    private char labyrinthe[][];
    // position x, y dans le lab. 
    private int x, y;
    // postion exacte dans l'espace
    private float vx, vy;
    // rotation de la momie
    private float r;
    // direction vers laquelle se deplace la momie
    private int dirX, dirY;
    // Coeff de rotation de la momie
    // 0 la momie avance
    // 1 la momie tourne à droite
    // -1 la momie tourne à gauche
    // 2 la momie se retourne
    private int rotate = 0; 
    
    public Momie(float w, float b, float h, int posX, int posY, char[][] lab){
        
        this.labyrinthe = lab;      
        this.x = posX; 
        this.y = posY; 
        this.vx = posX;
        this.vy = posY;
        this.r = 0;      
        this.dirX = 0;
        this.dirY = 1;
      
        float widthMin = 0.5 * w;
        float breadthMin = 0.5 * b;
        
        int nbLayer = 3 * DETAIL / 2;
        
        this.momie = createShape(GROUP);
        // Le nombre de banderelle du corps de la momie
        int bodyL = 8 * nbLayer / 10;
        // cette variable servira à translater i dans cos(asin(...))
        float t = -0.5 * bodyL;
        // dessine le corps
        for (int i = 0; i < bodyL; ++i){
          
            float wid = widthMin + 0.75 * widthMin * cos(asin( (t+i) / (bodyL+t)));
            float bre = breadthMin + 0.75 * breadthMin * cos(asin( (t+i) / (bodyL+t)));
            float alphaW = 0.25 * widthMin * noise((i+t) / 2.);
            float alphaB = 0.25 * breadthMin * noise((i+t) / 2.); 
            float hei1 = i * h / nbLayer;
            float alphaH1 = 0.02 * h * noise((i-1)/5.);
            float alphaH2 = 0.02 * h * noise(i/5.);
            // (i+1.15) pour que l'on ne puisse pas voir a travers la momie
            float hei2 = (i+1.15) * h / nbLayer;
            
            for (int j = 0; j < DETAIL; ++j){

                float abs1 = cos( j * 2 *PI / DETAIL);
                float abs2 = cos( (j+1) * 2 * PI / DETAIL);
                float ord1 = sin( j * 2 * PI / DETAIL);
                float ord2 = sin( (j+1) * 2 * PI / DETAIL);
                float re = RED_BODY + D_RED_BODY * noise(j*j / 8., i / 6.);
                float gr = GREEN_BODY + D_GREEN_BODY * noise(i*i / 8., j / 6.);
                float bl = BLUE_BODY + D_BLUE_BODY * noise(i*j*i / 8., j*i*j / 6.);;
                PShape part = createShape();
                
                part.beginShape(QUAD);
                part.noStroke();
                part.fill(re, gr, bl);
                
                part.vertex(abs1 * wid + alphaW, ord1 * bre + alphaB, hei1 + j * alphaH1 / DETAIL);
                part.vertex(abs1 * wid + alphaW, ord1 * bre + alphaB, hei2 + j * alphaH1 / DETAIL);
                part.vertex(abs2 * wid + alphaW, ord2 * bre + alphaB, hei2 + j * alphaH2 / DETAIL);
                part.vertex(abs2 * wid + alphaW, ord2 * bre + alphaB, hei1 + j * alphaH2 / DETAIL);
                
                part.endShape();
                momie.addChild(part);
                
            }
            
        }
        widthMin = 0.4 * w;
        breadthMin = 0.4 * b;
        t = -nbLayer + nbLayer / 10.;
        // dessine la tete
        for(int i = bodyL; i <= nbLayer; ++i){
          
            float wid = widthMin + 0.55 * widthMin * cos(asin( (t+i) / (bodyL+t)));
            float bre = breadthMin + 0.55 * breadthMin * cos(asin( (t+i) / (bodyL+t)));
            float alphaW = 0.1 * widthMin * noise((i+t) / 2.);
            float alphaB = 0.1 * breadthMin * noise((i+t) / 2.);
            float hei1 = (i-0.2) * h / nbLayer;
            float alphaH1 = 0.01 * h * noise((i-1)/5.);
            float alphaH2 = 0.01 * h * noise(i/5.);
            float hei2 = (i+1.2) * h / nbLayer;
               
            for (int j = 0; j < DETAIL; ++j){

                float abs1 = cos( j * 2 * PI / DETAIL);
                float abs2 = cos( (j+1) * 2 * PI / DETAIL);
                float ord1 = sin( j * 2 * PI / DETAIL);
                float ord2 = sin( (j+1) * 2 * PI /DETAIL);
                float re = RED_BODY + D_RED_BODY * noise(i, j);
                float gr = GREEN_BODY + D_GREEN_BODY * noise((i*i-j)/2., (j*j+i)/2.);
                float bl = BLUE_BODY;  
                PShape part = createShape();
                
                part.beginShape(QUAD);
                part.noStroke();
                part.fill(re, gr, bl);
                part.vertex(abs1 * wid + alphaW, ord1 * bre + alphaB, hei1 + j * alphaH1 / DETAIL);
                part.vertex(abs1 * wid + alphaW, ord1 * bre + alphaB, hei2 + j * alphaH1 / DETAIL);
                part.vertex(abs2 * wid + alphaW, ord2 * bre + alphaB, hei2 + j * alphaH2 / DETAIL);
                part.vertex(abs2 * wid + alphaW, ord2 * bre + alphaB, hei1 + j * alphaH2 / DETAIL);
                
                part.endShape();
                momie.addChild(part);
                
            }            
        }
        float eye_r = b/4.;
        float eye_tr_x = w/4.;
        float eye_tr_y = breadthMin + 0.1 * breadthMin;
        float eye_h = 9*h/10.;
        
        PShape leye = eye(eye_r, true);
        leye.translate(eye_tr_x, eye_tr_y, eye_h);
        this.momie.addChild(leye);
        
        PShape reye = eye(eye_r, false);
        reye.translate(-eye_tr_x , eye_tr_y, eye_h);
        this.momie.addChild(reye);
        
        
        float arm_width = w/2.25;
        float arm_breadth = b/2.25;
        float arm_length= h/4.;
        float arm_tr_x = 9*w/10.;
        float arm_tr_z = b/3.;
        float arm_h = bodyL*h/nbLayer;
        
        PShape larm = arm(arm_width, arm_breadth, -arm_length);
        larm.translate(arm_tr_x, arm_h,arm_tr_z);  
        larm.rotateX(PI/2.);
        this.momie.addChild(larm);
        
        PShape rarm = arm(arm_width, arm_breadth, -arm_length);
        rarm.translate(-arm_tr_x, arm_h,arm_tr_z);
        rarm.rotateX(PI/2.);
        this.momie.addChild(rarm);
        
        
        float hand_s = b / 15.;
        float hand_tr_x = 35. * w / 30.;
        float hand_tr_z = h/7.5;
        float hand_h = bodyL*h/nbLayer-b/4.+b/15.;
        
        
        PShape rHand = loadShape("src/hand/hand1.obj");
        rHand.setFill(color(RED_BODY, GREEN_BODY, BLUE_BODY));
        rHand.scale(hand_s);
        rHand.translate(hand_tr_x, hand_h, hand_tr_z);
        rHand.rotateX(PI/2.);
        rHand.rotateZ(-PI);
        this.momie.addChild(rHand);
        
        PShape lHand = loadShape("src/hand/hand2.obj");
        lHand.setFill(color(RED_BODY, GREEN_BODY, BLUE_BODY));
        lHand.scale(hand_s);
        lHand.translate(-hand_tr_x, hand_h, hand_tr_z);
        lHand.rotateX(PI/2.);
        lHand.rotateZ(-PI);
        this.momie.addChild(lHand);  
    }
    
    public void drawMomie(){
      // Dessine la momie
      rotateZ(this.r);
      shape(this.momie);

    }
    
    public void moveMomie(){
      /** Met à jour la position de la momie dans le labyrinthe où sa direction
        Si la momie peut avancer tout droit dans le labyrinthe sans recontrer de mur elle avance
        Sinon elle change de direction où elle peut avancer
      **/
      ArrayList<Integer> valid_move= new ArrayList<>();
      if ( this.verifCoord(this.x+dirX, this.y+dirY) && this.labyrinthe[this.y+dirY][this.x+dirX] != '#')
        valid_move.add(0);
      if ( this.verifCoord(this.x-this.dirY, this.y+this.dirX) && this.labyrinthe[this.y+dirX][this.x-dirY] != '#')
        // changement de direction vers la droite
        valid_move.add(1);
      if ( this.verifCoord(this.x+this.dirY, this.y-this.dirX) && this.labyrinthe[this.y-dirX][this.x+dirY] != '#')
        // changement de direction vers la gauche
        valid_move.add(-1);

      if (valid_move.size() == 0){
        this.dirX = -this.dirX;
        this.dirY = -this.dirY;
        this.rotate = 2;
      } else {
          int rd = (int) random(valid_move.size());
          if (valid_move.get(rd) == 0){
            this.x += this.dirX;
            this.y += this.dirY;
            this.rotate = 0;
          } else if (valid_move.get(rd) == 1){
            int tmp = -this.dirY;
            this.dirY = this.dirX;
            this.dirX = tmp;
            this.rotate = 1;
          } else if (valid_move.get(rd) == -1){
            int tmp = this.dirY;
            this.dirY = -this.dirX;
            this.dirX = tmp;
            this.rotate = -1;        
          } 
      }
    }
    
    public void updateMomie(){
        /** met à jour la postion de la momie dans l'espace où la rotation de la momie
           Si la momie n'avance pas, elle se tourne dans la bonne direction
        **/
        if (this.rotate != 0)
          this.r = this.r % ( 2. * PI ) + PI / ( 2. * (fps-1) ) * this.rotate;
        else{
          this.vx += dirX / (float)(fps-1);
          this.vy += dirY / (float)(fps-1);
        }
          
    }
    
    private boolean verifCoord(int x, int y){
      /** On verifie que les coordonnées passées en argument sont des coordonnées valides dans le labyrinthe 
          et qu'elles sont différents de celle du joueur
      **/
      int size = this.labyrinthe.length;
      if ( x < size && y < size && x >= 0 && y >= 0 && (x != posX || y != posY))
        return true;
      else
        return false;
    }
    
    public float getX(){
      /** renvoie l'abscisse de la momie dans l'espace **/
      return this.vx;  
    }
    
    public float getY(){
      /** renvoie l'ordonnée de la momie dans l'espace **/
      return this.vy;  
    } 
    
    public int getRealX(){
        return this.x;  
    }
    
    public int getRealY(){
        return this.y;  
    }
   
}

PShape arm(float w, float b, float h){
        
      float widthMin = w / 3.;
      float breadthMin = b / 3.;
        
      int nbLayer = DETAIL / 2 - DETAIL / 8;

      // Le nombre de banderelle du corps de la momie
      int bodyL = nbLayer / 2;
      // cette variable servira à translater i dans cos(asin(...))
      float t = -nbLayer / 4.; 
      PShape obj = createShape(GROUP);
      for (int i = 0; i < bodyL; ++i){
            
            float wid1 = widthMin + 1.5 * widthMin * cos(asin( (t+i) / (bodyL+t)));
            float wid2 = widthMin + 1.5 * widthMin * cos(asin( (t+i+1) / (bodyL+t)));
            float bre1 = breadthMin + 1.5 * breadthMin * cos(asin( (t+i) / (bodyL+t)));
            float bre2 = breadthMin + 1.5 * breadthMin * cos(asin( (t+i+1) / (bodyL+t)));
            float alphaW1 = 0.5 * widthMin * noise((i+t) / 10.);
            float alphaB1 = 0.5 * breadthMin * noise((i+t) / 10.);
            float alphaW2 = 0.5 * widthMin * noise((i+t+1) / 10.);
            float alphaB2 = 0.5 * breadthMin * noise((i+t+1) / 10.);
            float hei1 = (i-0.2) * h / nbLayer;
            float alphaH1 = 0.01 * h * noise((i-1)/5.);
            float alphaH2 = 0.01 * h * noise(i/5.);
            float hei2 = (i+1.2) * h / nbLayer;
            
        for (int j = 0; j < DETAIL; ++j){
              
            float abs1 = cos( j * 2 * PI / DETAIL);
            float abs2 = cos( (j+1) * 2 * PI / DETAIL);
            float ord1 = sin( j * 2 * PI / DETAIL);
            float ord2 = sin( (j+1) * 2 * PI / DETAIL);
            float re = RED_BODY + D_RED_BODY * noise(i, j);
            float gr = GREEN_BODY + D_GREEN_BODY * noise((i*i-j)/2., (j*j+i)/2.);
            float bl = BLUE_BODY;
            PShape part1 = createShape();
            part1.beginShape(QUAD);
            part1.noStroke();
            part1.fill(re, gr, bl);
            part1.vertex(abs1 * wid1 + alphaW1, ord1 * bre1 + alphaB1, hei1 + j * alphaH1 / DETAIL);
            part1.vertex(abs1 * wid2 + alphaW2, ord1 * bre2 + alphaB2, hei2 + j * alphaH1 / DETAIL);
            part1.vertex(abs2 * wid2 + alphaW2, ord2 * bre2 + alphaB2, hei2 + j * alphaH2 / DETAIL);
            part1.vertex(abs2 * wid1 + alphaW1, ord2 * bre1 + alphaB1, hei1 + j * alphaH2 / DETAIL);
            part1.endShape();
            obj.addChild(part1);                
            PShape part2 = createShape();
            part2.beginShape(QUAD);
            part2.noStroke();
            part2.fill(re, gr, bl);
            part2.vertex(abs1 * wid1 + alphaW1, ord1 * bre1 + alphaB1, h/2. + hei1 + j * alphaH1 / DETAIL);
            part2.vertex(abs1 * wid2 + alphaW2, ord1 * bre2 + alphaB2, h/2. + hei2 + j * alphaH1 / DETAIL);
            part2.vertex(abs2 * wid2 + alphaW2, ord2 * bre2 + alphaB2, h/2. + hei2 + j * alphaH2 / DETAIL);
            part2.vertex(abs2 * wid1 + alphaW1, ord2 * bre1 + alphaB1, h/2. + hei1 + j * alphaH2 / DETAIL);
            part2.endShape();
            obj.addChild(part2);

          }
      }
       
      PShape shoulder = createShape();
      shoulder.beginShape(TRIANGLE_FAN);
      shoulder.noStroke();
      shoulder.fill(150, 125, 0);
      shoulder.vertex(0, 0, 0);
      for (int i = 0; i <= DETAIL; ++i){
        float abs = widthMin * cos(2 * i * PI / DETAIL);
        float ord = breadthMin * sin(2 * i * PI / DETAIL);
        float re = RED_BODY + D_RED_BODY * noise(i);
        float gr = GREEN_BODY + D_GREEN_BODY * noise((i*i)/2., (i)/2.);
        float bl = BLUE_BODY;
        shoulder.fill(re, gr, bl);
        shoulder.vertex( abs, ord, 0); 
      }
      shoulder.endShape();
      obj.addChild(shoulder);
      return obj;
}

PShape eye(float r, boolean left){
    PShape eye = createShape(GROUP);
    sphereDetail(8);
    PShape glb = createShape(SPHERE, r);
    glb.setFill(color(RED_GLB, GREEN_GLB, BLUE_GLB));
    glb.setStroke(color(RED_GLB, GREEN_GLB, BLUE_GLB));
    eye.addChild(glb);
    sphereDetail(12);
    PShape pup = createShape(SPHERE, 0.4 * r);
    if (left)
      pup.translate(-r/6., r/2., -r/4.);
    else
      pup.translate(r/6., r/2., -r/4.);
    pup.setFill(color(RED_PUPIL, GREEN_PUPIL, BLUE_PUPIL));
    pup.setStroke(color(RED_PUPIL, GREEN_PUPIL, BLUE_PUPIL));
    eye.addChild(pup);
    
    return eye;
}

void initTabMomies(){
  momies = new Momie[tabLab.length];
  CUR_MOMIE = 0;
}
