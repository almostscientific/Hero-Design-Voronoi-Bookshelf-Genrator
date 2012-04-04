//public class Population {
//  //this class contains a list of packedRects which are variations on packing
//
//  List<PackedRects> pop= new ArrayList<PackedRects>();
//  List<PackedRects> topPop= new ArrayList<PackedRects>();
//  List<MyRect> cloneList= new ArrayList<MyRect>();
//  List<PackingOrder> darwin=new ArrayList<PackingOrder>();//the breading pool
//  List<Float[]> topMembers =new ArrayList<Float[]>();
//
//  int nPop;
//  float mutationRate;
//  boolean firstMember=true;
//  PackingOrder order;
//
//  int topPopNum=5;
//
//  public  Population(float mutation, int n) {
//    mutationRate=mutation;
//    nPop=n;
//    for (int i=0; i< nPop; i++) {
//      cloneList.clear();
//      buildCloneList();
//      boolean shuf = firstMember ? false : true;
//      order=new PackingOrder(orginalRects.size(), shuf);
//      pop.add(new PackedRects(cloneList, order));
//      firstMember=false;
//    }
//  }
//
//  void buildCloneList() {
//    for (MyRect r : orginalRects) {
//      MyRect theClone = (MyRect)r.clone();
//      cloneList.add(theClone);
//    }
//  }
//
//  void clipPopulation() {
//    print("ClipingPop///");
//    //    println();
//
//    topPop.clear();
//    List<Float> fit = new ArrayList<Float>();
//    List<Float> topFitTmp = new ArrayList<Float>();
//    for (int p=0; p<pop.size(); p++) {
//      fit.add(pop.get(p).getFitness());
//    }
//    //    Collections.sort(fit);
//    Collections.sort(fit, Collections.reverseOrder());
//
//    topFitTmp=fit.subList(0, topPopNum);
//    HashSet hashset=new HashSet(topFitTmp);
//    List<Float> topFit = new ArrayList<Float>(hashset);
//    Collections.sort(topFit, Collections.reverseOrder());
//
//    //       println("fit" + fit);
//    print(" topfit "+topFit);
//    float ave=0;
//    for (Float f: fit) {
//      ave+=f;
//    }
//    ave/=fit.size();
//    //    println("aveFit "+ave);
//
//    //REMOVE BELOW AVE MEMEBERS OF POP
//    Iterator it=pop.iterator();
//    while (it.hasNext ()) {
//      PackedRects pr=(PackedRects)it.next();
//      if (pr.getFitness() <ave) {
//        it.remove();
//      }
//    }
//    Iterator fIt=topFit.iterator();
//    while (fIt.hasNext ()) {
//      float F=(Float)fIt.next();
//      for (PackedRects pr:pop) {
//        if (pr.getFitness()==F) {
//          //          println("add "+ F);
//          topPop.add(pr);
//          break;
//        }
//      }
//    }
//  }
//
//  public void selection() {
//    print("Selecting///");
//    clipPopulation();
//    float totalFitness = getTotalFitness();
//    int idx=0;
//    for (PackedRects pr : pop) {
//      float normFitness = pr.getFitness()/totalFitness;
//      int n = (int) (normFitness * 1000.0f);
//      //      println("norm fitness= "+n);
//      //      println();
//      for (int j = 0; j < n; j++) {
//        darwin.add(pr.getPackingOrder());
//        //Darwin is a List of PackedRects with better performing ones more represeted
//      }
//    }
//  }
//
//  void generate() {
//    ///int popNum=0;
//    print(" Generating new pop ");
//
//    pop.clear();
//    //    println("top Pop size "+topPop.size());
//    for (PackedRects pr: topPop) {
//      //      print(popNum+"-");
//      //      PackingOrder popPackingOrder=pr.getPackingOrder();
//      //      cloneList.clear();
//      //      buildCloneList();
//      //      pop.add(new PackedRects(cloneList, popPackingOrder));
//      pop.add(pr);
//    }
//    //    print("b");
//    for (int i=0; i< nPop-(topPop.size()*1); i++) {
//      if (i%100==0) {
////        print(i+"...");
//      }
//      int m = int(random(darwin.size()));
//      int d = int(random(darwin.size()));
//      PackingOrder mom = darwin.get(m);
//      PackingOrder dad = darwin.get(d);
//
//      PackingOrder childPackingOrder = mom.mate(dad);
//      childPackingOrder.mutate(mutationRate);
//      cloneList.clear();
//      buildCloneList();
//      pop.add(new PackedRects(cloneList, childPackingOrder));
//      //      popNum++;
//    }
//  }
//
//  float getTotalFitness() {
//    float total=0;
//    for (PackedRects pr : pop) {
//      total =+ pr.getFitness();
//    }
//    return total;
//  }
//}

