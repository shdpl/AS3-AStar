package  
{
	/**
	 * ...
	 * @author Mariusz Gliwiński
	 */
	public class MapTile implements Tile
	{
		private var
			_distance:uint,
			_moveable:Boolean,
			_pathable:Boolean;
		
		public function MapTile() 
		{
			
		}
		
		public function get moveable(): Boolean { return _moveable; }
		public function set moveable(value:Boolean):void { _moveable = value; }
		
		public function get pathable(): Boolean { return _pathable; }
		public function set pathable(value:Boolean):void { _pathable = value; }
		
	}

}