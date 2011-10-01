package
{
	import de.polygonal.ds.GraphArc;
	import de.polygonal.ds.GraphNode;
	import de.polygonal.ds.PriorityQueue;
	import flash.geom.Point;
	import de.polygonal.ds.Graph;
	
	/**
	 * Standard pathfinder based on graph.
	 */
	public class StdPathfinder 
	{
		private static const
			H_SCALE:Number = 0.999;
			
		private var
			_pool:AStarNodePool,
			_queue:PriorityQueue = new PriorityQueue();
		
		public function StdPathfinder(map:Map)
		{
			Utils.assert(map._tiles.length >= 4 && map.width == map.height);
			_pool = new AStarNodePool(map);
		}
	
		public function query(from:Point, to:Point): Vector.<Point>
		{
			var ret:Vector.<Point>,
				path:Vector.<AStarNode>;
			
			path = aStar(_pool.get(from), _pool.get(to));
			
			ret = new Vector.<Point>(path.length, true);
			
			if (ret.length != 0)
				for ( var i:uint = 0; i < path.length; i++ )
					ret[ret.length - i - 1] = new Point(_pool.getX(path[i]), _pool.getY(path[i]));
			
			_pool.clear();
			_queue.clear();
			
			return ret;
		}
		
		private function aStar(from:AStarNode, to:AStarNode): Vector.<AStarNode>
		{
			var path:Vector.<AStarNode> = new Vector.<AStarNode>,
				cur:AStarNode,
				neighbour:AStarNode,
				newDistance:Number;
			
			if (!from._tile._pathability || !to._tile._pathability)
				return path;
			
			_queue.enqueue(from);
			
			while (!_queue.isEmpty())
			{
				cur = _queue.dequeue() as AStarNode;
				
				if (cur._visited)
					continue;
				
				cur._visited = true;
				
				if (cur == to)
					break;
				
				for (var arc:GraphArc = cur.arcList; arc != null; arc.next)
				{
					neighbour = arc.node as AStarNode;
					
					newDistance = cur._distance + arc.cost;
					
					if (neighbour._visited)
					{
						if (newDistance < neighbour._distance)
						{
							neighbour.parent = cur;
							neighbour._distance = newDistance;
						} else
							continue;
					} else {
						neighbour.parent = cur;
						neighbour._distance = newDistance;
						
						neighbour.priority = newDistance + heuristic(
							_pool.getX(neighbour), _pool.getY(neighbour), _pool.getX(to), _pool.getY(to));
							
						_queue.enqueue(neighbour);
					}
				}
			}
			
			for (; cur != null; cur = cur.parent as AStarNode )
				path.unshift(cur);
			
			path.reverse();
			
			return path;
		}
			
		private function heuristic(fromX:uint, fromY:uint, toX:uint, toY:uint):Number
		{
			// Future directions: past-based statistics as 'pathmap' :)
			return H_SCALE * Math.abs( toX - fromX ) + Math.abs( toY - fromY );
		}
	}

}