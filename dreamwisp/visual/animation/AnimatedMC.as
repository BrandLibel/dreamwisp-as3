package dreamwisp.visual.animation 
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	
	/**
	 * AnimatedMC provides functionality for animating Flash MovieClips. 
	 * It obviates the need for embedded frame scripts in Flash Professional.
	 * @author Brandon
	 */
	
	public class AnimatedMC extends Animation 
	{
		private var movieClip:MovieClip;
		
		public function AnimatedMC(movieClip:MovieClip, initLabel:String = "") 
		{
			this.movieClip = movieClip;
			super(/*movieClip,*/ initLabel);
		}
		
		override protected function findFrame(label:String):uint 
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
		
		override protected function countFrames(frameLabel:String):uint
		{
			var numFrames:uint = 0;
			const originalFrame:uint = movieClip.currentFrame;
			movieClip.gotoAndStop(frameLabel);
			while (movieClip.currentLabel == frameLabel)
			{
				numFrames++;
				// placed in middle so numFrames increments even on the breaking frame
				if (movieClip.currentFrame == movieClip.totalFrames)
					break;
				movieClip.nextFrame();
			}
			movieClip.gotoAndStop(originalFrame);
			return numFrames;
		}
		
		override protected function hasLabel(label:String):Boolean
		{
			for each (var frameLabel:FrameLabel in movieClip.currentLabels)
				if (frameLabel.name == label)
					return true;
			return false;
		}
		
		override public function render():void 
		{
			movieClip.gotoAndStop(frame);
		}
		
		override public function currentLabel():String { return movieClip.currentLabel; }
		
	}

}