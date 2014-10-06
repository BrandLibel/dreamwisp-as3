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
		public var visited:Boolean = false;
		private var nodeList:SwiftArray;
		
		/// Default: North, East, South, West. Remove these if the neighbor's side is solid
		/// this.solidUp ?-> remeove North; south.solidUp ?-> remove South
		protected var directions:Array = [[0, -1], [1, 0], [0, 1], [ -1, 0]];
		/// Up, Right, Down, Left
		internal var solid:Array = [false, false, false, false]
		
		public function Node(row:uint, col:uint, nodeList:SwiftArray) 
		{
			x = row;
			y = col;
			this.nodeList = nodeList;
		}
		
		/// Array of graph coordinates (x, y) for adjacent nodes
		public function neighbors():Array
		{
			var result:Array = [];
			for (var i:uint = 0; i < directions.length; i++)
			{
				var dir:Array = directions[i];
				var row:int = x + dir[1];
				var col:int = y + dir[0];
					
				// neighbors must be in bounds
				if (0 <= row && row < nodeList.numRows() && 0 <= col && col < nodeList.numCols())
				{
					// check if neighbor is a solid in the opposite direction (+2)%4 [X->][<-?]
					// if so, it is not a neighbor
					var oppositeDir:uint = (i + directions.length / 2) % directions.length;
					var node:Node = nodeList.access(row, col);
					if (node == null || node.solid[oppositeDir])
						continue;
					result.push([row, col]);
				}
			}
			
			return result;
		}
		
	}

}