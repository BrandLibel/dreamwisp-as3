package dreamwisp.visual 
{
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	
	/**
	 * Animation provides functionality for animating Flash MovieClips. 
	 * It obviates the need for embedded frame scripts in Flash Professional.
	 * @author Brandon
	 */
	
	public class Animation 
	{
		private var movieClip:MovieClip;
		
		private static const PRIORITY_NORMAL:int = 0;
		private static const PRIORITY_HIGH:int = 1;
		private var currentPriority:int = PRIORITY_NORMAL; 
		
		private var frame:uint = 0;
		private var targetFrame:uint = 0;
		private var speed:int = 0;
		private var callBack:Function = null;
		
		/// Locked indicates that any new animation will not be played
		private var locked:Boolean = false;
		
		public function Animation(movieClip:MovieClip) 
		{
			this.movieClip = movieClip;
		}
		
		/**
		 * Updates currentFrame and triggers any callbacks
		 * @return whether or not there was an animation lock during this update
		 */ 
		public function update():void
		{
			stopped = false;
			hadLock = locked;
			frame += speed;
			if (frame == targetFrame)
			{
				stopped = true;
				stop();
			}
		}
		
		private var stopped:Boolean = false;
		private var hadLock:Boolean = false;
		/**
		 * wasStopped + hadLock indicates the client update() might want to return
		 * because we aren't locked but we should be - the frame right after a locked stop()
		 */
		public function shouldKillUpdate():Boolean { return locked || (stopped && hadLock) }
		
		private function stop():void 
		{
			speed = 0;
			targetFrame = 0; // setting to invalid frame (0) prevents unwanted future stops
			
			// trigger callbacks
			if (callBack != null)
				callBack.call();
			
			locked = false;
		}
		
		/// Plays to the target frame
		public function runTo(targetFrame:uint, speed:int = 1, callBack:Function = null):void 
		{
			if (locked) return;
			this.targetFrame = targetFrame;
			
			this.speed = speed;
			// set speed negative (play backwards) when necessary
			if (targetFrame < frame && speed > 0)
				speed = -speed;
				
			this.callBack = callBack;
		}
		
		public function runToLabel(targetLabel:String, speed:int = 1, callBack:Function = null):void 
		{
			runTo( findFrame(targetLabel), speed, callBack );
		}
		
		/// Essentially movieClip.gotoAndPlay(startLabel); replays once the label is finished
		public function loop(startLabel:String):void 
		{
			play( startLabel, function replay():void { loop(startLabel) } );
		}
		
		/// Essentially movieClip.gotoAndPlay(startLabel); stops once the label is finished
		public function play(startLabel:String, callBack:Function = null):void 
		{
			if (locked || !hasLabel(startLabel)) return;
			speed = 1;
			frame = findFrame(startLabel);
			targetFrame = frame + countFrames(startLabel) - 1;
			this.callBack = callBack;
		}
		
		/// Plays and sets locked = true (prevents other animations or frame changes)
		public function playLock(startLabel:String, callBack:Function = null):void 
		{
			play(startLabel, callBack);
			locked = true;
		}
		
		public function setFrame(targetLabel:String):void 
		{
			if (locked) return;
			frame = findFrame(targetLabel);
			speed = 0;
			targetFrame = 0;
		}
		
		/// Returns the frame number of the provided label
		private function findFrame(label:String):uint 
		{
			if (movieClip.totalFrames == 1)
				return 1;
			
			for each (var frameLabel:FrameLabel in movieClip.currentLabels) 
			{
				if (frameLabel.name == label)
					return frameLabel.frame;
			}
			return null;
		}
		
		/**
		 * Count number of frames in a certain label
		 */
		private function countFrames(frameLabel:String):uint
		{
			var numFrames:uint = 0;
			const originalFrame:uint = movieClip.currentFrame;
			movieClip.gotoAndStop(frameLabel);
			while (movieClip.currentLabel == frameLabel && movieClip.currentFrame != movieClip.totalFrames)
			{
				numFrames++;
				movieClip.nextFrame();
			}
			movieClip.gotoAndStop(originalFrame);
			return numFrames;
		}
		
		private function hasLabel(label:String):Boolean
		{
			for each (var frameLabel:FrameLabel in movieClip.currentLabels)
				if (frameLabel.name == label)
					return true;
			return false;
		}
		
		/// Call to set the movieClip's frame
		public function render():void 
		{
			movieClip.gotoAndStop(frame);
		}
		
		/// Whether or not the current animation prevents other animations
		public function isLocked():Boolean { return locked;  }
		
		public function currentFrame():uint { return frame; }
		
	}

}