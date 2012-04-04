boolean lIsec(Line2D l1, Line2D l2) {
  Line2D la=l1.copy();
  Line2D lb=l2.copy();
  Line2D.LineIntersection isec=la.intersectLine(lb);
  if (isec.getType()==Line2D.LineIntersection.Type.INTERSECTING ) {
    return true;
  }
  else return false;
}


boolean polygonsIntersect(Polygon2D polyA, Polygon2D polyB) {

  for (Line2D ea : getEdges(polyA)) {
    for (Line2D eb : getEdges(polyB)) {
      Line2D.LineIntersection isec=ea.intersectLine(eb);
      //      if (isec.getType()==Line2D.LineIntersection.Type.INTERSECTING || isec.getType()==Line2D.LineIntersection.Type.COINCIDENT) {
      if (isec.getType()==Line2D.LineIntersection.Type.INTERSECTING ) {
        return true;
      }
    }
  }
  return false;
}

public List<Line2D> getEdges(Polygon2D poly) {
  int num = poly.vertices.size();
  List<Line2D> edges = new ArrayList<Line2D>(num);
  for (int i = 0; i < num; i++) {
    edges.add(new Line2D(poly.vertices.get(i), poly.vertices.get((i + 1) % num)));
  }
  return edges;
}

boolean polygonIntersectLine(Polygon2D poly, Line2D l) {
  for (Line2D e : getEdges(poly)) {
    Line2D.LineIntersection isec=e.intersectLine(l);
    if (isec.getType()==Line2D.LineIntersection.Type.INTERSECTING ) {
      return true;
    }
  }
  return false;
}


void getRectFromPolygon(Polygon2D poly) {
  List<Vec2D> vec = new ArrayList<Vec2D>();
  Collections.copy(vec, poly.vertices);
  Collections.sort(vec);
  for (Vec2D v: vec) {
    println(v.toString());
  }
}

public Line2D getEdgeOfRect(Rect r, int id) {
  //0 top 1 right 2 bottom 3 left
  Line2D edge = null;

  switch (id) {
    // top
  case 0:
    edge = new Line2D(new Vec2D(r.x, r.y), new Vec2D(r.x + r.width, r.y));
    break;
    // right
  case 1:
    edge = new Line2D(new Vec2D(r.x + r.width, r.y), new Vec2D(r.x + r.width, r.y + r.height));
    break;
    // bottom
  case 2:
    edge = new Line2D(new Vec2D(r.x, r.y + r.height), new Vec2D(r.x + r.width, r.y + r.height));
    break;
    // left
  case 3:
    edge = new Line2D(new Vec2D(r.x, r.y), new Vec2D(r.x, r.y + r.height));
    break;
  default:
    throw new IllegalArgumentException("edge ID needs to be 0...3");
  }
  return edge;
}



