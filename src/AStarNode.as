package  
{
	import de.polygonal.ds.Prioritizable;
	
	/**
	 * ...
	 * @author Mariusz Gliwiński
	 */
	public class AStarNode implements Prioritizable
	{
        public var priority:int;
        public var position:int;

        public function AStarNode(priority:int)
		{
			this.priority = priority;
        }
	}

}