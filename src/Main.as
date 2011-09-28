package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Mariusz Gliwiński
	 */
	public class Main extends Sprite 
	{
		private var
			_gui:Gui,
			_map:Map,
			_pathfinder:Pathfinder;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_gui = new Gui(this);
			_map = new Map(100, 100);
			_pathfinder = new Pathfinder(_map);
		}
	}
	
}