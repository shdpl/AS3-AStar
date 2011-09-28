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
			var max:uint = uint.MAX_VALUE >> 1;
			Utils.assert(width < max && height < max);
			
			_tiles = new Vector.<Tile>(width * height, true);
			_width = width;
			_height = height;
			buildTerrain(0.3);
			buildActors(10);
		}
		
		private function buildTerrain(probability:Number):void
		{
			for (var tid:uint; tid < _tiles.length; tid += 1) {
				_tiles[tid] = new MapTile();
				_tiles[tid].pathable = Math.random() >= probability;
			}
		}
		
		private function buildActors(amount:uint):void
		{
			Utils.assert(amount < _width * _height);
			for (var i:uint = 0; i < amount; i+=1 ) {
				var tid:uint;
				do {
					tid = Math.round(Math.random() * _width*_height);
				} while (_tiles[tid].moveable);
				
				_tiles[tid].moveable = true; // making it more readable affects performance
				_tiles[tid].pathable = false;
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