

boolean  update() {  
  //println("UPDATE");
  minPolyLen = matThick*5;
//  laserKerf=inchToPixel(0.005);

  voronoi = new Voronoi();
  voronoi.addPoints(pts);

  PolygonClipper2D clip=new ConvexPolygonClipper(bound);

  graph.edges.clear();
  graph.vertexEdgeIndex.clear();
  offsetLines.clear();
  innerPolyPoints.clear();
  for (Polygon2D poly : voronoi.getRegions()) {
    poly=clip.clipPolygon(poly);

    if (!checkPoly(poly)) {
      sendMsg("That creates too small a segement");
      pts.remove(pts.size()-1);//remove the last point
      return false;
    };
    // add all edges of the polygon to the graph (duplicates are ignored automatically)    
    for (int i=0,num=poly.vertices.size(); i<num; i++) {
      graph.addEdge(poly.vertices.get(i), poly.vertices.get((i+1)%num));
    }
  }

  verts.clear();
  for (Vec2D v : graph.getVertices()) {
    verts.add(new Vert(v));
  }

  for (Vert V : verts) {
    for (float t : V.innerThetas) {
      if (degrees(t)<minInteriorTheta) {
        sendMsg("That creates too steep an angle");
          pts.remove(pts.size()-1);//remove the last point
        return false;
      }
    }
  }

  faces.clear();
  extrudedFaces.clear();
  buildPolyEdge();//this adds all the faces to the faces set
  for (Face face : faces) {
    extrudedFaces.add(new ExtrudedPolygon(face.face, inchToPixel(depth), true));
  }
  vertexJoints.clear();
  extrudedJoints.clear();
  for (Vert v : verts) {
    vertexJoints.add(new VertexJoint(v));
  }
  for (VertexJoint vj : vertexJoints) {
    extrudedJoints.add(new ExtrudedPolygon(vj.outter, inchToPixel(matThick), true, inchToPixel(depth)));
    extrudedJoints.add(new ExtrudedPolygon(vj.outter, inchToPixel(matThick), true, -inchToPixel(matThick)));
  }
  update=false;
  return true;
}

boolean checkPoly(Polygon2D poly) {
  float theta;
  List<Line2D> polyLines = new ArrayList<Line2D>();

  for (int i=0; i<poly.vertices.size(); i++) {
    Vec2D thisV = poly.vertices.get(i);
    Vec2D thatV = poly.vertices.get((i+1)%poly.vertices.size());
    polyLines.add(new Line2D(thisV, thatV));
  }

  //  for (Line2D l : polyLines) {
  for (int i=0; i<polyLines.size(); i++) {
    Line2D thisLine = polyLines.get(i);
    Line2D thatLine = polyLines.get((i+1)%poly.vertices.size());
    //checks for min length
    if (thisLine.getLength()<inchToPixel(minPolyLen))  return false;
    //    theta = thisLine
  }

  return true;
}

void setBound() {
  Polygon2D tmp=orginalBound.copy();
  tmp.offsetShape(boundScale);
  bound=tmp;
  update();
}



