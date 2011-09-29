package  
{
	/**
	 * ...
	 * @author Mariusz Gliwiński
	 */
	public class Map 
	{
		public var _tiles:Vector.<Tile>;	// Cache coherency
		private var
			_width:uint,
			_height:uint;
		
		public function Map(width:uint, height:uint)
		{
			_tiles = new Vector.<Tile>(width * height, true);
			_width = width;
			_height = height;
			buildTerrain(0.3);
			buildActors(10);
		}
		
		/**
		 * 
		 * @param	probability	[0..1] of making an obstacle
		 */
		private function buildTerrain(probability:Number):void
		{
			for (var tid:uint; tid < _tiles.length; tid += 1) {
				_tiles[tid] = new Tile();
				_tiles[tid]._pathability = Math.random() >= probability ? 1 : 0;
			}
		}
		
		private function buildActors(amount:uint):void
		{
			Utils.assert(amount < _width * _height);
			for (var i:uint = 0; i < amount; i+=1 ) {
				var tid:uint;
				do {
					tid = Math.round(Math.random() * _width*_height);
				} while (_tiles[tid]._dynamic);
				
				_tiles[tid]._dynamic = true; // making it more readable affects performance
				_tiles[tid]._pathability = 0;
			}
		}
		
		public function get width():uint
		{
			return _width;
		}
		
		public function get height():uint
		{
			return _height;
		}
		
	}

}