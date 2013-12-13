package dreamwisp.entity.components 
{
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.hosts.Entity;
	import flash.display.MovieClip;
	
	/**
	 * This class is for entitys that have multiple frames and can be animated. 
	 * They can react to certain requests for animation
	 */
	
	public class Animation
	{
		private var host:Entity;
		
		private var frame:uint = 1;
		private var targetFrame:uint = 1;
		private var speed:uint = 1;
		
		private var state:uint = 0;
		private static const STATE_IDLE:uint = 0;
		private static const STATE_ANIMATE_FORWARD:uint = 1;
		private static const STATE_ANIMATE_BACKWARD:uint = 2;
		
		public function Animation(entity:Entity)
		{
			host = entity;
		}
		
		public function update():void 
		{
			if (state == STATE_ANIMATE_FORWARD)
				frame += speed;
			else if (state == STATE_ANIMATE_BACKWARD)
				frame -= speed;
				
			if (frame == targetFrame)
				state = STATE_IDLE;
				
			//TODO: Upon reaching target frame, animation reads from Animation data to find
			//		the new frame to switch to, rather than going idle.
		}
		
		/**
		 * 
		 * @param	label As specified within the MovieClip's animation timeline.
		 * @return
		 */
		public function findFrame(label:String):uint 
		{
			const movieClip:MovieClip = host.view.movieClip;
			const frameLabels:Array = movieClip.currentLabels;
			if (movieClip.totalFrames == 1)
				return 1;
				
			var i:uint;
			for (i = 0; i < frameLabels.length; i++)
			{
				if (frameLabels[i].name == label)
					break;
			}
			//MonsterDebugger.trace(this, frameLabels[i].frame);
			return frameLabels[i].frame;
		}
		
		public function runTo(targetFrame:uint, speed:uint = 1):void 
		{
			this.targetFrame = targetFrame;
			this.speed = speed;
			state = (targetFrame - frame > 0) ? STATE_ANIMATE_FORWARD : STATE_ANIMATE_BACKWARD;
		}
		
		public function currentFrame():uint
		{
			return frame;
		}
	
	}

}