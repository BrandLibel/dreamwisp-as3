package dreamwisp.visual.animation 
{
	import dreamwisp.visual.Frame;
	import flash.display.Bitmap;
	
	/**
	 * AnimatedFrames provides functionality for animating bitmap frames. 
	 * @author Brandon
	 */
	
	public class AnimatedFrames extends Animation 
	{
		private var bitmap:Bitmap;
		private var frames:Vector.<Frame>;
		
		public function AnimatedFrames(bitmap:Bitmap, frames:Vector.<Frame>)
		{
			this.bitmap = bitmap;
			this.frames = frames;
			super();
		}
		
		override protected function findFrame(label:String):uint 
		{
			for (var i:int = 0; i < frames.length; i++) 
			{
				if (frames[i].label == label)
					return i;
			}
			return null;
		}
		
		override protected function countFrames(frameLabel:String):uint 
		{
			var numFrames:uint = 0;
			var i:uint = findFrame(frameLabel);
			while (frames[i].label == frameLabel)
			{
				numFrames++;
				if (i == frames.length - 1)
					break;
				i++;
			}
			return numFrames;
		}
		
		override protected function hasLabel(label:String):Boolean 
		{
			for each (var frameObject:Frame in frames) 
				if (frameObject.label == label)
					return true;
			return false;
		}
		
		override public function render():void 
		{
			bitmap.bitmapData = frames[frame].bitmapData;
		}
		
		override public function currentLabel():String { return frameObject().label; }
		
		public function frameObject():Frame
		{
			return frames[frame];
		}
		
	}

}