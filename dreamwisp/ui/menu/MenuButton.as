package dreamwisp.ui.menu {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.components.Animation;
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.components.View;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.input.InputState;
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	import tools.Belt;
	
	public class MenuButton extends Entity {
				
		public var isEnabled:Boolean = true;
		
		public var dataProperty:String;
						
		public final function MenuButton(btnCode:String) {
			this.name = btnCode;
			init();
		}
		
		private function init():void {
			view = new View(this);
			view.movieClip = Belt.addClassFromLibrary(name, Belt.CLASS_MOVIECLIP);
			// buttonMode on MovieClips add overhead; it must handle events and frame seeking
			// buttonMode causes framerate to drop when rapidly clicking a button, it is unneeded
			// see: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/Sprite.html#buttonMode
			//view.movieClip.buttonMode = true;
			//view.movieClip.useHandCursor = false;
			
			var bounds:Rectangle = view.movieClip.getBounds(view.movieClip);
			
			body = new Body(this, view.movieClip.width + bounds.left, view.movieClip.height + bounds.top);
			//MonsterDebugger.trace(this, body.width + ", " + body.height);
			
			if (view.movieClip.totalFrames > 1){
				animation = new Animation(this);
				animation.mapFrameLabels(view.movieClip);
			}
		}
		
		private function testPress(btnCode:String):void {
			MonsterDebugger.trace(this, btnCode, "", "GAME_TEST", 0xF70DD3);
		}
		
		override public function update():void {
			super.update();
		}
		
		/**
		 * Checks whether this button's enable dependency has been made positive.
		 * If positive, immediately enables this button.
		 */
		public final function check():void {
			MonsterDebugger.trace(this, dataProperty);
			if (/*Data[dataProperty] != null || */Data[dataProperty] == true) {
				MonsterDebugger.trace(this, "button has been enabled");
				enable();
			}
		}
		
		public final function enable():void {
			isEnabled = true;
			view.alpha = 1;
		}
		
		public final function disable():void {
			isEnabled = false;
			view.alpha = 0.5;
		}
		
		public final function enableUpon(dataProperty:String):void {
			this.dataProperty = dataProperty;
		}
		
		public final function highlight():void {
			//var frameLabel:FrameLabel;
			animation.frame.animateTo(animation.findFrame("over", view.movieClip));
		}
		
		public final function deselect():void {
			//_buttonMC.gotoAndStop("up");
			animation.frame.animateTo(animation.findFrame("up", view.movieClip));
		}
				
	}
}