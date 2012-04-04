public class PackedRects {
  //This class has all the orginal rects but in a difrent order and rotation.
  //This is a specific ordering of the orginal rects
  //this is class that contains all the shapes we need to pack
  // this class can pack the shapes and determin its fitness
  // this class can be mutated to varing degrees

    List<MyRect> rects = new ArrayList<MyRect>();//this is an individual list of rects that can be packed.
  List<Vec2D> rayVecs=new ArrayList<Vec2D>();
  List<Ray2D> rays=new ArrayList<Ray2D>();
  List<Float> rayLen=new ArrayList<Float>();

  Vec2D boundingTopLeft, boundingBottomRight;
  Rect boundBox;
  boolean tmp;
  //  boolean kluge=false;
  int kluge=0;
  PackingOrder order;
  List brcntList=new ArrayList();

  int brcnt;
  float fitness=0;
  float heightFit;
  float areaFitness;
  float boundW, boundH;

  public PackedRects(List<MyRect> inRects, PackingOrder inOrder) {

    order=inOrder;
    rects.addAll(inRects);
    //                    print("Packing///");
    pack();
    //    Collections.sort(brcntList, Collections.reverseOrder());
    //       println("ACLK "+boundBox.width);
    if (kluge>0) {
      //      println("Kluge "+kluge);
    }
    evaluateFitness();
  }

  void evaluateFitness() {
    float totalRayLen=0;
    List<Float> yPos = new ArrayList<Float>();
    for (MyRect r : rects) {
      yPos.add(r.py);
    }
    Collections.sort(yPos);
    //    fitness=yPos.get(0);
    heightFit=yPos.get(0);
    //     println("fitness "+fitness);
    Line2D topLine=getEdgeOfRect(boundBox, 0);
    topLine.splitIntoSegments(topLine.a, topLine.b, 10, rayVecs, true);
    for (Vec2D rv:rayVecs) {
      Ray2D thisRay=new Ray2D(rv, topLine.getNormal()); 
      rays.add(thisRay);
      List<Float> rayIsecs=new ArrayList<Float>();
      for (MyRect rec : rects) {
        float minD=0;
        float maxD=height;
        if (rec.r.intersectsRay(thisRay, minD, maxD)!=null) {
          Vec2D isec=new Vec2D(rec.r.intersectsRay(thisRay, minD, maxD));
          rayIsecs.add(isec.y);
        }
        else {
          rayIsecs.add((float)height);
        }
      }
      Collections.sort(rayIsecs);
      rayLen.add(rayIsecs.get(0));
      totalRayLen+=rayIsecs.get(0);
    }
    float maxRayTotal=rayVecs.size()*height;
    //    println(maxRayTotal + " " + totalRayLen + " " + (totalRayLen/maxRayTotal));

    areaFitness=(totalRayLen/maxRayTotal);
    fitness=(((heightFit/height)+areaFitness)/2)*100;
    for (MyRect thisRect: rects) {
      for (MyRect thatRect: rects) {
        if (!thisRect.equals(thatRect) && thisRect.getRect().intersectsRect(thatRect.getRect())) {
          fitness=0;
          print("reject");
        }
      }
    }

    if (kluge>0) {
      //      fitness = 0;
    }
    //    fitness=areaFitness*100;
  }

  float getFitness() {
    return fitness;
  }
  float getHeightFit() {
    return heightFit;
  }

  PackingOrder getPackingOrder() {
    return order;
  }

  void pack() {

    //    println("pack");
    //this implements Bottom Right packing
    //create the bounding rectangle
    boundingTopLeft = new Vec2D(0, 0);
    boundW=inchToPixel(rawMatWidth)*drawScale;
    boundH=inchToPixel(rawMatHeight)*drawScale;
    //      println("PACK W"+boundW+" H "+boundH);

    boundingBottomRight = new Vec2D(boundW, boundH);

    boundBox=new Rect(boundingTopLeft, boundingBottomRight );
    //      println("makgin bb "+boundBox.width + " " + boundBox.height);

    for (int i=0; i<rects.size(); i++) {
      recursionKlugeCount=0;
      recursionKlugeX=0;
      recursionKlugeY=0;
      int o=order.order.get(i)[0];
      int r=order.order.get(i)[1];
      //      println("packing: "+i+ " o= "+o+ " r= "+r); 
      brcnt=0;
      brPlacment(rects.get(o), i, r);
      brcntList.add(brcnt);
    }
  }

  void brPlacment(MyRect inRect, int recNum, int rot) {
    //    print("o");
    if (brcnt>10) {
      println("BARf");
      kluge=1;
      return;
    }
    brcnt++;
    if (rot==1) {
      //      println("!");
      inRect.rotation=true;
      inRect.updateRect();
    }
    if (recursionKlugeX==round(inRect.bottomRight.x) && recursionKlugeY==round(inRect.bottomRight.y)) {
      recursionKlugeCount++;
    }
    if (recursionKlugeCount>2) {
      kluge=2;
      return;
    }
    recursionKlugeX=round(inRect.bottomRight.x);
    recursionKlugeY=round(inRect.bottomRight.y);


    float inc=1;
    float gap=5;
    
    
    inRect.translate(0, gap);
    boolean B=checkForTouching(inRect, recNum);
    inRect.translate(0, -gap);

    inRect.translate(gap, 0);
    boolean R=checkForTouching(inRect, recNum);
    inRect.translate(-gap, 0);
    if (B && R) {
      return;
    }
    inRect.translate(-gap, -gap);

    while (!checkForTouching (inRect, recNum)) {
      //            print("+");
      inRect.translate(0, inc);

      //      if (inRect.py > inchToPixel(rawMatHeight)) {
      if (inRect.py > inchToPixel(rawMatHeight)*drawScale) {

        kluge=3;
        println("Kluge3");
        return;
      }
    }
    inRect.translate(0, -gap);

    while (!checkForTouching (inRect, recNum)) {
      inRect.translate(inc, 0);
      //      if (inRect.px > inchToPixel(rawMatWidth)) {
      if (inRect.px > inchToPixel(rawMatWidth)*drawScale) {
        kluge=4;
        println("Kluge4");
        return;
      }
    }
    inRect.translate(-gap, 0);
    brPlacment(inRect, recNum, rot);
  }//end brPlacment

    boolean checkForTouching(MyRect inRect, int recNum) {
    boolean returnTouch = false;
    Polygon2D thisRect =inRect.getR();
    int rectNum=recNum;
    //first check for touching of the boundry box
    if (polygonIntersectLine(thisRect, getEdgeOfRect(boundBox, 2))) {
      returnTouch=true;
    }
    if (polygonIntersectLine(thisRect, getEdgeOfRect(boundBox, 1))) {
      returnTouch=true;
    }

    Rect thisRectR = inRect.getRect();
    if (recNum>0) {
      for (int pr=0; pr<recNum; pr++) {
        int o=order.order.get(pr)[0];
        Rect thatRect=rects.get(o).getRect();
        if (thisRectR.intersectsRect(thatRect)) {
          returnTouch=true;
        }
      }
    }
    return returnTouch;
  }
}

