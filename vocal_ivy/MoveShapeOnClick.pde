class Shape {
  float x, y;    // Position
  float size;     // Size
  color fillColor; // Color
  boolean isSelected; // Flag to track selection

  // Constructor
  Shape(float x, float y, float size, color fillColor) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.fillColor = fillColor;
    this.isSelected = false;
  }

  // Draw the shape
  void display() {
    fill(fillColor);
    ellipse(x, y, size, size); // Example: Draw an ellipse
    // You can modify this to draw other shapes as needed
  }

  // Check if a point is inside the shape
  boolean isPointInside(float px, float py) {
    return (dist(px, py, x, y) < size / 2);
  }

  // Select the shape
  void select() {
    isSelected = true;
  }

  // Move the shape to a new position if it is selected
  void move(float newX, float newY) {
    if (isSelected) {
      this.x = newX;
      this.y = newY;
      isSelected = false; // Deselect after moving
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
