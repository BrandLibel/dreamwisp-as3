package dreamwisp.visual {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class GenericView {
		
		public var label:String;
		public var displayObject:DisplayObject;
		public var layer:uint;
		
		public function GenericView(displayData:*, layer:uint, label:String = "") {
			this.label = label;
			this.layer = layer;
			this.displayObject = displayData;
		}
				
		public function addChild(child:DisplayObject):void 
		{
			if (displayObject is DisplayObjectContainer) {
				DisplayObjectContainer(displayObject).addChild(child);
			}
		}
		
		public function removeChild(child:DisplayObject):void {
			if (displayObject is DisplayObjectContainer) {
				DisplayObjectContainer(displayObject).removeChild(child);
			}
		}
		
	}

}