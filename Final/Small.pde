class Small extends Button {
  
  Small(String _name, int _x, int _y, int _w, int _h, int _r) {
    super(_name, _x, _y, _w, _h, _r);
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
    text(name, x+10, y+25);
  }
  
}