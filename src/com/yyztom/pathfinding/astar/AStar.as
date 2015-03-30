package com.yyztom.pathfinding.astar
{
	import flash.geom.Point;


	public class AStar
	{
		private var
			_openHeap : BinaryHeap,
			_touched : Vector.<AStarNodeVO>,
			_grid : Vector.<Vector.<AStarNodeVO>>,
			tcur : AStarNodeVO,
			currentNode : AStarNodeVO,
			ret : Vector.<AStarNodeVO>,
			neighbors : Vector.<AStarNodeVO>,
			neighbor : AStarNodeVO,
			newG : uint,
			i : uint, j : uint;
			
		
		public function AStar( grid : Vector.<Vector.<AStarNodeVO>> ){
			_touched = new Vector.<AStarNodeVO>(grid.length * grid.length+1, true);
			_grid = grid;
			_openHeap = new BinaryHeap( function(node:AStarNodeVO):Number { return node.f; } );
			
			for each (var row:Vector.<AStarNodeVO> in _grid)
				for each(var node:AStarNodeVO in row) {
					node.neighbors = new Vector.<AStarNodeVO>();
					for each(var neighbor:AStarNodeVO in getNeighbors(_grid, node)) {
						if (neighbor == null)
							break;
						if (!neighbor.isWall)
							node.neighbors.push(neighbor);	// in demo i focus only on query optimization
					}
				}
		}
		
		
		
		/**
		 * 
		 * DEBUG ONLY.
		 */
		public function get evaluatedTiles () : Vector.<AStarNodeVO> {
			return _touched;
		}
		
		
		public function search( start : AStarNodeVO, end:AStarNodeVO ) : Vector.<AStarNodeVO> {
			i = 0;
			tcur = _touched[0];
			while(tcur) {
				tcur.f=0;
				tcur.g=0;
				tcur.h=0;
				tcur.closed = false;
				tcur.visited = false;
				tcur.parent = null;
				tcur.next = null;
				_touched[i] = null;
				
				i++;
				tcur = _touched[i];
			}
			_openHeap.reset();
			i = 0;	// touched count -- lol, imperative programming (optimizer :()
			
			
			_openHeap.push(start);
			_touched[i++] = start;
			
			while( _openHeap.size > 0 ){
				currentNode = _openHeap.pop();
				
				if (currentNode == end) {
					i = 0;
					while (currentNode.parent) {
						currentNode.parent.next = currentNode;
						i++;
						currentNode = currentNode.parent;
					}
					ret = new Vector.<AStarNodeVO>(i+1, true);
					for (j = 0; currentNode; j++) {
						ret[j] = currentNode;
						currentNode = currentNode.next;
					}
					return ret;
				}
				
				currentNode.closed = true;
				
				for each(neighbor in currentNode.neighbors)	{
					if (neighbor.closed)
						continue;
					
					newG = currentNode.g + currentNode.cost;
					
					if ( !neighbor.visited ) {
						
						_touched[i++] = neighbor;
						
						neighbor.visited = true;
						neighbor.parent = currentNode;
						neighbor.g = newG;
						neighbor.h = heuristic(neighbor.position, end.position);
						neighbor.f = newG + neighbor.h;
						_openHeap.push(neighbor);
						
					} else if ( newG < neighbor.g) {
						
						neighbor.parent = currentNode;
						neighbor.g = newG;
						neighbor.f = newG + neighbor.h;
						
						_openHeap.rescoreElement(neighbor);
					}
					
				}
			}
			
			return null;
		}
		
		
		private function getNeighbors( grid : Vector.<Vector.<AStarNodeVO>> , node : AStarNodeVO) : Vector.<AStarNodeVO> {
			var ret : Vector.<AStarNodeVO> = new Vector.<AStarNodeVO>(8, true),
				x : uint = node.position.x,
				y : uint = node.position.y,
				gridWidth : uint = grid.length,
				gridHeight : uint = grid[x].length,
				id : uint;
			
			if (x > 0) {
				ret[id++] = grid[x - 1][y];
				if (y > 0)
					ret[id++] = grid[x - 1][y - 1];
				if (y < gridHeight - 1)
					ret[id++] = grid[x - 1][y + 1];
			}
			if (x < gridWidth - 1) {
				ret[id++] = grid[x + 1][y];
				if (y > 0)
					ret[id++] = grid[x + 1][y - 1];
				if (y < gridHeight - 1)
					ret[id++] = grid[x + 1][y + 1];
			}
			if (y > 0)
				ret[id++] = grid[x][y - 1];
			if (y < gridHeight - 1)
				ret[id++] = grid[x][y + 1];
			
			return ret;
		}
		
		private function heuristic( pos0 : Point, pos1 : Point ) : uint{
			var d1 : int = pos1.x - pos0.x,
				d2 : int = pos1.y - pos0.y;
			d1 = d1 < 0 ? -d1 : d1;
			d2 = d2 < 0 ? -d2 : d2;
			//var diag:int = Math.SQRT2 * diag + d1 + d2 - 2 * diag;
			//var diag:int = d1 > d2 ? d1 : d2;
			var diag:int = d1 + d2; // using of this heuristic might result with incorect results, see https://github.com/shdpl/AS3-AStar/pull/1
			return diag;
		}
		
	}
}