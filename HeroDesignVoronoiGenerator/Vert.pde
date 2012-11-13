
public class Vert {
  public int ack=1;
  Vec2D v;
  //  Set<Line2D> linesOfV = new LinkedHashSet<Line2D>();
  List<Line2D> linesOfV = new ArrayList<Line2D>();

  Set<innerVertexEdge> innerVertexEdges = new LinkedHashSet<innerVertexEdge>();
  //  List<innerVertexEdge2> innerVertexEdges2 = new LinkedHashSet<innerVertexEdge2>();
  List<Float> innerThetas = new ArrayList<Float>();
  List<Float> distances = new ArrayList<Float>();


  public Vert(Vec2D v) {
    innerVertexEdges.clear();
    linesOfV.clear();
    this.v=v;
    for (Edge e : graph.getEdgesForVertex(v)) {

      ReadonlyVec2D farVert = v.distanceTo(e.a) > v.distanceTo(e.b) ? e.a : e.b;
      linesOfV.add(new Line2D(v, farVert.copy()));
    }

    getDistanceFromV();

    for (int l=0; l<linesOfV.size(); l++) {
      //      println("in vert linesOfV size:"+linesOfV.size());
      float d1, d2, maxDist;
      Line2D thisLine;
      thisLine=linesOfV.get(l);
      d1=distances.get(l);
      d2=distances.get((l+2)%linesOfV.size());
      maxDist= (d1>d2) ? d1 : d2;
      innerVertexEdges.add(new innerVertexEdge(v, thisLine, maxDist));
    }

  }

  public void getDistanceFromV() {
    for (int i=0; i<linesOfV.size(); i++) {
      float theta, D, thick, gap;
      Vec2D thisVec = new Vec2D();
      Vec2D thatVec = new Vec2D();
      thisVec= linesOfV.get(i).getDirection();
      thatVec= linesOfV.get((i+1)%linesOfV.size()).getDirection();
      theta=thisVec.angleBetween(thatVec);
      innerThetas.add(theta);

      thick= inchToPixel(matThick);
      gap = inchToPixel(minNotchSpace)/2;
      D=(thick/2+gap)/tan(theta/2);
      D = (D<0) ? 0 : D; 
      distances.add(D);
      //      println(degrees(theta)+" "+degrees(theta/2)+ " " +thick + " " + D);
    }
  }

  public boolean isJoinedTo(Vert inV) {
    for (Line2D thatLine : inV.linesOfV) {
      for (Line2D thisLine : this.linesOfV) {
        if (thatLine.equals(thisLine)) {
          return true;
        }
      }
    }
    return false;
  }



  public List<Vec2D> getInnerVertexEdgesForLine(Line2D inLine) {
    List<Vec2D> returnVects=new ArrayList<Vec2D>();
    for (Line2D thisLine : this.linesOfV) {
      if (inLine.equals(thisLine)) {
        for (innerVertexEdge ive : this.innerVertexEdges) {
          if (ive.l.equals(thisLine)) {
            returnVects.add(ive.a.add(this.v)); //add(this.v) corrects for the position of the vert
            returnVects.add(ive.b.add(this.v));
          }
        }
      }
    }
    return returnVects;
  }

  public List<Vec2D> getInnerVertexEdgesForJoin(Vert inV) { 
    //    Line2d join;
    List<Vec2D> returnVects=new ArrayList<Vec2D>();

    for (Line2D thatLine : inV.linesOfV) {
      for (Line2D thisLine : this.linesOfV) {
        if (thatLine.equals(thisLine)) {
          //gets the pair for this vert
          for (innerVertexEdge ive : this.innerVertexEdges) {
            if (ive.l.equals(thisLine)) {
              returnVects.add(ive.a.add(this.v)); //add(this.v) corrects for the position of the vert
              returnVects.add(ive.b.add(this.v));
            }

            for (innerVertexEdge inIve : inV.innerVertexEdges) {
              if (inIve.l.equals(thisLine)) {
                Vec2D lastPoint = ive.b.add(this.v);
                Vec2D aPoint =inIve.a.add(inV.v);
                Vec2D bPoint =inIve.b.add(inV.v);
                if (lastPoint.distanceTo(aPoint) < lastPoint.distanceTo(bPoint)) {
                  //if the a point is closer then the b point
                  returnVects.add(inIve.a.add(inV.v));
                  returnVects.add(inIve.b.add(inV.v));
                } 
                else {
                  returnVects.add(inIve.b.add(inV.v));
                  returnVects.add(inIve.a.add(inV.v));
                }
              }
            }
          }
        }
      }
    }

    return returnVects;
  }



  public boolean hasIntersections() {
    Line2D thisLine;
    Line2D thatLine;
    for (innerVertexEdge thisEdge: innerVertexEdges) {
      thisLine = thisEdge.getLine_();
      for (innerVertexEdge thatEdge: innerVertexEdges) {
        thatLine = thatEdge.getLine_();
        Line2D.LineIntersection isec=thisLine.intersectLine(thatLine);

        if (isec.getType()==Line2D.LineIntersection.Type.INTERSECTING) {
          return true;
        }
      }
    }
    return false;
  }

  public void updateInnerVertexEdge() {
    Line2D thisLine;
    Line2D thatLine;
    for (innerVertexEdge thisEdge: innerVertexEdges) {
      thisLine = thisEdge.getLine_();
      for (innerVertexEdge thatEdge: innerVertexEdges) {
        thatLine = thatEdge.getLine_();

        Line2D.LineIntersection isec=thisLine.intersectLine(thatLine);
        if (isec.getType()==Line2D.LineIntersection.Type.INTERSECTING) {
          thatEdge.incDist();
          //          println("ack"+thatEdge.dist);
        }
      }
    }
  }


  void display() {
    for (innerVertexEdge thisEdge : innerVertexEdges) {
      thisEdge.drawEdge();
    }
  }
}


public class innerVertexEdge {
  float dist=0;
  float distInc=.1;
  Line2D l;
  Vec2D v;
  Vec2D offset;
  Vec2D  addOffset ;
  Vec2D pos;
  Vec2D a;
  Vec2D b;
  boolean intersecting=true;
  //Set<Vec2D> innerVertexEdgeVectors = new HashSet<Vec2D>();

  public innerVertexEdge(Vec2D v, Line2D l, float d) {
    this.l=l;
    this.v=v;
    this.dist=d;
    this.offset=l.getNormal().normalize().scale(inchToPixel(matThick)/2);//this is the offset vector
    this.addOffset=l.getNormal().normalize().scale(inchToPixel(matThick)/2);//this is the extra additive offset
    this.pos=l.getDirection().normalize().scale(dist);
    a=pos.add(offset);
    b=pos.sub(offset);
  }

  public void drawEdge() {
    //    println("ack");
    pushMatrix();
    gfx.translate(v);
    stroke(0, 0, 255);
    //    println(this.a.toString());
    gfx.line(new Line2D(this.a, this.b));
    popMatrix();
  }

  public Line2D getLine() {
    Line2D l=new Line2D(this.a, this.b);
    return l;
  }
  public Line2D getLine_() {
    Line2D l=new Line2D(this.a.add(addOffset), this.b.sub(addOffset));
    //    Line2D l=new Line2D(this.a, this.b);

    return l;//.scale(1.25);
  }
  public void incDist() {
    this.dist+=distInc;
    this.pos=this.l.getDirection().normalize().scale(dist);
    a=pos.add(offset);
    b=pos.sub(offset);
  }
}



