
class Player {
  PVector feet, center, vel, acc, fist;
  PImage idle, walk, jump, duck, attack;
  float damage;
  boolean player1;
  boolean grounded;
  boolean facingRight;
  
  float MOVEMENT_MULTIPLIER = 0.9;
  float GRAVITY = 1;
  float ATTACK_COOLDOWN = 1000.0;
  
  float JUMP_SPEED = 30;
  float MOVE_SPEED = 1;
  
  int timer;
  
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
    fist = new PVector(0, 0);
    
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
    
    facingRight = true;
    timer = millis();
  }
  
  void takeDamage(float dmg, float dir) {
    damage += dmg;
    
    PVector knockback = PVector.fromAngle(dir);
    knockback.setMag(damage);
    applyForce(knockback);
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
      facingRight = true;
    }
    if(inputs.get(L)) {
      // move left
      PVector f = PVector.fromAngle(PI);
      f.setMag(MOVE_SPEED);
      applyForce(f);
      moving = true;
      state = 1;
      facingRight = false;
    }
    if(inputs.get(A)) {
      // attack
      if(checkTimer()) {
        timer = millis();
        moving = true;
        attacking = true;
        state = 4;
      }
    }
    
    if(!grounded && !attacking) { state = 2; }
    else if (!moving) { state = 0; }
  }
  
  boolean checkTimer() {
    
    int dt = millis() - timer;
    println(dt > ATTACK_COOLDOWN);
    return(dt > ATTACK_COOLDOWN);
  }
  
  void display() {
    
    pushMatrix();
    
    translate(center.x, center.y);
    if(!facingRight) { scale(-1, 1); }
    else { scale(1, 1); }
    
    if(state == 0) {  // Idle
      image(idle, 0, 0);
    } else if (state == 1) {  // Walk
      image(walk, 0, 0);
    } else if (state == 2) {  // Jump
      image(jump, 0, 0);
    } else if (state == 3) {  // Duck
      image(duck, 0, 0);
    } else if (state == 4 && attacking) {  // Attack
      image(attack, 0, 0);
    }
    
    
    
    fill(128, 255, 255);
    ellipse(0, 32, 5, 5);
    popMatrix();
    ellipse(fist.x, fist.y, 5, 5);
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
    fist.y = center.y;
    if(facingRight) { fist.x = center.x+32; }
    else { fist.x = center.x-32; }
    
    acc.mult(0);
  }
}
