package dreamwisp.entity.components
{
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.visual.camera.Camera;
	import dreamwisp.entity.hosts.Entity;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	/**
	 * This class is for anything that can be visually rendered on the screen.
	 * Invisible entitys will not need this.
	 */
	
	//TODO: Replace the View component in Entitys with an IGraphicsObject component.
	//		Whenever added to a ContainerView it gives a reference from getGraphicsData().
	//		Get rid of all the GraphicsFactory stuff. Instantiate each class individually.
	//		The GraphicsObject concrete class should contain most of the properties
	//		included in this class. some special GraphicsObjects will handle animation,
	//		some will handle relative positioning.
	 
	public class View
	{
		private var host:Entity;
		
		private var _displayObject:DisplayObject;
		private var _alpha:Number = 1;
		protected const rotAngle:Number = (180 / Math.PI);
		
		// color transformation tools
		private var currentTint:Array = [1, 1, 1];
		private var colorTransform:ColorTransform;
		
		/// Layer for if this View gets added into a ContainerView
		private var _layer:uint = uint.MAX_VALUE;
		
		public function View(entity:Entity, displayObject:DisplayObject)
		{
			host = entity;
			this.displayObject = displayObject;
			colorTransform = displayObject.transform.colorTransform;
		}
		
		public function render(interpolation:Number):void
		{
			if (!movieClip) return;
			
			if (host.animation) movieClip.gotoAndStop(host.animation.currentFrame());
			if (host.physics)
			{
				displayObject.x = host.body.x + (host.physics.velocityX * interpolation);
				displayObject.y = host.body.y + (host.physics.velocityY * interpolation);
			} 
			else
			{
				displayObject.x = host.body.x;
				displayObject.y = host.body.y;
			}
            displayObject.rotation = host.body.angle * rotAngle;
            displayObject.alpha = alpha;
            displayObject.scaleX = 1;//scale;
            displayObject.scaleY = 1;//scale;
		}
		
		/**
		 * Alters the tinting of this view
		 * @param	colors red, green, and blue multiplier (0 - 1) values
		 */
		public function applyTint(colors:Array):void 
		{
			currentTint = colors;
			colorTransform.redMultiplier = colors[0];
			colorTransform.greenMultiplier = colors[1];
			colorTransform.blueMultiplier = colors[2];
			displayObject.transform.colorTransform = colorTransform;
		}
		
		public function getTint():Array 
		{
			return currentTint;
		}
		
		public function hasTint():Boolean
		{
			return (currentTint[0] != 1 && currentTint[1] != 1 && currentTint[2] != 1);
		}
		
		public function get alpha():Number { return _alpha; }
		
		public function set alpha(value:Number):void { _alpha = value; }
		
		public function get layer():uint { return _layer; }
		
		public function set layer(value:uint):void {
			_layer = value;
		}
		
		public function get movieClip():MovieClip { return displayObject as MovieClip; }
		
		public function set movieClip(value:MovieClip):void { displayObject = value; }
		
		public function get displayObject():DisplayObject 
		{
			if (colorTransform)
				_displayObject.transform.colorTransform = colorTransform;
			return _displayObject;
		}
		
		public function set displayObject(value:DisplayObject):void 
		{
			_displayObject = value;
		}
		
		public function get displayObjectContainer():DisplayObjectContainer
		{
			return _displayObject as DisplayObjectContainer;
		}
		
	}
}