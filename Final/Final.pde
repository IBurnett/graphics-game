import processing.sound.*;
SoundFile sound;

//initialize variables and lists for displaying and recording the balls
float ball_x1;
float ball_y1;
Ball newBall;
ArrayList<Ball> balls = new ArrayList<Ball>();
ArrayList<Tail> tails = new ArrayList<Tail>();
ArrayList<Line> lines = new ArrayList<Line>();
boolean ballmode = true;  //set this to false at start
boolean newline = true;  //be sure to set to true on mode switch
boolean ballref = false; //set true if ball is reflected (hits a line)
boolean squish = false;
float collision = 0; //saves the collision state of a given ball
float newx;  //save the location of the first click for a new line
float newy;
float currx;  //current x position, or position of a nearby point
float curry;
boolean menu = true;
boolean start = true;
boolean entry = false;
boolean fromMenu = false;
Button begin;
Button load;
Button guide;
Button resume;
Button mutebutt;
Button unmutebutt;
Button savebutt;
Button filebutt;
Small back;
Small confirm;
PFont simplifica;
boolean info = false;
String instructions;
String input = "";
String entryInfo;
Table table;
boolean mute = false;
boolean oops = false;
String invalid;


void setup() {
  size(800, 600);
  background(110);
  
  //font courtesy of FONTOM - https://www.behance.net/gallery/14209843/SIMPLIFICA-Typeface-Free
  simplifica = createFont("SIMPLIFICA Typeface.ttf", 32);
  textFont(simplifica);
    
  begin = new Button("N E W", 220,195,360,65,5);
  load = new Button("L O A D", 220,355,360,65,5);
  guide = new Button("I N F O", 220,275,360,65,5);
  instructions = "S P A C E to swap between line and ball modes \n\nP  to open the menu inside the sketch\n\nL E F T click to create a vertex or ball \nL E F T click a ball and drag to assign velocity\n\nR I G H T click a ball or vertex to remove it\nR I G H T click to end a line\n\nD E L E T E in ball mode to remove the last ball made";
  entryInfo = "Enter a filename to save or load from the /data folder.\n\nOnly alphanumeric characters and underscore may be used.";
  invalid = "Filename not found!";
  back = new Small("< <", 120,450,100,30,5);
  confirm = new Small("CONFIRM",580,450,100,30,5);
  filebutt = new Button("FILENAME:", 220,355,360,65,5);
  
  resume = new Button("R E S U M E", 220,195,360,65,5);
  savebutt = new Button("S A V E", 220,355,360,65,5);
  mutebutt = new Button("M U T E", 220,275,360,65,5);
  unmutebutt = new Button("U N M U T E", 220,275,360,65,5);
  
  //Sound effect courtesy of djfroyd - https://www.freesound.org/people/djfroyd/sounds/317247/
  //Effect shortened and quieted for this project using Audacity - http://www.audacityteam.org/
  sound = new SoundFile(this, "317247__djfroyd__c-2-kick__short.wav");
}

void draw() {
  background(110);
  if (lines.size() < 1) {
    currx = mouseX;
    curry = mouseY;
  }
  else {
    for (int i = 0; i < lines.size(); i ++) {
      Line line = lines.get(i);
      if (line.x1 >= mouseX - 10 && line.x1 <= mouseX + 10 && line.y1 >= mouseY - 10 && line.y1 <= mouseY + 10) {
        currx = line.x1;
        curry = line.y1;
        break;
      }
      else if (line.x2 >= mouseX - 10 && line.x2 <= mouseX + 10 && line.y2 >= mouseY - 10 && line.y2 <= mouseY + 10) {
        currx = line.x2;
        curry = line.y2;
        break;
      }
      else {
        currx = mouseX;
        curry = mouseY;
      }
    }
  }
  for (int l = 0; l < lines.size(); l++) {
    stroke(0);
    lines.get(l).display();
  }
  
  //don't run if in menu
  if (!menu && !ballmode && !newline) {    
    //draw sample line
    stroke(205,201,201);
    //stroke(139,137,137);  //darker grey
    line(newx,newy,currx,curry);
  }
  
  //Framerate display
  //textSize(10);
  //text(str(frameRate),20,20);
  
  //don't run if in menu
  if(!menu && ballmode && mousePressed && mouseButton == LEFT) {
    float leadAngle;
    float arrowX1;
    float arrowY1;
    float arrowX2;
    float arrowY2;
    
    stroke(255);
    if (balls.size() >= 1) {
      Ball lastBall = balls.get(balls.size() - 1);
      if (lastBall.vx == 0 && lastBall.vy == 0) {
        leadAngle = degrees(atan((lastBall.x - mouseX) / (lastBall.y - mouseY))) + 180;
        if (mouseY > lastBall.y) {
          arrowX1 = mouseX + (10 * sin(radians(leadAngle + 45)));
          arrowY1 = mouseY + (10 * cos(radians(leadAngle + 45)));
          arrowX2 = mouseX + (10 * sin(radians(leadAngle - 45)));
          arrowY2 = mouseY + (10 * cos(radians(leadAngle - 45)));
        }
        else {
          arrowX1 = mouseX - (10 * sin(radians(leadAngle + 45)));
          arrowY1 = mouseY - (10 * cos(radians(leadAngle + 45)));
          arrowX2 = mouseX - (10 * sin(radians(leadAngle - 45)));
          arrowY2 = mouseY - (10 * cos(radians(leadAngle - 45)));
        }
        line(lastBall.x, lastBall.y, mouseX, mouseY);
        line(mouseX, mouseY, arrowX1, arrowY1);
        line(mouseX, mouseY, arrowX2, arrowY2);
      }
    }
  }
  
  //display the balls
  for (int i = 0; i < balls.size(); i++) {
    for (int j = 0; j < lines.size(); j++) {
      //lines.get(j).display();
      collision = ballCollision(balls.get(i), lines.get(j));
      if (balls.size() > 0) {
        if (ballEnd(balls.get(i), lines.get(j).x1, lines.get(j).y1) || ballEnd(balls.get(i), lines.get(j).x2, lines.get(j).y2)) {
          if (!mute) {
            sound.play();
          }
          balls.get(i).endReflect();
          ballref = true;
          balls.get(i).move();
          tails.get(i).update(balls.get(i));
          //tails.get(i).display();
        }
        else if (collision == 2) {
          if (!mute) {
            sound.play();
          }
          balls.get(i).reflect(lines.get(j));
          ballref = true;
          boolean secondColl;
          for (int k = 0; k < lines.size(); k++) {
            secondColl = lineIntersect(balls.get(i), lines.get(k));
            if (secondColl) {
              balls.get(i).reflect(lines.get(k));
            }
          }
          balls.get(i).move();
          tails.get(i).update(balls.get(i));
          //tails.get(i).display();
        }
        else if (collision == 1) {
          squish = true; 
        }
      }
    }
    if (!ballref) {
      float wallColl = ballWall(balls.get(i));
      if (wallColl == 2) {
        if (!mute) {
          sound.play();
        } 
      }
      balls.get(i).move();
      tails.get(i).update(balls.get(i));
      if (!squish && wallColl == 0) {
        tails.get(i).display(); 
        balls.get(i).display();
      }
    }
    ballref = false;
    collision = 0;
    squish = false;
  }
  
  //draw menus
  if (menu) {
    fill(15);
    rect(100,100,600,400,30);
    
    if (start) {
      if (!info) {
        if (entry) {
          //draw entry screen, including instructions
          confirm.update();
          back.update();
          filebutt.update();
          confirm.display();
          back.display();
          filebutt.display();
          textSize(24);
          text(entryInfo, 220,195,360,145);
          text(input,320,397);
          if (oops) {
            fill(255,0,0);
            textSize(32);
            text(invalid,315,345);
            fill(255);
          }
        } else {
          //draw normal buttons
          begin.update();
          load.update();
          guide.update();
          begin.display();
          load.display();
          guide.display();
        }
      } else {
        fill(255);
        textSize(24);
        text(instructions, 160,117,480,400);
        back.update();
        back.display();
      }
    }
    else {
      //draw "pause" menu
      if (entry) {
        confirm.update();
        back.update();
        filebutt.update();
        confirm.display();
        back.display();
        filebutt.display();
        textSize(24);
        text(entryInfo, 220,195,360,145);
        text(input,320,397);
      } else {
        resume.update();
        savebutt.update();
        if (!mute) {
          mutebutt.update();
          mutebutt.display();
        } else {
          //unmute button
          unmutebutt.update();
          unmutebutt.display();
        }
        resume.display();
        savebutt.display();
      }
    }
  }
}


void mousePressed() {
  if (menu) {
    if (start) {
      //check start buttons
      if (guide.mouseover) {
        info = true;
        guide.mouseover = false;
      } else if (back.mouseover) {
        info = false;
        entry = false;
        back.mouseover = false;
      } else if (load.mouseover) {
        entry = true;
        oops = false;
        load.mouseover = false;
      } else if (begin.mouseover) {
        //begin
        start = false;
        menu = false;
        begin.mouseover = false;
        fromMenu = true;  //hardcode check to keep mouse release block from triggering
      } else if (entry && confirm.mouseover) {
        confirm.mouseover = false;
        //entry = false;
        //println("Confirm");
        load(input);
      }
    }
    else {
      //check pause buttons
      if (resume.mouseover) {
        menu = false;
        fromMenu = true;
        resume.mouseover = false;
      } else if (mutebutt.mouseover) {
        mute = true;
        mutebutt.mouseover = false;
      } else if (unmutebutt.mouseover) {
        mute = false;
        unmutebutt.mouseover = false;
      } else if (savebutt.mouseover) {
        entry = true;
        savebutt.mouseover = false;
      } else if (entry && confirm.mouseover) {
        confirm.mouseover = false;
        //entry = false;
        save(input);
      } else if (back.mouseover) {
        info = false;
        entry = false;
        back.mouseover = false;
      }
    }
  }
  else {
    if (mouseButton == LEFT) {
      if (ballmode) {
        float distx;
        float disty;
        float curBallX = mouseX;
        float curBallY = mouseY;
        boolean isBallNew = true;
        
        for (int i = 0; i < balls.size(); i++) {
          distx = abs(balls.get(i).x - mouseX);
          disty = abs(balls.get(i).y - mouseY);
          if (distx < 5 && disty < 5) {
            isBallNew = false;
            curBallX = balls.get(i).x;
            curBallY = balls.get(i).y;
            balls.remove(i);
            tails.remove(i);
          }
        }
        
        if (isBallNew) {
          //record the initial ball position
          ball_x1 = mouseX;
          ball_y1 = mouseY;
        }
        else {
          //record the current ball's position
          ball_x1 = curBallX;
          ball_y1 = curBallY;
        }
        newBall = new Ball(ball_x1, ball_y1, 0, 0);
        Tail newTail = new Tail(ball_x1, ball_y1, 0, 0);
        balls.add(newBall);
        tails.add(newTail);
        isBallNew = true;
      }
      else {
        if (newline) {
          newline = false;
          newx = currx;
          newy = curry;
        }
        else {
          //connect the previous point
          lines.add(new Line(newx,newy,currx,curry));
          if (balls.size() > 0) {
            for (int i = balls.size() - 1; i >= 0; i--) {
              if (ballCollision(balls.get(i), lines.get(lines.size() - 1)) != 0) {
                 balls.remove(i);
                 tails.remove(i);
              }
            }
          }
        }
        newx = currx;
        newy = curry;
      }
    }
    else if (mouseButton == RIGHT) {
      if (ballmode) {
        float distx;
        float disty;
        for (int i = 0; i < balls.size(); i++) {
          distx = abs(balls.get(i).x - mouseX);
          disty = abs(balls.get(i).y - mouseY);
          if (distx < 5 && disty < 5) {
            balls.remove(i);
            tails.remove(i);
          }
        }
      }
      else {  
        if (!newline) {
          newline = true;
        }
        else {
          //delete a point
          for (int i = lines.size() - 1; i >= 0; i--) {
            Line line = lines.get(i);
            if (line.x1 >= mouseX - 5 && line.x1 <= mouseX + 5 && line.y1 >= mouseY - 5 && line.y1 <= mouseY + 5
            || line.x2 >= mouseX - 5 && line.x2 <= mouseX + 5 && line.y2 >= mouseY - 5 && line.y2 <= mouseY + 5) {
              lines.remove(i);
            }
          }
        }
      }
    }
  }
}

void mouseReleased() {
  if (fromMenu) {
    fromMenu = false;
  } else if (!menu && ballmode && mouseButton == LEFT) {
    //set the new ball in motion and add it to the list
    newBall = new Ball(ball_x1, ball_y1, (mouseX - ball_x1) / 10, (mouseY - ball_y1) / 10);
    balls.remove(balls.size() - 1);
    balls.add(newBall);
    tails.remove(tails.size() - 1);
    Tail newTail = new Tail(newBall.x, newBall.y, newBall.vx, newBall.vy);
    tails.add(newTail);
  }
}

void keyPressed() {
  if (menu) {
    if (entry) {
      //key inputs for save/load filename
      if (key != CODED) {
        String dummy = "" + key;
        if (match(dummy, "[\\w]") != null) {
          input += key;
        }
      }
      if (key == BACKSPACE && input.length() > 0) {
        //this -2 seems weird, why does -1 not work?
        input = input.substring(0,input.length()-1);
      }
    }
  }
  else {
    if (key == 'p' || key == 'P') {
      menu = !menu;
    }
    if (key == ' ') {
      ballmode = !ballmode;
      newline = true;
    }
    if (key == BACKSPACE && ballmode) {
      if (balls.size() >= 1) {
        balls.remove(balls.size() - 1);
        tails.remove(tails.size() - 1);
      }
    }
  }
}


//adapted from code by Jeffrey Thompson - jeffreythompson.org
float ballCollision(Ball ball, Line line) {
  
  //get length of line
  float distX = line.x1 - line.x2;
  float distY = line.y1 - line.y2;
  float len = sqrt((distX * distX) + (distY * distY));
  
  //get dot product of line and circle
  float dot = (((ball.x - line.x1) * (line.x2 - line.x1)) +
               ((ball.y - line.y1) * (line.y2 - line.y1))) / pow(len, 2);
               
  //find closest point on the line
  float closeX = line.x1 + (dot * (line.x2 - line.x1));
  float closeY = line.y1 + (dot * (line.y2 - line.y1));
  
  //check that closest point is actually on the line segment
  float d1 = dist(closeX, closeY, line.x1, line.y1);
  float d2 = dist(closeX, closeY, line.x2, line.y2);
  float lineLen = dist(line.x1, line.y1, line.x2, line.y2);
  float buffer = 0.1;
  if (d1 + d2 < lineLen - buffer || d1 + d2 > lineLen + buffer) {
    return 0;
  }
  
  //get distance of center of circle to closest point on line
  distX = closeX - ball.x;
  distY = closeY - ball.y;
  float distance = sqrt((distX * distX) + (distY * distY));
  
  if (lineIntersect(ball, line)) {
    return 2;
  }
  
  if (distance <= ball.r / 2) {
    ball.squish(distance, line);
    return 2;
  }
  else if (distance < ball.r && distance >= ball.r / 2) {
    ball.squish(distance, line);
    return 1;
  }
  /*
  if (lineIntersect(ball, line)) {
    return 2;
  }*/
  
  return 0;
  
}

boolean ballEnd(Ball ball, float lx, float ly) {
  //get distance between line end and center of ball
  float distX = lx - ball.x;
  float distY = ly - ball.y;
  float distance = sqrt((distX * distX) + (distY * distY));
  
  //if distance is less than the radius of the ball, the end of the line is in the ball
  if (distance <= ball.r) {
    return true;
  }
  return false;
}

//adapted from line intersection example at processingjs.org/learning/custom/intersect
boolean lineIntersect(Ball ball, Line line) {
  float x1 = ball.x;
  float y1 = ball.y;
  float x2 = ball.x + ball.vx;
  float y2 = ball.y + ball.vy;
  
  float x3 = line.x1;
  float y3 = line.y1;
  float x4 = line.x2;
  float y4 = line.y2;
  if (x3 <= x4) {
    x3 -= ball.r;
    x4 += ball.r;
  }
  else {
    x3 += ball.r;
    x4 -= ball.r;
  }
  if (y3 <= y4) {
    y3 -= ball.r;
    y4 += ball.r;
  }
  else {
   y3 += ball.r;
   y4 -= ball.r;
  }
  
  float a1 = y2 - y1;
  float b1 = x1 - x2;
  float c1 = (x2 * y1) - (x1 * y2);
  
  float r3 = ((a1 * x3) + (b1 * y3) + c1);
  float r4 = ((a1 * x4) + (b1 * y4) + c1);
  
  if ((r3 != 0) && (r4 != 0) && (r3 * r4) >= 0) {
    return false;
  }
  
  float a2 = y4 - y3;
  float b2 = x3 - x4;
  float c2 = (x4 * y3) - (x3 * y4);
  
  float r1 = ((a2 * x1) + (b2 * y1) + c2);
  float r2 = ((a2 * x2) + (b2 * y2) + c2);
  
  if ((r1 != 0) && (r2 != 0) && (r1 * r2) >= 0) {
    return false;
  }  
  
  if (r1 == 0 || r2 == 0) {
    return false;
  }
  
  return true;
}

float ballWall(Ball ball) {
  if (ball.x - ball.r <= 0) {
    Line wall = new Line(0, 0, 0, height);
    ball.squish(ball.x - (ball.r / 2), wall);
    if (ball.x - (ball.r / 2) <= 0) {
      if (ball.vx > 0) {
        return 0; 
      }
      ball.flip(0);
      return 2;
    }
    else {
      return 1; 
    }
  }
  else if (ball.y - ball.r <= 0) {
    Line wall = new Line(0, 0, width, 0);
    ball.squish(ball.y - (ball.r / 2), wall);
    if (ball.y - (ball.r / 2) <= 0) {
      if (ball.vy > 0) {
        return 0; 
      }
      ball.flip(1);
      return 2;
    }
    else {
      return 1; 
    }
  }
  else if (ball.x + ball.r >= width) {
    Line wall = new Line(width, 0, width, height);
    ball.squish(width - (ball.x + (ball.r / 2)), wall);
    if (ball.x + (ball.r / 2) >= width) {
      if (ball.vx < 0) {
        return 0;
      }
      ball.flip(0);
      return 2;
    }
    else {
      return 1; 
    }
  }
  else if (ball.y + ball.r >= height) {
    Line wall = new Line(0, height, width, height);
    ball.squish(height - (ball.y + (ball.r / 2)), wall);
    if (ball.y + (ball.r / 2) >= height) {
      if (ball.vy < 0) {
        return 0;
      }
      ball.flip(1);
      return 2;
    }
    else {
      return 1; 
    }
  }
  
  return 0;
}

void load(String filename) {
  //println("In load");
  if (filename.length() > 3) {
    if (!filename.substring(filename.length()-4,filename.length()).equals(".csv")) {
      //println(filename.substring(filename.length()-4,filename.length()));
      filename += ".csv";
    }
  } else {
    filename += ".csv";
  }
  table = loadTable(filename);
  try {
    for (TableRow row : table.rows()) {
      float x1 = row.getFloat(0);
      float y1 = row.getFloat(1);
      float x2 = row.getFloat(2);
      float y2 = row.getFloat(3);
      lines.add(new Line(x1,y1,x2,y2));
    }
    start = false;
    menu = false;
    fromMenu = true;
    entry = false;
    println("Loaded successfully");
  } catch(NullPointerException e) {
    oops = true;
    println("Invalid file name");
  }
}

void save(String filename) {
  if (filename.length() > 3) {
    if (!filename.substring(filename.length()-4,filename.length()).equals(".csv")) {
      //println(filename.substring(filename.length()-4,filename.length()));
      filename += ".csv";
    }
  } else {
    filename += ".csv";
  }
  PrintWriter output = createWriter("data/" + filename);
  
  for (int l = 0; l < lines.size(); l++) {
    Line line = lines.get(l);
    output.println(line.x1 + "," + line.y1 + "," + line.x2 + "," + line.y2);
  }
  output.close();
  entry = false;
  println("Saved!");
}