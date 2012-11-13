/**
 * A single immutable, undirected connection between two vertices.
 * Provides equals() & hashCode() implementations to ignore direction.
 */
public class Edge {

  public final ReadonlyVec2D a, b;

  public Edge(ReadonlyVec2D a, ReadonlyVec2D b) {
//    println(a.x);
    this.a = a;
    this.b = b;
  }

  public boolean equals(Object o) {
    //accepts an object as an input
    if (o != null && o instanceof Edge) { 
      //if the incoming objects is not null
      // and the it is an instacen of an Edge object
      Edge e = (Edge) o;
      //creates a new edge, e, for the incoming edge object
      return
        (a.equals(e.a) && b.equals(e.b)) ||
        (a.equals(e.b) && b.equals(e.a));
      //if any of the points match up it retourns true
    }
    return false;
    //otherwise it retursn faluse
  }

  public Vec2D getDirectionFrom(ReadonlyVec2D p) {
    Vec2D dir = b.sub(a);
    if (p.equals(b)) {
      dir.invert();
    }
    return dir;
  }

  public ReadonlyVec2D getOtherEndFor(ReadonlyVec2D p) {
    return p.equals(a) ? b : a;
  }

  public int hashCode() {
    return a.hashCode() + b.hashCode();
  }

  public String toString() {
    return a.toString() + " <-> " + b.toString();
  }
}

