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
    flatFace.add( faceH.add(notchH).invert() );//n
    flatFace.add( notchW.sub(faceH).sub(notchH) );//m
    flatFace.add( notchW.sub(faceH) );//l
    flatFace.add( faceW.sub(notchW).sub(faceH) );//k
    flatFace.add( faceW.sub(notchW).sub(faceH).sub(notchH) );//j
    flatFace.add( faceW.sub(faceH).sub(notchH) );//i
    flatFace.add( faceW.sub(faceH) );//h
    flatFace.add( faceW );//g
    flatFace.add( faceW.add(notchH) );//f
    flatFace.add( faceW.sub(notchW).add(notchH) );    //e
    flatFace.add( faceW.sub(notchW) );//d
    flatFace.add( notchW );//c
    flatFace.add( notchH.add(notchW) );//b
    flatFace.add( notchH );//a
    for (int t=1; t<180; t+=1) {
  }
}

