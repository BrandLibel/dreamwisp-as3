package dreamwisp.story.dialogue {
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class ChatNode {
		
		private var _speaker:uint;
		private var _text:String;
		private var _target:uint;
		private var _endTarget:uint;
		
		/// String names of the functions to call upon entry
		private var _entryActions:Array;
		/// String names of the functions to call upon exit
		private var _exitActions:Array;
		
		private var _actionName:String;
		private var _useTelepathy:Boolean;
		
		
		public function ChatNode(data:Object) {
			if (data.speaker) {
				if (data.speaker is String) {
					
				} else {
					speaker = data.speaker;
				}
			}
			
			text = data.text;
			
			if (data.entryActions) entryActions = data.entryActions;
			if (data.exitActions) exitActions = data.exitActions;
			
			if (data.actionName) actionName = data.actionName;
			if (data.endTarget) endTarget = data.endTarget;
			
			/*if (data.speaker) {
				speaker = data.speaker;
			} else {
				if (data.speaker == 0) {
					
				}
			}*/
			
			
		}
		
		public function get speaker():uint {
			return _speaker;
		}
		
		public function set speaker(value:uint):void {
			_speaker = value;
		}
		
		public function get text():String {
			return _text;
		}
		
		public function set text(value:String):void {
			_text = value;
		}
		
		public function get target():uint {
			return _target;
		}
		
		public function set target(value:uint):void {
			_target = value;
		}
		
		public function get useTelepathy():Boolean {
			return _useTelepathy;
		}
		
		public function set useTelepathy(value:Boolean):void {
			_useTelepathy = value;
		}
		
		public function get actionName():String {
			return _actionName;
		}
		
		public function set actionName(value:String):void {
			_actionName = value;
		}
		
		public function get endTarget():uint {
			return _endTarget;
		}
		
		public function set endTarget(value:uint):void {
			_endTarget = value;
		}
		
		public function get entryActions():Array {
			return _entryActions;
		}
		
		public function set entryActions(value:Array):void {
			_entryActions = value;
		}
		
		public function get exitActions():Array {
			return _exitActions;
		}
		
		public function set exitActions(value:Array):void {
			_exitActions = value;
		}
		
	}

}