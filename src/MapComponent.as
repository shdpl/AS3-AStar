package  
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Mariusz Gliwiński
	 */
	public class MapComponent extends Sprite
	{
		private var
			_map:Map,
			_mtrx:Matrix,
			_scale:Number,
			_waypoints:Vector.<Point> = new Vector.<Point>(),
			_path:Vector.<Point>,
			_pathfinder:StdPathfinder;
		
		public function MapComponent(parent:DisplayObjectContainer) 
		{
			
			parent.addChild(this);
			this.x = stage.stageWidth / 4;
			this.y = 20;
			
			addEventListener(Event.ENTER_FRAME, onRender);
			addEventListener(MouseEvent.CLICK, onNodeClick, false, 0, true);
		}
		
		public function set map(value:Map):void
		{
			_map = value;
			
			_mtrx = new Matrix();
			_scale = (stage.stageHeight - 20) / 2 / _map.height;
			_mtrx.scale(_scale, _scale);
			
			// TODO: high performance clock?
			_pathfinder = new StdPathfinder(_map);
			//
		}
		
		private function drawTile(to:BitmapData, tile:Tile, x:uint, y:uint):void
		{
			if(!tile._dynamic)
				to.setPixel(x, y, tile._pathability * uint.MAX_VALUE);
			else
				to.setPixel(x, y, 0xFF0000);
		}
		
		private function drawMap():void
		{
			var bm:BitmapData = new BitmapData(_map.width, _map.height, false);
			
			for (var i:uint = 0; i < _map.width * _map.height; i++)
				drawTile(bm, _map._tiles[i], i%_map.width, i/_map.height);
			
			graphics.beginBitmapFill(bm, _mtrx, true);
				graphics.drawRect(0, 0, _map.width * _scale, _map.height * _scale);
			graphics.endFill();
		}
		
		private function drawPath():void
		{
			//TODO
		}
		
		private function onRender(e:Event):void
		{
			this.graphics.clear();
			drawMap();
			if (_path)
				drawPath();
		}
		
		private function onNodeClick(e:MouseEvent):void
		{
			var len:uint = _waypoints.push(new Point(e.localX, e.localY));
			trace("waypoints: ", _waypoints);
			if (len > 1)
			{
				_path = _pathfinder.query(_waypoints[_waypoints.length - 2], _waypoints[_waypoints.length - 1]);
				trace("path: ", _path);
			}
		}
		
		
	}

}