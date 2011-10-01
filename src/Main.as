package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Mariusz Gliwiński
	 */
	public class Main extends MovieClip 
	{
		private var
			_gui:Gui,
			_map:Map;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			haxe.init(this);
			removeEventListener(Event.ADDED_TO_STAGE, init);

			_gui = new Gui(this);
			_map = new Map(6, 6);
			_gui.mapComponent.map = _map;
		}
	}
	
}