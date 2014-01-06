package dreamwisp.visual {
	
	import dreamwisp.core.IUpdatable;
	import flash.display.DisplayObject;
	
	/**
	 * IGraphicsObject defines functionality for a displayObject wrapped 
	 * in a slightly more complex shell, offering more methods.
	 * @author Brandon
	 */
	
	public interface IGraphicsObject extends IUpdatable {
		
		/// Activates and gives context to this GraphicsObject after attaching it.
		function initialize():void;
		function getGraphicsData():DisplayObject;
		
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		
		function get relativeX():String;
		function get relativeY():String;
		
		function get parentWidth():Number;
		function set parentWidth(value:Number):void;
		function get parentHeight():Number;
		function set parentHeight(value:Number):void;
		
	}
	
}