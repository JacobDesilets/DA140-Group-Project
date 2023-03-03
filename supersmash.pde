import java.util.Map;

PImage p1idle;
PImage walk;
PImage jump;
PImage duck;
PImage attack;

HashMap<Character, Boolean> input = new HashMap<Character, Boolean>();


Player player1;
Stage stage1;
Stage stage2 = new Stage(125,10, 150, 250,100);
Stage stage3 = new Stage(125,10, -150, 250,100);
Stage stage4 = new Stage(125,10, 0, 375,100);

Platform p1, p2, p3;

char[] possibleInputs = {'w', 'a', 's', 'd', ' '};

void setup()
{
  background(0);
  colorMode(HSB, 255);
  imageMode(CENTER);
  size (800,500);
  
  p1idle = loadImage("art/char1_idle.png");
  walk = loadImage("art/char1_walk.png");
  jump = loadImage("art/char1_jump.png");
  duck = loadImage("art/char1_duck.png");
  attack = loadImage("art/char1_attack.png");
  
  p1idle.resize(64,64);
  walk.resize(64,64);
  jump.resize(64,64);
  duck.resize(64,64);
  attack.resize(64,64);
  
  stage1 = new Stage(500,20, 0, 125,100);
  player1 = new Player(p1idle, walk, jump, duck, attack, true);
  player1.center.x = width/2;
  
  for (char c : possibleInputs) {
    input.put(c, false);
  }
  
  p1 = new Platform(20, height-50, 500, 20);
  p2 = new Platform(20, height-200, 200, 20);
  p3 = new Platform(200, height-350, 200, 20);
}

void draw()
{  
   background(0);
   //stage1.display();
   //stage2.display();
   //stage3.display();
   //stage4.display();
   p1.display();
   p2.display();
   p3.display();
   
   
   player1.phaseThrough = false;
   
   player1.input(input);
   player1.update();
   player1.display();
   
   player1.grounded = false;
   
   //Function calls for each platform
   //onPlatform (stage1, player1);a
   playerOnPlatformCheck(player1, p1);
   playerOnPlatformCheck(player1, p2);
   playerOnPlatformCheck(player1, p3);

}

void playerOnPlatformCheck(Player plyr, Platform pltfm) {
  if(pltfm.collisionCheck(plyr.feet)) {
     if(!plyr.phaseThrough) {
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

// keep track of which keys are pressed in the kbInputs hashmap
void keyPressed() {
  if (arrayContains(possibleInputs, key)) {
    input.put(key, true);
  }
}

void keyReleased() {
  if (arrayContains(possibleInputs, key)) {
    input.put(key, false);
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
  
  
