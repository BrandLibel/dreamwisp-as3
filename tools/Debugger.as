package tools {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Debugger extends MovieClip {
		
		public function Debugger() {
			//this.visible = false;
			this.x = 368;
			this.buttonMode = true;
			this.cacheAsBitmap = false;
			addEventListener(MouseEvent.ROLL_OVER, mouse);
			addEventListener(MouseEvent.ROLL_OUT, mouse);
			addEventListener(MouseEvent.MOUSE_DOWN, mouse);
			addEventListener(MouseEvent.MOUSE_UP, mouse);
			this.minimize.addEventListener(MouseEvent.CLICK, min);
		}
		
		public function debugEnterFrame(
		a:* = 0, b:* = 0, c:* = 0, d:* = 0, e:* = 0, f:* = 0, g:* = 0, h:* = 0, i:* = 0, j:* = 0):void {
			if (this.currentFrame != 3){
				this.debug1.text  = a.toString();
				this.debug2.text  = b.toString();
				this.debug3.text  = c.toString();
				this.debug4.text  = d.toString();
				this.debug5.text  = e.toString();
				this.debug6.text  = f.toString();
				if (f < 55){
					//trace("FPS drop: " + f);
				}
				this.debug7.text  = g.toString();
				this.debug8.text  = h.toString();
				this.debug9.text  = i.toString();
				this.debug10.text = j.toString();
			}
		}
		
		private function mouse(e:MouseEvent):void {
			if (this.currentFrame != 3){
				if (e.type == MouseEvent.ROLL_OVER){
					this.gotoAndStop(2);
				}
				if (e.type == MouseEvent.ROLL_OUT){
					this.gotoAndStop(1);
				}
			}
			if (e.type == MouseEvent.MOUSE_DOWN){
				this.startDrag();
			}
			if (e.type == MouseEvent.MOUSE_UP){
				this.stopDrag();
			}
		}
		
		private function min(e:MouseEvent):void {
			//trace(name);
			this.gotoAndStop(3);
			this.maximize.addEventListener(MouseEvent.CLICK, max);
		}
		
		private function max(e:MouseEvent):void {
			this.gotoAndStop(1);
			this.minimize.addEventListener(MouseEvent.CLICK, min);
		}
			
	}
}