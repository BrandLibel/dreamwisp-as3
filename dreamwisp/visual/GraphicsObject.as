package dreamwisp.visual {
	
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.DisplayObject;
	
	/**
	 * GraphicsObject should be an abstract class.
	 * @author Brandon
	 */
	
	public class GraphicsObject implements IGraphicsObject {
		
		private var _x:Number;
		private var _y:Number;
		private var _relativeX:String;
		private var _relativeY:String;
		
		protected var width:Number;
		protected var height:Number;
		protected var parentWidth:Number;
		protected var parentHeight:Number;
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
		
		public function initialize(parentWidth:Number = 768, parentHeight:Number = 480):void {
			MonsterDebugger.trace(this, parentWidth + ", " + parentHeight +"||" + displayObject.width + ", " + displayObject.height );
			this.parentWidth = parentWidth;
			this.parentHeight = parentHeight;
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
		
		public function get x():Number {
			return _x;
		}
		
		public function set x(value:Number):void {
			_x = value;
		}
		
		public function get y():Number {
			return _y;
		}
		
		public function set y(value:Number):void {
			_y = value;
		}
		
		public function update():void {
			
		}
		
		public function render():void {
			
		}
		
	}

}