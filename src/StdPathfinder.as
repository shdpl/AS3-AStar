/*
 *                            _/                                                    _/   
 *       _/_/_/      _/_/    _/  _/    _/    _/_/_/    _/_/    _/_/_/      _/_/_/  _/    
 *      _/    _/  _/    _/  _/  _/    _/  _/    _/  _/    _/  _/    _/  _/    _/  _/     
 *     _/    _/  _/    _/  _/  _/    _/  _/    _/  _/    _/  _/    _/  _/    _/  _/      
 *    _/_/_/      _/_/    _/    _/_/_/    _/_/_/    _/_/    _/    _/    _/_/_/  _/       
 *   _/                            _/        _/                                          
 *  _/                        _/_/      _/_/                                             
 *                                                                                       
 * POLYGONAL - A HAXE LIBRARY FOR GAME DEVELOPERS
 * Copyright (c) 2009-2010 Michael Baczynski, http://www.polygonal.de
 * 				 Modified by Mariusz 'shd' Gliwiński
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package
{
	import de.polygonal.ds.DA;
	import de.polygonal.ds.GraphNode;
	import flash.geom.Point;
	import de.polygonal.ds.Heap;
	import de.polygonal.ds.Graph;
	import de.polygonal.ds.DA;
	
	/**
	 * Standard pathfinder based on graph
	 */
	public class StdPathfinder 
	{
		private static const
			H_SCALE:Number = 0.999;
			
		private var
			_graph:Graph = new Graph(),
			_que:Heap = new Heap(),
			_wayPoints:DA = new DA(),
			_map:Map;
		
		public function StdPathfinder(map:Map)
		{
			_map = map;
			_buildGraph();
		}
		
		function _buildGraph():void
		{
			var nodes:Vector.<Waypoint> = new Vector.<Waypoint>();
			
			trace("building");
			
			var tmp:uint = 0;
			for (var id:uint = 0; id < _map._tiles.length; id++)
			{
				var wp:Waypoint = new Waypoint(id);
				wp.x = id % _map.width;
				wp.y = id / _map.width;
				nodes.push(_graph.addNode(wp as GraphNode));
			}
			
			for (var id:uint = 1; id < _map.width-1; id++)
			{	//TOP ROW
				var source = _wayPoints.get(id);
				var target = _wayPoints.get(id-1);
				_graph.addMutualArc(source as GraphNode, target as GraphNode, 1);
				
				target = _wayPoints.get(id+1);
				_graph.addMutualArc(source as GraphNode, target as GraphNode, 1);
				
				target = _wayPoints.get(id+_map.width);
				_graph.addMutualArc(source as GraphNode, target as GraphNode, 1);
			}
			
			for (var id:uint = _map._tiles.length - _map.width+1; id < _map._tiles.length-1; id++)
			{	//BOT ROW
				var source = _wayPoints.get(id);
				var target = _wayPoints.get(id-1);
				_graph.addMutualArc(source as GraphNode, target as GraphNode, 1);
				
				target = _wayPoints.get(id+1);
				_graph.addMutualArc(source as GraphNode, target as GraphNode, 1);
				
				target = _wayPoints.get(id-_map.width);
				_graph.addMutualArc(source as GraphNode, target as GraphNode, 1);
			}
			
			for (var id:uint = _map.width; id < _map._tiles.length-_map.height; id+=_map.width)
			{	//LEFT COL
				var source = _wayPoints.get(id);
				var target = _wayPoints.get(id-_map.width);
				_graph.addMutualArc(source as GraphNode, target as GraphNode, 1);
				
				target = _wayPoints.get(id+_map.width);
				_graph.addMutualArc(source as GraphNode, target as GraphNode, 1);
				
				target = _wayPoints.get(id+1);
				_graph.addMutualArc(source as GraphNode, target as GraphNode, 1);
			}
			
			for (var id:uint = 2*_map.width-1; id < _map._tiles.length-_map.height; id+=_map.width)
			{	//RIGHT COL
				var source = _wayPoints.get(id);
				var target = _wayPoints.get(id-_map.width);
				_graph.addMutualArc(source as GraphNode, target as GraphNode, 1);
				
				target = _wayPoints.get(id+_map.width);
				_graph.addMutualArc(source as GraphNode, target as GraphNode, 1);
				
				target = _wayPoints.get(id-1);
				_graph.addMutualArc(source as GraphNode, target as GraphNode, 1);
			}
			for (var x:uint = 1; x < _map.width-1; x+=1)
				for (var y:uint = 1; y < _map.height-1; y+=1)
			{	//MIDDLE
				var source = _wayPoints.get((y*_map.width) + x);
				var target = _wayPoints.get((y*_map.width-1) + x);
				_graph.addMutualArc(source as GraphNode, target as GraphNode, 1);
				
				target = _wayPoints.get((y*_map.width+1) + x);
				_graph.addMutualArc(source as GraphNode, target as GraphNode, 1);
				
				target = _wayPoints.get((y*_map.width) + x+1);
				_graph.addMutualArc(source as GraphNode, target as GraphNode, 1);
				
				target = _wayPoints.get((y*_map.width) + x-1);
				_graph.addMutualArc(source as GraphNode, target as GraphNode, 1);
				
				target = _wayPoints.get((y*_map.width+1) + x+1);
				_graph.addMutualArc(source as GraphNode, target as GraphNode, 1);
				
				target = _wayPoints.get((y*_map.width-1) + x+1);
				_graph.addMutualArc(source as GraphNode, target as GraphNode, 1);
				
				target = _wayPoints.get((y*_map.width+1) + x-1);
				_graph.addMutualArc(source as GraphNode, target as GraphNode, 1);
				
				target = _wayPoints.get((y*_map.width-1) + x-1);
				_graph.addMutualArc(source as GraphNode, target as GraphNode, 1);
			}
			//CORNERS
			
			trace("done");
		}
	
		public function query(from:Point, to:Point): Vector.<Point>
		{
			var pathExists:Boolean;
			var path:Vector.<Point> = new Vector.<Point>();
			
			var source:Waypoint = new Waypoint(from.y * _map.width + from.x);
			source.x = from.x;
			source.y = from.y;
			
			var target:Waypoint = new Waypoint(to.y * _map.width + to.x);
			target.x = to.x;
			target.y = to.y;
			
			var walker:GraphNode = _graph.getNodeList();
			while (walker != null)
			{
				//reset node
				(walker as Waypoint).reset();
				walker = walker.next;
			}
		
			var q = _que;
		
			//reset queue
			q.clear();
			
			//enqueue starting node
			q.add(source);
			
			//while there are waypoints in the queue...
			while (q.size() > 0)
			{
				//grab the next waypoint off the queue and process it
				var node1 = q.pop();
				node1.onQue = false;
				
				//make sure the waypoint wasn't visited before (can be visited multiple times)
				if (node1.marked) continue;
				
				//mark node as processed
				node1.marked = true;
				
				//exit if the target node has been found
				if (node1 == target)
				{
					pathExists = true;
					break;
				}
				
				//visit all connected nodes (denoted as node2, node2)
				var arc = node1.arcList;
				while (arc != null)
				{
					//the node our arc is pointing at
					var node2:Waypoint = arc.node as Waypoint;
					
					//skip marked nodes
					if (node2.marked)
					{
						arc = arc.next;
						continue;
					}
					
					//compute accumulated distance to get from the current waypoint (1) to the next waypoint (2)
					var distance = node1.distance + node1.distanceTo(node2) * arc.cost;
					
					//node has been processed before ?
					if (node2.parent != null)
					{
						//distance has been calculated before so check if new distance is shorter
						if (distance < node2.distance)
						{
							//switch to shorter path ('edge relaxation')
							node2.parent = node1;
							node2.distance = distance;
						}
						else
						{
							//new distance > existing distance, skip
							arc = arc.next;
							continue;
						}
					}
					else
					{
						//first time of being added to the queue - setup parent and distance
						node2.parent = node1;
						node2.distance = distance;
					}
					
					//compute A* heuristics
					var heuristics = node2.distanceTo(target) + distance;
					
					//waypoints closest to the source node are processed first
					node2.heuristic = heuristics;
					
					//add to the search frontier
					if (!node2.onQue)
					{
						node2.onQue = true;
						q.add(node2);
					}
					
					arc = arc.next;
				}
			}
			
			if (pathExists)
			{
				//trace the path by working back through the parents
				//from the target node to the source node
				var walker = target;
				while (walker != source)
				{
					path.push(walker);
					walker = walker.parent as Waypoint;
				}
				
				path.push(source);
				path.reverse();
			}
			
			return path;
		}
			
		public function heuristic(fromX:uint, fromY:uint, toX:uint, toY:uint):Number
		{
			// Future directions: past-based statistics as 'pathmap' :)
			return H_SCALE * Math.max(Math.abs(fromX - toX), Math.abs(fromY - toY));
		}
	}

}