package dreamwisp.ui 
{
	import dreamwisp.input.InputState;
	import dreamwisp.input.KeyMap;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	
	/**
	 * DialogueBox is a linear conversation explorer.
	 * Its appearance varies, through an interchangable MovieClip. 
	 * It controls the display and navigation of conversations, 
	 * @author Brandon
	 */
	public class DialogueBox extends SpeechBubble
	{
		private static const KEY_SPEAKER:String = "speaker";
		
		private var conversation:Array;
		private var convoProgress:uint = 0;
		
		private var displayedSpeaker:String;

		private var keyMap:KeyMap;
		
		public function DialogueBox(graphic:DisplayObjectContainer, keyMap:KeyMap, typeSpeed:uint = 0) 
		{
			init(graphic, typeSpeed);
		}
		
		override protected function init(graphic:DisplayObjectContainer, typeSpeed:uint = 0):void 
		{
			super.init();
			
			super.graphic = graphic;
			super.graphic.visible = false;
			
			dialogueWriter = new TypeWriter(accessField(SpeechBubble.KEY_DIALOGUE), typeSpeed);
			
			this.keyMap = keyMap;
		}
		
		public function readPrev():void 
		{
			if (convoProgress <= 0)
				return;
			readConvo(convoProgress - 1);		
		}
		
		public function readNext():void 
		{
			// still reading? this will transfer remainder & immediately finish
			if (state == SpeechBubble.STATE_READING)
			{
				dialogueWriter.finish();
				state = SpeechBubble.STATE_FINISHED;
				return;
			}
			// reached conversation end, close the box
			if (convoProgress == conversation.length - 1)
			{
				hide();
				return;
			}
			readConvo(convoProgress + 1);
		}
		
		public function readConvo(convoProgress:uint):void 
		{
			displayedSpeaker = conversation[convoProgress].speaker;
			read(conversation[convoProgress].dialogue);
			this.convoProgress = convoProgress;
		}
		
		/**
		 * Opens a linear conversation that this DialogueBox can explore internally. 
		 * @param	conversation a linear array preverified to contain Speaker and Dialogue text.
		 */		
		public function load(conversation:Array):void 
		{
			if (conversation == null || conversation.length == 0)
				throw new Error("Conversation is empty!");			
			this.conversation = conversation;
			readConvo(0);
			show();
		}
		
		public function handleInput(inputState:InputState):void 
		{
			keyMap.readInput(inputState);
		}
		
		override public function render(interpolation:Number):void 
		{
			graphic.visible = visible;
			if (state == SpeechBubble.STATE_HIDDEN) return;
			accessField(KEY_SPEAKER).htmlText = displayedSpeaker;
			dialogueWriter.render();
		}
		
		private function accessField(field:String):TextField
		{
			return TextField(graphic.getChildByName(field));
		}
		
	}

}