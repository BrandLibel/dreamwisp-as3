package dreamwisp.story.events {
	
	import dreamwisp.visual.IVideo;
	import tools.Belt;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Brandon
	 */
	public class Cutscene implements IVideo {
		
		private var currentFrame:uint;
		private var playSpeed:int = 0;
		private var movieClip:MovieClip;
		private var myPlayer:CutscenePlayer;
		
		private const FAST_SPEED:uint = 10;
		
		public function Cutscene(mcName:String) {
			// finds data from Cutscenes.json file
			mcName = Data.getText(mcName);
			this.movieClip = Belt.addClassFromLibrary(mcName, MovieClip);
			var data:Object = Data.cutscenes;
			var i:uint = 0;
			for (i; i < data.cutscenes.length; i++) {
				if (Data.getText(data.cutscenes[i].name) == mcName) {
					data = data.cutscenes[i];
					break;
				}
			}
			configurePlayer(data);
		}
		
		public function play():void {
			playSpeed = 1;
		}
		
		public function pause():void {
			playSpeed = 0;
		}
		
		public function fastForward():void {
			playSpeed = FAST_SPEED;
		}
		
		public function rewind():void {
			playSpeed = -FAST_SPEED;
		}
		
		public function skip():void {
			// finishes the cutscene and transition to whatever comes next
			finish();
		}
		
		private function finish():void {
			
		}
		
		/**
		 * Based on this cutscene's available functionality, displays buttons on the player.
		 * @param	data
		 */
		private function configurePlayer(data:Object):void {
			myPlayer.showButtons(data.functions);
		}
		
		public function update():void {
			currentFrame += playSpeed;
			if (currentFrame <= 0) currentFrame = 1;
			if (currentFrame > movieClip.totalFrames) currentFrame = movieClip.totalFrames;
			movieClip.gotoAndStop(currentFrame);
		}
		
		
		
	}

}