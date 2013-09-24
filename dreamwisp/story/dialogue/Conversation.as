package dreamwisp.story.dialogue {
	import com.demonsters.debugger.MonsterDebugger;
	/**
	 * ...
	 * @author Brandon
	 */
	public class Conversation {
		
		/// The uint representing the current point in conversation.
		private var convoPoint:uint;
		
		/// The current chatNode.
		private var _chatNode:ChatNode;
		private var _chatNodes:Vector.<ChatNode> = new Vector.<ChatNode>;
		
		public var dialogueBox:DialogueBox;
		
		/// The point to go to after the conversation ends
		private var endTarget:uint;
		
		public function Conversation() {
			
		}
		
		public function proceed():void {
			
			// finding the future chat node
			if (chatNode.target) {
				// go to specific target
				convoPoint = chatNode.target;
			} else {
				// no target specified, move forward 1
				convoPoint++;
			}
			
			// performing the exit actions of the present chatNode
			if (chatNode.exitActions) {
				for each (var actionName:String in chatNode.exitActions) {
					this[actionName].call();
				}
			}
			/*if (chatNode.actionName) {
				MonsterDebugger.trace(this, "contained action for ending");
				this[chatNode.actionName].call();
			}*/
			
			if (convoPoint == chatNodes.length) {
				// no more chatNodes, conversation ends
				end();
				return;
			}
			
			chatNode = chatNodes[convoPoint];
		}
		
		private function moveNode(convoPoint:uint):void {
			if (this.convoPoint != convoPoint) {
				this.convoPoint = convoPoint;
			}
			chatNode = chatNodes[convoPoint];
		}
		
		/// Ends the current conversation. 
		internal function end():void {
			MonsterDebugger.trace(this, "ended conversation");
			// the new node to begin on when the conversation is restarted
			// if no endTarget, it defaults to 0
			moveNode( (chatNode.endTarget) ? chatNode.endTarget : 0 );
			dialogueBox.endConversation();
		}
		
		public function get chatNode():ChatNode {
			if (!_chatNode) return chatNodes[convoPoint];
			return _chatNode;
		}
		
		public function set chatNode(value:ChatNode):void {
			_chatNode = value;
		}
		
		public function get chatNodes():Vector.<ChatNode> {
			return _chatNodes;
		}
		
		public function set chatNodes(value:Vector.<ChatNode>):void {
			_chatNodes = value;			
		}
		
	}

}