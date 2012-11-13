
void menu() {
  controlP5.setAutoDraw(false);
  ////////////////////////////////////////////////
  ControlGroup displayGroup=controlP5.addGroup("display / view", 20, 20);
  displayGroup.disableCollapse();
  displayGroup.setMoveable(false);
  int space=15;
  controlP5.addToggle("togExtude", 5, 5+space*0, 0, 0).setGroup(displayGroup);
  controlP5.addToggle("togJoints", 5, 5+space*1, 0, 0).setGroup(displayGroup);
  controlP5.addToggle("togFace", 5, 5+space*2, 0, 0).setGroup(displayGroup);
  controlP5.addToggle("togLines", 5, 5+space*3, 0, 0).setGroup(displayGroup);
  controlP5.addToggle("togPoints", 5, 5+space*4, 0, 0).setGroup(displayGroup);
  controlP5.addToggle("togDim", 5, 5+space*5, 0, 0).setGroup(displayGroup);
  controlP5.addButton("butResetcam", 0, 5, 5+space*6, 0, 0).setGroup(displayGroup);
  displayGroup.setBackgroundHeight(115);


  //////////////////////////////////////
  int totalHeight=40+displayGroup.getBackgroundHeight();
  ControlGroup boundryGroup=controlP5.addGroup("boundry", 20, totalHeight);
  boundryGroup.disableCollapse();
  boundryGroup.setMoveable(false);
  space=25;
  controlP5.addButton("butClearBound", 0, 5, 5+space*0, 0, 0).linebreak().setGroup(boundryGroup);
  controlP5.addButton("butGrow", 0, 5, 5+space*1, 0, 0).linebreak().setGroup(boundryGroup);
  controlP5.addButton("butShrink", 0, 5, 5+space*2, 0, 0).setGroup(boundryGroup);
  controlP5.addSlider("slidScale", 1, 10, 5, 5+space*3, 10, 5).setGroup(boundryGroup);
  boundryGroup.setBackgroundHeight(115);
  totalHeight+=boundryGroup.getBackgroundHeight();

  ///////////////////////////////////////////
  ControlGroup pointsGroup=controlP5.addGroup("points", 20, totalHeight);
  pointsGroup.disableCollapse();
  pointsGroup.setMoveable(false); 
  controlP5.addButton("butClear", 0, 5, 5+space*0, 0, 0).linebreak().setGroup(pointsGroup);
  controlP5.addButton("butUndo", 0, 5, 5+space*1, 0, 0).linebreak().setGroup(pointsGroup);
  pointsGroup.setBackgroundHeight(65);
  totalHeight+=pointsGroup.getBackgroundHeight();

  ///////////////////////////////////
  ControlGroup dimGroup=controlP5.addGroup("Dimensions", 20, totalHeight);
  dimGroup.disableCollapse();
  dimGroup.setMoveable(false);  
  controlP5.addSlider("slidMatThick", 0.1, .5, 5, 5+space*0, 15, 5).linebreak().setGroup(dimGroup);
  matThickTextField=controlP5.addTextfield("textMatThick", 5, 5+space*1, 50, 80);
  matThickTextField.setGroup(dimGroup);
  matThickTextField.setAutoClear(false);
  //  matThickTextField.setValue(nf(matThick, 0, 2));

  controlP5.addSlider("slidDepth", 0.125, 24, 5, 5+space*2, 15, 5).linebreak().setGroup(dimGroup);
  dimGroup.setBackgroundHeight(90);
  totalHeight+=dimGroup.getBackgroundHeight();
  ///////////////////////////////
  ControlGroup tweakGroup=controlP5.addGroup("Vertex", 20, totalHeight);
  tweakGroup.disableCollapse();
  tweakGroup.setMoveable(false);  
  controlP5.addSlider("slidCpLenA", 1, 5, 5, 5+space*0, 15, 2).linebreak().setGroup(tweakGroup);
  controlP5.addSlider("slidCpLenB", 1, 5, 5, 5+space*1, 15, 2).linebreak().setGroup(tweakGroup);
  tweakGroup.setBackgroundHeight(65);
  totalHeight+=tweakGroup.getBackgroundHeight();

  ///////////////////////////////////////
  ///////////////////////////////
  ControlGroup buildGroup=controlP5.addGroup("Material / Build", 20, totalHeight);
  buildGroup.disableCollapse();
  buildGroup.setMoveable(false);  
  Radio rMat=controlP5.addRadio("fabMethod", 5, 5+space*0);
  rMat.setGroup(buildGroup);
  rMat.add("Laser / WaterJet", 0);//this is a problme
  rMat.add("Router", 1);
  rMat.setColorActive(orange);
  rMat.setColorBackground(blue);
  rMat.setColorForeground(blue);
  rMat.setColorLabel(blue);
  controlP5.addSlider("slidRawMatWidth", 1, 120, 5, 5+space*1+3, 15, 5).linebreak().setGroup(buildGroup);
  controlP5.addSlider("slidRawMatHeight", 1, 120, 5, 5+space*2+3, 15, 5).linebreak().setGroup(buildGroup);
  Textfield kerfTextField=controlP5.addTextfield("textKerf", 5, 5+space*3+3, 50, 80);
  kerfTextField.setGroup(buildGroup);
  kerfTextField.setAutoClear(false);
  kerfTextField.setValue(nf(laserKerf, 0, 3));
  Textfield bitDTextField=controlP5.addTextfield("textBitD", 5, 5+space*4+3, 50, 80);
  bitDTextField.setGroup(buildGroup);
  bitDTextField.setAutoClear(false);
  bitDTextField.setValue(nf(bitD, 0, 2));
  Textfield margTextField=controlP5.addTextfield("textMarg", 5, 5+space*5+3, 50, 80);
  margTextField.setGroup(buildGroup);
  margTextField.setAutoClear(false);
  margTextField.setValue(nf(bitD, 0, 2));
  buildGroup.setBackgroundHeight(170);
  totalHeight+=buildGroup.getBackgroundHeight();
  ///////////////////////////////
  ControlGroup ioGroup=controlP5.addGroup("Save / Load", 20, totalHeight);
  ioGroup.disableCollapse();
  buildGroup.setMoveable(false); 
  Textfield fileTextField=controlP5.addTextfield("textFile", 5, 5+space*0, 50, 80);
  fileTextField.setGroup(ioGroup);
  fileTextField.setAutoClear(false);
  controlP5.addButton("butSave", 0, 5, 5+space*1, 0, 0).linebreak().setGroup(ioGroup);
  controlP5.addButton("butLoad", 0, 5, 5+space*2, 0, 0).linebreak().setGroup(ioGroup);
  controlP5.addButton("butDownload", 0, 5, 5+space*3, 0, 0).linebreak().setGroup(ioGroup);

  //  fileTextField.setValue(nf(laserKerf, 0, 3));


  setText("textKerf", "Laser Kerf", laserKerf);
  setText("textBitD", "Bit Diamater", bitD);
  setText("textMarg", "Margin", marg);
  setText("textMatThick", "Thickness", matThick);
  setText("textFile", "File Name");

  setToggle("togExtude", "Extrude", 1);
  setToggle("togJoints", "Joints", 1);
  setToggle("togFace", "faces", 0);
  setToggle("togPoints", "points", 1);
  setToggle("togDim", "dimensions", 1);
  setToggle("togLines", "Lines", 0);

  setButton("butSave", "Save");
  setButton("butLoad", "Load");
  setButton("butDownload", "Download");
  setButton("butClear", "Clear All Points");
  setButton("butUndo", "Remove Last Point");
  setButton("butResetcam", "Reset View");
  //  setButton("butWrite", "Write PDF");
  setButton("butClearBound", "New Boundry");
  setButton("butShrink", "Shirnk");
  setButton("butGrow", "Grow");
//  setButton("butSetOto", "1 : 1 view");

  setSlider("slidMatThick", "Thickness", matThick);
  setSlider("slidDepth", "Depth", 1);
  //  setSlider("slidBoundWidth", "Width", boundWidth);
  //  setSlider("slidBoundHeight", "Height", boundWidth);
  setSlider("slidScale", "Boundry Scale", boundScale);
  setSlider("slidCpLenA", "Inner", cpLenModA);
  setSlider("slidCpLenB", "Outtter", cpLenModB);
  setSlider("slidRawMatWidth", "Width", rawMatWidth);
  setSlider("slidRawMatHeight", "Height", rawMatHeight);
  //  setText("textScale","Scale Factor", scaleFactor);
}
public void togLines(boolean theFlag) {
  showLines = theFlag==false ? false: true;
}
public void togExtude(boolean theFlag) {
  showExtrude = theFlag==false ? false: true;
}
public void togJoints(boolean theFlag) {
  showJoint = theFlag==false ? false: true;
}
void togPoints(boolean theFlag) {
  showPoints = theFlag==false ? false: true;
}
public void togFace(boolean theFlag) {
  showFace = theFlag==false ? false: true;
}
public void togDim(boolean theFlag) {
  showDims = theFlag==false ? false: true;
}
public void butSave() {
  boolean saved = save();
  println(saved);
  if(saved){
  output=true;
  msgStatic="Outputing PDFs ... this can take a bit";
  msgOn=true;
  displayStaticMsg();
  }
}
public void butDownload(){
  if(download){
//  link("http://www.hero-design.com/Voronoi/"+fileName+"/"+fileName+"_Layout.pdf","_new");
//  link("http://www.hero-design.com/Voronoi/"+fileName+"/"+fileName+"_Map.pdf","_new");
//  link("http://www.hero-design.com/Voronoi/"+fileName+"/"+fileName+"_Cut.pdf","_new");
    loadStrings("http://www.hero-design.com/zip.php?action=zip&fName="+fileName);
link("http://www.hero-design.com/Voronoi/"+fileName+"/"+fileName+".zip","_blank");
  sendMsg("Ding! Pick up your files in the next windows..");

  
  }else{
        sendMsg("Ummmm, you need to save save before you can download.");

  }

}

public void butLoad() {
  load( );
}
public void butWrite(boolean theValue) {
  output=true;
  msgStatic="Outputing PDFs ... this can take a bit";
  msgOn=true;
  displayStaticMsg();
}

//void butSetOto() {
//  //  cam.setDistance(702);
//}

public void butShrink(boolean theValue) {
  boundScale = (boundScale<0) ? boundScale+=scaleFactor : (-1*(boundScale-=scaleFactor));
  PPI*=scaleFactor;
  update();
}
public void butGrow(boolean theValue) {
  boundScale = (boundScale<0) ? -1*(boundScale+=scaleFactor) : (boundScale+=scaleFactor);
  PPI/=scaleFactor;
  update();
}

public void butClearBound(boolean theValue) {
  needBound=true;
  scaleFactor=1.25;
  PPI=72;
  controlP5.controller("slidScale").setValue(scaleFactor);
  pts.clear();
  update();
  boundPts.clear();
  butResetcam();
}




public void butClear(boolean theValue) {
  pts.clear();
  update=true;
}


public void butUndo(boolean theValue) {
  if (pts.size()-1>0) pts.remove(pts.get(pts.size()-1));
  update=true;
}

public void butResetcam() {
//  scene.camera().setPosition(new PVector(400, 400, 1000));
//  scene.camera().lookAt(new PVector(400, 400, 0));
    scene.camera().setUpVector(new PVector(0, 1, 0));
      scene.camera().setPosition(new PVector(width/2, height/2, 1000));
  scene.camera().setSceneCenter(new PVector(width/2, height/2, 0));
  scene.camera().lookAt(new PVector(width/2, height/2, 0));
  //  cam.reset();
  //  cam.setDistance(702);
}
public void slidRawMatHeight(float theValue) {
  rawMatHeight=theValue;
  update=true;
}
public void slidRawMatWidth(float theValue) {
  rawMatWidth=theValue;
  update=true;
}
public void slidCpLenA(float theValue) {
  cpLenModA=theValue;
  update=true;
}
public void slidCpLenB(float theValue) {
  cpLenModB=theValue;
  update=true;
}
public void slidScale(float theValue) {
  scaleFactor=theValue;
  //  println(scaleFactor);
  //  setBound();
  update=true;
}

public void slidMatThick(float theValue) {
  matThick=theValue;
  //    controlP5.controller("textMatThick").setValue(matThick);
  matThickTextField.setValue(nf(matThick, 0, 2));
  update=true;
}

public void slidDepth(float theValue) {
  depth=theValue;
  update=true;
}
public void slidBoundWidth(float theValue) {
  boundWidth=theValue;
  update=true;
}
public void slidBoundHeight(float theValue) {
  boundHeight=theValue;
  update=true;
}

public void fabMethod(int theID) {
  switch(theID) {
    case(0)://LASER
    laser=true;
    router=false;
    rawMatWidth=24;
    rawMatHeight=18;
    controlP5.controller("slidRawMatWidth").setValue(rawMatWidth);
    controlP5.controller("slidRawMatHeight").setValue(rawMatHeight);
    break;  

    case(1)://ROUTER
    laser=false;
    router=true;
    rawMatWidth=8*12;
    rawMatHeight=4*12;
    controlP5.controller("slidRawMatWidth").setValue(rawMatWidth);
    controlP5.controller("slidRawMatHeight").setValue(rawMatHeight);
    break;
  }
}

public void controlEvent(ControlEvent theEvent) {
  if (theEvent.controller() instanceof Textfield) {
    if (theEvent.controller().name() == "textFile") {
      fileName=theEvent.controller().stringValue();
      sendMsg("Setting the file name to "+fileName);

      //      sendMsg("Laser Kerf = "+theEvent.controller().stringValue());
    }
    if (theEvent.controller().name() == "textKerf") {
      laserKerf=float(theEvent.controller().stringValue());
      //      sendMsg("Laser Kerf = "+theEvent.controller().stringValue());
    }
    if (theEvent.controller().name() == "textMarg") {
      //      laserKerf=float(theEvent.controller().stringValue());
      //      sendMsg("Margin = "+theEvent.controller().stringValue());
      marg=float(theEvent.controller().stringValue());
    }
    if (theEvent.controller().name() == "textBitD") {
      //      laserKerf=float(theEvent.controller().stringValue());
      //      sendMsg("Bit Diamater = "+theEvent.controller().stringValue());
      bitD=float(theEvent.controller().stringValue());
    }
    if (theEvent.controller().name() == "textMatThick") {
      float tmpVal=float(theEvent.controller().stringValue());
      if (tmpVal<0.1) {
        sendMsg("The minimum thicknes is 0.1\"");
        println("a");
      }
      if (tmpVal>0.5) {
        sendMsg("The maximum thicknes is 0.5\"");
        println("b");
      }
      matThick=constrain(tmpVal, 0.1, .5);
      controlP5.controller("slidMatThick").setValue(matThick);
      //      update();
    }
  }
}
//color blue=color(0, 146, 255);
//color orange=color(255, 166, 0);
public void setToggle(String s, String l, int state) {
  controlP5.controller(s).setLabel(l);
  controlP5.controller(s).setValue(state);
  controlP5.controller(s).setSize(10, 10);
  controlP5.controller(s).setColorActive(orange);
  controlP5.controller(s).setColorBackground(blue);
  controlP5.controller(s).captionLabel().style().marginTop=-13;
  controlP5.controller(s).captionLabel().style().marginLeft=13;
  controlP5.controller(s).captionLabel().setColor(blue);

  //    controlP5.controller(s).setColorCaptionLabel(color(0, 146, 255));
  //  controlP5.controller(s).captionLabel().setColor(color(0,146,255),true);
  //  controlP5.controller(s).captionLabel().disableColorBackground() ;
}

public void setButton(String s, String l) {
  controlP5.controller(s).setLabel(l);
  controlP5.controller(s).setSize(20, 20);
  controlP5.controller(s).setColorActive(orange);
  controlP5.controller(s).setColorBackground(blue);
  controlP5.controller(s).setColorForeground(lightOrange);
  controlP5.controller(s).captionLabel().setColor(blue);

  controlP5.controller(s).captionLabel().style().marginLeft=20;
  controlP5.controller(s).captionLabel().disableColorBackground() ;
}

public void setSlider(String s, String l, float intVal) {
  controlP5.controller(s).setLabel(l);
  controlP5.controller(s).setValue(intVal);
  controlP5.controller(s).setHeight(20);
  controlP5.controller(s).setWidth(80);
  controlP5.controller(s).setColorActive(orange);
  controlP5.controller(s).setColorBackground(blue);
  controlP5.controller(s).setColorForeground(lightOrange);
  controlP5.controller(s).setColorValueLabel(color(0, 0, 0));
  //    controlP5.controller(s).setColorCaptionLabel(blue);
  controlP5.controller(s).captionLabel().setColor(blue);
  //  controlP5.controller(s).captionLabel().setColorBackground(color(bgColor));
  controlP5.controller(s).captionLabel().disableColorBackground() ;
}

public void setText(String s, String l, float intVal) {
  controlP5.controller(s).setLabel(l);
  controlP5.controller(s).setValue(intVal);
  controlP5.controller(s).setHeight(20);
  controlP5.controller(s).setWidth(30);  
  controlP5.controller(s).setColorActive(color(255, 166, 0));
  controlP5.controller(s).setColorValueLabel(color(0, 0, 0));
  controlP5.controller(s).setColorBackground(color(0, 146, 255));
  controlP5.controller(s).setColorForeground(color(255, 206, 121));
  //  controlP5.controller(s).setColorCaptionLabel(color(0, 146, 255));
  //        controlP5.controller(s).captionLabel().setColor(color(0,146,255));
  controlP5.controller(s).captionLabel().setColor(blue);

  controlP5.controller(s).captionLabel().style().marginTop=-18;
  controlP5.controller(s).captionLabel().style().marginLeft=+35;
  controlP5.controller(s).captionLabel().disableColorBackground() ;
}
public void setText(String s, String l) {
  controlP5.controller(s).setLabel(l);
  //  controlP5.controller(s).setValue(intVal);
  controlP5.controller(s).setHeight(20);
  controlP5.controller(s).setWidth(50);  
  controlP5.controller(s).setColorActive(color(255, 166, 0));
  controlP5.controller(s).setColorValueLabel(color(0, 0, 0));
  controlP5.controller(s).setColorBackground(color(0, 146, 255));
  controlP5.controller(s).setColorForeground(color(255, 206, 121));
  //  controlP5.controller(s).setColorCaptionLabel(color(0, 146, 255));
  //        controlP5.controller(s).captionLabel().setColor(color(0,146,255));
  controlP5.controller(s).captionLabel().setColor(blue);

  controlP5.controller(s).captionLabel().style().marginTop=-18;
  controlP5.controller(s).captionLabel().style().marginLeft=+55;
  controlP5.controller(s).captionLabel().disableColorBackground() ;
}

