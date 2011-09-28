package
{
	/**
	 * ...
	 * @author Mariusz Gliwiński
	 */
	internal interface Tile
	{
		function get moveable(): Boolean;
		function set moveable(value:Boolean):void;
		
		function get pathable(): Boolean;
		function set pathable(value:Boolean):void;
	}

}