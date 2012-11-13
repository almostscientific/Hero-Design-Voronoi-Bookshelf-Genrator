void buildPolyEdge() {
    for (Edge thisEdge : graph.edges) {
      //for each edge
      List<Vec2D> faceVecs = new ArrayList<Vec2D>();
      List<Vec2D> a=new ArrayList<Vec2D>();
      List<Vec2D> b=new ArrayList<Vec2D>();

      Set<Vert> vertsOfLine = new HashSet<Vert>();

      for (Vert thisVert : verts) {
        //for each vert
        if (thisEdge.a.equals(thisVert.v)) {
          //if this edge is as a point at this vertex
          //get the offset lines associated with this line at this vert
          Line2D l=new Line2D(thisEdge.a.copy(), thisEdge.b.copy()); //the line of the edge
          a=thisVert.getInnerVertexEdgesForLine(l);
        }
        if (thisEdge.b.equals(thisVert.v)) {
          //get the offset lines associated with this line at this vert
          Line2D l=new Line2D(thisEdge.a.copy(), thisEdge.b.copy());

          b=thisVert.getInnerVertexEdgesForLine(l);
        }
      }
      faceVecs.add(a.get(0));
      faceVecs.add(a.get(1));
      ReadonlyVec2D tmp1= b.get(0);
      ReadonlyVec2D tmp2= b.get(1); 

      if (a.get(1).distanceTo(tmp1) < a.get(1).distanceTo(tmp2) ) {
        faceVecs.add(b.get(0));
        faceVecs.add(b.get(1));
      } 
      else {
        faceVecs.add(b.get(1));
        faceVecs.add(b.get(0));
      }
      Face tmp = new Face(faceVecs);
      faces.add(tmp);
    }
    
    for(Face f:faces){
    f.checkFace();
    
    }
}

