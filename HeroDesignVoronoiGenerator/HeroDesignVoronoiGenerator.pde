import toxi.processing.*;
import toxi.geom.*;
import toxi.math.*;
import toxi.geom.mesh2d.*;
import toxi.geom.mesh.*;
import processing.pdf.*;
import controlP5.*;
import remixlab.proscene.*;

//import processing.video.*;
//MovieMaker mm;  // Declare MovieMaker object


boolean applet=true;

Textfield matThickTextField;

ControlP5 controlP5;
PMatrix3D currCameraMatrix;
PGraphics3D g3;
Voronoi voronoi = new Voronoi();
UndirectedGraph graph=new UndirectedGraph();
ToxiclibsSupport gfx;
PFont font, msgFont;
PGraphics G3, dimCanvas;


Set<Line2D> offsetLines = new HashSet<Line2D>();
Set<Vec2D> innerPolyPoints = new HashSet<Vec2D>();
Set<Vert> verts = new HashSet<Vert>();
Set<Face> faces = new HashSet<Face>();
Set<ExtrudedPolygon> extrudedFaces = new HashSet<ExtrudedPolygon>();
Set<ExtrudedPolygon> extrudedJoints = new HashSet<ExtrudedPolygon>();

List<Vec2D> pts=new ArrayList<Vec2D>();
List<VertexJoint> vertexJoints = new ArrayList<VertexJoint>();

boolean doneUpating=true;//this is what controls the dynamic ver updating
boolean doneBuildingFaces=false;
boolean doneBuildingVertexJoint=false;
boolean doneExtrudingFaces=false;
boolean doneExtrudingJoints=false;
boolean showJoint=true;
boolean showFace=false;
boolean showLines=false;
boolean showIVE=true;
boolean showExtrude=true;
boolean update=true;
boolean badForm=false;
boolean showPoints=true;
boolean showDims=true;
boolean laser=true;
boolean router=false;
boolean needBound=true;
boolean needBoundCheck=true;
boolean msgOn=false;
boolean output=false;
boolean download=false;
Vec2D selectedVertex=null;
float snapDist = 5*5;
public float matThick = 0.204;//.125;//in inches
float minNotchSpace=matThick/2;
float minPolyLen = matThick*5;
float minInteriorTheta = 50; //deg
float depth=1; // in inches
float PPI;
float boundScale=1;
float scaleFactor=1.25;
float bitD=0.25;
float cpLenModA=1;
float cpLenModB=4;//outside coner
float drawScale;
float marg=0.25;
int recursionKlugeCount=0;
float recursionKlugeX=0.0;
float recursionKlugeY=0.0;
boolean next=true;
//int w=1000;
//int h=800;
float laserKerf=0.005;
float rawMatWidth, rawMatHeight;

Rect clipRect;
float boundWidth=8;//in inches
float boundHeight=8;

long timer = 0;
String msg = "";
String msgStatic="";
public String fileName="";
String layoutPath, mapPath, cutPath;

Polygon2D bound, orginalBound;
int nBoundPts=5;
List<Vec2D> boundPts=new ArrayList<Vec2D>();

color blue=color(0, 146, 255);
color orange=color(255, 166, 0);
color lightOrange=color(255, 206, 121);
color bgColor=color(255);//255*.8;

int msgDur=8000;

Scene scene, GUIscene;

void setup() {
  font=loadFont("GothamNightsNormal-40.vlw");
  msgFont=loadFont("GothamNightsNormal-25.vlw");
  PPI=72;
//  try {
//    quicktime.QTSession.open();
//  } 
//  catch (quicktime.QTException qte) { 
//    qte.printStackTrace();
//  }
  size(1000, 800);
  smooth();
  gfx=new ToxiclibsSupport(this);

//  mm = new MovieMaker(this, width, height, "test.mov", 
//  30, MovieMaker.ANIMATION, MovieMaker.LOSSLESS);

  controlP5 = new ControlP5(this);
  if (laser) {
    rawMatWidth=24;
    rawMatHeight=18;
  }
  menu();
  controlP5.controller("slidScale").setValue(1.25);
  G3 = createGraphics(width, height, P3D);
  scene = new Scene(this, (PGraphics3D)G3);
  scene.setGridIsDrawn(false);
  scene.setAxisIsDrawn(false);
  scene.disableKeyboardHandling();
  scene.camera().setPosition(new PVector(width/2, height/2, 1000));
  scene.camera().setSceneCenter(new PVector(width/2, height/2, 0));
  scene.camera().lookAt(new PVector(width/2, height/2, 0));
  scene.camera().setUpVector(new PVector(0, 1, 0));
}

void draw() {
  background(bgColor);
  drawScale=(72/PPI);//THIS SCALES THE PIXELS
  stroke(0);
  strokeWeight(1);
  setControlP5Active();

  if (!needBound) {
    if (update) {
      update();
    }
    render();
    image(G3, 0, 0);
    drawBound();
  }
  else {//if we still need bound
    bound = new Polygon2D(boundPts);
    fill(color(0, 146, 255, 50));
    stroke(color(0, 146, 255));
    strokeWeight(2);
    gfx.polygon2D(bound);
    for (Vec2D bpts:boundPts) {
      fill(color(255, 166, 0));
      noStroke();
      gfx.circle(bpts, 10);
    }
    drawDims(g);
  }

  if (!needBound) {
    if (pts.size()>0) {
      controlP5.controller("butGrow").lock();
      controlP5.controller("butShrink").lock();
      controlP5.controller("butGrow").setColorBackground(color(134, 130, 130));
      controlP5.controller("butShrink").setColorBackground(color(134, 130, 130));
    }
  }
  else {
    controlP5.controller("butGrow").unlock();
    controlP5.controller("butShrink").unlock();
    controlP5.controller("butGrow").setColorBackground(color(0, 146, 255));
    controlP5.controller("butShrink").setColorBackground(color(0, 146, 255));
  }

  gui();

  if (msgOn) {
    displayStaticMsg();
  }
  if (boundPts.size()==nBoundPts) {
    needBound=false;
    orginalBound=bound.copy();
  }
  if (laser) {
    controlP5.controller("textBitD").lock(); 
    controlP5.controller("textBitD").setColorBackground(color(134, 130, 130));
    controlP5.controller("textBitD").setColorValueLabel(color(100));
    controlP5.controller("textKerf").unlock();
    controlP5.controller("textKerf").setColorBackground(color(0, 146, 255));
  }
  if (router) {
    controlP5.controller("textBitD").unlock();
    controlP5.controller("textBitD").setColorBackground(color(0, 146, 255));
    controlP5.controller("textBitD").setColorValueLabel(color(0));

    controlP5.controller("textKerf").lock();
    controlP5.controller("textKerf").setColorBackground(color(134, 130, 130));
    controlP5.controller("textKerf").setColorValueLabel(color(100));
  }

  if (output) {
    writePDF();
    output=false;
    msgOn=false;
  }
//  mm.addFrame();  // Add window's pixels to movie
}



void drawBound() {
  if (pts.size()==0) {
    fill(color(0, 146, 255));
    stroke(color(0, 146, 255));
    strokeWeight(2);
    gfx.polygon2D(bound);
    for (Vec2D bpts:boundPts) {
      fill(color(255, 166, 0));
      noStroke();
      gfx.circle(bpts, 10);
    }
  }
}

void mousePressed() {
  Vec2D p = new Vec2D(mouseX, mouseY);
  if (!needBound) {
    if (bound.containsPoint(p)) {
      pts.add(p);
      update=true;
    }
    else {
    }
  }
  else {
    boundPts.add(p);
  }
}

float pixelToInch(float pix) {
  return pix/PPI;
}

float inchToPixel(float inch) {
  return PPI*inch;
}


void keyPressed() {
  if (key == ' ') {
//    mm.finish();  // Finish the movie if space bar is pressed!
  }
}

void gui() {
  controlP5.draw();
  if (timer > millis()) displayMsg();
  if (msgOn) displayMsg();
  drawMouse(new Vec2D(mouseX, mouseY));
}

void drawMouse(Vec2D pos) {
  noStroke();
  fill(blue);
  gfx.circle(pos, 10);
}

void  setControlP5Active() {
  if (controlP5.window(this).isMouseOver()|| pts.size()==0) {
    scene.disableMouseHandling();
  } 
  else {
    scene.enableMouseHandling();
  }
}

void displayMsg() {
  int marg=10;
  textFont(msgFont);
  float fade=map(timer - millis(), 0, 3000, 0, 100);
  fill(orange, fade );
  noStroke();
  float textW=textWidth(msg);
  float textH=textAscent()+textDescent();
  Rect msgbox=new Rect(140, 30, textW+marg*2, textH+marg*2);
  gfx.polygon2D(msgbox.toPolygon2D(5, 10));
  Vec2D msgboxCent=msgbox.getCentroid();
  fill(blue, fade);
  text(msg, msgbox.x+marg, msgboxCent.y+textH/2-(marg/2));
}

void displayStaticMsg() {
  println("static "+msgStatic);
  int marg=10;
  textFont(msgFont);
  fill(orange);
  noStroke();
  float textW=textWidth(msgStatic);
  println(textW);
  float textH=textAscent()+textDescent();
  Rect msgbox=new Rect(140, 30, textW+marg*2, textH+marg*2);
  gfx.polygon2D(msgbox.toPolygon2D(5, 10));
  Vec2D msgboxCent=msgbox.getCentroid();
  fill(blue);
  println(msgbox.x+marg);
  text(msgStatic, msgbox.x+marg, msgboxCent.y+textH/2-(marg/2));
}

void sendMsg(String inMsg) {
  msg=inMsg;
  timer = millis() + msgDur;
}

boolean save() {
    return(saveApplet());
}

boolean saveApplet() {
  if (fileName=="") {
    sendMsg("We need a file name before we can save it ...");
    return false;
  }
  else {
    sendMsg("Yeah, let's save this one as "+fileName);

    String[] writeString= new String[9];
    String urlToPhp="http://www.hero-design.com/myphp.php";

    List<String> ptsStrings=new ArrayList<String>();
    for (Vec2D p: pts) {
      ptsStrings.add(p.toString().replaceAll(" ", ""));
    }
    String[] arrayOfPts=ptsStrings.toArray(new String[ptsStrings.size()]); 
    String allPts;
    allPts=join(arrayOfPts, ";");

    List<String> boundStrings=new ArrayList<String>();
    for (Vec2D bp: boundPts) {
      boundStrings.add(bp.toString().replaceAll(" ", ""));
    }
    String[] arrayOfBoundPts=boundStrings.toArray(new String[boundStrings.size()]); 
    String allBoundPts;
    allBoundPts=join(arrayOfBoundPts, ";");

    writeString[0]=allPts;
    writeString[1]=allBoundPts;
    writeString[2]=nf(matThick, 0, 0);
    writeString[3]=nf(depth, 0, 0);
    writeString[4]=nf(cpLenModA, 0, 0);
    writeString[5]=nf(cpLenModB, 0, 0);
    writeString[6]=nf(boundScale, 0, 0);
    writeString[7]=nf(scaleFactor, 0, 0);
    writeString[8]=nf(PPI, 0, 0);

    String saveString=urlToPhp+"?type=save&fName="+fileName+"&allPts="+allPts+"&allBoundPts="+writeString[1]+"&matThick="+writeString[2]+"&depth="+writeString[3]+"&cpLenModA="+writeString[4]+"&cpLenModB="+writeString[5]+"&boundScale="+writeString[6]+"&scaleFactor="+writeString[7]+"&PPI="+writeString[8];

    //    loadStrings(saveString);
    String [] lines;
    lines=loadStrings(saveString);
    for (String s : lines) {
      s.replaceAll("<br>", "");
    }
    if (lines[0] != null) {
      println(lines[0]);
      sendMsg(lines[0]);
      return lines[0].equals("I saved you!")? true:false;
    }
    else {
      println("Null");
      return false;
    }
  }
}

void saveApp() {
  println(fileName);
  if (fileName=="") {
    sendMsg("We need a file name before we can save it ...");
  }
  else {
    //  String fname=fileName;
    sendMsg("Yeah, let's save this one as "+fileName);

    String[] writeString= new String[9];

    List<String> ptsStrings=new ArrayList<String>();
    for (Vec2D p: pts) {
      ptsStrings.add(p.toString());
    }
    String[] arrayOfPts=ptsStrings.toArray(new String[ptsStrings.size()]); 
    String allPts;
    allPts=join(arrayOfPts, ";");

    List<String> boundStrings=new ArrayList<String>();
    for (Vec2D bp: boundPts) {
      boundStrings.add(bp.toString());
    }
    String[] arrayOfBoundPts=boundStrings.toArray(new String[boundStrings.size()]); 
    String allBoundPts;
    allBoundPts=join(arrayOfBoundPts, ";");

    writeString[0]=allPts;
    writeString[1]=allBoundPts;
    writeString[2]=nf(matThick, 0, 0);
    writeString[3]=nf(depth, 0, 0);
    writeString[4]=nf(cpLenModA, 0, 0);
    writeString[5]=nf(cpLenModB, 0, 0);
    writeString[6]=nf(boundScale, 0, 0);
    writeString[7]=nf(scaleFactor, 0, 0);
    writeString[8]=nf(PPI, 0, 0);

    saveStrings(fileName, writeString);
  }
}

void load() {
loadApplet();
}

void loadApplet() {
  String [] lines;
  if (fileName=="") {
    sendMsg("Ummm, what file did you want to load ...");
  }
  else {
    Pattern p=Pattern.compile("\\d+.\\d+");
    pts.clear();
    boundPts.clear();
    //    lines = loadStrings(fileName);
    lines = loadStrings("http://www.hero-design.com/myphp.php?type=load&fName="+fileName);
    for (String s : lines) {
      s.replaceAll("<br>", "");
      println(s.replaceAll("<br>", ""));
    }
    println(lines[0]);
    println(lines[1]);
    println(lines[2].replaceAll("<br>", ""));

    if (lines==null) {
      sendMsg("Oops something is wrong with your file, check you spelling ...");
      return;
    }
    else {
      sendMsg("Sweet, we loaded you file named "+fileName);
    }
    //the first line contais the pts
    List<String> inPts=Arrays.asList(split(lines[0].replaceAll("<br>", ""), ';'));
    for (String s: inPts) {
      Matcher m =p.matcher(s);
      Float[] vals=new Float[2];
      int x=0;
      while (m.find ()) {
        vals[x]= float(m.group());
        x++;
      }
      pts.add(new Vec2D(vals[0], vals[1]));
    }
    //the second line is the boundry
    List<String> inBoundPts=Arrays.asList(split(lines[1].replaceAll("<br>", ""), ';'));
    for (String s: inBoundPts) {
      Matcher m =p.matcher(s);
      Float[] vals=new Float[2];
      int x=0;
      while (m.find ()) {
        vals[x]= float(m.group());
        x++;
      }

      boundPts.add(new Vec2D(vals[0], vals[1]));
    }
    bound = new Polygon2D(boundPts);
    //The Thrid line is 
    matThick=float(lines[2].replaceAll("<br>", ""));
    controlP5.controller("slidMatThick").setValue(matThick);

    depth=float(lines[3].replaceAll("<br>", ""));
    controlP5.controller("slidDepth").setValue(depth);

    cpLenModA=float(lines[4].replaceAll("<br>", ""));
    controlP5.controller("slidCpLenA").setValue(cpLenModA);

    cpLenModB=float(lines[5].replaceAll("<br>", ""));
    controlP5.controller("slidCpLenB").setValue(cpLenModB);

    boundScale=float(lines[6].replaceAll("<br>", ""));

    scaleFactor=float(lines[7].replaceAll("<br>", ""));
    controlP5.controller("slidScale").setValue(scaleFactor);
    PPI=float(lines[8].replaceAll("<br>", ""));
    butResetcam();
    update();
    render();
    drawBound();
  }
}

//void loadApp() {
//  String [] lines;
//  if (fileName=="") {
//    sendMsg("Ummm, what file did you want to load ...");
//  }
//  else {
//    Pattern p=Pattern.compile("\\d+.\\d+");
//    pts.clear();
//    boundPts.clear();
//    lines = loadStrings(fileName);
//    if (lines==null) {
//      sendMsg("Oops something is wrong with your file, check you spelling ...");
//      return;
//    }
//    else {
//      sendMsg("Sweet, we loaded you file named "+fileName);
//    }
//    //the first line contais the pts
//    List<String> inPts=Arrays.asList(split(lines[0], ';'));
//    for (String s: inPts) {
//      Matcher m =p.matcher(s);
//      Float[] vals=new Float[2];
//      int x=0;
//      while (m.find ()) {
//        vals[x]= float(m.group());
//        x++;
//      }
//      pts.add(new Vec2D(vals[0], vals[1]));
//    }
//    //the second line is the boundry
//    List<String> inBoundPts=Arrays.asList(split(lines[1], ';'));
//    for (String s: inBoundPts) {
//      Matcher m =p.matcher(s);
//      Float[] vals=new Float[2];
//      int x=0;
//      while (m.find ()) {
//        vals[x]= float(m.group());
//        x++;
//      }
//
//      boundPts.add(new Vec2D(vals[0], vals[1]));
//    }
//    bound = new Polygon2D(boundPts);
//    //The Thrid line is 
//    matThick=float(lines[2]);
//    controlP5.controller("slidMatThick").setValue(matThick);
//
//    depth=float(lines[3]);
//    controlP5.controller("slidDepth").setValue(depth);
//
//    cpLenModA=float(lines[4]);
//    controlP5.controller("slidCpLenA").setValue(cpLenModA);
//
//    cpLenModB=float(lines[5]);
//    controlP5.controller("slidCpLenB").setValue(cpLenModB);
//
//    boundScale=float(lines[6]);
//
//    scaleFactor=float(lines[7]);
//    controlP5.controller("slidScale").setValue(scaleFactor);
//    PPI=float(lines[8]);
//    butResetcam();
//    update();
//    render();
//    drawBound();
//  }
//}

