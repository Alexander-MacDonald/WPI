package aemacdonald.hw4;

/** 
 * Question 1. Represents the binary expression (left + right) where 'left' and 'right'
 * are themselves expressions.  
 *
 * For example:
 * 
 *    Add add1 = new Add(new Value(3), new Value(5)) 
 *    
 * represents the expression (3.0 + 5.0). The following example:
 * 
 *    Add add2 = new Add(new Value(4), add1)
 *    
 * represents the expression (4.0 + (3.0 + 5.0))
 *
 */
public class Add extends Expression {

	final Expression left;
	final Expression right;
	
	public Add(Expression left, Expression right) {
		this.left = left;
		this.right = right;
	}
	
	@Override
	public double eval() {
		return left.eval() + right.eval();
	}

	@Override
	public String format() {
		return String.format("(%s+%s)", left.format(), right.format());
	}
	
	public int height() {
		int Lheight = left.height();
		int Rheight = right.height();
		
		if(Lheight > Rheight)
		{
			return Lheight + 1;
		}
		else
		{
			return Rheight + 1;
		}
	}
}
