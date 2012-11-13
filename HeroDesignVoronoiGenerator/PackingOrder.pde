  // this class can mate and evolve.

public class PackingOrder {

  List<int[]> order = new ArrayList<int[]>();
  int len;

  PackingOrder(int inlen, boolean shuf) {
    len=inlen;
    for (int i=0; i<len; i++) {
      int[] tmp = new int[2];
      tmp[0]=i;
      tmp[1]=0;
      order.add(tmp);
    }
    if (shuf) {
      int n=order.size()-1;
      int startShuffel = int(random(0, n));
      int stopShuffel = int(random(startShuffel+1, n));
      Collections.shuffle(order.subList(startShuffel, stopShuffel));
              mutate(.5);
    }
  }

  PackingOrder(int inlen, List<int[]> inOrder) {
    len=inlen;
    order.addAll(inOrder);
  }

  List<int[]> getOrder() {

    return order;
  }

  int[] getGene(int gene) {
    return order.get(gene);
  }

  void mutate(float rate) {
    for (int[] gene : order) {
      if (random(1) < rate) {
        gene[1] = (gene[1]==0) ? 1 : 0;
      }
    }
  }

  PackingOrder mate(PackingOrder mate) {
    List<int[]> childOrder = new ArrayList<int[]>();
    int crossover = int(random(len));
    int crossoverLen=int(random(1, len-crossover));
    //This adds the genes from this object
    childOrder.addAll(order.subList(crossover, (crossover+crossoverLen) ));
    for (int[] gene :mate.order) {
      boolean found=false;       
      for (int[] childGene: childOrder) {
        if (gene[0]==childGene[0]) {
          found=true;
        }
      }    
      if (!found) {
        //if the mates gene is not present in the child
        childOrder.add(gene);
      }
    }
    PackingOrder child = new PackingOrder(len, childOrder);
    return child;
  }
}

