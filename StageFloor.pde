class Stage
{
  float sWidth;
  float sHeight;
  float translateX;
  float translateY;
  float divisions;
  boolean isVisible = true;
  
  Stage (float tempW, float tempY, float tempTransX, float tempTransY, float divs)
  {
    sWidth = tempW;
    sHeight = tempY;
    translateY = tempTransY;
    translateX = tempTransX;
    divisions = divs;
  }
  
  void display() 
  {   
      noStroke();
      rect(((width*1/2) - (sWidth*1/2)) - translateX, height - translateY, sWidth, sHeight); 
      
      
  }
}
