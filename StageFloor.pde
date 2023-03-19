class Platform {
  float x, y, w, h;
  boolean fallable, playerTouching;
  PImage floor;
  
  Platform(PImage floor, float x, float y, float w, float h, boolean fallable) {
    this.floor = floor;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.fallable = fallable;
    playerTouching = false;
   
  }
  
  void display() {
    noStroke();
    if(fallable) {
      fill(255, 255, 255);
    } else {
      fill(0, 0, 255);
    }
    
    //rect(x, y, w, h);
    image(floor,x+w/2,y+h/2);
  }
  
  boolean collisionCheck(PVector point) {
    return ((point.x >= x && point.x <= (x+w)) && (point.y >= y-1 && point.y <= (y+h)));
  }
  
  boolean overEdge(PVector point) {
    return (point.x >= x && point.x <= (x+w));
  }
}
