package aemacdonald.hw3;

import java.util.ArrayList;
import java.util.Iterator;

import  algs.hw3.ShakespearePlay;

public class Q3 {
	
	
	public static String findTop5Words(int playNum, ShakespearePlay[] plays)
	{
		ArrayList<Data> words = new ArrayList<Data>();
		Iterator<String> bruh = plays[playNum-1].iterator();
		String ret = "";
		
		while(bruh.hasNext())
		{
			String s = (String) bruh.next();
			Data w = new Data(s, 1);
			boolean flag = false;
			
			if(words.isEmpty())
			{
				words.add(w);
			}
			else
			{
				for(int j = 0; j < words.size(); j++)
				{
					if(words.get(j).getWord().equals(w.getWord()))
					{
						words.get(j).increment();
						flag = true;
					}
				}
				if(flag == false)
				{
					words.add(w);
				}
			}
		}
		
		BST wordFinal = new BST();
		
		for(int j = 0; j < words.size(); j++)
		{
			wordFinal.put(words.get(j).getWord(), words.get(j).getCount());
		}
		
		for(int j = 0; j < 5; j++)
		{
			ret += wordFinal.mostFrequent();
			wordFinal.delete(wordFinal.mostFrequent());
			ret += "\t";
		}
		
		ret += plays[playNum-1].getTitle();
		
		return ret;
	}

	
	public static void main(String[] args){
		
		System.out.println("The most common word is: and\n Furthermore, the only play that does not contain 'and' in it's most common words is....\n MACBETH!");
		
		ShakespearePlay[] plays = new ShakespearePlay[38];
		
		for(int i = 0; i < plays.length; i++)
		{
			plays[i] = new ShakespearePlay(i+1);
		}
		
		for(int i = 0; i < plays.length; i++)
		{
			System.out.println(findTop5Words(i+1, plays));
		}
		}
	}


