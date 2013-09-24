package dreamwisp.entity.components {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.story.dialogue.ChatNode;
	import dreamwisp.story.dialogue.Conversation;
	import tools.Belt;
	/**
	 * ...
	 * @author Brandon
	 */
	public class Actor {
		
		private var host:Entity;
		
		private var _conversation:Conversation;
		
		public function Actor(entity:Entity) {
			host = entity;
		}
		
		public final function read(script:Object):void {
			
		}
		
		
		
		// Conversation Handling
		
		/// The array containing chat objects.
		public function get conversation():Conversation {
			return _conversation;
		}
		
		public function set conversation(value:Conversation):void {
			_conversation = value;
		}
		
		public function setConversation(data:Object):void {
			if (!conversation) conversation = new Conversation();
			
			// convert simple object chatNodes to proper type ChatNodes
			// ChatNodes are initialized with the simple object chatNode,
			// which contains the 
			for each (var chatNode:Object in data.chatNodes) {
				conversation.chatNodes.push( new ChatNode(chatNode) );
			}
			
			MonsterDebugger.trace(this, conversation.chatNodes);
			
			//Belt.copyVariables( data.chatNodes, conversation.chatNodes);
			
		}
		
		
		
	}

}