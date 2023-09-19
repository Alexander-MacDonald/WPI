import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * An implementation of <tt>Cache</tt> that uses a least-recently-used (LRU)
 * eviction policy.
 */
public class LRUCache<T, U> implements Cache<T, U> {

	private Map<T, Node<T, U>> m;

	private int numMisses = 0;
	private int size = 0;
	private int numElements = 0;

	private DataProvider<T,U> provider;

	private Node<T, U> head;
	private Node<T, U> tail;

	private class Node<T, U>{
		private Node<T, U> next;
		private Node<T, U> previous;
		private T key;
		private U data;
		private Node (T key, U data){
			this.key = key;
			this.data = data;
		}
	}

	/**
	 * @param provider the data provider to consult for a cache miss
	 * @param capacity the exact number of (key,value) pairs to store in the cache
	 */
	public LRUCache (DataProvider<T, U> provider, int capacity) {
		size = capacity;
		this.provider = provider;
		head = null;
		tail = null;
		m = new HashMap<T, Node<T, U>>();
	}

	/**
	 * Returns the value associated with the specified key.
	 * @param key the key
	 * @return the value associated with the key
	 */
	public U get (T key) {
		if (!(m.containsKey(key))) { /** does it not exist in hashmap? **/
			Node<T, U> node = new Node<T, U>(key, provider.get(key)); /** instantiate node **/
			numMisses++; /** miss **/
			if (head == null) {  /** if this is the first node, make the head and tail it **/
				head = node;
				tail = node;
			}
			if (m.size() > size) {  /** at capacity? **/
				m.remove(head.key); /** get rid of the head in the map **/
				head = head.next; /** make the new head the next in the list **/
			}
			m.put(node.key, node); /** add node to map **/
		}
		tail.next = m.get(key);
		if(m.size() > 1)
		{
			m.get(key).previous = tail;
		}
		tail = m.get(key);
		return m.get(key).data; /** return the data **/
	}

	/**
	 * Returns the number of cache misses since the object's instantiation.
	 * @return the number of cache misses since the object's instantiation.
	 */
	public int getNumMisses () {
		return numMisses;
	}
}