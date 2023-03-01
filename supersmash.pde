Stage stage1 = new Stage(500,20, 0, 125,100);
Stage stage2 = new Stage(125,10, 150, 250,100);
Stage stage3 = new Stage(125,10, -150, 250,100);
Stage stage4 = new Stage(125,10, 0, 375,100);
Player player1;

void setup()
{
  background(0);
  colorMode(HSB, 255);
  size (800,500);
}

void draw()
{  
   stage1.display();
   stage2.display();
   stage3.display();
   stage4.display();
   player1.display();
   
   //Function calls for each platform
   onPlatform (stage1, player1);
   onPlatform (stage2, player1);
   onPlatform (stage3, player1);
   onPlatform (stage4, player1);
}

// Edits player attributes based on if it is on platform or not
void onPlatform ( Stage stg, Player ply ) { 
  if(isOnPlatform(stg, ply)) {                                       // Checks if on platform
    if(ply.vel.y > 0 && ply.feet.y < (height - stg.translateY)) {    // Player is moving downard when landing on platform
      ply.vel.y = 0;                                                 // Stops players vertical movement 
      ply.onGround = true;
    }
  }
}

//Is player within platform bounds
boolean isOnPlatform( Stage stg, Player ply) {
  
    
  
  player1.feet.x = 25;
   player1.feet.y = 25;
  return (ply.feet.x > (width-stg.sWidth/2) && (ply.feet.x < (width+stg.sWidth/2))         );
}
  
  
