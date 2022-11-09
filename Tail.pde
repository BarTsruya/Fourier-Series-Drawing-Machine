
public class Tail {
  
  ArrayList<PVector> dots;
  int size;
  int R,G,B;
  
  public Tail(float tu, int R, int G, int B){
    this.size = int(1/(2*tu));
    this.R = R;
    this.G = G;
    this.B = B;
    dots = new ArrayList<PVector>();
  }
  
  public void addDot(PVector p){
     this.dots.add(0, p);
     if(this.dots.size() > this.size)
       this.dots.remove(this.size);
  }
  
  
  public void drawTail(){
    strokeWeight(3);
    for(int i=0;i<dots.size()-1;i++){
      stroke(getLineColor(i));
      line(dots.get(i).x,dots.get(i).y, dots.get(i+1).x,dots.get(i+1).y);
    }
    
  }
  
  public color getLineColor(int level){ // where 0<=level<=size
    return color(fixedColorVal(R + (float(level)/this.size)*255),fixedColorVal(G + (level/this.size)*255),fixedColorVal(B + (level/this.size)*255));
  }
  
  public int fixedColorVal(float val){
   
    if(val > 255)
      val = 255;
    
    return int(val);
  }
  
  
  
}
