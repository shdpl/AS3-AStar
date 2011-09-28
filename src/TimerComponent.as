package
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Mariusz Gliwiński
	 */
	public class TimerComponent
	{
		private var
			_frames:uint,
			_timer:Timer,
			_ticks:uint,
			_fpsLabel:TextField,
			_fpsComponent:TextField;
		
		public function TimerComponent(parent:DisplayObjectContainer) 
		{
			parent.addEventListener(Event.ENTER_FRAME, onRender);
			
			_timer = new Timer(1000);
			_timer.addEventListener("timer", onTick);
			_timer.start();
			
			_fpsLabel = new TextField();
			_fpsLabel.text = "fps: ";
			parent.addChild(_fpsLabel);
			
			_fpsComponent = new TextField();
			_fpsComponent.text = "??";
			_fpsComponent.x = 20;
			parent.addChild(_fpsComponent);
		}
		
		private function onRender(e:Event):void
		{
			_frames += 1;	//incrementation is slower than +=1,
			if (_frames == uint.MAX_VALUE)
				_timer.reset();
		}
		
		private function onTick(e:TimerEvent):void
		{
			_ticks += 1;
			if (_frames == 0) {
				updateFPS(_ticks, uint.MAX_VALUE);
				_timer.reset();
			} else
				updateFPS(_ticks, _frames);
		}
		
		private function updateFPS(secs:uint, frames:uint):void
		{
			var fps:Number = Math.round(frames / secs*100)/100;
			_fpsComponent.text = fps.toString();
		}
		
	}

}