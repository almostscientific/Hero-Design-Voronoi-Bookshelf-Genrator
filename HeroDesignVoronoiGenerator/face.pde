public class Face {
  Polygon2D face;
  List<Vec2D> basePoints = new ArrayList<Vec2D>();
  
  public Face(List<Vec2D> inVecs) {
    basePoints=inVecs;
    this.face=new Polygon2D(basePoints);
    //    checkFace();
  }

  public void render() {
    gfx.polygon2D(this.face);
  }

  public void checkFace() {
    Vec2D a, b, c, d;
    Line2D l1, l2;

    //    for(i=0, i<4, i++){
    a=this.face.vertices.get(0);
    b=this.face.vertices.get(1);
    c=this.face.vertices.get(2);
    d=this.face.vertices.get(3);
    l1=new Line2D(a, c);
    l2=new Line2D(a, c);
    Line2D.LineIntersection isec=l1.intersectLine(l2);

    if (isec.getType()==Line2D.LineIntersection.Type.INTERSECTING) {
    }
    else {
    }
    
  }


  public boolean isClockwise() {
    return face.isClockwise();
  }
}

