package dreamwisp.visual {
	
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.DisplayObject;
	
	/**
	 * GraphicsObject should be an abstract class.
	 * @author Brandon
	 */
	
	public class GraphicsObject /*implements IGraphicsObject*/ {
		
		private var _x:Number;
		private var _y:Number;
		private var _relativeX:String;
		private var _relativeY:String;
		
		protected var width:Number;
		protected var height:Number;
		private var _parentWidth:Number = 768;
		private var _parentHeight:Number = 480;
		
		private var alpha:Number = 1;
		private var scaleX:Number = 1;
		private var scaleY:Number = 1;
		
		private var _layer:uint;
		
		protected var displayObject:DisplayObject;
		
		public function GraphicsObject(displayObject:DisplayObject, x:Object = 0, y:Object = 0 ) {
			this.displayObject = displayObject;
			if (x is String)
				_relativeX = String(x);
			else 
				this.x = Number(x);
			if (y is String)
				_relativeY = String(y);
			else 
				this.y = Number(y);
		}
		
		/* INTERFACE dreamwisp.visual.IGraphicsObject */
		
		public function initialize():void {
			
		}
		
		public function getGraphicsData():DisplayObject {
			return displayObject;
		}
	
		public function get relativeX():String {
			return _relativeX;
		}
		
		public function get relativeY():String {
			return _relativeY;
		}
		
		public function get x():Number { return _x; }
		
		public function set x(value:Number):void { _x = value; }
		
		public function get y():Number { return _y; }
		
		public function set y(value:Number):void { _y = value; }
		
		public function get parentWidth():Number { return _parentWidth; }
		
		public function set parentWidth(value:Number):void { _parentWidth = value; }
		
		public function get parentHeight():Number { return _parentHeight; }
		
		public function set parentHeight(value:Number):void { _parentHeight = value; }
		
		public function get layer():uint { return _layer; }
		
		public function set layer(value:uint):void { _layer = value; }
		
		
		public function update():void {
			
		}
		
		public function render():void {
			
		}
		
	}

}