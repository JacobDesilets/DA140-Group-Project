//class Stage
//{
//  float sWidth;
//  float sHeight;
//  float translateX;
//  float translateY;
//  float divisions;
//  boolean isVisible = true;
  
//  Stage (float tempW, float tempY, float tempTransX, float tempTransY, float divs)
//  {
//    sWidth = tempW;
//    sHeight = tempY;
//    translateY = tempTransY;
//    translateX = tempTransX;
//    divisions = divs;
//  }
  
//  void display() 
//  {   
//      noStroke();
//      rect(((width*1/2) - (sWidth*1/2)) - translateX, height - translateY, sWidth, sHeight); 
//      //rect(width - translateX, height - translateY, sWidth, sHeight); 
      
//  }
//}


class Platform {
  float x, y, w, h;
  boolean fallable;
  
  Platform(float x, float y, float w, float h, boolean fallable) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.fallable = fallable;
  }
  
  void display() {
    noStroke();
    fill(0, 0, 255);
    rect(x, y, w, h);
  }
  
  boolean collisionCheck(PVector point) {
    return ((point.x >= x && point.x <= (x+w)) && (point.y >= y-1 && point.y <= (y+h)));
  }
  
  boolean overEdge(PVector point) {
    return (point.x >= x && point.x <= (x+w));
  }
}
