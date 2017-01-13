class Button {
  boolean mouseover;
  int x, y;
  int w, h;
  int r;
  String name;
  
  Button(String _name, int _x, int _y, int _w, int _h, int _r) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    r = _r;
    name = _name;
    mouseover = false;
  }
  
  void update() {
    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h) {
      mouseover = true;
    }
    else {
      mouseover = false;
    }
  }
  
  void display() {
    if (mouseover) {
      fill(100);
    }
    else {
      fill(60);
    }
    noStroke();
    rect(x,y,w,h,r);
    fill(255);
    textSize(32);
    text(name, x+10, y+42);
  }
  
}