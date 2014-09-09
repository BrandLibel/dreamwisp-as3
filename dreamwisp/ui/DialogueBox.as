package dreamwisp.ui 
{
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.components.View;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.entity.hosts.IPlayerControllable;
	import dreamwisp.input.InputState;
	import dreamwisp.input.KeyMap;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	/**
	 * DialogueBox is a conversation explorer.
	 * Its appearance varies, through an interchangable MovieClip. 
	 * It controls the display and navigation of conversations, 
	 * @author Brandon
	 */
	public class DialogueBox
	{
		private static const KEY_SPEAKER:String = "speaker";
		private static const KEY_DIALOGUE:String = "dialogue";
		
		private static const STATE_HIDDEN:uint = 0;
		private static const STATE_READING:uint = 1;
		private static const STATE_FINISHED:uint = 2;
		private var state:uint = STATE_HIDDEN;
		
		private var conversation:Array;
		private var convoProgress:uint = 0;
		
		private var displayedSpeaker:String;
		private var dialogueWriter:TypeWriter;
		
		private var _movieClip:MovieClip;
		private var visible:Boolean;
		
		public function DialogueBox(movieClip:MovieClip, typeSpeed:uint = 1) 
		{
			if (movieClip.getChildByName(KEY_SPEAKER) == null)
				throw new Error("The MovieClip for DialogueBox is missing a necessary speaker textField!");
			if (movieClip.getChildByName(KEY_DIALOGUE) == null)
				throw new Error("The MovieClip for DialogueBox is missing a necessary dialogue textField!");
			
			_movieClip = movieClip;
			_movieClip.visible = false;
			
			dialogueWriter = new TypeWriter(accessField(KEY_DIALOGUE), typeSpeed);
		}
		
		public function readPrev():void 
		{
			if (convoProgress <= 0)
				return;
			read(convoProgress - 1);		
		}
		
		public function readNext():void 
		{
			// still reading? this will transfer remainder & immediately finish
			if (state == STATE_READING)
			{
				dialogueWriter.finish();
				state = STATE_FINISHED;
				return;
			}
			// reached conversation end, close the box
			if (convoProgress == conversation.length - 1)
			{
				hide();
				return;
			}
			read(convoProgress + 1);
		}
		
		/**
		 * Opens a conversation that this DialogueBox can explore internally. 
		 * @param	conversation a linear array preverified to contain Speaker and Dialogue text.
		 */		
		public function load(conversation:Array):void 
		{
			if (conversation == null || conversation.length == 0)
				throw new Error("Conversation is empty!");			
			this.conversation = conversation;
			read(0);
			show();
		}
		
		public function read(convoProgress:uint):void 
		{
			state = STATE_READING;
			displayedSpeaker = conversation[convoProgress].speaker;
			dialogueWriter.load(conversation[convoProgress].dialogue);
			this.convoProgress = convoProgress;
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
			accessField(KEY_SPEAKER).htmlText = displayedSpeaker;
			dialogueWriter.render();
		}
		
		private function show():void 
		{
			visible = true;
		}
		
		private function hide():void 
		{
			state = STATE_HIDDEN;
			visible = false;
		}
		
		private function accessField(field:String):TextField
		{
			return TextField(movieClip.getChildByName(field));
		}
		
		public function get movieClip():MovieClip { return _movieClip; }
		
	}

}