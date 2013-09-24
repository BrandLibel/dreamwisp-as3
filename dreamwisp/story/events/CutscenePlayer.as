package dreamwisp.story.events {
	
	import dreamwisp.visual.IVideo;
	import dreamwisp.menu.Menu;
	
	/**
	 * ...
	 * @author Brandon
	 */
	public class CutscenePlayer extends Menu {
		
		private var cutscene:Cutscene;
		
		public function CutscenePlayer() {
			
		}
		
		/**
		 * Runs a cutscene.
		 * @param	scene
		 */
		public function load(scene:IVideo):void {
			this.cutscene = scene;
			// display the cutscene loaded
		}
		
		public function showButtons(functions:Array):void {
			for (var i:uint = 0; i < functions.length; i++) {
				functions[i]
			}
		}
		
		/**
		 * Ends the menu and deletes the cutscene from memory
		 */
		override public function exit():void {
			super.exit();
			cutscene = null;
		}
		
	}

}