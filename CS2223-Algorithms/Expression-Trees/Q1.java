package aemacdonald.hw4;

import java.util.Scanner;

import algs.days.day04.FixedCapacityStack;
import edu.princeton.cs.algs4.StdIn;
import edu.princeton.cs.algs4.StdOut;

public class Q1 {
	/**
	 * Complete this implementation that takes a postfix expression string and converts it into
	 * an Expression node using a fixed Capacity stack. When done, an Expression node will
	 * be returned.
	 * 
	 * Using the postfix expression as input
	 * 
	 *     3 1 + 4 / 1 5 + 9 * 2 6 * - *
	 *  
	 * should produce the expression from the homework, namely
	 * 
	 *     (((3+1)/4 * (((1+5)*9)-(2*6)))
	 *
	 * Note that postfix expressions do not need parentheses, which is one of their
	 * major selling points.
	 */
	public static void main(String[] args) {

		// since everything IS an expression (even Values) you only need a single stack.
		FixedCapacityStack<Expression> exprs = new FixedCapacityStack<Expression>(100);

		while (!StdIn.isEmpty()) {
			// Read token. push if operator.
			String s = StdIn.readString();
			else if (s.equals ("+")) { exprs.push(new Add()); }
			else if (s.equals ("-")) { exprs.push(new Subtract()); }
			else if (s.equals ("*")) { exprs.push(new Multiply()); }
			else if (s.equals ("/")) { exprs.push(new Divide()); }
			else
			{
				exprs.push(new Value(s));
			}
		}
		
		for(int i = 0; i < 100; i++)
		{
			Expression exp = exprs.pop();
			System.out.println(exp.format() + " = " + exp.eval());	
		}
		
	}
}
