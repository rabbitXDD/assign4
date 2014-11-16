Ship ship;
PowerUp ruby;
Bullet[] bList;
Laser[] lList;
Alien[] aList;

//Game Status
final int GAME_START   = 0;
final int GAME_PLAYING = 1;
final int GAME_PAUSE   = 2;
final int GAME_WIN     = 3;
final int GAME_LOSE    = 4;
int status;              //Game Status
int point;               //Game Score
int expoInit;            //Explode Init Size
int countBulletFrame;    //Bullet Time Counter
int bulletNum;           //Bullet Order Number

/*--------Put Variables Here---------*/
int ix = 50;
int iy = 50;
int spacingX = 40;
int spacingY = 50;
int circlesInRow = 12;
int total = 53;
int life =3;
int deadAlien = 0;
int countLaserFrame=0;
int laserNum = 0;

void setup() {

  status = GAME_START;

  bList = new Bullet[30];
  lList = new Laser[30];
  aList = new Alien[100];

  size(640, 480);
  background(0, 0, 0);
  rectMode(CENTER);

  ship = new Ship(width/2, 460, 3);
  ruby = new PowerUp(int(random(width)), -10);

  reset();
}

void draw() {
  background(50, 50, 50);
  noStroke();

  switch(status) {

  case GAME_START:
    reset();
    /*---------Print Text-------------*/
    textAlign(CENTER);
    textSize(60);
    fill(95, 194, 226);
    text("GALIXIAN", width/2, 240);
    textSize(20);
    text("Press ENTER to Start", width/2, 280); // replace this with printText
    /*--------------------------------*/
    break;
  case GAME_PLAYING:
    background(50, 50, 50);

    drawHorizon();
    drawScore();
    drawLife();
    ship.display(); //Draw Ship on the Screen
    drawAlien();
    drawBullet();
    drawLaser();
    checkRubyDrop(point);
    checkRubyHit();
    /*---------Call functions---------------*/


    checkAlienDead();/*finish this function*/
    checkShipHit();  /*finish this function*/
    alienShoot(countLaserFrame);
    checkWin_Lose();
    countLaserFrame+=1;
    countBulletFrame+=1;
    break;

  case GAME_PAUSE:
    /*---------Print Text-------------*/
    textAlign(CENTER);
    textSize(40);
    fill(95, 194, 226);
    text("PAUSE", width/2, 240);
    textSize(20);
    text("Press ENTER to Resume", width/2, 280);
    /*--------------------------------*/
    break;

  case GAME_WIN:
    /*---------Print Text-------------*/
    textAlign(CENTER);
    fill(95, 194, 226);
    textSize(40);
    text("WINNER", width/2, 310);
    textSize(20);
    text("SCORE:", width/2-10, 350);
    text(point, width/2+45, 350);
    /*--------------------------------*/
    winAnimate();
    break;

  case GAME_LOSE:
    loseAnimate();
    /*---------Print Text-------------*/
    textAlign(CENTER);
    fill(95, 194, 226);
    textSize(40);
    text("BOOOOM", width/2, 240);
    textSize(20);
    text("You are dead!!", width/2, 280);
    /*--------------------------------*/
    break;
  }
}

void drawHorizon() {
  stroke(153);
  line(0, 420, width, 420);
}

void drawScore() {
  noStroke();
  fill(95, 194, 226);
  textAlign(CENTER, CENTER);
  textSize(23);
  text("SCORE:"+point, width/2, 16);
}

void keyPressed() {
  if (status == GAME_PLAYING) {
    ship.keyTyped();
    cheatKeys();
    shootBullet(30);
  }
  statusCtrl();
}

/*---------Make Alien Function-------------*/
void alienMaker() {
  for(int i = 0; i < total ;i++){ 
      int row = int(i/circlesInRow);
      int col = int(i%circlesInRow);
      int x = ix + col*spacingX;
      int y = iy + row*spacingY;
      aList[i]= new Alien(x, y);
  }
}

void drawLife() {
  fill(230, 74, 96);
  text("LIFE:", 36, 455);
  /*---------Draw Ship Life---------*/
  for(int i = 0; i<life ; i++){
    ellipse(78+i*30,459,15,15);  
  }
}

void drawBullet() {
  for (int i=0; i<bList.length-1; i++) {
    Bullet bullet = bList[i];
    if (bullet!=null && !bullet.gone) { // Check Array isn't empty and bullet still exist
      bullet.move();     //Move Bullet
      bullet.display();  //Draw Bullet on the Screen
      if (bullet.bY<0 || bullet.bX>width || bullet.bX<0) {
        removeBullet(bullet); //Remove Bullet from the Screen
      }
    }
  }
}

void drawLaser() {
  for (int i=0; i<lList.length-1; i++) { 
    Laser laser = lList[i];
    if (laser!=null && !laser.gone) { // Check Array isn't empty and Laser still exist
      laser.move();      //Move Laser
      laser.display();   //Draw Laser
      if (laser.lY>480) {
        removeLaser(laser); //Remove Laser from the Screen
      }
    }
  }
}

void drawAlien() {
  for (int i=0; i<aList.length-1; i++) {
    Alien alien = aList[i];
    if (alien!=null && !alien.die) { // Check Array isn't empty and alien still exist
      alien.move();    //Move Alien
      alien.display(); //Draw Alien
      /*---------Call Check Line Hit---------*/
      checkLineHit(alien);
      /*--------------------------------------*/
    }
  }
}

/*--------Check Line Hit---------*/
void checkLineHit(Alien alien){
  if(alien.aY>=420){
    status=GAME_LOSE;
  }
}

/*---------Ship Shoot-------------*/
void shootBullet(int frame) {
  if ( key == ' ' && countBulletFrame>frame) {
    if (!ship.upGrade) {
      bList[bulletNum]= new Bullet(ship.posX, ship.posY, -3, 0);
      if (bulletNum<bList.length-2) {
        bulletNum+=1;
      } else {
        bulletNum = 0;
      }
    } 
    /*---------Ship Upgrade Shoot-------------*/
    else {
      bList[bulletNum]= new Bullet(ship.posX, ship.posY, -3, 0); 
      if (bulletNum<bList.length-2) {
        bulletNum+=1;
      } else {
        bulletNum = 0;
      }
      bList[bulletNum]= new Bullet(ship.posX, ship.posY, -3, 1); 
      if (bulletNum<bList.length-2) {
        bulletNum+=1;
      } else {
        bulletNum = 0;
      }
      bList[bulletNum]= new Bullet(ship.posX, ship.posY, -3, -1); 
      if (bulletNum<bList.length-2) {
        bulletNum+=1;
      } else {
        bulletNum = 0;
      }
    }
    countBulletFrame = 0;
  }
}

/*---------Check Alien Hit-------------*/
void checkAlienDead() {
  for (int i=0; i<bList.length-1; i++) {
    Bullet bullet = bList[i];
    for (int j=0; j<aList.length-1; j++) {
      Alien alien = aList[j];
      if (bullet != null && alien != null && !bullet.gone && !alien.die // Check Array isn't empty and bullet / alien still exist
      /*------------Hit detect-------------*/        ) {
        
        if(aList[j].aX - aList[j].aSize <= bList[i].bX && bList[i].bX <= aList[j].aX + aList[j].aSize &&
        aList[j].aY - aList[j].aSize <= bList[i].bY && bList[i].bY <= aList[j].aY + aList[j].aSize){
          removeBullet(bList[i]);
          removeAlien(aList[j]);
          point +=10;
          deadAlien++;
        }
      }
    }
  }
}

/*---------Alien Drop Laser-----------------*/
void alienShoot(int frame) {
      int i = int(random(0,53));
      if(frame%50==0){
        lList[laserNum]= new Laser(aList[i].aX , aList[i].aY);
          if (laserNum<lList.length-2) {
            laserNum+=1;
          } else {
            laserNum = 0;
          }
       }

}

/*---------Check Laser Hit Ship-------------*/
void checkShipHit() {
  for (int i=0; i<lList.length-1; i++) {
    Laser laser = lList[i];
    if (laser!= null && !laser.gone // Check Array isn't empty and laser still exist
    /*------------Hit detect-------------*/      ) {
      /*-------do something------*/
      if(ship.posX - ship.shipSize <= lList[i].lX && lList[i].lX <= ship.posX + ship.shipSize &&
      ship.posY - ship.shipSize <= lList[i].lY && lList[i].lY <= ship.posY + ship.shipSize){
        removeLaser(laser);
        life--;
      }
    }
  }
}

/*---------Check Win Lose------------------*/
void checkWin_Lose(){
    if(life==0){
      status=GAME_LOSE;
    }
    if(deadAlien==total){
      status=GAME_WIN;
    }
}

void winAnimate() {
  int x = int(random(128))+70;
  fill(x, x, 256);
  ellipse(width/2, 200, 136, 136);
  fill(50, 50, 50);
  ellipse(width/2, 200, 120, 120);
  fill(x, x, 256);
  ellipse(width/2, 200, 101, 101);
  fill(50, 50, 50);
  ellipse(width/2, 200, 93, 93);
  ship.posX = width/2;
  ship.posY = 200;
  ship.display();
}

void loseAnimate() {
  fill(255, 213, 66);
  ellipse(ship.posX, ship.posY, expoInit+200, expoInit+200);
  fill(240, 124, 21);
  ellipse(ship.posX, ship.posY, expoInit+150, expoInit+150);
  fill(255, 213, 66);
  ellipse(ship.posX, ship.posY, expoInit+100, expoInit+100);
  fill(240, 124, 21);
  ellipse(ship.posX, ship.posY, expoInit+50, expoInit+50);
  fill(50, 50, 50);
  ellipse(ship.posX, ship.posY, expoInit, expoInit);
  expoInit+=5;
}

/*---------Check Ruby Hit Ship-------------*/
void checkRubyDrop(int p){
  if(p==200){
    ruby.show = true;
    ruby.pX = int(random(width));
    ruby.pY = -10;
    }
  if (ruby.show) { // Check ruby still exist
      ruby.move();      //Move ruby
      ruby.display();   //Draw ruby
      //println("powerup");
      if (ruby.pY>480) {
        removeRuby(ruby); //Remove ruby from the Screen
      }
  }
}
void checkRubyHit(){
   if(ship.posX - ship.shipSize <= ruby.pX && ruby.pX <= ship.posX + ship.shipSize &&
      ship.posY - ship.shipSize <= ruby.pY && ruby.pY <= ship.posY + ship.shipSize){
        removeRuby(ruby);
        checkLevelUp();
    }
}
/*---------Check Level Up------------------*/
void checkLevelUp(){
    ship.upGrade = true;
}

/*---------Print Text Function-------------*/


void removeBullet(Bullet obj) {
  obj.gone = true;
  obj.bX = 2000;
  obj.bY = 2000;
}

void removeLaser(Laser obj) {
  obj.gone = true;
  obj.lX = 2000;
  obj.lY = 2000;
}

void removeAlien(Alien obj) {
  obj.die = true;
  obj.aX = 1000;
  obj.aY = 1000;
}

void removeRuby(PowerUp obj) {
  obj.show = false;
  obj.pX = 1000;
  obj.pY = 1000;
}

/*---------Reset Game-------------*/
void reset() {
  for (int i=0; i<bList.length-1; i++) {
    bList[i] = null;
    lList[i] = null;
  }

  for (int i=0; i<aList.length-1; i++) {
    aList[i] = null;
  }

  /*--------Init Variable Here---------*/
  point = 0;
  expoInit = 0;
  countBulletFrame = 30;
  countLaserFrame = 0;
  bulletNum = 0;
  deadAlien = 0;
  life = 3;

  /*-----------Call Make Alien Function--------*/
  alienMaker();

  ship.posX = width/2;
  ship.posY = 460;
  ship.upGrade = false;
  ruby.show = false;
  ruby.pX = int(random(width));
  ruby.pY = -10;
}

/*-----------finish statusCtrl--------*/
void statusCtrl() {
  if (key == ENTER) {
    switch(status) {

    case GAME_START:
      status = GAME_PLAYING;
      break;

      /*-----------add things here--------*/
    case GAME_PLAYING:
      status = GAME_PAUSE;
      break;
      
    case GAME_PAUSE:
      status = GAME_PLAYING;
      break;
      
    case GAME_WIN:
      reset();
      status = GAME_PLAYING;
      break;      
 
    case GAME_LOSE:
      reset();
      status = GAME_PLAYING;
      break;
    }
  }
}

void cheatKeys() {

  if (key == 'R'||key == 'r') {
    ruby.show = true;
    ruby.pX = int(random(width));
    ruby.pY = -10;
  }
  if (key == 'Q'||key == 'q') {
    ship.upGrade = true;
  }
  if (key == 'W'||key == 'w') {
    ship.upGrade = false;
  }
  if (key == 'S'||key == 's') {
    for (int i = 0; i<aList.length-1; i++) {
      if (aList[i]!=null) {
        aList[i].aY+=50;
      }
    }
  }
}
