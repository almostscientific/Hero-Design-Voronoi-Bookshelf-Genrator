public class MyRect implements Cloneable, Comparable<MyRect> {
  //This is a recetangle that will be packed.
  Rect r;
  Polygon2D polyR;
  Vec2D topLeft, bottomRight;
  float w, h;
  float px=10; 
  float py=-(rawMatHeight/2);
  boolean rotation=false;
  boolean bottomTouching = false;
  boolean rightTouching = false;
  boolean touching=false;
  int id;

  //  public MyRect(float posMin, float posMax, float widthMax, float heightMax) {
  //  public MyRect(float widthMax, float heightMax) {
  public MyRect(float inHeight, float inWidth, int inid) {
    id=inid;
    w=inWidth;
    h=inHeight;
    //px=random(posMin, posMax);
    //py=random(posMin, posMax);
    //    px=12;
    //    py=-heightMax*2;

    updateRect();
  }

  void updateRect() {
    setRect();
    setPoly();
  }

  void setPoly() {
    polyR=r.toPolygon2D();
    if (polyR.isClockwise()) {
      //      polyR.reverseOrientation();
      polyR.flipVertexOrder();
    }
  }

  void setRect() {
    topLeft= new Vec2D(px, py);
    bottomRight=new Vec2D(w, h);    
    if (rotation) {
      bottomRight=new Vec2D(h, w);
    }
    bottomRight.addSelf(topLeft);
    r = new Rect( topLeft, bottomRight );
  }

  void translate(float x, float y) {
    px+=x;
    py+=y;
    updateRect();
  }

  void resetPos() {
    px=12; 
    py=-height;
    updateRect();
  }

  Polygon2D getCopyTranslated(float x, float y) {
    float testX=px+x;
    float testY=px+y;
    float testW, testH;
    if (rotation) {
      testW=h;
      testH=w;
    }
    else {
      testW=w;
      testH=h;
    }
    Vec2D testTopLeft= new Vec2D(testX, testY);
    Vec2D testBottomRight=new Vec2D(testW, testH);
    testBottomRight.addSelf(testTopLeft);
    Rect testRec = new Rect(testTopLeft, testBottomRight);
    return testRec.toPolygon2D();
  }

  public Polygon2D getR() {
    updateRect();
    return polyR;
  }

  public Rect getRect() {
    updateRect();
    return r;
  }

  public Vec2D getCent() {
    return r.getCentroid();
  }

  public int compareTo(MyRect inr) {
    Float thisHeight=new Float( this.r.height );
    Float thatHeight=new Float( inr.r.height );
    Float thisWidth=new Float( this.r.width );
    Float thatWidth=new Float( inr.r.width );

    int lastCmp =  thatWidth.compareTo(thisWidth);
    return (lastCmp != 0 ? lastCmp :thisWidth.compareTo(thatWidth));
  }

  public Object clone() {
    try {
      MyRect clonedMyRect=(MyRect)super.clone();
      return clonedMyRect;
    }
    catch(CloneNotSupportedException e) {
      //      println(e);
      //      println("ick");
      return null;
    }
  }
}

