package
{
	import flash.geom.Point;
	
	/**
	 * Optimized A* pathfinder based on quad tree
	 * @author Mariusz Gliwiński
	 */
	public class QuadPathfinder 
	{
		private static const
			H_SCALE:Number = 0.999;
			
		private var
			_quadTree:QuadTree;
		
		public function QuadPathfinder(map:Map) 
		{
			_quadTree = new QuadTree(map);
		}
		
		public function query(from:Point, to:Point): Vector.<Point>
		{
			return new Vector.<Point>();
		}
		
		public function heuristic(fromX:uint, fromY:uint, toX:uint, toY:uint):Number
        {
			// Future directions: past-based statistics as 'pathmap' :)
			return H_SCALE * Math.max(Math.abs(fromX - toX), Math.abs(fromY - toY));
        }
	}

}
