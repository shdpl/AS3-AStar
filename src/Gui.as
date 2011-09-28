package
{
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Mariusz Gliwiński
	 */
	public class Gui 
	{
		private var _timer:TimerComponent;
		
		public function Gui(parent:DisplayObjectContainer) 
		{
			_timer = new TimerComponent(parent);
		}
		
	}

}