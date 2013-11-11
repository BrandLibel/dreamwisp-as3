package dreamwisp.story.dialogue {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.components.View;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.input.KeyMap;
	import flash.ui.Keyboard;
	import org.osflash.signals.Signal;
	import tools.Belt;
	import flash.utils.*;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class DialogueBox extends Entity {
		
		/// The current conversation being handled by the DialogueBox.
		private var conversation:Conversation;
		/// The uint representing the current point in the conversation.
		private var convoPoint:uint = 0;
		/// The entity which contains the conversation object.
		private var owner:String;
		/// The entity which began the conversation.
		private var initiator:Entity;
		
		private var keyMap:KeyMap;
		
		private var isOpen:Boolean = false;
		
		/// The current chat point in the conversation.
		private var chatObj:Object;
		private var entityList:Object;
		
		public var openedDialogue:Signal;
		public var closedDialogue:Signal;
		
		/**
		 * 
		 * @param	entityList Needs a ref to the entity list so it can lookup names.
		 */
		public function DialogueBox(entityList:Object) {
			this.entityList = entityList;
			
			view = new View(this);
			view.movieClip = Belt.addClassFromLibrary("DialogueGraphic", Belt.CLASS_MOVIECLIP);
			view.movieClip.visible = false;
			
			body = new Body(this, view.movieClip.width, view.movieClip.height);
						
			keyMap = new KeyMap();
			keyMap.bind(Keyboard.UP, proceed);
						
			openedDialogue = new Signal();
			closedDialogue = new Signal();
		}
		
		/**
		 * 
		 * @param	conversation
		 * @param	owner The name of the Entity that owns current conversation.
		 */
		public function open(conversation:Conversation, owner:String = null, initiator:Entity = null):void {
			if (isOpen) return;
			MonsterDebugger.trace(this, "DIALOGUE IS OPENING");
			this.conversation = conversation;
			this.conversation.dialogueBox = this;
			this.owner = owner;
			this.initiator = initiator;
			enabledInput.dispatch(this);
			openedDialogue.dispatch();
			view.movieClip.visible = true;
			isOpen = true;
			display();
		}
		
		private function proceed():void {
			MonsterDebugger.trace(this, "DIALOGUE IS PROCEEDING");
			conversation.proceed();
			if (!conversation.chatNode) {
				endConversation();
				return;
			}
			display();
			/*if (!isOpen) return;
			MonsterDebugger.trace(this, "proceeding dialogue");
			// continue to the next point in conversation
			convoPoint++;
			chatObj = conversation[convoPoint];
			if (!conversation[convoPoint]) {
				endConversation();
				return;
			}
			
			if (chatObj.speaker == 0) {
				DialogueGraphic(view.movieClip).nameBox.text = initiator;
			} else {
				DialogueGraphic(view.movieClip).nameBox.text = (chatObj.speaker) ? Data.entityList.entitys[chatObj.speaker].name : owner;
			}
			
			DialogueGraphic(view.movieClip).textBox.text = chatObj.text;
			
			// check for actions to execute
			if (chatObj.action) this[chatObj.action].call();*/
			
			
		}
		
		private function display():void {
			//DialogueGraphic(view.movieClip).nameBox.text = initiator;
			//DialogueGraphic(view.movieClip).textBox.text = chatObj.text;
			//if (conversation.chatNode.speaker )
			
			var name:String = entityList.entitys[conversation.chatNode.speaker].name;
			var text:String;
			
			var DialogueGraphicClass:Class = getDefinitionByName("DialogueGraphic") as Class;
			DialogueGraphicClass(view.movieClip).nameBox.text = name;
			DialogueGraphicClass(view.movieClip).textBox.text = conversation.chatNode.text;
			MonsterDebugger.trace(this, "dialoguebox visible");
		}
		
		internal function endConversation():void {
			MonsterDebugger.trace(this, "dialogue box ending");
			var DialogueGraphicClass:Class = getDefinitionByName("DialogueGraphic") as Class;
			DialogueGraphicClass(view.movieClip).textBox.appendText( "THIS IS AN ACTION" );
			view.movieClip.visible = false;
			convoPoint = 0;
			disabledInput.dispatch(this);
			closedDialogue.dispatch();
			isOpen = false;
			initiator.mobilize();
		}
		
		override public function hearKeyInput(type:String, keyCode:uint):void {
			//MonsterDebugger.trace(this, "receiving input");
			keyMap.receiveKeyInput(type, keyCode);
		}
		
	}

}