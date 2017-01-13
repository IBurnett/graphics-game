class Tail extends Ball {
  float v;
  
  Tail (float x, float y, float vx, float vy) {
    super(x, y, vx, vy); 
    v = sqrt((vx * vx) + (vy * vy));
  }
  
  void display() {
    float vAngle = degrees(atan(vx / vy)) + 180;
    float x1 = x + (10 * sin(radians(vAngle + 90)));
    float y1 = y + (10 * cos(radians(vAngle + 90)));
    float x2 = x + (10 * sin(radians(vAngle - 90)));
    float y2 = y + (10 * cos(radians(vAngle - 90)));
    float x3 = x - vx;
    float y3 = y - vy;
    
    if (vx <= 0 && vy < 0) {
      x3 = x - ((v + 10) * sin(radians(vAngle)) * 1);
      y3 = y - ((v + 10) * cos(radians(vAngle)) * 1);
    }
    else if (vx <= 0 && vy >= 0) {
      x3 = x + ((v + 10) * sin(radians(vAngle)) * 1);
      y3 = y + ((v + 10) * cos(radians(vAngle)) * 1);
    }
    else if (vx > 0 && vy < 0) {
      x3 = x - ((v + 10) * sin(radians(vAngle)) * 1);
      y3 = y - ((v + 10) * cos(radians(vAngle)) * 1);
    }
    else {
      x3 = x + ((v + 10) * sin(radians(vAngle)) * 1);
      y3 = y + ((v + 10) * cos(radians(vAngle)) * 1);
    }

    noStroke();
    fill(220);
    triangle(x1, y1, x2, y2, x3, y3);
  }
  
  void update(Ball ball) {
    x = ball.x;
    y = ball.y;
    vx = ball.vx;
    vy = ball.vy;
  }
}