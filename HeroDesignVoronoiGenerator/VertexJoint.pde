public class VertexJoint {
  Vert V;

  List<Polygon2D> tabs = new ArrayList<Polygon2D>();
  List<Vec2D[]> outterPointsSets = new ArrayList<Vec2D[]>();
  Set<Vec2D> allOutterPoihts = new LinkedHashSet<Vec2D>();
  boolean[] flipped = new boolean[4];
  Polygon2D outter=new Polygon2D();

  float innerR;
  float outterR;

  float toler=0;//0.05;
  float notchW=0;//This is the width added to the matThick in inches
  float notchH=matThick*1.5;//In inches //20+toler;
  float outterWidthOffset=matThick/2;//*.3;
  float outterHeightOffset=matThick/2;//*.3;

  public VertexJoint(Vert V) {
    this.V=V;
    flipped[0]=false;
    flipped[1]=false;
    flipped[2]=false;

    buildJoint();
  }

  Polygon2D getOutter() {
    Polygon2D returnPoly=new Polygon2D();
    Vec2D outterBoundVec=outter.getBounds().getCentroid();
    Vec2D deltaVec=outterBoundVec.sub(V.v);
    //deltaVec insures that the joint gets drawin in the center of its packing rect.
    for (Vec2D polyV: outter.vertices) {
      returnPoly.add(polyV.sub(V.v).sub(deltaVec));
    }
    return returnPoly.scale(drawScale);
  }

  Polygon2D getOutterReflectd() {
    Polygon2D returnPoly=new Polygon2D();
    Polygon2D reflectOuter=new Polygon2D();
    //reflects 
    Vec2D N =new Vec2D(0, 1);
    for (Vec2D oV: outter.vertices) {
      reflectOuter.add(oV.getReflected(N));
    }

    Vec2D outterBoundVec=reflectOuter.getBounds().getCentroid();
    Vec2D deltaVec=outterBoundVec.sub(V.v);

    for (Vec2D polyV: reflectOuter.vertices) {
      returnPoly.add(polyV.sub(V.v).sub(deltaVec));
    }
    return returnPoly.scale(drawScale);
  }

  List<Polygon2D> getTabs() {
    List<Polygon2D> returnList=new ArrayList<Polygon2D>();
    Vec2D outterBoundVec=outter.getBounds().getCentroid();
    Vec2D deltaVec=outterBoundVec.sub(V.v);

    for (Polygon2D t:tabs) {
      Polygon2D tmpPoly=new Polygon2D();
      for (Vec2D polyV: t.vertices) {
        tmpPoly.add(polyV.sub(V.v).sub(deltaVec));
      }
      returnList.add(tmpPoly.scale(drawScale));
    }
    return returnList;
  }

  List<Polygon2D> getTabsReflectd() {
    //       List<Polygon2D> returnList=new ArrayList<Polygon2D>();
    List<Polygon2D> reflectedTabs=new ArrayList<Polygon2D>();
    Vec2D N =new Vec2D(0, 1);
    Vec2D outterBoundVec=outter.getBounds().getCentroid();
    Vec2D deltaVec=outterBoundVec.sub(V.v);
    for (Polygon2D t:tabs) {
      Polygon2D tmpPoly=new Polygon2D();
      for (Vec2D polyV: t.vertices) {

        tmpPoly.add(polyV.sub(V.v).sub(deltaVec).getReflected(N));
      }

      //      for(Vec2D v:tmpPoly){
      //      v.sub(V.v).sub(deltaVec);
      //      }
      reflectedTabs.add(tmpPoly.scale(drawScale));
    }
    return reflectedTabs;
  }

  Rect getBoundingRect() {
    return getOutter().getBounds();
  }

  void renderJoint() {

    for (Polygon2D tab : tabs) {
      //      stroke(255, 0, 0);
      noFill();
      stroke(blue);

      gfx.polygon2D(tab);
      if (!outter.isClockwise()) {
        outter.flipVertexOrder();
      }
      int x = outter.isClockwise() ? 255 : 0;
      //      stroke(x, 0, 255);
      stroke(blue);
      gfx.polygon2D(outter);
    }

    //    for (Vec2D p : allOutterPoihts) {
    //      //    gfx.circle(p,10);
    //    }
  }



  void buildJoint() {
    //    println("buildJoint "+ V.innerVertexEdges.size());
    int iveIndex=0;
    for (innerVertexEdge ive : V.innerVertexEdges) {
      //build the notches
      Vec2D a, b, c, d;
      Line2D thisLine= ive.getLine().copy();//Gets the line of the IVE
      Vec2D thisNorm=thisLine.getDirection();//gets the drection that line goes in
      /////
      Line2D outterNotchLine;
      ////////for laser cutting 
      if (laser) {
        thisLine.offsetAndGrowBy(laserKerf, -laserKerf, thisNorm);
        outterNotchLine=thisLine.offsetAndGrowBy(inchToPixel(notchH)+laserKerf, inchToPixel(notchW), thisNorm);
      }
      else {
        outterNotchLine=thisLine.offsetAndGrowBy(inchToPixel(notchH), inchToPixel(notchW), thisNorm);
      }
      outterNotchLine.set(outterNotchLine.a.add(V.v), outterNotchLine.b.add(V.v));
      a= outterNotchLine.a;
      b= outterNotchLine.b;
      c= b.add(outterNotchLine.getNormal().normalize().getInverted().scale(inchToPixel(notchH)));
      d= a.add(outterNotchLine.getNormal().normalize().getInverted().scale(inchToPixel(notchH)));
      tabs.add(new Polygon2D(a, b, c, d));
      //outter line
      Line2D outterLine=ive.getLine().copy().offsetAndGrowBy(inchToPixel(notchH)+inchToPixel(outterHeightOffset), inchToPixel(notchW)+inchToPixel(outterWidthOffset), thisNorm);
      outterLine.set(outterLine.a.add(V.v), outterLine.b.add(V.v));

      Vec2D[] outterPoints = new Vec2D[2];
      outterPoints[0]=outterLine.a;
      outterPoints[1]=outterLine.b ;

      outterPointsSets.add(outterPoints);
    }
    //Check to be sure the vectors of the outterPointsSets are in the proper order
    //if not put them in the right order
    for (int i=0; i<outterPointsSets.size(); i++) {
      //      println(outterPointsSets.size());
      int M=outterPointsSets.size();
    }
    if (outterPointsSets.size()==3) {
      Line2D l1, l2, l3;

      l1=new Line2D(outterPointsSets.get(0)[1], outterPointsSets.get(1)[0]);
      l2=new Line2D(outterPointsSets.get(1)[1], outterPointsSets.get(2)[0]);
      l3=new Line2D(outterPointsSets.get(2)[1], outterPointsSets.get(0)[0]);

      Line2D.LineIntersection isec1=l1.intersectLine(l2);
      Line2D.LineIntersection isec2=l3.intersectLine(l2);
      Line2D.LineIntersection isec3=l3.intersectLine(l1);

      if (isec1.getType()==Line2D.LineIntersection.Type.INTERSECTING) {
        int i=0;
        Vec2D tmp1, tmp2;
        Vec2D[] tmp3 = new Vec2D[2];
        tmp1=outterPointsSets.get(i)[0];
        tmp2=outterPointsSets.get(i)[1];
        tmp3[0]=tmp2;
        tmp3[1]=tmp1;
        outterPointsSets.set(i, tmp3);
        flipped[i]=true;
      }
      if (isec2.getType()==Line2D.LineIntersection.Type.INTERSECTING) {
        int i=1;
        Vec2D tmp1, tmp2;
        Vec2D[] tmp3 = new Vec2D[2];
        tmp1=outterPointsSets.get(i)[0];
        tmp2=outterPointsSets.get(i)[1];
        tmp3[0]=tmp2;
        tmp3[1]=tmp1;
        outterPointsSets.set(i, tmp3);
        flipped[i]=true;
      }
      if (isec3.getType()==Line2D.LineIntersection.Type.INTERSECTING) {
        int i=2;
        Vec2D tmp1, tmp2;
        Vec2D[] tmp3 = new Vec2D[2];
        tmp1=outterPointsSets.get(i)[0];
        tmp2=outterPointsSets.get(i)[1];
        tmp3[0]=tmp2;
        tmp3[1]=tmp1;
        outterPointsSets.set(i, tmp3);
        flipped[i]=true;
      }
    }

    for (int i=0; i<outterPointsSets.size(); i++) {
      //implement Bezier
      int M=outterPointsSets.size();
      float cpLen; 
      float x1, x2, y1, y2, cpx1, cpx2, cpy1, cpy2;
      Vec2D cp1Vec, cp2Vec;      

      if (outterPointsSets.size()==2) {
      }
      else {
        //        println("matThick= "+(matThick));
        //        println("cpLen= "+inchToPixel(matThick)*(25/inchToPixel(matThick)));
        //        println();
        cpLen =inchToPixel(matThick)*cpLenModA;//25;
      }

      //set main points
      x1=outterPointsSets.get(i)[1].x;
      y1=outterPointsSets.get(i)[1].y;
      x2=outterPointsSets.get((i+1) % M)[0].x;
      y2=outterPointsSets.get((i+1) % M)[0].y;
      //caculate the control points
      if (outterPointsSets.size()==2) {
        //IF this is a cornde
        Vec2D tmp1=new Vec2D(x1, y1);
        Vec2D tmp2=new Vec2D(x2, y2);
        Line2D thisLine= new Line2D(tmp1, tmp2);
        Vec2D tmp3=new Vec2D(outterPointsSets.get((i+1)% M)[1].x, outterPointsSets.get((i+1)% M)[1].y);
        Vec2D tmp4=new Vec2D(outterPointsSets.get((i+2) % M)[0].x, outterPointsSets.get((i+2) % M)[0].y);
        Line2D nextLine= new Line2D(tmp3, tmp4);
        cpLen= (thisLine.getLength() > nextLine.getLength()) ? inchToPixel(matThick)*cpLenModB :inchToPixel(matThick)*cpLenModA;
      }
      else {
        cpLen =inchToPixel(matThick)*cpLenModA;//25;
      }
      //create the line between the two points
      Line2D l1 = new Line2D(outterPointsSets.get(i)[0], outterPointsSets.get(i)[1]);
      Line2D l2 = new Line2D(outterPointsSets.get((i+1) % M)[0], outterPointsSets.get((i+1) % M)[1]);
      //get the noram vector, scale it by the length
      Vec2D norm1 = l1.getNormal().normalizeTo(cpLen);
      Vec2D norm2 = l2.getNormal().normalizeTo(cpLen);
      //create a new vector for each CP by adding the norm vector to the main point
      cp1Vec = outterPointsSets.get(i)[1].add(norm1.invert());
      cp2Vec = outterPointsSets.get((i+1) % M)[0].add(norm2.invert());
      if (flipped[i]) {
        //this flips inverts the control points of the direction of the points were flipped earliler
        cp1Vec = outterPointsSets.get(i)[1].sub(norm1);
        cp2Vec = outterPointsSets.get((i+1) % M)[0].sub(norm2);
      }
      //define the cps by these vector componets
      cpx1=cp1Vec.x;
      cpy1=cp1Vec.y;
      cpx2=cp2Vec.x;
      cpy2=cp2Vec.y;
      //run though and get points
      int steps = 25;
      for (int s = 0; s <= steps; s++) {
        float t = s / float(steps);
        //xpoint1 xcp1 xcp2 xp2
        float x = bezierPoint(x1, cpx1, cpx2, x2, t);
        float y = bezierPoint(y1, cpy1, cpy2, y2, t);

        //convert each point to a vector
        Vec2D p =new Vec2D(x, y); 
        allOutterPoihts.add(p);
        //      println(p.toString());
        //  ellipse(width/2, height/2, 5, 5);
        //add that vector to outter polygon
        outter.add(p);
        //may need to add to a set and then add that set to the polygon
      }
    }

    if (outter.vertices.size()>4) {
      //      linef(outter.vertices.size());
      //    println(outter.vertices.get(0));
      Line2D l1=new Line2D(outter.vertices.get(1), outter.vertices.get(2));
      Line2D l2=new Line2D(outter.vertices.get(3), outter.vertices.get(4));
      Line2D.LineIntersection isec=l1.intersectLine(l2);

      if (isec.getType()==Line2D.LineIntersection.Type.INTERSECTING) {
        //        println("X");

        Collections.swap(outter.vertices, 0, 1);
        Collections.swap(outter.vertices, 2, 3);
        Collections.swap(outter.vertices, 4, 5);
      }
      else {
        //        println("O");
      }
    }
    //    Iterator it = outter.vertices.iterator();
    //    while(it.hasNext()){
    //    
    //      
    //    }
  }
}

