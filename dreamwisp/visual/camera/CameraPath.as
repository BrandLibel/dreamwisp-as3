package dreamwisp.visual.camera {
	
	import com.demonsters.debugger.MonsterDebugger;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	internal class CameraPath {
		
		public var path:Vector.<CameraPathNode> = new Vector.<CameraPathNode>;
		
		public const NODE_INSTANT:String = "instant";
		public const NODE_MOVE:String = "move";
		public const NODE_LOITER:String = "loiter";
		
		public function CameraPath(nodes:Array) {
			// node is an array with primitive node objects
			for each (var node:Object in nodes) {
				// replacing ref name with the value
				if (this.hasOwnProperty(node.type)) {
					MonsterDebugger.trace(this, "PATH HAS A TYPE CALLED: " + node.type);
					node.type = this[node.type];
				}
				path.push( new CameraPathNode(node));
			}			
		}
		
		internal function hasNextNode():Boolean {
			return (path.length > 1);
		}
		
		internal function nextNode():void {
			MonsterDebugger.trace(this, "moved to next node", "", "", 0x00FF00);
			
			// removes first element in the path
			path.shift();
			MonsterDebugger.trace(this, node, "", "", 0x00FF00);
		}
		
		internal function get pathStart():CameraPathNode {
			return path[0];
		}
		
		internal function get node():CameraPathNode {
			// current node is always the first node due to path.shift()
			return path[0];
		}
		
		internal function get x():* { return node.x; }
		
		internal function set x(value:*):void { node.x = value; }
		
		internal function get y():* { return node.y; }
		
		internal function set y(value:*):void { node.y = value; }
		
		internal function get xSpeed():Number { return node.xSpeed; }
		
		internal function set xSpeed(value:Number):void { node.xSpeed = value; }
		
		internal function get ySpeed():Number { return node.ySpeed; }
		
		internal function set ySpeed(value:Number):void { node.ySpeed = value; }
		
		internal function get type():String { return node.type }
		
		internal function set type(value:String):void { node.type = value; }
		
		internal function get ticks():uint { return node.ticks }
		
		internal function set ticks(value:uint):void { node.ticks = value; }
		
	}
}