class Particle {
  float life, r;
  int hue, c;
  PVector pos, vel, acc;
  float multiplier, maxVel;
  float GRAVITY = 0.2;

  Particle(float x, float y, float r, int hue) {
    pos = new PVector(x, y);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);

    multiplier = 0.95;

    this.r = r;
    this.hue = hue;
    
    c = color(this.hue, 255, 255);

    life = 255;

  }

  void display() {
    c = color(hue, life, life);
    noStroke();
    fill(c);

    ellipse(pos.x, pos.y, 2*r, 2*r);
  }
  
  void update() {
    life -= 1.0;
    
    applyForce(new PVector(0, GRAVITY));
    vel.add(acc);
    vel.mult(multiplier);
    pos.add(vel);
    

    acc.mult(0);
  }
  
  void applyForce(PVector force) {
    acc.add(force);
  }
}


// Handles spawning, despawning, and rendering of particles
class ParticleSystem {
  ArrayList<Particle> particles;

  ParticleSystem() {
    particles = new ArrayList<Particle>();
  }

  void createParticles(float x, float y, int count, int hue, float dir) {
    for (int i = 0; i < count; i++) {
      // particles have random size and color
      Particle p = new Particle(x, y, random(5), hue);
      // and fly in random directions at random speeds
      p.applyForce(PVector.fromAngle(random(dir - QUARTER_PI, dir + QUARTER_PI) - PI).setMag(random(10, 20)));
      particles.add(p);
    }
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();
      p.display();
      // Dereference particles once their life runs out
      if (p.life <= 0) {
        particles.remove(i);
      }
    }
  }
}
