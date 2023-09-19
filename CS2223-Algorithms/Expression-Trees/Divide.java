package aemacdonald.hw4;

// Question 1. complete this class. It must extend Expression
public class Divide extends Expression{
	final Expression left;
	final Expression right;
	
	public Divide(Expression left, Expression right) {
		this.left = left;
		this.right = right;
	}
	
	@Override
	public double eval() {
		return left.eval() / right.eval();
	}

	@Override
	public String format() {
		return String.format("(%s/%s)", left.format(), right.format());
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
