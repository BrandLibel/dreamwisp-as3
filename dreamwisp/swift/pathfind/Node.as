package dreamwisp.swift.pathfind 
{
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.swift.SwiftArray;
	
	/**
	 * Basic 4-direction node in A* algorithm 
	 * @author Brandon
	 */
	public class Node 
	{
		public var x:int;
		public var y:int;
		
		public var priority:int = 0;
		public var h:Number;
		
		protected var nodeList:SwiftArray;
		protected var specialNeighbors:Array;
		
		public static const NORTH:Array = [0, -1];
		public static const EAST:Array = [1, 0];
		public static const SOUTH:Array = [0, 1];
		public static const WEST:Array = [ -1, 0];
		public static const NORTH_EAST:Array = [1, -1];
		public static const SOUTH_EAST:Array = [1, 1];
		public static const SOUTH_WEST:Array = [-1, 1];
		public static const NORTH_WEST:Array = [ -1, -1];
		/// Default: North, East, South, West. Remove these if the neighbor's side is solid
		/// this.solidUp ?-> remeove North; south.solidUp ?-> remove South
		protected var directions:Array = [NORTH, EAST, SOUTH, WEST];
		/// Up, Right, Down, Left
		internal var solid:Array = [false, false, false, false]
		
		public function Node(row:uint, col:uint, nodeList:SwiftArray) 
		{
			y = row;
			x = col;
			this.nodeList = nodeList;
			specialNeighbors = [];
		}
		
		public function addNeighbor(node:Node):void 
		{
			specialNeighbors.push(node);
		}
		
		/// Array of adjacent nodes
		public function neighbors():Array
		{
			var result:Array = [];
			for (var i:uint = 0; i < directions.length; i++)
			{
				var dir:Array = directions[i];
				var row:int = y + dir[1];
				var col:int = x + dir[0];
					
				// neighbors must be in bounds
				if (0 <= row && row < nodeList.numRows() && 0 <= col && col < nodeList.numCols())
				{
					// check if neighbor is a solid in the opposite direction (+2)%4 [X->][<-?]
					// if so, it is not a neighbor
					var oppositeDir:uint = (i + directions.length / 2) % directions.length;
					var node:Node = nodeList.access(row, col);
					if (node == null || node.solid[oppositeDir])
						continue;
					result.push(node);
				}
			}
			result = result.concat(specialNeighbors);
			
			return result;
		}
		
	}

}