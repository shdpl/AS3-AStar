package
{
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Mariusz Gliwiński
	 */
	public class Gui 
	{
		private var
			_timer:TimerComponent,
			_map:MapComponent;
		
		public function Gui(parent:DisplayObjectContainer) 
		{
			_timer = new TimerComponent(parent);
			_map = new MapComponent(parent);
		}
		
		public function get mapComponent():MapComponent
		{
			return _map;
		}
		
	}

}