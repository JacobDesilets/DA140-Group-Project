import java.util.Map;

PImage p1idle;
PImage p1walk;
PImage p1jump;
PImage p1duck;
PImage p1attack;

PImage p2idle;
PImage p2walk;
PImage p2jump;
PImage p2duck;
PImage p2attack;

HashMap<Character, Boolean> input = new HashMap<Character, Boolean>();


Player player1, player2;
Player[] players;

Platform p1, p2, p3;
Platform[] platforms;

char[] possibleInputs = {'w', 'a', 's', 'd', ' ', '-', '_', '=', '+', '|'};

void setup()
{
  background(0);
  colorMode(HSB, 255);
  imageMode(CENTER);
  size (800,500);
  
  p1idle = loadImage("art/char1_idle.png");
  p1walk = loadImage("art/char1_walk.png");
  p1jump = loadImage("art/char1_jump.png");
  p1duck = loadImage("art/char1_duck.png");
  p1attack = loadImage("art/char1_attack.png");
  
  p1idle.resize(64,64);
  p1walk.resize(64,64);
  p1jump.resize(64,64);
  p1duck.resize(64,64);
  p1attack.resize(64,64);
  
  p2idle = loadImage("art/char2_idle.png");
  p2walk = loadImage("art/char2_walk.png");
  p2jump = loadImage("art/char2_jump.png");
  p2duck = loadImage("art/char2_duck.png");
  p2attack = loadImage("art/char2_attack.png");
  
  p2idle.resize(64,64);
  p2walk.resize(64,64);
  p2jump.resize(64,64);
  p2duck.resize(64,64);
  p2attack.resize(64,64);
  
  //stage1 = new Stage(500,20, 0, 125,100);
  player1 = new Player(p1idle, p1walk, p1jump, p1duck, p1attack, true);
  player1.center.x = width/2;
  
  player2 = new Player(p2idle, p2walk, p2jump, p2duck, p2attack, false);
  player2.center.x = width/2 + 50;
  
  players = new Player[]{player1, player2};
  
  for (char c : possibleInputs) {
    input.put(c, false);
  }
  
  p1 = new Platform(20, height-50, 500, 20, false);
  p2 = new Platform(20, height-200, 200, 20, true);
  p3 = new Platform(200, height-350, 200, 20, true);
  platforms = new Platform[]{p1, p2, p3};
}

void draw()
{  
   background(0);
   

   // UI
   text("Player 1: " + player1.damage, 50, 50);
   text("Player 2: " + player2.damage, 50, 100);
   
   for (Platform p : platforms) {
     p.display();
   }

   
   
   //player1.phaseThrough = false;
   //player2.phaseThrough = false;
   
   for(Player p : players) {
     p.input(input);
     p.display();
     
     p.update();
     for(Platform platform : platforms) {
       p.platformCollide(platform);
     }
     
   }
   
   // hit checks
   if(hitCheck(player1, player2) && player1.attacking) {
     float dir = player1.facingRight ? 0 : -PI;
     player2.takeDamage(0.1, dir);
   }
   
   if(hitCheck(player2, player1) && player2.attacking) {
     float dir = player2.facingRight ? 0 : -PI;
     player1.takeDamage(0.1, dir);
   }
    
   playerReset(player1);
   playerReset(player2);

}

boolean hitCheck(Player plyr1, Player plyr2) {
  return( plyr1.fist.x > (plyr2.center.x -24 ) && plyr1.fist.x < (plyr2.center.x + 24 ) && plyr1.fist.y > (plyr2.center.y -24 ) && plyr1.fist.y < (plyr2.center.y + 24 ));
}


//Displays player percent
void displayStats( Player ply ) { 
  fill (0,0,255);
  textSize(32);
 
  if(ply.player1) {
    text("P1: " + round(player1.damage * 10) * .1 + "%", (width/2 - 155), 30); 
  } else {
    text("P2: " + round(player2.damage * 10) * .1 + "%", (width/2 + 45), 30); 
  }
}

//Displays current player stocks as circles
void displayStocks( Player ply) {

  int stockShift;
  
  if(ply.player1) {
    fill (0,255,255);
    stockShift = -50;
  } else {
    fill (150,255,255);
    stockShift = 50;
  }
  
  if (ply.stocks == 3)
    for (int i = 0; i < 3; i++) circle(((width/2 + stockShift) + i*stockShift), 50, 25);
  else if (ply.stocks == 2)
    for (int i = 0; i < 2; i++) circle(((width/2 + stockShift) + i*stockShift), 50, 25);
  else if (ply.stocks == 1)
    for (int i = 0; i < 1; i++) circle(((width/2 + stockShift) + i*stockShift), 50, 25);
  else
    print("Dead"); 
}

//Resets player once they have fallen off the screem
void playerReset( Player ply) {
  if(isOffStage(ply)) {     
    ply.stocks--;  
    if (ply.stocks > 0) {     
      ply.damage = 1;
      ply.center.x = width/2;
      ply.center.y = height/2;  
    }
  }
}


void playerOnPlatformCheck(Player plyr, Platform pltfm) {
  if(pltfm.collisionCheck(plyr.feet)) {
     if(!plyr.phaseThrough || !pltfm.fallable) {
       plyr.vel.y = 0;
       plyr.center.y = pltfm.y - 32;
       plyr.grounded = true;
     }
  }
}

//Edits player attributes based on if it is on platform or not
void onPlatform ( Stage stg, Player ply ) { 
  if(isOnPlatform(stg, ply)) {                                       // Checks if on platform
    if(ply.vel.y > 0 && ply.feet.y < (height - stg.translateY)) {    // Player is moving downard when landing on platform
      ply.vel.y = 0;                                                 // Stops players vertical movement 
      ply.grounded = true;
    }
  }
}

//Is player within platform bounds
boolean isOnPlatform( Stage stg, Player ply) {
  println(ply.feet.x > (width/2-stg.sWidth/2) && (ply.feet.x < (width/2+stg.sWidth/2)) && (ply.feet.y == height - stg.translateY));
  return (ply.feet.x > (width/2-stg.sWidth/2) && (ply.feet.x < (width/2+stg.sWidth/2)) && (ply.feet.y == height - stg.translateY));
}

//Is player off screen 
boolean isOffStage( Player ply ) {
  return (ply.center.y > height+32);
}


// keep track of which keys are pressed in the kbInputs hashmap
void keyPressed() {
  char keyval = key;
  if (key == CODED) {
    if (keyCode == UP) { keyval = '-';}
    if (keyCode == DOWN) { keyval = '_';}
    if (keyCode == RIGHT) { keyval = '=';}
    if (keyCode == LEFT) { keyval = '+';}
    if (keyCode == CONTROL) { keyval = '|';}
  }
  
  if (arrayContains(possibleInputs, keyval)) {
    input.put(keyval, true);
  }
}

void keyReleased() {
  char keyval = key;
  if (key == CODED) {
    if (keyCode == UP) { keyval = '-';}
    if (keyCode == DOWN) { keyval = '_';}
    if (keyCode == RIGHT) { keyval = '=';}
    if (keyCode == LEFT) { keyval = '+';}
    if (keyCode == CONTROL) { keyval = '|';}
  }
  if (arrayContains(possibleInputs, keyval)) {
    input.put(keyval, false);
  }
}

// Returns true if char array pi contains char i, false otherwise
boolean arrayContains(char[] pi, char i) {
  // Use linear search because pi will usually be small
  for (char c : pi) {
    if (c == i) {
      return true;
    }
  }
  return false;
}
  
  
