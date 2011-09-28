package  
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Mariusz Gliwiński
	 */
	public class QuadTree // TODO: why quad and not Trie? :)
	{
		public const ROOT_NODE = 0;
		public const
			TILE_TOP		:uint	=	1 << 0,
			TILE_TOP_RIGHT	:uint	=	1 << 1,
			TILE_RIGHT		:uint	=	1 << 2,
			TILE_BOT_RIGHT	:uint	=	1 << 3,
			TILE_BOT		:uint	=	1 << 4,
			TILE_BOT_LEFT	:uint	=	1 << 5,
			TILE_LEFT		:uint	=	1 << 6,
			TILE_TOP_LEFT	:uint	=	1 << 7;
		
		private var
			_cache:Dictionary = new Dictionary(),	// TODO: implement fast custom hashmap (above consts => 8*7 uints)
			_dirty:Boolean,
			_child:Array = new Array,
			_moveable:Boolean,
			_pathable:Boolean,
			_root:Vector.<Tile>,
			_id:uint;
		
		
		public function QuadTree(tiles:Vector.<Tile>, width:uint)
		{
			Utils.assert(0 == tiles.length % _child.length);
			
			for (var qid:uint = 0; qid < _child.length; qid+=1)
			{
				var quad:Vector.<Tile> = new Vector.<Tile>;
				// FIXME: Warning: very unefficient
				for (var row:uint = 0; row < tiles.length / _child.length / width; row += 1)
				quad.concat(tiles.slice(
					qid * tiles.length / _child.length + row * width,
					qid * tiles.length / _child.length + row * width + width)); //FIXME: overflow
					
				_child[qid] = new QuadTree(quad, width / _child.length);
			}
		}
		
		
		/// return == this if root
		public function parent():QuadTree
		{
			return _root[_id >> 2];
		}
		
		public function child(i:uint):QuadTree
		{
			return _root[_id << 2] + i;
		}
		
		/// depth of this node
		public function get depth():uint
		{
			return Math.ceil(Math.log(_id)) - 1;
		}
		
		public function get maxDepth():uint
		{
			return Math.ceil(Math.log(_root.length)) - 1;
		}
		
		public function query(x:uint, y:uint): Tile
		{
			return _root[_id + (y-this.y)*smth + (x-this.x)*smth];
		}
		
		public function get x():uint
		{
			return _id % 1 << depth;
		}
		
		public function get y():uint
		{
			return _id / 1 << depth;
		}
		
		public function get width():uint
		{
			return _root.width >> depth;
		}
		
		public function get height():uint
		{
			return _root.height >> depth;
		}
		
		public function flatten():Vector.<uint>	//FIXME: id's for claritys sake
		{
			return _root.range(_id, _id + width*heigth);
		}
		
		public function isLeaf():Boolean
		{
			return(depth == maxDepth);
		}
		
		/// Use class constants as arguments (no enums)
		public function getDistance(from:uint, to:uint):uint
		{
			if (!_dirty)
				return _cache[from & to];
			
				return uint.MAX_VALUE;
		}
		
		/// No polymorphism, this OR initQuads
		// TODO: separate objects for built from quads, and tiles
		public function initTiles(topLeft:Tile, top:Tile, topRight:Tile,
							left:Tile, 					right:Tile,
							botLeft:Tile, bot:Tile, botRight:Tile):void
		{
			if (null == topLeft)
			{
				if (null != left)
					trace("top boundary");
				else if (null != top)
					trace("left boundary");
				else
					trace("top-left corner");
			} else if (null == botRight) {
				if (null != right)
					trace("bottom boundary");
				else if (null != bot)
					trace("right boundary");
				else
					trace("bot-left corner");
			}
		}
		
		/// No polymorphism, this OR initTiles
		public function initQuads(topLeft:QuadTree, topRight:QuadTree,
							botLeft:QuadTree, botRight:QuadTree):void
		{
			
		}
		
		public function get moveable(): Boolean
		{
			if (_dirty)
				update();
			return _moveable;
		}
		public function set moveable(value:Boolean):void { _moveable = value; }
		
		public function get pathable(): Boolean
		{
			if (_dirty)
				update();
			return _pathable;
		}
		public function set pathable(value:Boolean):void { _pathable = value; }
		
		/// Use class constants as arguments (no enums)
		// TODO: make separate objects for each kind of nodes (top, topleft, right etc.)
		private function markNotPathable(tile:uint):void
		{
			for ( var i:uint = 0; i < 8; i += 1 )
				_cache[(1 << i) & tile] = uint.MAX_VALUE;
		}
		
		private function update():void
		{
			//FIXME:
			_dirty = false;
		}
		
		public function createDepthCursor():IViewCursor
		{
			return new QuadTreeCursor(this);
		}
		
		public function createMemberCursor():IViewCursor
		{
			return new QuadTreeCursor(this);
		}
	}

}

/**
* ...
* @author Mariusz Gliwiński
*/
internal class QuadTreeCursor implements IViewCursor 
{
	private var
		_afterLast:Boolean,
		_beforeFirst:Boolean = true,
		_current:QuadTree;
	
	public function QuadTreeCursor(qt:QuadTree) 
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