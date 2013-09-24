package dreamwisp.story.dialogue {
	import dreamwisp.entity.hosts.Entity;
	
	/**
	 * A RichDialogueBox is a feature-rich dialogue box.
	 * It is able to display text using a variety of effects.
	 * It can also use flash Sprites and MovieClips to be placed
	 * inline with the text or in the background..
	 * @author Brandon
	 */
	
	public class RichDialogueBox extends DialogueBox {
		
		public function RichDialogueBox() {
			super();
			
		}
		
		override public function open(conversation:Conversation, owner:String = null, initiator:Entity = null):void {
			super.open(conversation, owner, initiator);
		}
		
	}

}