import java.util.List;
import java.util.*;
import java.io.*;

/**
 * @author Alexander MacDonald
 * @date 11/23/2020
 */
public class GraphSearchEngineImpl implements GraphSearchEngine {

    /**
     * my main method that would make sure it worked lol/
     */
    /*
    public static void main(String[] args) throws IOException {
        IMDBGraphImpl bruh = new IMDBGraphImpl
                ("D:\\2103\\Project 3\\src\\actors_test.list",
                        "D:\\2103\\Project 3\\src\\actresses_test.list");
        GraphSearchEngineImpl searchEngine = new GraphSearchEngineImpl();
        searchEngine.findShortestPath(bruh.getActor("Actor1"), bruh.getActor("Actress1"));

    }
     */

    /**
     * Find the shortest path between nodes
     * @param s the start node.
     * @param t the target node.
     * @return the path in a list form of the path.
     */
    public List<Node> findShortestPath(Node s, Node t) {
        Node source = s;
        Node destination = t;

        Map<Node, Integer> distance = new HashMap<Node, Integer>(); //how far out is each node
        Map<Node, Node> previous = new HashMap<Node, Node>(); // keeps track of order
        Queue<Node> queue = new LinkedList<>(); //queue


        distance.put(source, 0);
        previous.put(source, null);
        queue.offer(source);

        while (!queue.isEmpty()) {
            Node u = queue.poll();
            if (u.equals(destination)) {
                return goBack(u, previous, source);
            }
            queue.remove(u);
            for (int i = 0; i < u.getNeighbors().size(); i++) {
                ArrayList<Node> temp = (ArrayList<Node>) u.getNeighbors();
                if (!distance.containsKey(temp.get(i))) {
                    distance.put(temp.get(i), distance.get(u) + 1);
                    previous.put(temp.get(i), u);
                    queue.offer(temp.get(i));
                    u = temp.get(i);
                }
            }
        }
        return null;
    }

    /**
     * backtracks through the previous hashmap to get the path taken for shortest distance.
     * @param destination - the new *source* node
     * @param previous - the path to take
     * @param source - the new *destination* node
     * @return - the path from source to destination (reverse of *source* to *destination*
     */
    List<Node> goBack(Node destination, Map<Node, Node> previous, Node source) {
        previous.get(destination);
        List<Node> finalPath = new ArrayList<>();

        Node help = destination;
        while(!(previous.get(help) == null))
        {
            finalPath.add(help);
            help = previous.get(help);
        }
        finalPath.add(source);
        Collections.reverse(finalPath); //since it places it in backwards
        ArrayList<Node> bruh = (ArrayList<Node>) finalPath;


        /**
         * make sure it works lol
         */
        for(int i = 0; i < bruh.size(); i++)
        {
            System.out.println(bruh.get(i).getName());
        }

        return finalPath;
    }
}





