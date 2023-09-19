package aemacdonald.hw4;

/** 
 * Every operator must extend this class. 
 * 
 * This is the abstract class that represents a Node in an Expression tree.
 * 
 * Unlike the BST and AVL example from class, there is no separate class to represent 
 * the tree itself. Instead, you will only be working with nodes that are subclasses
 * of this abstract type.
 */
public abstract class Expression {
	/** 
	 * Compute the result of an expression rooted at this node and return its double 
	 */
	public abstract double eval();
	
	/** 
	 * Generate a string equivalent to the Infix expression for this node. 
	 */
	public abstract String format();
	
	public abstract int height();

}
