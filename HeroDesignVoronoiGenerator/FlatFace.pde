//FlatFace takes a lenght for one of the edges and creates a flatend and notched polygon 
public class FlatFace {

  Polygon2D flatFace = new Polygon2D();  
  float len;
  Vec2D faceH = new Vec2D();//, faceW, notchH, notchW;
  Vec2D faceW = new Vec2D();
  Vec2D notchH = new Vec2D();
  Vec2D notchW = new Vec2D();
  
  public FlatFace(float len) {
    this.len=len;
    faceH.set(0, inchToPixel(depth)*drawScale);
    faceW.set(this.len, 0);//This has been scaled before it gets here
    float hMod = laser ? 1:0.5;
    notchH.set(0, inchToPixel(matThick*hMod)*drawScale);
    notchW.set(inchToPixel(matThick*1.5*drawScale), 0);

    build();
    //This sets each flat face to be centered on the orgin so when we plot it we just go to where it belongs 
    Vec2D halfW = new Vec2D(faceW.scale(-.5));
    Vec2D halfH = new Vec2D(faceH.scale(-.5)); 
    Vec2D dis = new Vec2D(halfW.sub(halfH));
    for (Vec2D v : flatFace.vertices) {
      v.set(v.add(dis));
    }
//    float kerfCorrection= laser ? inchToPixel(laserKerf) : 0;
    if(laser)
    {
    flatFace.offsetShape(laserKerf);
    }
  }

  void build() {
    List<Vec2D> arcPts=new ArrayList<Vec2D>();
    for (int t=1; t<180; t+=1) {
      arcPts.add(new Vec2D().fromTheta(radians(t)).scale(inchToPixel(bitD/2)*drawScale));
    }
    println(arcPts.size());
    Vec2D bitOff= new Vec2D().fromTheta(0).scale(inchToPixel(bitD/2)*drawScale);
    
    flatFace.add( faceH.add(notchH).invert() );//a
    flatFace.add( notchW.sub(faceH).sub(notchH) );//b
    flatFace.add( notchW.sub(faceH) );//c
    if (router) {
      println("NOTCHING");
      Collections.reverse(arcPts);
      for (Vec2D v :arcPts) {
        flatFace.add(v.add(notchW.sub(faceH)).add(bitOff));
      }
      for (Vec2D v :arcPts) {
        flatFace.add(v.add(faceW.sub(notchW).sub(faceH)).sub(bitOff));
      }
    }
    flatFace.add( faceW.sub(notchW).sub(faceH) );//d
    flatFace.add( faceW.sub(notchW).sub(faceH).sub(notchH) );//e
    flatFace.add( faceW.sub(faceH).sub(notchH) );//f
    flatFace.add( faceW.sub(faceH) );//g
    flatFace.add( faceW );//h
    flatFace.add( faceW.add(notchH) );//i
    flatFace.add( faceW.sub(notchW).add(notchH) );    //j
    flatFace.add( faceW.sub(notchW) );//k
    if (router) {
      for (Vec2D v :arcPts) {
        flatFace.add(v.getRotated(PI).add(faceW.sub(notchW)).sub(bitOff));
      }
      for (Vec2D v :arcPts) {
        flatFace.add(v.getRotated(PI).add( notchW).add(bitOff));
      }
    }
    flatFace.add( notchW );//l
    flatFace.add( notchH.add(notchW) );//m
    flatFace.add( notchH );//n
  }
}

