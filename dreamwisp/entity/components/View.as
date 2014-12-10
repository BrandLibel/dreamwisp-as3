package dreamwisp.entity.components
{
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.visual.camera.Camera;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.visual.ContainerView;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import tools.Belt;
	
	/**
	 * This class is for anything that can be visually rendered on the screen.
	 * Invisible entitys will not need this.
	 */
	 
	public class View
	{
		private var host:Entity;
		
		private var _displayObject:DisplayObject;
		protected const rotAngle:Number = (180 / Math.PI);
		public var offsetX:Number = 0;
		public var offsetY:Number = 0;
		
		// color transformation tools
		private var currentTint:Array = [1, 1, 1];
		private var colorTransform:ColorTransform;
		
		/// Layer for if this View gets added into a ContainerView
		private var _layer:uint;
		private var containerView:ContainerView;
		
		public function View(entity:Entity, displayObject:DisplayObject)
		{
			host = entity;
			this.displayObject = displayObject;
			//colorTransform = displayObject.transform.colorTransform;
		}
		
		public function render(interpolation:Number):void
		{
			if (host.physics)
			{
				displayObject.x = host.body.x + (host.physics.velocityX * interpolation) + offsetX;
				displayObject.y = host.body.y + (host.physics.velocityY * interpolation) + offsetY;
			} 
			else
			{
				displayObject.x = host.body.x + offsetX;
				displayObject.y = host.body.y + offsetY;
			}
            displayObject.rotation = host.body.angle * rotAngle;
		}
		
		public function applyTint(r:Number, g:Number, b:Number, displayObject:DisplayObject = null):void 
		{
			if (displayObject == null) displayObject = this.displayObject;
			
			currentTint[0] = r;
			currentTint[1] = g;
			currentTint[2] = b;
			
			colorTransform = Belt.applyTint(displayObject, r, g, b);
		}
		
		/**
		 * Applies a destructive (prev tint is ignored) tint.
		 * @param	colors red, green, and blue multiplier (0 - 1) values
		 */
		public function applyTintArray(colors:Array, displayObject:DisplayObject = null):void 
		{
			applyTint(colors[0], colors[1], colors[2], displayObject);
		}
		
		public function applyTintRGB(rgb:uint, displayObject:DisplayObject = null):void 
		{
			applyTintArray(Belt.rgbToMultipliers(rgb), displayObject);
		}
		
		public function getTint():Array 
		{
			return currentTint.concat();
		}
		
		public function hasTint():Boolean
		{
			return (currentTint[0] != 1 && currentTint[1] != 1 && currentTint[2] != 1);
		}
		
		/**
		 * Count number of frames in a certain label
		 */
		public function countFrames(frameLabel:String):uint
		{
			var numFrames:uint = 0;
			const originalFrame:uint = movieClip.currentFrame;
			movieClip.gotoAndStop(frameLabel);
			while (movieClip.currentLabel == frameLabel)
			{
				numFrames++;
				movieClip.nextFrame();
			}
			movieClip.gotoAndStop(originalFrame);
			return numFrames;
		}
		
		public function get alpha():Number { return displayObject.alpha; }
		
		public function set alpha(value:Number):void { displayObject.alpha = value; }
		
		public function get layer():uint { return _layer; }
		
		public function set layer(value:uint):void {
			_layer = value;
		}
		
		public function get movieClip():MovieClip { return displayObject as MovieClip; }
		
		public function set movieClip(value:MovieClip):void { displayObject = value; }
		
		public function get displayObject():DisplayObject 
		{
			//if (colorTransform != null)
				//_displayObject.transform.colorTransform = colorTransform;
			return _displayObject;
		}
		
		public function set displayObject(value:DisplayObject):void 
		{
			if (containerView && _displayObject != null)
			{
				// new displayObject? update its existence in ContainerView
				containerView.removeDisplayObject(displayObject);
				containerView.addDisplayObject(value, layer, host.body.x, host.body.y);
			}
			_displayObject = value;
			
		}
		
		public function get displayObjectContainer():DisplayObjectContainer
		{
			return _displayObject as DisplayObjectContainer;
		}
		
		public function setContainerView(containerView:ContainerView):void 
		{
			this.containerView = containerView;
			
		}
		
	}
}