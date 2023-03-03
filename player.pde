
class Player {
  PVector feet, center, vel, acc;
  PImage idle, walk, jump, duck, attack;
  float damage;
  boolean player1;
  boolean grounded;
  
  float MOVEMENT_MULTIPLIER = 0.9;
  float GRAVITY = 1;
  
  float JUMP_SPEED = 30;
  float MOVE_SPEED = 1;
  
  char U, D, R, L, A;
  
  boolean moving, attacking, phaseThrough, jumpReleased;
  
  int state, previousState; // 0: idle
                            // 1: walking
                            // 2: jumping
                            // 3: ducking
                            // 4: attacking
  
  Player(PImage idle, PImage walk, PImage jump, PImage duck, PImage attack, boolean player1) {
    // imageMode(CENTER);
    this.idle = idle;
    this.walk = walk;
    this.jump = jump;
    this.duck = duck;
    this.attack = attack;
    this.player1 = player1;
    
    feet = new PVector(0, 32);
    center = new PVector(0, 0);
    acc = new PVector(0, 0);
    vel = new PVector(0, 0);
    
    if(this.player1) {
      U = 'w';
      D = 's';
      R = 'd';
      L = 'a';
      A = ' ';
    } else {
      // Input handler needs to map these
      U = '-';  // up arrow
      D = '_';  // down arrow
      R = '=';  // right arrow
      L = '+';  // left arrow
      A = '|';  // right ctrl
    }
    
    grounded = true;
    damage = 1.0;
    
    phaseThrough = false;
    jumpReleased = true;
  }
  
  void input(HashMap<Character, Boolean> inputs) {
    moving = false;
    attacking = false;
    
    if(inputs.get(U) && grounded) {
      // jump
      
      if(jumpReleased) {
        PVector f = PVector.fromAngle(-HALF_PI);
        f.setMag(JUMP_SPEED);
      
        applyForce(f);
      
        moving = true;
        state = 2;
        jumpReleased = false;
      }
    }
    
    if (!inputs.get(U)) { jumpReleased = true; }
      
    if(inputs.get(D)) {
      // crouch?
      moving = true;
      phaseThrough = true;
      state = 3;
    } else if(state == 3 && !inputs.get(D)) {
      state = 0;
    }
    if(inputs.get(R)) {
      // move right
      PVector f = PVector.fromAngle(0);
      f.setMag(MOVE_SPEED);
      applyForce(f);
      moving = true;
      state = 1;
    }
    if(inputs.get(L)) {
      // move left
      PVector f = PVector.fromAngle(PI);
      f.setMag(MOVE_SPEED);
      applyForce(f);
      moving = true;
      state = 1;
    }
    if(inputs.get(A)) {
      // attack
      moving = true;
      attacking = true;
      state = 4;
    }
    
    if(!grounded && !attacking) { state = 2; }
    else if (!moving) { state = 0; }
  }
  
  void display() {
    
    
    if(state == 0) {  // Idle
      image(idle, center.x, center.y);
    } else if (state == 1) {  // Walk
      image(walk, center.x, center.y);
    } else if (state == 2) {  // Jump
      image(jump, center.x, center.y);
    } else if (state == 3) {  // Duck
      image(duck, center.x, center.y);
    } else if (state == 4) {  // Attack
      image(attack, center.x, center.y);
    } 
    
    fill(128, 255, 255);
    ellipse(feet.x, feet.y, 5, 5);
  }
  
  void applyForce(PVector force) {
    acc.add(force);
  }
  
  void update() {
    //println(grounded);
    
    if(!grounded) {
      applyForce(new PVector(0, GRAVITY));
    }
    
    acc.mult(damage);
    vel.mult(MOVEMENT_MULTIPLIER);
    vel.add(acc);
    center.add(vel);
    feet.x = center.x;
    feet.y = center.y + 32;
    
    acc.mult(0);
  }
}
