import java.util.Map;
import java.text.DecimalFormat;

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

PImage fist;

HashMap<Character, Boolean> input = new HashMap<Character, Boolean>();

ParticleSystem ps;

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
  
  fist = loadImage("art/fist.png");
  fist.resize(32,32);
  
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
  player1 = new Player(p1idle, p1walk, p1jump, p1duck, p1attack, fist, true);
  player1.center.x = width/2;
  
  player2 = new Player(p2idle, p2walk, p2jump, p2duck, p2attack, fist, false);
  player2.center.x = width/2 + 50;
  
  players = new Player[]{player1, player2};
  
  for (char c : possibleInputs) {
    input.put(c, false);
  }
  
  p1 = new Platform(20, height-50, 500, 20, false);
  p2 = new Platform(20, height-200, 200, 20, true);
  p3 = new Platform(200, height-350, 200, 20, true);
  platforms = new Platform[]{p1, p2, p3};
  
  ps = new ParticleSystem();
}

void draw()
{  
   background(0);
   
   for (Platform p : platforms) {
     p.display();
   }

   for(Player p : players) {
     displayStocks(p);
     displayStats(p);
     p.input(input);
     p.display();
     
     p.update();
     for(Platform platform : platforms) {
       p.platformCollide(platform);
     }
     
     playerReset(p);
     
   }
   
   // hit checks
   if(hitCheck(player1, player2) && player1.attacking) {
     float dir = player1.facingRight ? 0 : -PI;
     player2.takeDamage(0.3, dir);
   }
   
   if(hitCheck(player2, player1) && player2.attacking) {
     float dir = player2.facingRight ? 0 : -PI;
     player1.takeDamage(0.3, dir);
   }
   
   displayWin(player1, player2);
   ps.run();
    

}

boolean hitCheck(Player plyr1, Player plyr2) {
  return( plyr1.fist.x > (plyr2.center.x -24 ) && plyr1.fist.x < (plyr2.center.x + 24 ) && plyr1.fist.y > (plyr2.center.y -24 ) && plyr1.fist.y < (plyr2.center.y + 24 ));
}


//Displays player percent
void displayStats( Player ply ) {
  DecimalFormat df = new DecimalFormat("#.##");
  fill (0,0,255);
  textSize(32);
  if(ply.player1) {
    text("P1: " + df.format(round(player1.damage * 10) - 10) + "%", (width/2 - 155), 30); 
  } else {
    text("P2: " + df.format(round(player2.damage * 10) - 10) + "%", (width/2 + 45), 30); 
  }
}

void displayWin( Player ply1, Player ply2 ){
  fill(0,0,255);
  textSize(32);
  
  if (ply1.stocks <= 0)
    text("Player 2 Wins!", width/2 - 100, height/2);
  if (ply2.stocks <= 0)
    text("Player 1 Wins!", width/2 - 100, height/2);
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
    ply.deathExplode();
    if (ply.stocks > 0) {     
      ply.damage = 1;
      ply.center.x = width/2;
      ply.center.y = height/2;  
    }
  }
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
  
  
