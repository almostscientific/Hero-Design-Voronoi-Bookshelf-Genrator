void writePDF() {
  if (fileName=="") {
    sendMsg("We need a file name before we can save it ...");
  }
  else {
    List<FlatFace> flatFaces = new ArrayList<FlatFace>();  
    final List<MyRect> orginalRects = new ArrayList<MyRect>();
    List<List<Polygon2D>> polysToPack= new ArrayList<List<Polygon2D>>();

    float margin=0;
    if (laser) {
      margin=inchToPixel(marg);
      //    println("margin "+margin);
    }
    if (router) {
      margin=inchToPixel(2*bitD+marg);
    }

    int id=0;
    for (Edge e : graph.getEdges()) {
      Line2D thisLine = new Line2D(e.a, e.b);
      float lineLength = thisLine.getLength()*drawScale;
      flatFaces.add(new FlatFace(lineLength) );
      float hMod = laser ? 1:0.5;
      float tmpHeight=inchToPixel(depth)+(2*(inchToPixel(matThick*hMod)))+margin;
      float tmpWidth=lineLength+(margin*drawScale);
      //Rect rectToPack=new Rect(tmpHeight*drawScale, tmpWidth);
      //rectToPack.width=+margin;
      //rectToPack.heig=+margin;
      orginalRects.add( new MyRect(tmpHeight*drawScale, tmpWidth, id) );//the width has allredy been scaled at this point
      id++;
      //Each flatFace is paird with a Rect that is packed in an order se=pecificed by the packing order
    }
    for (FlatFace ff: flatFaces) {
      List<Polygon2D> tmp = new ArrayList<Polygon2D>();
      tmp.add(ff.flatFace);
      polysToPack.add(tmp);
    }
    ////this adds the vertex the first time
    for (VertexJoint vj : vertexJoints) {
      List<Polygon2D> tmp = new ArrayList<Polygon2D>();
      Polygon2D tmpPoly; 
      tmpPoly=vj.getOutter();
      orginalRects.add( new MyRect(tmpPoly.getBounds().height+(drawScale*margin), tmpPoly.getBounds().width+(drawScale*margin), id));
      id++;
      tmp.add(vj.getOutter());
      tmp.addAll(vj.getTabs());
      polysToPack.add(tmp);
    }
    int vEndId=id;
    int nV=vertexJoints.size();
    ////this adds the vertex the second time and flips it if we are routing.
    for (VertexJoint vj : vertexJoints) {
      List<Polygon2D> tmp = new ArrayList<Polygon2D>();
      Polygon2D tmpPoly;
      if (router) {
        tmpPoly=vj.getOutterReflectd();
        orginalRects.add( new MyRect(tmpPoly.getBounds().height+(drawScale*margin), tmpPoly.getBounds().width+(drawScale*margin), id));
        id++;
        tmp.add(vj.getOutterReflectd());
        tmp.addAll(vj.getTabsReflectd());
        polysToPack.add(tmp);
      }
      if (laser) {//else {
        tmpPoly=vj.getOutter();
        orginalRects.add( new MyRect(tmpPoly.getBounds().height+(drawScale*margin), tmpPoly.getBounds().width+(drawScale*margin), id));
        id++;
        tmp.add(vj.getOutter());
        tmp.addAll(vj.getTabs());
        polysToPack.add(tmp);
      }
    }


    Collections.sort(orginalRects);
    boolean shuf=false;
    PackingOrder order=new PackingOrder(orginalRects.size(), shuf);
    PackedRects packedRects=new PackedRects(orginalRects, order);


    String outFile=fileName+"_output.pdf";
//    PGraphics pdf = createGraphics((int)(inchToPixel(rawMatWidth)*drawScale), (int)(inchToPixel(rawMatHeight)*drawScale), PDF, outFile);
    PGraphics pdf = createGraphics((int)(inchToPixel(rawMatWidth)*drawScale), (int)(inchToPixel(rawMatHeight)*drawScale),  "InMemoryPGraphicsPDF");
    beginRecord(pdf);
    gfx.setGraphics(pdf);
    pdf.noFill();
    pdf.strokeWeight(inchToPixel(0.01));
    for (int i=0; i<order.order.size(); i++) {
      int pacNum=order.order.get(i)[0];//this is the index of the sorted orginal rect
      int thisRectNum=orginalRects.get(pacNum).id;//this number in the packing order to get
      int thisRot=order.order.get(i)[1];//1 if rotated 
      Vec2D cent=packedRects.rects.get(i).getCent();//this is the center of the packed rect
      //    gfx.rect(packedRects.rects.get(thisRectNum).getRect());//This drwaws the packing rect
      pdf.pushMatrix();
      gfx.translate(cent);
      for (Polygon2D poly : polysToPack.get(thisRectNum) ) {
        gfx.polygon2D(poly);
      }
      pdf.popMatrix();
    }
    endRecord();
//    InMemoryPGraphicsPDF impgpdfB = (InMemoryPGraphicsPDF) pdf;  // Get the real renderer
//    byte[] pdfDataB = impgpdfB.getBytes();
//    DataUpload duB=new DataUpload();
//    duB.UploadBinaryData(fileName+"_Cut"+".pdf", "PDF", pdfDataB);
//    println(duB.GetServerFeedback());
             cutPath=writePDFToWeb(fileName+"_Cut"+".pdf",pdf);


//    String digFile=fileName+"_diagram.pdf";
//    PGraphics pdfMap = createGraphics(width, height, PDF, digFile);
    PGraphics pdfMap = createGraphics(width, height, "InMemoryPGraphicsPDF");
    beginRecord(pdfMap);
    gfx.setGraphics(pdfMap);
    pdfMap.noFill();
    pdfMap.strokeWeight(inchToPixel(0.01));
    int i=0;
    for (Edge e : graph.getEdges()) {
      Line2D thisLine = new Line2D(e.a, e.b);
      gfx.line(thisLine);
      Vec2D midPt=thisLine.getMidPoint(); 
      //      pdfMap.noFill();
      pdfMap.fill(255, 255, 255);
      //      pdfMap.noStroke();
      String s=Integer.toString(i);
      String pre="L";
      //      gfx.circle(midPt, textAscent());
      pdfMap.fill(orange);
      pdfMap.textFont(msgFont);
      pdfMap.textAlign(CENTER, CENTER);
      pdfMap.text(pre+s, midPt.x, midPt.y);
      i++;
    }
    int startOfV=i;
    for (VertexJoint vj : vertexJoints) {
      pdfMap.fill(blue);
      //      gfx.circle(vj.V.v, textAscent());
      pdfMap.fill(blue);
      pdfMap.textFont(msgFont);
      String s=Integer.toString(i);
      pdfMap.text("V"+s, vj.V.v.x, vj.V.v.y);
      i++;
    }
    endRecord();      
//    InMemoryPGraphicsPDF impgpdfA = (InMemoryPGraphicsPDF) pdfMap;  // Get the real renderer
//    byte[] pdfDataA = impgpdfA.getBytes();
//    DataUpload duA=new DataUpload();
//    duA.UploadBinaryData(fileName+"_Map"+".pdf", "PDF", pdfDataA);
//    println(duA.GetServerFeedback());
         mapPath=writePDFToWeb(fileName+"_Map"+".pdf",pdfMap);


//    String layFile=fileName+"_layout.pdf";
    //     pdfLay = createGraphics((int)(inchToPixel(rawMatWidth)*drawScale), (int)(inchToPixel(rawMatHeight)*drawScale), PDF, layFile);
    PGraphics pdfLay = createGraphics((int)(inchToPixel(rawMatWidth)*drawScale), (int)(inchToPixel(rawMatHeight)*drawScale), "InMemoryPGraphicsPDF");
    beginRecord(pdfLay);

    gfx.setGraphics(pdfLay);
    pdfLay.strokeWeight(inchToPixel(0.01));

    boolean skip=false;
    for (int j=0; j<order.order.size(); j++) {
      int pacNum=order.order.get(j)[0];//this is the index of the sorted orginal rect
      int thisRectNum=orginalRects.get(pacNum).id;//this number in the packing order to get
      Vec2D cent=packedRects.rects.get(j).getCent();//this is the center of the packed rect

        pdfLay.noFill();
      pdfLay.stroke(1);
      gfx.rect(packedRects.rects.get(thisRectNum).getRect());//This drwaws the packing rect

        pdfLay.pushMatrix();
      gfx.translate(cent);
      for (Polygon2D poly : polysToPack.get(thisRectNum) ) {
        gfx.polygon2D(poly);
      }
      pdfLay.popMatrix();
      pdfLay.fill(0, 0, 255);
      if (router) {
        pdfLay.textFont(msgFont, 40);
      }
      else {
        pdfLay.textFont(msgFont);
      }

      pdfLay.textAlign(CENTER, CENTER);
      String pre=(j>=startOfV)? "V " : "L ";
      if (thisRectNum>=vEndId) {
        thisRectNum-=nV;
      }
      String s=Integer.toString(thisRectNum);
      pdfLay.text(pre+s, cent.x, cent.y);
    }
    endRecord();

//    InMemoryPGraphicsPDF impgpdf = (InMemoryPGraphicsPDF) pdfLay;  // Get the real renderer
//    byte[] pdfData = impgpdf.getBytes();
//    DataUpload du=new DataUpload();
//    du.UploadBinaryData(fileName+"_Layout"+".pdf", "PDF", pdfData);
//    println(du.GetServerFeedback());
     layoutPath=writePDFToWeb(fileName+"_Layout"+".pdf",pdfLay);
    
    gfx.setGraphics(g);
  }
  sendMsg("Done.");
  download=true;
}

String writePDFToWeb(String name, PGraphics thePDF){
    InMemoryPGraphicsPDF impgpdf = (InMemoryPGraphicsPDF) thePDF;  // Get the real renderer
    byte[] pdfData = impgpdf.getBytes();
    DataUpload du=new DataUpload();
    du.UploadBinaryData(name, "PDF", pdfData);
    return du.GetServerFeedback();
}
