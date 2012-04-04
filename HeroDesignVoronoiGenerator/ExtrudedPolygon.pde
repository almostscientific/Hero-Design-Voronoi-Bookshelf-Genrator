public class ExtrudedPolygon {
  Polygon2D baseShape;
  float extrudeH;
  float offsetH;
  List<Vec2D> baseVecs2D = new ArrayList<Vec2D>();
  List<Vec3D> baseVecs3D = new ArrayList<Vec3D>();

  TriangleMesh mesh = new TriangleMesh();
  Vec3D extrudeVec;
  Vec3D offsetVec;

  boolean cap;

  public ExtrudedPolygon(Polygon2D inPoly, float h, boolean cap) {
    this.baseShape=inPoly;
    this.extrudeH=h;
    this.cap=cap;
    offsetH=0;//if not specified the extrude is form 0
    baseVecs2D=baseShape.vertices;
    extrudeVec=new Vec3D(0, 0, extrudeH);
    offsetVec=new Vec3D(0, 0, offsetH);
    buildBase();
    extrude();
  }
  public ExtrudedPolygon(Polygon2D inPoly, float h, boolean cap, float offset) {
    this.baseShape=inPoly;
    this.extrudeH=h;
    this.offsetH=offset;
    this.cap=cap;

    baseVecs2D=baseShape.vertices;
    extrudeVec=new Vec3D(0, 0, extrudeH);
    offsetVec=new Vec3D(0, 0, offsetH);
    buildBase();
    extrude();
  }


  void buildBase() {
    for (Vec2D v :baseVecs2D) {
      baseVecs3D.add(new Vec3D(v.x, v.y, 0) );
    }
  }


  void extrude() {
    for (int i=0; i<baseVecs3D.size(); i++) {
      int m=baseVecs3D.size();
      Vec3D v1, v2, v3=new Vec3D();
      //      Vec3D v2=new Vec3D();
      //      Vec3D v3=new Vec3D();

      v1= baseVecs3D.get(i).add(offsetVec);//the base with its base offset
      v2= baseVecs3D.get(i).add(offsetVec).add(extrudeVec);//the base with base offset and extrude
      v3= baseVecs3D.get((i+1)%m).add(offsetVec);//the next point of the base with offset modulo the size
      mesh.addFace(v1, v2, v3);

      v1= baseVecs3D.get((i+1)%m).add(offsetVec);//the base with its base offset
      v2= baseVecs3D.get((i+1)%m).add(offsetVec).add(extrudeVec);//the base with base offset and extrude
      v3= baseVecs3D.get((i)).add(offsetVec).add(extrudeVec);//the next point of the base with offset modulo the size
      mesh.addFace(v1, v2, v3);
    }
    if (cap) {
      Vec2D cent2D =baseShape.getCentroid();
      Vec3D cent3D=new Vec3D(cent2D.x, cent2D.y, 0);
      for (int i=0; i<baseVecs3D.size(); i++) {
        int m=baseVecs3D.size();
        Vec3D t1, t2, t3=new Vec3D();
        Vec3D b1, b2, b3=new Vec3D();
        t1= baseVecs3D.get(i).add(offsetVec).add(extrudeVec);//the base with its base offset
        b1= baseVecs3D.get(i).add(offsetVec);//the base with its base offset
        t2= cent3D.add(offsetVec).add(extrudeVec);//the base with base offset and extrude
        b2= cent3D.add(offsetVec);//the base with base offset and extrude
        t3= baseVecs3D.get((i+1)%m).add(offsetVec).add(extrudeVec);//the base with its base offset
        b3= baseVecs3D.get((i+1)%m).add(offsetVec);//the base with its base offset
        mesh.addFace(t1, t2, t3);
        mesh.addFace(b1, b2, b3);
        
      }
    }
    mesh.computeVertexNormals();
    mesh.faceOutwards() ;
  }
}

