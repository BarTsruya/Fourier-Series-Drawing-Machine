
int winSize = 1000;

ArrayList<PVector> points;
ArrayList<PVector> centeredPoints;



int N;
int initialN = 20;
PVector[] coefficients;

float time;
float tu;

PVector[] fsVecs;

PVector center;


Tail machineTail;

String fileName="";


boolean arrows, circles;
color on, off;


public static enum STATE{
    OpenningScreen,
    shapeTime,
    InputName,
    showTime,
    SavedPaint;
}

STATE state;


void setup(){
  size(1000 ,1000);
  strokeWeight(2);
  
  
  
  points = new ArrayList<PVector>();
  centeredPoints = new ArrayList<PVector>();
  
  center = new PVector(width/2, height/2);
  
  
  
  // We measure the time for the changing color.
  time = 0;
  tu = 0.001;
  
  machineTail = new Tail(tu,134, 0, 179); // The numbers represent a color in RGB representation.
  
  state = STATE.OpenningScreen;
  
  arrows = false;
  circles = true;
  
  on = color(60,158,128);
  off = color(128,60,158);
  
  
}

void determineN(int n){
  N=n;
  coefficients = new PVector[2*N+1];
  calculateCs();
  fsVecs = new PVector[2*N+1];
}

PVector ei(float x){
  return new PVector(cos(x), sin(x));
}


PVector complexMult(PVector c1, PVector c2){
  return new PVector(c1.x*c2.x - c1.y*c2.y, c1.y*c2.x+c1.x*c2.y);
}


PVector getCn(int n){
  float deltaT = 1.0 / centeredPoints.size();
  float t = 0;
  PVector sum = new PVector(0,0);
  
  for(int i=0; i<centeredPoints.size();i++){
    sum.add(complexMult(centeredPoints.get(i), ei(-n*2*PI*t)));
    t += deltaT;
  }
  
  
  return sum.mult(deltaT);
}


void calculateCs(){
  coefficients[N] = getCn(0);
  for(int i=1; i<=N; i++){
    coefficients[N + i] = getCn(i);
    coefficients[N - i] = getCn(-i);
  }
}


PVector fixPoint(PVector p){
  return new PVector(p.x-center.x, -(p.y-center.y)); 
}

PVector inversePoint(PVector p){
  return new PVector(p.x+center.x, -(p.y-center.y)); 
}



void updateFSVecs(float t){
  fsVecs[0] = complexMult(coefficients[N], ei(0*2*PI*t)); 
  
  int k=1;
  for(int i=1; i<=N;i++){
    fsVecs[k] = complexMult(coefficients[N+i], ei(i*2*PI*t)); // C(i)
    fsVecs[k+1] = complexMult(coefficients[N-i], ei(-i*2*PI*t)); // C(-i)
    k+=2;
  }
  
  
  for(int j=0;j<fsVecs.length;j++)
      fsVecs[j] = PVector.sub(inversePoint(fsVecs[j]),center);

  
}


boolean isMouseOn(int x, int y, int w, int h){
  
  return (x <= mouseX && mouseX <= x+w) && (y <= mouseY && mouseY <= y+h);
  
}

void mousePressed(){
  if(state == STATE.OpenningScreen){
    if(isMouseOn(winSize/2-100,winSize/2-50,200,50)) // Draw 
      state = STATE.shapeTime;
    else if(isMouseOn(winSize/2-100,winSize/2+50,200,50)) // Load
      selectInput("Select a file to process:", "parseFile");
      
      
    
  }else if(state == STATE.shapeTime){
    points.add(new PVector(mouseX, mouseY));
  
  }else if(state == STATE.showTime || state == STATE.SavedPaint){
    if(isMouseOn(winSize-150,winSize-150,50,50)) // Minus button
      determineN(N-1);
    else if(isMouseOn(winSize-150,winSize-300,50,50)) // Plus button
      determineN(N+1);
    else if(isMouseOn(winSize/5,60,120,60)) // Arrows button
      arrows = !arrows;
    else if(isMouseOn(3*winSize/5,60,120,60)) // Circles button
      circles = !circles;
    
    
    if(state == STATE.showTime && isMouseOn(winSize/10,winSize-150,120,60)){ // Save button
      state = STATE.InputName;
      
    
    
    
    
    }
  }
}


void parseFile(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
  }
  
  
  BufferedReader reader = createReader(selection.getAbsolutePath());
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      String[] pieces = split(line, ",");
      int x = int(pieces[0]);
      int y = int(pieces[1]);
      points.add(new PVector(x, y));
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
  
  for(PVector p: points)
      centeredPoints.add(fixPoint(p));
    
  determineN(initialN);
  
  state = STATE.SavedPaint;
} 



void savePaint(){
 
  PrintWriter writer = createWriter(fileName + "-positions.txt");
  for(PVector point: points)
    writer.println(point.x+","+point.y);
  
  writer.flush();
  writer.close();
  
  
}


void keyPressed(){
 
  if(state == STATE.shapeTime && keyCode == ENTER){
    
    for(PVector p: points)
      centeredPoints.add(fixPoint(p));
    
    determineN(initialN);
    
    state = STATE.showTime;
  }else if(state == STATE.InputName){
    
    if(keyCode == BACKSPACE){
      fileName = "";
    }else if(keyCode == ENTER){
      print(fileName);
      savePaint();
      state = STATE.SavedPaint;
    }else if(keyCode != SHIFT){
      fileName+=key;
    }
  }    
}
  





void draw(){
  
  background(255);
  
  if(state == STATE.OpenningScreen){
    stroke(0);
    fill(255);
    rect(winSize/2-100,winSize/2-50,200,50);
    rect(winSize/2-100,winSize/2+50,200,50);
    
    fill(0);
    textSize(40);
    text("Draw", winSize/2-45,winSize/2-12);
    text("Load",winSize/2-45,winSize/2+88);
    
    textSize(80);
    text("Fourier Series Animation", winSize/10, winSize/3);
    
    
  }else if(state == STATE.shapeTime){
    
    stroke(color(0,0,0));
    strokeWeight(2);
    for(int i=1; i<points.size();i++)
      line(points.get(i-1).x, points.get(i-1).y, points.get(i).x, points.get(i).y);
  
  }else if(state == STATE.showTime){
    
    displayPaint();
    
    // save button
    fill(128,128,30);
    rect(winSize/10,winSize-150,120,60);
    fill(0);
    textSize(35);
    text("Save",winSize/10+25,winSize-110);
  }else if(state == STATE.InputName){
    
    fill(0);
    textSize(50);
    text("Please type a file name: ", winSize/10, winSize/4);
    textSize(35);
    text(fileName, winSize/10, winSize/3);
  
  }else if(state == STATE.SavedPaint){
   
    displayPaint();
    fill(0);
    textSize(35);
    text("Saved!",winSize/10+25,winSize-110);
  }
  
  
  
  
}


void drawFigure(){
  stroke(0);
  
  for(int i=1; i<points.size();i++)
    line(points.get(i-1).x, points.get(i-1).y, points.get(i).x, points.get(i).y);
  line(points.get(points.size()-1).x, points.get(points.size()-1).y, points.get(0).x, points.get(0).y);
}

void drawArrowBetween(float x1, float y1, float x2, float y2){
  
  PVector originalVec = new PVector(x2-x1,y2-y1);
  PVector normalVec = new PVector(originalVec.y,-originalVec.x);
  
  line(x1,y1,x2,y2);
  
  
  
  if(0.25*originalVec.mag() <= 5){
    // (x1,y1) + 3/4*originalVec + 1/4*normalVec -> (x2,y2)
    line(x1+0.75*originalVec.x+0.25*normalVec.x,y1+0.75*originalVec.y+0.25*normalVec.y,x2,y2);
    // (x1,y1) + 3/4*originalVec - 1/4*normalVec -> (x2,y2)
    line(x1+0.75*originalVec.x-0.25*normalVec.x,y1+0.75*originalVec.y-0.25*normalVec.y,x2,y2);
  }else{
    // (x1,y1) + 3/4*originalVec + 1/4*normalVec -> (x2,y2)
    line(x1+0.9*originalVec.x+0.1*normalVec.x,y1+0.9*originalVec.y+0.1*normalVec.y,x2,y2);
    // (x1,y1) + 3/4*originalVec - 1/4*normalVec -> (x2,y2)
    line(x1+0.9*originalVec.x-0.1*normalVec.x,y1+0.9*originalVec.y-0.1*normalVec.y,x2,y2);
  }
}


PVector drawArrowsCirclesCalcTotalVec(){
  PVector totalVec = center.copy();
  noFill();
  stroke(50,50,50);
  for(int i=0;i<fsVecs.length;i++){
    PVector prev = totalVec.copy();
    
    
    
    totalVec.add(fsVecs[i]);
    if(circles && i!=fsVecs.length-1)
      circle(totalVec.x,totalVec.y,2*fsVecs[i+1].mag());
    
    if(arrows)
      drawArrowBetween(prev.x, prev.y,totalVec.x, totalVec.y);
    else
      line(prev.x, prev.y,totalVec.x, totalVec.y);
  }
  
  return totalVec;
}


void featuresButtons(){
  
  
  fill(arrows ? on:off);
  rect(winSize/5,60,120,60);
  fill(circles ? on:off);
  rect(3*winSize/5,60,120,60);
  
  fill(0);
  textSize(30);
  text("Arrows",winSize/5+17,98);
  text("Circles",3*winSize/5+20,98);
  
}

void displayPaint(){
  fill(255,0,0);
  circle(center.x, center.y, 8);
  
  strokeWeight(2);
  drawFigure();
  updateFSVecs(time);
  PVector totalVec = drawArrowsCirclesCalcTotalVec();
  
  machineTail.addDot(totalVec);
  machineTail.drawTail();
  
  time += tu;
  
  strokeWeight(2);
  displayPlusMinusButtons();
  featuresButtons();

}


void displayPlusMinusButtons(){
  
  stroke(0);
  
  fill(128,255,255);
  rect(winSize-150,winSize-150,50,50);
  rect(winSize-150,winSize-300,50,50);
  
  fill(0);
  textSize(30);
  text("-",winSize-129,winSize -117);
  text("+",winSize-132,winSize -265);
  
  
  
  text("N="+N,winSize - 155,winSize - 190);
  
  
}
