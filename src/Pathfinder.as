package
{
	import flash.desktop.ClipboardFormats;
	import flash.utils.Dictionary;
	import flash.geom.Point;
	
	/**
	 * Optimized A* pathfinder based on quad tree
	 * @author Mariusz Gliwiński
	 */
	public class Pathfinder 
	{
		//private var
		//	_static:Vector.<Vector.<MapTile>>,	/// _static[quadLevel][x * (y + 1)]
		//	_dynamic:Vector.<MapTile>;
		
		private static const H_SCALE:float = 0.999;
		
		private var
			_qt:QuadTree;
		
		public function Pathfinder(map:Map) 
		{
			//buildStatic(map);
			_qt = new QuadTree(map._tiles, map.width);
		}
		
		/**
		 * 
		 * @param	map		Most preferable rectangle map
		 */
		private function buildStatic(map:Map): void
		{
			/*
			var maxQuadLevel:uint = Math.ceil(Math.max(Math.log(map.width), Math.log(map.height)));
			Utils.assert(maxQuadLevel <= uint.MAX_VALUE);
			_static = new Vector.<Vector.<Tile>>(maxQuadLevel + 1, true);
			_static[maxQuadLevel] = map._tiles;
			var quadSide:uint;
			
			for (var quadLevel:int = maxQuadLevel-1; quadLevel >= 0; quadLevel -= 1)
			{
				quadSide = 1 << quadLevel;
				
				_static[quadLevel] = new Vector.<Tile>(quadSide * quadSide, true);
				for (var i:uint; i < quadSide * quadSide; i++)
					_static[quadLevel][i] = buildQuad(_static[quadLevel + 1], quadSide >> 1, i);
			}*/
		}
		
		public function query(from:Point, to:Point): Vector.<Tile>
		{
			var from:uint = _qt.query(from.x, from.y),
				to:uint = _qt.query(to.x, to.y),
				path:Vector.<uint> = _qt.flatten(_qt.ROOT_NODE);
				
			Utils.assert(_qt.maxDepth > 1 && from.pathable && to.pathable);
			
			do {
				path = aStar(from, to, path);
				path.map(_qt.flatten());			//TODO: closure is slow
			} while (path.every(!_qt.isLeaf()));	//TODO: performance - check should be linear + ditto
			
			return path;	//FIXME: Vector has to know exact type
		}
		
		/**
		 * 
		 * @param	from
		 * @param	to
		 * @param	Vector.<QuadTree>
		 * @return	null if not found
		 */
		private function aStar(from:QuadTree, to:QuadTree, on:Vector.<QuadTree>): Vector.<QuadTree>
		{
			var openSet:PriorityQueue = new PriorityQueue("f"),			//TODO: use list to avoid heap fragmentation?
				nodes:Vector.<AStarNode> = new Vector.<AStarNode>(),	//TODO: think about fast storage
				cur:AStarNode = new AStarNode(_qt.query(fromX, fromY)),
				end:AStarNode = new AStarNode(_qt.query(toX, toY)),
				path:Vector.<QuadTree> = new Vector.<QuadTree>,
				newG:float,	newH:float,	newF:float;
			
			//nodes[cur].g = 0;
			nodes[cur].h = heuristic(from.x, from.y, to.x, to.y);
			nodes[cur].f = g + h;
			
			openSet.enqueue(cur);
			
			while (!openSet.empty)
			{
				cur = openSet.dequeue(); //TODO: use quad-tree provided data...
				
				if (cur.qt == end.qt)
					break;
				
				cur.closed = true;
				for (var nbour:IViewCursor = cur.createNbourIter(); !nbour.afterLast; nbour.moveNext())
				{
					if (null == nbour || !nbour.current.pathable || nbour.qt == cur.prev.qt)	//TODO: into iterator?
						continue;
						
					newG = nbour.current.getDistance(_qt.pos(nbour) - _qt.pos(cur));
					newH = heuristic(_qt.pos(nbour).x, _qt.pos(nbour).y, toX, toY);
					newF = g + h;	//TODO: uint or getter?
					
					if (newF >= nodes[nbour].f && (nodes[nbour].closed || nodes[nbour].open))
						continue;
					
					nodes[nbour].prev = cur;
					nodes[nbour].qt = ??;
					nodes[nbour].closed = false;
					nodes[nbour].g = newG;
					nodes[nbour].h = newH;
					nodes[nbour].f = newF;
					
					if (!nodes[nbour].open)
						openSet.enqueue(nodes[nbour]);
				}
			}
			
			while (null != cur)
			{
				path.unshift(cur);	//TODO: i doubt it's efficient
				cur = cur.prev;
			}
			
			return path;
		}
		
		public function heuristic(fromX:uint, fromY:uint, toX:uint, toY:uint):float
        {
			// Future directions: past-based statistics as 'pathmap' :)
			return H_SCALE * Math.max(Math.abs(fromX - toX), Math.abs(fromY - toY));
        }
	}

}

/**
* This cursor implements Filtering Iterator pattern
* @author Mariusz Gliwiński
*/
internal class AStarCursor implements IViewCursor 
{
	private var
		_afterLast:Boolean,
		_beforeFirst:Boolean = true,
		_current:QuadTree;
	
	public function QuadTreeCursor(qt:IViewCursor) 
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