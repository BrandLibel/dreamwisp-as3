package dreamwisp.ui.hud {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import tools.Belt;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class HeadUpDisplay extends Sprite {
		
		private var modules:Vector.<IHUDModule> = new Vector.<IHUDModule>;
		private var moduleNames:Array = new Array();
		
		private var dictionary:Dictionary;
		
		public var movieClip:MovieClip;
		
		public function HeadUpDisplay() {
			movieClip = Belt.addClassFromLibrary("Screen", Belt.CLASS_MOVIECLIP);
			//movieClip["health"].text = "10";
			//sendTo("health", "10");
		}
		
		public function initialize():void {
			
		}
		
		public function addModule(name:String):void {
			moduleNames.push(name);
		}
		
		public function sendTo(name:String, data:*):void {
			movieClip[name].text = data;
		}
		
	}

}