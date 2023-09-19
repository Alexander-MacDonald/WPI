import java.io.*;

import java.util.*;

/**
 * @author Alexander MacDonald
 * @date 11/23/2020
 */
public class IMDBGraphImpl implements IMDBGraph {

	/**
	 * This was my main method for checking that the graph formed properly.
	 */

/*
	public static void main(String[] args) throws IOException {
		IMDBGraphImpl bruh = new IMDBGraphImpl
				("D:\\2103\\Project 3\\src\\actors_test.list",
						"D:\\2103\\Project 3\\src\\actresses_test.list");
		for(int i = 0; i < bruh.allActors.size(); i++)
		{
			System.out.println(bruh.allActors.get(i).getName());

			for(int j = 0; j < bruh.allActors.get(i).getNeighbors().size(); j++)
			{
				System.out.println("Movies Actor " + (i + 1) + " is in: " + bruh.allActors.get(i).getNeighbor(j).getName());
			}
			System.out.println();

		}

		for(int k = 0; k < bruh.allMovies.size(); k++)
		{
			System.out.println(bruh.allMovies.get(k).getName());

			for(int l = 0; l < bruh.allMovies.get(k).getNeighbors().size(); l++)
			{
				System.out.println("Actors in Movie " + (k + 1) + ": " + bruh.allMovies.get(k).getNeighbor(l).getName());
			}
			System.out.println();
		}



	}
*/

	ArrayList<actorNode> allActors = new ArrayList<actorNode>();
	ArrayList<movieNode> allMovies = new ArrayList<movieNode>();

	/**
	 * Generates movie nodes on a graph with actorNode neighbors.
	 */
	public class movieNode implements Node{
		String name;
		ArrayList<actorNode> actorNeighbors  = new ArrayList<actorNode>();

		/**
		 * Constructor for movie node
		 * @param name the name of the movie
		 */
		public movieNode(String name){
			this.name = name;
		}

		/**
		 * Name getter
		 * @return returns the name of the movie
		 */
		public String getName(){
			return name;
		}

		/**
		 * Neighbors getter
		 * @return returns the actorNode neighbors of the movie
		 */
		public Collection<? extends Node> getNeighbors(){
			return actorNeighbors;
		}

		/**
		 * Gets specific neighbor at specific index
		 * @param index index of neighbor you want
		 * @return actorNode at the specified index
		 */
		public actorNode getNeighbor(int index){
			return actorNeighbors.get(index);
		}

		/**
		 * Adds actorNode to movie neighbors
		 * @param s actorNode that is an actor/actress that was in the movie.
		 */
		public void addActor(actorNode s)
		{
			actorNeighbors.add(s);
		}

	}
	/**
	 * Generates actor nodes on a graph with movieNode neighbors.
	 */
	public class actorNode implements Node{
		String name;
		ArrayList<movieNode> movieNeighbors = new ArrayList<movieNode>();

		/**
		 * Constructor for an actorNode
		 * @param name name of actor
		 */
		public actorNode(String name){
			this.name = name;
		}

		/**
		 * Actor name getter
		 * @return name of actor
		 */
		public String getName(){
			return name;
		}

		/**
		 * Neighbors getter
		 * @return returns the movieNode neighbors of the actor
		 */
		public Collection<? extends Node> getNeighbors(){
			return movieNeighbors;
		}
		/**
		 * Gets specific neighbor of actor at specific index
		 * @param index index of neighbor you want
		 * @return movieNode at the specified index
		 */
		public movieNode getNeighbor(int index){
			return movieNeighbors.get(index);
		}

		/**
		 * Adds movieNode to actor neighbors
		 * @param s movieNode that is a movie that the actor was in.
		 */
		public void addMovie(movieNode s)
		{
			movieNeighbors.add(s);
		}

	}

	/**
	 * Processes the files and creates a graph of nodes
	 * @param actorsFilename - nodes and their neighbors
	 * @param actressesFilename - another set of nodes and their neighbors.
	 * @throws IOException
	 */
	public IMDBGraphImpl (String actorsFilename, String actressesFilename) throws IOException {
		processActors(actorsFilename, -1);
		int bruh3 = allActors.size() - 1;
		processActors(actressesFilename, bruh3);
	}

	/**
	 * @return all the actors/actresses processed
	 */
	public Collection<? extends Node> getActors () {
		return allActors;
	}

	/**
	 * @return all the movies processed
	 */
	public Collection<? extends Node> getMovies () {
		return allMovies;
	}

	/**
	 * checks if movie exists in processed data and returns the node
	 * @param name the name of the requested movie
	 * @return the node of the movie, if the movie doesn't exist, return null
	 */
	public Node getMovie (String name) {
		for(int i = 0; i < allMovies.size(); i++)
		{
			if(allMovies.get(i).name.equals(name))
			{
				return allMovies.get(i);
			}
		}
		return null;
	}

	/**
	 * checks if actor exists in processed data and returns the node
	 * @param name the name of the requested actor
	 * @return the node of the actor, if the actor doesn't exist, return null
	 */
	public Node getActor (String name) {
		for(int i = 0; i < allActors.size(); i++)
		{
			if(allActors.get(i).name.equals(name))
			{
				return allActors.get(i);
			}
		}
		return null;
	}

	/**
	 * Parses the movie title from a line containing a movie
	 * @param str line containing a movie
	 * @return the movie title
	 */
	protected static String parseMovieName (String str) {
		int idx1 = str.indexOf("(");
		int idx2 = str.indexOf(")", idx1 + 1);
		return str.substring(0, idx2 + 1);
	}

	/**
	 * Scans an IMDB file for its actors/actresses and movies
	 * @param filename the movie file to parse
	 */
	protected void processActors (String filename, int actorCounter) throws IOException {
		final Scanner s = new Scanner(new File(filename), "ISO-8859-1");

		// Skip until:  Name...Titles
		while (s.hasNextLine()) {
			String line = s.nextLine();
			if (line.startsWith("Name") && line.indexOf("Titles") >= 0) {
				break;
			}
		}
		s.nextLine();  // read one more

		String actorName = null;

		while (s.hasNextLine()) {
			final String line = s.nextLine();

			//System.out.println(line);
			if (line.indexOf("\t") >= 0) {  // new movie, either for an existing or a new actor
				int idxOfTab = line.indexOf("\t");
				if (idxOfTab > 0) {  // not at beginning of line => new actor
					actorName = line.substring(0, idxOfTab);
					boolean flag = false;
					actorCounter++; //know what actor you're on

					actorNode node = new actorNode(actorName);
					/**
					 * the actors are different (Kevin Bacon (II) vs Kevin Bacon (VI) so a new node every time
					 */

					allActors.add(node);
				}
				if (line.indexOf("(TV)") < 0 && line.indexOf("\"") < 0) {  // Only include bona-fide movies
					int lastIdxOfTab = line.lastIndexOf("\t");
					final String movieName = parseMovieName(line.substring(lastIdxOfTab + 1));
					boolean flag = false;
					int space = -1;

					/**
					 * movies can repeat and keep track of what movie repeats. to add it again, otherwise add it as unique movie
					 */
					for (int j = 0; j < allMovies.size(); j++)
					{
						if(movieName.equals(allMovies.get(j).name))
						{
							flag = true;
							space = j;
							break;
						}
					}
					if(!flag)
					{
						movieNode node = new movieNode(movieName);
						allMovies.add(node);
						allActors.get(actorCounter).addMovie(node);
						node.addActor(allActors.get(actorCounter));
					}
					else
					{
						allActors.get(actorCounter).addMovie(allMovies.get(space));
						allMovies.get(space).addActor(allActors.get(actorCounter));
					}
					// We have found a new movie
				}
			}
		}
	}
}
