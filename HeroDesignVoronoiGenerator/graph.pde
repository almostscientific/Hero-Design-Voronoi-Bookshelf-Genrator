
/**
 * This class implements a undirected vertex graph and provides basic connectivity information.
 * Vertices can only be added by defining edges, ensuring there're no isolated nodes
 * (but allowing for subgraphs/clusters).
 */
public class UndirectedGraph {

  // use vertex position as unique keys and a list of edges as its value
  private final Map<Vec2D, List<Edge>> vertexEdgeIndex = new LinkedHashMap<Vec2D, List<Edge>>();

  // set of all edges in the graph
  private final Set<Edge> edges = new HashSet<Edge>();

  // attempts to add new edge for the given vertices
  // if successful also add vertices to index and associate edge with each
  public void addEdge(Vec2D a, Vec2D b) {
    a.x=floor(a.x*1000)/1000;
    a.y=floor(a.y*1000)/1000;
    b.x=floor(b.x*1000)/1000;
    b.y=floor(b.y*1000)/1000;
    if (!a.equals(b)) {
      Edge e = new Edge(a, b);
      if (edges.add(e)) {
        addEdgeForVertex(a, e);
        addEdgeForVertex(b, e);
      }
    }
  }

  private void addEdgeForVertex(Vec2D a, Edge e) {

    List<Edge> vertEdges = vertexEdgeIndex.get(a);
    if (vertEdges == null) {
      vertEdges = new ArrayList<Edge>();
      vertexEdgeIndex.put(a, vertEdges);
    }
    vertEdges.add(e);
  }

  public Set<Edge> getEdges() {// returns a set of edges
    return edges;
  }

  // get list of edges for the given vertex (or null if vertex is unknown)
  public List<Edge> getEdgesForVertex(ReadonlyVec2D v) {
    return vertexEdgeIndex.get(v);
  }

  public Set<Vec2D> getVertices() {
    return vertexEdgeIndex.keySet();
  }
}

