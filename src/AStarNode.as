package  
{
	import de.polygonal.ds.GraphNode;
	import de.polygonal.ds.Prioritizable;
	import de.polygonal.ds.TreeNode;
	
	/**
	 * Generally this class should be instantiated by AStarNodePool
	 * @author Mariusz Gliwiński
	 */
	public class AStarNode extends GraphNode implements Prioritizable
	{
        public var
			_tile:Tile,						/// tile that is described by this node
			_prev:AStarNode,				/// previous best node in path from source
			_neighbours:Vector.<AStarNode>,
			_visited:Boolean,				/// whether this node has been already visited
			_distance:Number,				/// from source to this node (a.k.a G)
			// Required for Prioritizable
			priority:Number,				/// sum of distance + heuristic (a.k.a F)
			position:uint;
			

        public function AStarNode(tile:Tile)
		{
			_distance = priority = 0;
			_tile = tile;
		}
		
		public function clear():void
		{
			_distance = 0;
			priority = 0;
			_prev = null;
			_visited = false;
		}
	}

}