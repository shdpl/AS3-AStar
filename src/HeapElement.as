package
{
    import de.polygonal.ds.Heapable;

    public class HeapElement implements Heapable {
        public var value:int;
        public var position:int;

        public function HeapElement(value:int)
        {
            this.value = value;
        }

        public function compare(other:Object):int
        {
            return other.value - value;
        }

        public function toString():String
        {
            return "" + value;
        }
    }
}