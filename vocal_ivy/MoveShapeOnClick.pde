
 public enum form{
  TRIANGL,
  RECTANGLE,
  CERCLE
}


public class Shape {
  form  maForme;  // forme
  float x, y;    // Position
  int size = 100;
  color fillColor = color(255,200,0)   ; // Color
  boolean isSelected; // Flag to track selection

  // Constructor
  Shape(form  maForme,float x, float y) {
    this.maForme = maForme ;
    this.x = x;
    this.y = y;
    
    //this.fillColor = fillColor;
    this.isSelected = false;
  }
  
  
MyTriangle tri;
 

class MyTriangle{
  float x,y,hLen;

  //Center point and side length
  MyTriangle(float cx, float cy,float length){
    x=cx;
    y=cy;
    hLen=length/2;
  }

  void draw(){
    triangle(x-hLen, y-hLen, x+hLen, y-hLen, x, y+hLen);  
  }
}

void setColor(color col ){

  this.fillColor = col;

}

void drawShape(form shape) {
  if(shape == form.TRIANGL) {
    tri = new MyTriangle(mouseX,mouseY,100);
    tri.draw();
  }
  else if(shape == form.RECTANGLE) {
    rectMode(CENTER);
    rect(mouseX, mouseY, 100, 100);
  }
  else if(shape == form.CERCLE) {
    circle(mouseX, mouseY, 100);
  }
}

void randomColorShape(form shape){
  color col = color(random(255), random(255), color(255));
  fill(col);
  drawShape(shape);
}

void colorShape(form shape, color col){

  fill(col);
  drawShape(shape);

}

  // Draw the shape
  void display(boolean isRandom) {
    
    if (isRandom){randomColorShape(this.maForme) ;}
    
    else { colorShape(this.maForme, this.fillColor);}
    
     // Example: Draw an ellipse
    // You can modify this to draw other shapes as needed
    
  }

  // Check if a point is inside the shape
  boolean isPointInside(float px, float py) {
    return (dist(px, py, x, y) < size / 2);
  }

  // Select the shape
  void select() {
    this.isSelected = true;
  }

  // Move the shape to a new position if it is selected
  void move(float newX, float newY) {
    if (isSelected) {
      this.x = newX;
      this.y = newY;
      this.isSelected = false; // Deselect after moving
    }
  }
}

//// Create an instance of the Shape class
//Shape myShape;

//void setup() {
//  size(400, 200);

//  // Initialize the shape with position (50, 50), size 50, and red color
//  myShape = new Shape(50, 50, 50, color(255, 0, 0));
//}

//void draw() {
//  background(255);

//  // Display the shape
//  myShape.display();
//}

//void mousePressed() {
//  // Check if the mouse is over the shape
//  if (myShape.isPointInside(mouseX, mouseY)) {
//    // Select the shape on the first click
//    myShape.select();
//  } else {
//    // Move the shape to a new position on the second click
//    myShape.move(mouseX, mouseY);
//  }
//}
