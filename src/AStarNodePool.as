package  
{
	import de.polygonal.ds.Graph;
	import de.polygonal.ds.GraphNode;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Mariusz Gliwiński
	 */
	public class AStarNodePool
	{
		private var
			_graph:Graph = new Graph(),
			_map:Map,
			_nodes:Vector.<AStarNode>;
		
		public function AStarNodePool(map:Map) 
		{
			_map = map;
			_nodes = new Vector.<AStarNode>(_map._tiles.length, true);
			
			buildNodes();
			buildEdges();
		}
		
		/**
		 * clears dynamic state of a graph
		 */
		public function clear():void
		{
			for ( var cur:AStarNode = _graph.getNodeList() as AStarNode; cur != null; cur = cur.next as AStarNode )
			{
				cur.clear();
			}
		}
		
		public function get(point:Point):AStarNode
		{
			return _nodes[point.y * _map.width + point.x];
		}
		
		public function getX(node:AStarNode):uint
		{
			return node.key % _map.width;
		}
		
		public function getY(node:AStarNode):uint
		{
			return node.key / _map.width;
		}
		
		private function buildNodes(): void
		{
			for (var i:uint; i < _map._tiles.length; i++ )
				_nodes[i] = _graph.addNode(new AStarNode(_map._tiles[i]) as GraphNode) as AStarNode;
		}
		
		private function buildEdges(): void
		{
			var mapLen:uint = _map._tiles.length,
				mapWidth:uint = _map.width,
				mapHeight:uint = _map.height,
				source:AStarNode,
				target:AStarNode,
				shift:uint,
				id:uint;
			
			Utils.assert(_map.width % 2 == 0);	// That's just a demo
			
			for (id = mapWidth + 1; id < mapLen - mapWidth - 1; id += mapWidth + 2)
				for (; id % mapWidth != mapWidth - 1; id += 2)
				{
					addEdge(id, id - mapWidth - 1);	// top-left
					addEdge(id, id - mapWidth);		// top
					addEdge(id, id - mapWidth + 1);	// top-right
					addEdge(id, id - 1);			// left
					addEdge(id, id + 1);			// right
					addEdge(id, id + mapWidth - 1);	// bot-left
					addEdge(id, id + mapWidth);		// bot
					addEdge(id, id + mapWidth + 1);	// bot-right
				}
		}
		
		private function addEdge(id1:uint, id2:uint):void
		{
			var n1:AStarNode = _nodes[id1],
				n2:AStarNode = _nodes[id2];
			
			if(n1._tile._pathability && n2._tile._pathability)
				_graph.addMutualArc(n1 as GraphNode, n2 as GraphNode, 1);
		}
		
	}

}