package aemacdonald.hw4;

/** 
 * Question 1. Represents a "leaf node" in the expression tree, whose value 
 * is the desired double.
 *
 * For example:
 * 
 *    Value lit1 = new Value(3);
 *    
 * represents the expression 3.0. When you call 'eval' on this object, it returns
 * its value. 
 */
public class Value extends Expression {

	final double value;
	
	public Value(double value) {
		this.value = value;
	}
	
	@Override
	public double eval() {
		return value;
	}

	@Override
	public String format() {
		return Double.toString(value);
	}
	
	public int height() {
		return 0;
	}
	
}
