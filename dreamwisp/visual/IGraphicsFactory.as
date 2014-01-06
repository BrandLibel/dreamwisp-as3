package dreamwisp.visual {
	
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public interface IGraphicsFactory {
		
		function getGraphicsObject(type:String, name:String, data:Object = null):GraphicsObject;
		
	}
	
}