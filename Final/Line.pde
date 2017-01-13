class Line {
  float x1 = 0;
  float y1 = 0;
  float x2 = 0;
  float y2 = 0;
  float theta = 0;
  
  Line (float _x1, float _y1, float _x2, float _y2) {
    x1 = _x1;
    y1 = _y1;
    x2 = _x2;
    y2 = _y2;
    theta = degrees(atan((x2 - x1) / (y2 - y1)));
  }
  
  void display() {
    line(x1, y1, x2, y2);
  }
}