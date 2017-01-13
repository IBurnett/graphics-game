class Ball {
  float r = 10;
  float x = 0;
  float y = 0;
  float vx = 0;
  float vy = 0;
  float v = 0;
  
  Ball (float _x, float _y, float _vx, float _vy) {
    x = _x;
    y = _y;
    vx = _vx;
    vy = _vy;
    v = sqrt((vx * vx) + (vy * vy));
  }
  
  void display() {
    noStroke();
    fill(255);
    ellipse(x, y, 2 * r, 2 * r);
  }
  
  void move() {
    x += vx;
    y += vy;
  }
  
  void reflect(Line line) {
    float refAngle = line.theta + 90;
    float vAngle;
    float newAngle;
    if (vx <= 0 && vy < 0) {
      vAngle = degrees((atan(vx / vy))) + 180;
      newAngle = refAngle + (refAngle - vAngle) + 180;
    }
    else if (vx <= 0 && vy >= 0) {
      vAngle = degrees((atan(vx / vy))) + 180;
      newAngle = refAngle + (refAngle - vAngle);
    }
    else if (vx > 0 && vy < 0) {
      vAngle = degrees((atan(vx / vy)));
      newAngle = refAngle + (refAngle - vAngle);
    }
    else {
      vAngle = degrees((atan(vx / vy)));
      newAngle = refAngle + (refAngle - vAngle) + 180;
    }
        
    vx = v * sin(radians(newAngle));
    vy = v * cos(radians(newAngle));
  }
 
  void endReflect() {
    vx = -vx;
    vy = -vy;
  }
  
  void squish(float dist, Line line) {
    noStroke();
    fill(255);
    pushMatrix();
    translate(x, y);
    rotate(-radians(line.theta + 90));
    ellipse(0, 0, (r * 2) + (r - dist), (r * 2) - (r - dist));
    popMatrix();
  }
  
  void flip(float v) {
    if (v == 0) {
      vx = -vx; 
    }
    else {
      vy = -vy; 
    }
  }
}