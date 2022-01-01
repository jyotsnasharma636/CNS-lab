package shivani;
import java.util.*;
public class BellmanFord {

	private int d[];
	private int n;
	public static final int max_value = 999;
	
	public BellmanFord(int n)
	{
		this.n = n;
	    d = new int[n+1];	
	}
	
	public void shortest(int s, int a[][])
	{
		for(int i=1; i<=n; i++)
		{
			d[i] = max_value;
		}
		d[s] = 0;
		for(int k=1; k<=n-1; k++)
		{
			for(int i=1; i<=n; i++)
			{
				for(int j=1; j<=n; j++)
				{
					if(a[i][j] != max_value)
					{
						if(d[j] > d[i] + a[i][j])
						{
							d[j] = d[i] + a[i][j];
						}
					}
				}
			}
		}

		for(int i=1; i<=n; i++)
		{
			for(int j=1; j<=n; j++)
			{
				if(a[i][j] != max_value)
				{
					if(d[j] > d[i] + a[i][j])
					{
					System.out.println("The graph has negative edge cycles");
					return;
					}
				}
			}
		}
		for(int i=1; i<=n; i++)
		{
		   System.out.println("The distance from source "+s+" to "+i+" = "+d[i]);
		}
	}
	

public static void main(String[] args)
{
	int n=0, s;
	Scanner sc = new Scanner(System.in);
	System.out.println("Enter the number of nodes: ");
	n = sc.nextInt();
	int a[][] = new int[n+1][n+1];
	
	System.out.println("Enter the weighted matrix: ");
	
	for(int i=1; i<=n; i++)
	{
		for(int j=1; j<=n; j++)
		{
			a[i][j] = sc.nextInt();
			if(i==j)
			{
				a[i][j] =0;
				continue;
			}
			if(a[i][j] == 0)
			{
				a[i][j] = max_value;
			}
		}
	}
	System.out.println("Enter the source node: ");
	s = sc.nextInt();
	BellmanFord b = new BellmanFord(n);
	b.shortest(s, a);
	sc.close();
}
}
