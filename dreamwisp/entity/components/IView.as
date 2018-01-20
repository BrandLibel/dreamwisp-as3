package dreamwisp.entity.components 
{
	import dreamwisp.visual.ContainerViewS;
	import dreamwisp.visual.animation.Animation;
	
	/**
	 * ...
	 * @author 
	 */
	public interface IView 
	{
		function render(interpolation:Number):void;
		
		function applyTint(r:Number, g:Number, b:Number, displayObject:DisplayObject = null):void;

		/**
		 * Applies a destructive (prev tint is ignored) tint.
		 * @param	colors red, green, and blue multiplier (0 - 1) values
		 */
		function applyTintArray(colors:Array, displayObject:DisplayObject = null):void;
		
		function applyTintRGB(rgb:uint, displayObject:DisplayObject = null):void;
		
		function get movieClip():MovieClip;
		
		function set movieClip(value:MovieClip):void;
		
		function get displayObject():DisplayObject;
		
		function set displayObject(value:DisplayObject):void;
		
		function get displayObjectContainer():DisplayObjectContainer;
		
		function setContainerView(containerView:ContainerViewS):void;
		
		function get animation():Animation;
		
		function set animation(value:Animation):void;
		
		function getTint():Array;
		
		function hasTint():Boolean;
		
		/**
		 * Count number of frames in a certain label
		 */
		function countFrames(frameLabel:String):uint;
		
		function get alpha():Number;
		
		function set alpha(value:Number):void;
		
		function get layer():uint;
		
		function set layer(value:uint):void;
		
		function get offsetX():Number;
		
		function set offsetX(value:Number):void;
		
		function get offsetY():Number;
		
		function set offsetY(value:Number):void;
	}
	
}