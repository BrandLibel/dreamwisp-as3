package dreamwisp.entity.components {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.visual.camera.Camera;
	import dreamwisp.entity.hosts.Entity;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
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
	 
	public class View {
		
		private var host:Entity;
		
		public var displayObject:DisplayObject;
		private var _movieClip:MovieClip;
		private var _alpha:Number = 1;
		protected const rotAngle:Number = (180 / Math.PI);
		
		/// Layer for if this View gets added into a ContainerView
		private var _layer:uint = uint.MAX_VALUE;
		
		public function View(entity:Entity) {
			host = entity;
		}
		
		public function render(interpolation:Number):void {
			if (!movieClip) return;
			
			if (host.animation) movieClip.gotoAndStop(host.animation.currentFrame());
			if (host.physics) {
				movieClip.x = host.body.x + (host.physics.xVelocity * interpolation);
				movieClip.y = host.body.y + (host.physics.yVelocity * interpolation);
			} else {
				movieClip.x = host.body.x;
				movieClip.y = host.body.y;
			}
            movieClip.rotation = host.body.angle * rotAngle;
            movieClip.alpha = alpha;
            movieClip.scaleX = 1;//scale;
            movieClip.scaleY = 1;//scale;
		}
		
		public function get movieClip():MovieClip { return _movieClip; }
		
		public function set movieClip(value:MovieClip):void { _movieClip = value; }
		
		public function get alpha():Number { return _alpha; }
		
		public function set alpha(value:Number):void { _alpha = value; }
		
		public function get layer():uint { return _layer; }
		
		public function set layer(value:uint):void {
			//MonsterDebugger.trace(this, "set layer: " + value);
			_layer = value;
		}
		
	}
}