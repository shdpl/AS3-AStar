package 
{
	/**
	 * ...
	 * @author Mariusz Gliwiński
	 */
	internal class Utils {
		public static function assert(expression:Boolean):void
		{
			if (!expression)
				throw new Error("Assertion failed!");
		}
	}

}