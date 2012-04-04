void render() {
  gfx.setGraphics(G3);
 
  G3.beginDraw();
  scene.beginDraw();

  G3.pushMatrix();
//  G3.translate(-400, -400);
 
  G3.background(bgColor);
  G3.smooth();
  G3.shininess(10);
  G3.ambientLight(255, 255, 255);
  G3.directionalLight(255, 255, 255, 0, 1, 0);

    if (bound.containsPoint(new Vec2D(mouseX, mouseY))) {
      //this is the projection of the cursor 
      G3.noStroke();
      G3.fill(color(255, 166, 0));
      gfx.circle(new Vec2D(mouseX, mouseY), 10);
    }
    
  if (showDims) {
    drawDims(G3);
  }
  if (showPoints) {
    for (Vec2D p : pts) {
      G3.fill(255, 0, 255);
      G3.noStroke();
      gfx.circle(p, 10);
      G3.noFill();
      G3.stroke(1);
    }
  }
  if (showLines) {
    for (Edge e : graph.getEdges()) {
      //These are the main lines of the voronie
      gfx.line(e.a, e.b);//THis is a line made by two readonlyVectors
    }
  }
  //  for (Vert v : verts) {
  //    //displays the vert lines
  //    if (showIVE) {
  //      v.display();
  //    }
  //  }
  if (showFace) {
    for (Face face : faces) {
      face.render();
    }
  }
  if (showJoint && !showExtrude) {
    for (VertexJoint vj : vertexJoints) {
      vj.renderJoint();
    }
  }

  if (showExtrude) {
    for (ExtrudedPolygon eFace : extrudedFaces) {
      G3.noSmooth();
      G3.fill(orange);
      G3.noStroke();
      gfx.mesh(eFace.mesh);
      G3.noFill();
      G3.stroke(0);
      G3.smooth();
    }
    if (showJoint) {
      for (ExtrudedPolygon eJoint : extrudedJoints) {
        G3.noSmooth();
        G3.fill(blue);
        G3.noStroke();
        gfx.mesh(eJoint.mesh);
        G3.noFill();
        G3.stroke(0);
        G3.smooth();
      }
    }
  }
  else {
    if (showJoint) {
      for (VertexJoint vj : vertexJoints) {

        vj.renderJoint();
      }
    }
  }
  scene.endDraw();
  G3.popMatrix();
  G3.endDraw();
  gfx.setGraphics(g);
}


void drawDims(  PGraphics _canvas) {
    dimCanvas=_canvas;
    dimCanvas.stroke(0);
    dimCanvas.strokeWeight(2);
    dimCanvas.strokeCap(ROUND);
    dimCanvas.fill(0);
//    dimCanvas.noSmooth();
  //  println("dims");
  //  if (needBound) {
  if (bound.vertices.size()>=2) {
    Rect dimRect=new Rect();
    dimRect=bound.getBounds();
    Vec2D cent=new Vec2D();
    cent=bound.getCentroid();
    //    println(cent.toString());
    //      gfx.circle(cent, 20);
    Vec2D halfW=new Vec2D( dimRect.width/2, 0);
    //      Line2D halfWLine = new Line2D(cent, cent.add(halfW));
    Line2D boundWLine, boundHLine;// = new Line2D();
    float offset=50;
    boundWLine=dimRect.getEdge(0).offsetAndGrowBy(offset, 0.0, dimRect.getEdge(0).getNormal());
    boundHLine=dimRect.getEdge(1).offsetAndGrowBy(offset, 0.0, dimRect.getEdge(0).getNormal());
    Vec2D wmp=boundWLine.getMidPoint();
    Vec2D hmp=boundHLine.getMidPoint();
    dimCanvas.textFont(font, max(boundWLine.getLength(), boundHLine.getLength())/10);
    dimCanvas.fill(0);
    float wLen=pixelToInch(boundWLine.getLength());
    float hLen=pixelToInch(boundHLine.getLength());
    float wLenFeet=floor(wLen/12);
    float wLenInch=wLen%12;
    float hLenFeet=floor(hLen/12);
    float hLenInch=hLen%12;
    String widthFeetString =nf(wLenFeet, 0, 0);
    String widthInchString =nf(wLenInch, 0, 2);
    String heightFeetString =nf(hLenFeet, 0, 0);
    String heightInchString =nf(hLenInch, 0, 2);
    String widthStringA= new String(widthFeetString+"' "+widthInchString+"\"");
    String widthStringB= new String(widthInchString+"\"");
    String heightStringA= new String(heightFeetString+"' "+widthInchString+"\"");
    String heightStringB= new String(heightInchString+"\"");
    if (wLenFeet>0) {
      dimCanvas.text(widthStringA, wmp.x-(textWidth(widthStringA)/2), wmp.y-10);
    }
    else {
      dimCanvas.text(widthStringB, wmp.x-(textWidth(widthStringB)/2), wmp.y-10);
    }
    if (hLenFeet>0) {
      dimCanvas.text(heightStringA, hmp.x+(textWidth(heightStringA)/4), hmp.y+textAscent()/2);
    }
    else {
      dimCanvas.text(heightStringB, hmp.x+(textWidth(heightStringB)/4), hmp.y+textAscent()/2);
    }
    //    text(round(pixelToInch(boundWLine.getLength()))+"\"", wmp.x, wmp.y-10);
    //        text(round(pixelToInch(boundHLine.getLength()))+"\"", hmp.x+10, hmp.y);

//dimCanvas.smooth();
    gfx.line(boundWLine);
    gfx.line(boundHLine);
  }
  //  }
}

