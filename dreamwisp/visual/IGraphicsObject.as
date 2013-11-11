package dreamwisp.visual {
	
	/**
	 * ...
	 * @author Brandon
	 */
	public interface IGraphicsObject {
		
		/// Activates and gives context to this GraphicsObject after attaching it.
		function initialize(parentWidth:Number = 768, parentHeight:Number = 480):void;
		function getGraphicsData():*;
		
		function getX():Number;
		function setX(value:Number):void;
		function getY():Number;
		function setY(value:Number):void;
		
		function get relativeX():String;
		function get relativeY():String;
		
	}
	
}