package  
{
	
	/**
	 * ...
	 * @author Mariusz Gliwiński
	 */
	public interface IViewCursor 
	{
		function get afterLast(): Boolean;
		function get beforeFirst(): Boolean;
		//function get bookmark(): CursorBookmark;
		function get current(): Object;
		//function get view(): ICollectionView;
		
		//function findAny(values:Object): Boolean;
		//function findFirst(values:Object): Boolean;
		//function findLast(values:Object): Boolean;
		//function insert(item:Object): void;
		function moveNext(): Boolean;
		//function movePrevious(): Boolean;
		//function remove(): Object;
		//function seek(bookmark:CursorBookmark, offset:int = 0, prefetch:int = 0): void;
		
		//function get cursorUpdate() : Event
	}
	
}