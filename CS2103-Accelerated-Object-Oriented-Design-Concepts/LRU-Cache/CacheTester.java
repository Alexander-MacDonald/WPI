import static org.junit.Assert.*;
import org.junit.Before;
import org.junit.Test;

import java.util.Arrays;

/**
 * Code to test an <tt>LRUCache</tt> implementation.
 */
public class CacheTester {

	class sLoader implements DataProvider<String, String> {
		private String base;
		public sLoader (String base) {
			this.base = base;
		}
		public String get (String key) {
			return base + key;
		}
	}


	float largest(float[] arr){

		float max = Integer.MIN_VALUE;

		for (int i = 0; i < arr.length; i++) {
			if (arr[i] > max) {
				max = arr[i];
			}
		}
		return max;
	}

	float smallest(float[] arr){
		float min = Integer.MAX_VALUE;

		for(int i = 0; i < arr.length; i++) {
			if(arr[i] < min){
				min = arr[i];
			}

		}
		return min;

	}

	float average(float[] arr){
		float average = 0;

		for(int i = 0; i < arr.length; i++){
			average += arr[i];
		}

		return (average/arr.length);

	}


	@Test
	public void leastRecentlyUsedIsCorrect () {

		DataProvider<String,String> provider = new sLoader("bruh");
		Cache<String,String> cache = new LRUCache<String,String>(provider, 5);

		cache.get("abc"); /** miss **/
		cache.get("bcd"); /** miss **/
		cache.get("gef"); /** miss **/
		cache.get("abc"); /** hit **/

		assertEquals(cache.get("abc"), "bruhabc"); /** does it work properly? **/
		assertTrue(cache.getNumMisses() == 3); /** did it use the cache? **/

	}

	@Test
	public void checkNumOfMisses() {
		DataProvider<String,String> provider = new sLoader("bruh");
		Cache<String,String> cache = new LRUCache<String,String>(provider, 5);

		cache.get("abc"); /** Miss **/
		cache.get("abc"); /** Hit **/
		cache.get("abc"); /** Hit **/
		cache.get("cba"); /** Miss **/
		cache.get("cba"); /** Hit **/
		cache.get("yeehaw"); /** Miss **/
		cache.get("wowIFeelSoGoodComparedToLastProject"); /** Miss **/

		assertEquals(cache.getNumMisses(), 4);

	}

	@Test
	public void checkEviction() {
		DataProvider<String,String> provider = new sLoader("bruh");
		Cache<String,String> cache = new LRUCache<String,String>(provider, 5);

		cache.get("abc"); /** miss 1**/
		cache.get("bcd"); /** miss 2**/
		cache.get("cde"); /** miss 3**/
		cache.get("abc"); /** hit **/
		cache.get("def"); /** miss 4**/
		cache.get("efg"); /** miss 5**/
		cache.get("fgh"); /** miss 6**/
		cache.get("ghi");/** miss 7**/
		cache.get("abc"); /** miss 8**/

		System.out.println(cache.getNumMisses());
		assertTrue(cache.getNumMisses() == 8);
	}


	@Test
	public void checkNumOfMissesFalse() {
		DataProvider<String,String> provider = new sLoader("bruh");
		Cache<String,String> cache = new LRUCache<String,String>(provider, 5);

		cache.get("abc");

		assertNotEquals(cache.getNumMisses(), 0);
	}

	/** The second Array takes a while to form due to it's size**/

	@Test
	public void checkTiming() {
		DataProvider<String,String> provider = new sLoader("bruh");
		Cache<String,String> cache = new LRUCache<String,String>(provider, 10);

		String s1 = "Testing 2"; /** random string **/
		String s2 = "Testing 3"; /** random string 2 **/

		String[] mediumTester = new String[10000000]; /** massive array of data **/
		String[] largeTester = new String[100000000]; /** even more massive array of data **/

		/** instantiating before and after time variables **/
		long before;
		long after;
		long before2;
		long after2;

		/** instantiating arrays that will track all times **/
		float[] times = new float[10];
		float[] times2 = new float[10];

		/** make string arrays all the same string **/
		Arrays.fill(mediumTester, s1);
		Arrays.fill(largeTester, s2);

		/** get the two misses out of the way to prevent faux data **/
		cache.get(s1);
		cache.get(s2);

		/** for the amount of data needed to be collected **/
		for(int b = 0; b < times.length; b++)
		{
			before = System.currentTimeMillis();

			for(int j = 0; j < mediumTester.length; j++){
				cache.get(mediumTester[j]);
			}

			after = System.currentTimeMillis();

			float total2 = ((float)(after-before)/mediumTester.length) * 1000; /** the amount of time the method took in seconds **/

			times[b] = total2;
			System.out.print("Test " + b + "a: " + times[b] + " seconds average ");
			System.out.println();
		}

		System.out.println("---- LARGER DATA TEST LOADING ----");
        /** for the amount of data needed to be collected **/
		for(int c = 0; c < times.length; c++)
		{
			if(c == 0)
			{
				System.out.println("---- Loaded ----");
			}

			before2 = System.currentTimeMillis();

			for(int k = 0; k < largeTester.length; k++){
				cache.get(largeTester[k]);
			}

			after2 = System.currentTimeMillis();

			float total3 = ((float)(after2 - before2)/largeTester.length) * 1000; /** the amount of time the method took in seconds **/

			times2[c] = total3;
			System.out.print("Test " + c + "b: " + times2[c] + " seconds average ");
			System.out.println();
		}
		System.out.println();
		System.out.println("---- Results ----");
		System.out.println();

		float largest = largest(times);
		float largest2 = largest(times2);

		float smallest = smallest(times);
		float smallest2 = smallest(times2);

		float average = average(times);
		float average2 = average(times2);

		System.out.println("Largest: " + largest + " seconds");
		System.out.println("Other Largest: " + largest2 + " seconds");

		System.out.println();

		System.out.println("Smallest: " + smallest + " seconds");
		System.out.println("Other Smallest: " + smallest2 + " seconds");

		System.out.println();

		System.out.println("Average: " + average + " seconds");
		System.out.println("Other Average: " + average2 + " seconds");

		System.out.println();

		System.out.println("Scale between average1 and max1: " + (largest / average) + "x");
		System.out.println("Scale between average2 and max2: " + (largest2 / average2) + "x");

		System.out.println();

		System.out.println("Scale between average1 and min1: " + (smallest / average) + "x");
		System.out.println("Scale between average2 and min2: " + (smallest2 / average2) + "x");

		/** So my thought process is to find the largest and smallest multiplier between the average, max, and min, to find a multiplicative range
		 * I want a multiplicative range because a solid number is determinant of the specs of the computer running it.
		 *
		 * I should probably make another array and a giant for loop for all the multipliers but I'm just running the program
		 * 20-30 times in order to find the max/min and add an error of maybe 15% due to the lack of testing. Then just check that every multiplier in
		 * someone's function is less than the max, and greater than the min.
		 *
		 * My worry is that if someones program is not actually O(1), this will take a really long time to run... hmm...
		 *
		 *
		 * Largest Multiplier so far: 1.4945455x
		 * 1.49 * 1.15 = 1.71x
		 *
		 * Smallest Multiplier so far: 0.7734531x
		 * 0.77 * 0.85 = 0.65x
		 *
		 * So for extraneous errors, I'll give it:
		 *
		 * Max is (at most) 1.71x the average (0.08 round up)
		 * Min is (at least) 0.67x the average (0.08 round down)
		 *
		 * as long as someone's program falls within these averages, they have O(1).
		 *
		 */

		assertTrue(1.71 > (largest / average));
		assertTrue(1.71 > (largest2 / average2));
		assertTrue(0.65 < (smallest / average));
		assertTrue(0.65 < (smallest2 / average2));
		assertTrue(cache.getNumMisses() == 2); /** only had to add 2 items to the cache **/

	}


}
