
class Player {
  PVector feet, center, vel, acc;
  PImage idle, walk, jump, duck, attack;
  float damage;
  boolean player1;
  boolean grounded;
  
  float MOVEMENT_MULTIPLIER = 0.95;
  
  float JUMP_SPEED = 2;
  float MOVE_SPEED = 3;
  
  char U, D, R, L, A;
  
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
    
    feet = new PVector(0, 0);
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
  }
  
  void input(HashMap<Character, Boolean> inputs) {
    if(inputs.get(U) && grounded) {
      // jump
      PVector f = PVector.fromAngle(HALF_PI);
      f.setMag(JUMP_SPEED);
      applyForce(f);
      
      state = 2;
    }
    if(inputs.get(D)) {
      // crouch?
      previousState = state;
      state = 3;
    } else if(state == 3 && !inputs.get(D)) {
      state = previousState;
    }
    if(inputs.get(R)) {
      // move right
      PVector f = PVector.fromAngle(0);
      f.setMag(MOVE_SPEED);
      applyForce(f);
      
      if(grounded) { state = 1; }
      else { state = 2; }
      
    }
    if(inputs.get(L)) {
      // move left
      PVector f = PVector.fromAngle(PI);
      f.setMag(MOVE_SPEED);
      applyForce(f);
      
      if(grounded) { state = 1; }
      else { state = 2; }
    }
    if(inputs.get(A)) {
      // attack
      
      state = 4;
    }
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
  }
  
  void applyForce(PVector force) {
    acc.add(force);
  }
  
  void update() {
    if(!grounded) {
      applyForce(new PVector(0, 2));
    }
    
    acc.mult(damage);
    vel.mult(MOVEMENT_MULTIPLIER);
    vel.add(acc);
    center.add(vel);
    
    acc.mult(0);
  }
}
