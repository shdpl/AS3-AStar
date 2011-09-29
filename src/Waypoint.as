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

	import de.polygonal.core.fmt.Sprintf;
	import de.polygonal.core.math.Mathematics;
	import de.polygonal.ds.GraphNode;
	import de.polygonal.ds.Heapable;

	public class Waypoint extends GraphNode implements Heapable
	{
		/**
		 * Node position on the cartesian plane.
		 */
		public var x:Number;
		public var y:Number;
		
		/** Heapable interface */
		public var position:int;
		
		/**
		 * The total distance of all the edges that compromise the best path to this node so far.
		 */
		public var distance:Number;
		
		/**
		 * Heuristic estimate of the distance to the target to direct the search towards the target.
		 */
		public var heuristic:Number;
		
		/**
		 * True if this waypoint is contained in the queue.
		 */
		public var onQue:Boolean;
		
		public function Waypoint(x:int)
		{
			super(x);
		}
		
		public function reset():void
		{
			distance  = 0;
			heuristic = 0;
			onQue     = false;
			marked    = false;
			parent    = null;
		}
		
		public function distanceTo(other:Waypoint):Number
		{
			var dx = other.x - x;
			var dy = other.y - y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		public function compare(other:Object):int
		{
			return Mathematics.fsgn(other.heuristic - heuristic);
		}
		
		override public function toString():String
		{
			return Sprintf.format("{Waypoint, id: %d}", [val]);
		}
	}
}