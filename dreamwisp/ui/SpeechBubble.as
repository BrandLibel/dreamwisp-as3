package dreamwisp.ui 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * SpeechBubble displays a single TextField at a time.
	 * @author Brandon
	 */
	
	public class SpeechBubble 
	{
		protected static const KEY_DIALOGUE:String = "dialogue";
		
		protected static const STATE_HIDDEN:uint = 0;
		protected static const STATE_READING:uint = 1;
		protected static const STATE_FINISHED:uint = 2;
		protected var state:uint = STATE_HIDDEN;
		
		public var movieClip:MovieClip;
		protected var visible:Boolean;
		protected var dialogueTextField:TextField;
		protected var dialogueWriter:TypeWriter;
		
		public function SpeechBubble(movieClip:MovieClip, typeSpeed:uint = 1) 
		{
			if (movieClip.getChildByName(KEY_DIALOGUE) == null)
				throw new Error("The MovieClip for DialogueBox is missing a necessary dialogue textField!");
				
			this.movieClip = movieClip;
			dialogueTextField = TextField(movieClip.getChildByName(KEY_DIALOGUE));
			dialogueWriter = new TypeWriter(dialogueTextField, typeSpeed);
		}
		
		public function read(text:String):void
		{
			state = STATE_READING;
			dialogueWriter.load(text);
		}
		
		public function isFinished():Boolean
		{
			return state == STATE_FINISHED;
		}
		
		public function isHidden():Boolean
		{
			return state == STATE_HIDDEN;
		}
		
		public function update():void 
		{
			if (state == STATE_HIDDEN) return;
			if (state == STATE_READING)
			{
				if (!dialogueWriter.write())
					state = STATE_FINISHED;
			}
		}
		
		public function render(interpolation:Number):void 
		{
			movieClip.visible = visible;
			if (state == STATE_HIDDEN) return;
			dialogueWriter.render();
		}
		
		public function show():void 
		{
			visible = true;
		}
		
		public function hide():void 
		{
			state = STATE_HIDDEN;
			visible = false;
		}
		
	}

}