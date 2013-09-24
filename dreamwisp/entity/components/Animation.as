package dreamwisp.entity.components {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.visual.AnimHandler;
	import dreamwisp.entity.hosts.Entity;
	import flash.display.MovieClip;
	
	/**
	 * This class is for entitys that have multiple frames and can be animated. 
	 * They can react to certain requests for animation
	 */
	
	public class Animation extends AnimHandler {
				
		private var host:Entity;
		//public var currentFrame:uint = 1;
		/// Array of string frameLabels in the specified movieClip.
		private var frameLabels:Array;
		
		public function Animation(entity:Entity) {
			init(entity);
		}
		
		private function init(entity:Entity):void {
			host = entity;
			
			actual = entity.view.movieClip;
			frame.init(1, 1);
			nullify();
		}
		
		override public function update():void {
			super.update();
			//host.view.movieClip.gotoAndStop(currentValue);
			
			//host.view.movieClip.gotoAndStop(frame.currentValue);
		}
		
		override public function render():void {
			host.view.movieClip.gotoAndStop(frame.currentValue);
		}
		
		
		// movieClip specific functionality

		public function mapFrameLabels(movieClip:MovieClip):void {
			frameLabels = movieClip.currentLabels;
			//MonsterDebugger.trace(this, frameLabels);
		}
		
		public function findFrame(label:String, movieClip:MovieClip):int {
			if (movieClip.totalFrames == 1) return 1;
			var i:uint = 0;
			for (i; i < frameLabels.length; i++) {
				if (frameLabels[i].name == label) {
					break;
				}
			}
			//MonsterDebugger.trace(this, frameLabels[i].frame);
			return frameLabels[i].frame;
		}
		
		
	}

}