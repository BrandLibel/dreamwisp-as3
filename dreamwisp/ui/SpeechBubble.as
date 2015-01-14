package dreamwisp.ui 
{
	import flash.display.DisplayObjectContainer;
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
		
		public var graphic:DisplayObjectContainer;
		public var x:Number;
		public var y:Number;
		protected var visible:Boolean;
		protected var dialogueTextField:TextField;
		protected var dialogueWriter:TypeWriter;
		
		public function SpeechBubble(graphic:DisplayObjectContainer, typeSpeed:uint = 1) 
		{
			init(graphic, typeSpeed);
		}
		
		protected function init(graphic:DisplayObjectContainer, typeSpeed:uint = 1):void 
		{
			this.graphic = graphic;
			dialogueTextField = TextField(graphic.getChildByName(KEY_DIALOGUE));
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
			graphic.visible = visible;
			graphic.x = x;
			graphic.y = y;
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
		
		public function currentText():String
		{
			return dialogueTextField.text;
		}
		
	}

}