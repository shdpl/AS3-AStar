package com.yyztom.pathfinding.astar
{
	import flash.geom.Point;
	
	public class AStarNodeVO
	{
		
		public var
			h : uint,
			f : uint,
			g : uint,
			cost : uint,
			visited : Boolean,
			closed : Boolean,
			isWall : Boolean,
			position : Point,
			parent : AStarNodeVO,
			next : AStarNodeVO,
			neighbors : Vector.<AStarNodeVO>;
		
		public function AStarNodeVO(cost:uint = 1)
		{
			this.cost = cost;
		}
	}
}