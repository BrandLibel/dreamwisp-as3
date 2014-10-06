package dreamwisp.swift.pathfind {
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.swift.SwiftArray;
	import dreamwisp.world.tile.Tile;
	import dreamwisp.world.tile.TileScape;
	import flash.utils.Dictionary;
	
	/**
	 * A* Pathfinding implementation.
	 * Suitable for top-down, tile-based, 4-direction movement.
	 * @author Brandon
	 */
	public class AStar 
	{
		private var nodeList:SwiftArray;
		
		private var frontier:Array;
		/// Map with Key Node : Value Node, used recreate path through nodes
		private var cameFrom:Dictionary;
		private var goal:Node;
		private var start:Node;
		
		protected var MOVE_COST:Number = 1;
		
		public function AStar() 
		{
			
		}
		
		/// Scans a tileScape to produce a grid of Nodes based on tiles.
		public function scan(tileScape:TileScape):void 
		{
			var rows:uint = tileScape.gridHeight();
			var cols:uint = tileScape.gridWidth();
			nodeList = new SwiftArray(rows, cols);
			for (var row:int = 0; row < rows; row++) 
			{
				for (var col:int = 0; col < cols; col++)
				{
					var t:Tile = tileScape.tileAt(row, col);
					//MonsterDebugger.trace(this, "aR: " + row + ", " + "aC: " + col);
					var node:Node = new Node(row, col, nodeList);
					node.solid[0] = t.isSolidUp();
					node.solid[1] = t.isSolidRight();
					node.solid[2] = t.isSolidDown();
					node.solid[3] = t.isSolidLeft();
					// don't add a complete solid (obstacle) into the nodeList
					if (!t.isCompleteSolid())
						nodeList.put(row, col, node );
					else
						nodeList.put(row, col, null)
					// remove the edges 
				}
			}
		}
		
		public function ping(row:uint, col:uint):Array 
		{
			var neighbors:Array = nodeList.access(row, col).neighbors();
			//MonsterDebugger.trace(this, neighbors);
			return neighbors;
		}
		
		/**
		 * 
		 * @param	sRow
		 * @param	sCol 
		 * @param	gRow the row coordinate of the goal node
		 * @param	gCol the column coordinate of the goal node
		 * @return
		 */
		public function findPath(sRow:uint, sCol:uint, gRow:uint, gCol:uint):Vector.<Node> 
		{
			start = nodeList.access(sRow, sCol);
			goal = nodeList.access(gRow, gCol);
			
			frontier = new Array();
			cameFrom = new Dictionary();
			frontier.push(start);
			while (frontier.length > 0) 
			{
				var current:Node = frontier.shift();
				if (current == goal)
					break;
					
				for each (var coords:Array in current.neighbors()) 
				{
					var node:Node = nodeList.access(coords[0], coords[1]);
					
					if (!node.visited)
					{
						frontier.push(node);
						node.visited = true;
						cameFrom[node] = current;
					}
				}
			}
			
			// Construct the path, working backwards from goal
			var path:Vector.<Node> = new Vector.<Node>();
			
			var pathHead:Node = goal;
			path.push(pathHead);
			
			while (pathHead != start)
			{
				pathHead = cameFrom[pathHead];
				path.unshift(pathHead);
			}
			
			return path;
		}
		
		protected function f(from:Node, to:Node):Number
		{
			return g(from, to) + h(from);
		}
		
		/// Actual cost to reach a target node
		protected function g(from:Node, to:Node):Number 
		{
			return 0;
		}
		
		/// Estimated (heuristic) cost to reach the goal node
		protected function h(start:Node):Number
		{
			var dx:Number = Math.abs(goal.x - start.x);
			var dy:Number = Math.abs(goal.y - start.y);
			return MOVE_COST * (dx + dy);
		}
		
	}

}