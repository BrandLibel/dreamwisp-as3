package dreamwisp.visual.camera {
	//import com.demonsters.debugger.MonsterDebugger;
	/**
	 * ...
	 * @author Brandon
	 */
	internal class CameraPathNode {
		
		internal var type:String;
		
		internal var x:*;
		internal var y:*;
		internal var nextNode:CameraPathNode;
		
		internal var xSpeed:uint;
		internal var ySpeed:uint;
		
		/// ticks remaining in the loiter mode
		internal var ticks:uint;
		
		public function CameraPathNode(node:Object) {
			//if (nextNode) MonsterDebugger.trace(this, "has next node");
			// this gets all the properties from the data
			for (var prop:String in node) {
				this[prop] = node[prop];
			}
			
			/*if (path) {
				// get properties from first node obj in the path and splice it
				var firstNode:Object = path.shift();
				this.xSpeed = firstNode.xSpeed;
				this.ySpeed = firstNode.ySpeed;
				this.x = firstNode.x;
				this.y = firstNode.y;
				
				// this is the head node, create the path that follows
				var targetNode:CameraPathNode = this;
				while (path.length != 0) {
					var nodeData:Object = path.shift();
					targetNode = new CameraPathNode(nodeData.xSpeed, nodeData.ySpeed, nodeData.x, nodeData.y);
					targetNode = targetNode.nextNode;
				}
			}*/
		}
		
		internal function update(pathState:PathState):void {
			
		}
		
	}

}