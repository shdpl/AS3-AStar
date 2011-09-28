package  
{
	/**
	 * ...
	 * @author Mariusz Gliwiński
	 */
	public class AStarNode 
	{
		public var
			g:float,
			h:float,
			f:float,
			prev:AStarNode,
			qt:QuadTree,
			closed:Boolean;
		
		public function AStarNode(qt:QuadTree) 
		{
			this.qt = qt;
		}
		
		public function createNbourIter():IViewCursor
		{
			return new AStarNodeCursor
		}
		
	}

}

/**
* ...
* @author Mariusz Gliwiński
*/
internal class AStarNodeCursor implements IViewCursor 
{
	private var
		_afterLast:Boolean,
		_beforeFirst:Boolean = true,
		_current:QuadTree;
	
	public function AStarNodeCursor() 
	{
		
	}
	
	/* INTERFACE IViewCursor */
	
	public function get afterLast():Boolean 
	{
		return _afterLast;
	}
	
	public function get beforeFirst():Boolean 
	{
		return _beforeFirst;
	}
	
	public function get current():Object 
	{
		return _current;
	}
	
	public function moveNext():Boolean 
	{
		return true;
	}
}