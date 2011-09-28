package  
{
	/**
	 * TODO: inspect, maybe list rather than heap-fragmentation? or http://code.google.com/p/polygonal/
	 * license: Public Domain
	 * @link http://pastebin.com/VAGbSyRT
	 * @author anonymous
	 */
	public class PriorityQueue 
	{
		private var _objects:Vector.<Object> = new Vector.<Object>;
		private var _property:String;
		
		public function PriorityQueue(property:String = "priority") 
		{
			_property = property;
			_objects.push(null);
		}
		
		public function get count():uint
		{
			return _objects.length - 1;
		}
		
		public function get property():String
		{
			return _property;
		}
		
		public function clear():void
		{
			_objects.length = 1;
		}
		
		public function peek():Object
		{
			if (_objects.length > 1) return _objects[1];
			return null;
		}
		
		public function enqueue(o:Object):void
		{
			_objects.push(o);
			var cell:int = _objects.length - 1,
				parentValue:Object;
			while (cell != 1 && _objects[int(cell >> 1)][_property] > _objects[cell][_property])
			{
				parentValue = _objects[int(cell >> 1)];
				_objects[int(cell >> 1)] = _objects[cell];
				_objects[cell] = parentValue;
				cell >>= 1;
			}
		}
		
		public function dequeue():Object
		{
			if (_objects.length > 1)
			{
				var minValue:Object = _objects[1];
				if (_objects.length > 2)
				{
					_objects[1] = _objects[_objects.length - 1];
					_objects.length --;
					var cell:int = 1,
						left:int = cell << 1,
						right:int = left + 1,
						parentValue:Object,
						leftSmaller:Boolean = left < _objects.length && _objects[left][_property] < _objects[cell][_property],
						rightSmaller:Boolean = right < _objects.length && _objects[right][_property] < _objects[cell][_property];
					while (leftSmaller || rightSmaller)
					{
						if (leftSmaller && rightSmaller)
						{
							if (_objects[left][_property] <= _objects[right][_property])
							{
								parentValue = _objects[cell];
								_objects[cell] = _objects[cell << 1];
								_objects[left] = parentValue;
								cell = left;
							}
							else
							{
								parentValue = _objects[cell];
								_objects[cell] = _objects[right];
								_objects[right] = parentValue;
								cell = right;
							}
						}
						else if (leftSmaller)
						{
							parentValue = _objects[cell];
							_objects[cell] = _objects[cell << 1];
							_objects[left] = parentValue;
							cell = left;
						}
						else
						{
							parentValue = _objects[cell];
							_objects[cell] = _objects[right];
							_objects[right] = parentValue;
							cell = right;
						}
						left = cell << 1;
						right = left + 1;
						leftSmaller = left < _objects.length && _objects[left][_property] < _objects[cell][_property],
						rightSmaller = right < _objects.length && _objects[right][_property] < _objects[cell][_property];
					}
				}
				else _objects.length --;
				return minValue;
			}
			return null;
		}
	}
}