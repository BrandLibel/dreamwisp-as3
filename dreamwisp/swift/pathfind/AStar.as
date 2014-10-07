package dreamwisp.swift.pathfind
{
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.swift.ds.PriorityQueue;
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
		
		protected var MOVE_COST:Number = 1;
		
		public function AStar() 
		{
			
		}
		
		/**
		 * Scans a tileScape to produce a grid of Nodes based on tiles.
		 * Only rescan when there is a change in the tileScape.
		 * @param	tileScape
		 */
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
					nodeList.put(row, col, makeNode(row, col, t));
				}
			}
		}
		
		/// Creates a node from a provided tile
		protected function makeNode(row:int, col:int, t:Tile):Node 
		{
			if (t.isCompleteSolid())
				return null;
			var node:Node = new Node(row, col, nodeList);
			node.solid[0] = t.isSolidUp();
			node.solid[1] = t.isSolidRight();
			node.solid[2] = t.isSolidDown();
			node.solid[3] = t.isSolidLeft();
			return node;
		}
		
		/**
		 * 
		 * @param	sRow the row coordinate of the start node
		 * @param	sCol the column coordinate of the start node
		 * @param	gRow the row coordinate of the goal node
		 * @param	gCol the column coordinate of the goal node
		 * @return
		 */
		public function findPath(sRow:uint, sCol:uint, gRow:uint, gCol:uint):Vector.<Node> 
		{
			var start:Node = nodeList.access(sRow, sCol);
			var goal:Node = nodeList.access(gRow, gCol);
			
			var frontier:PriorityQueue = new PriorityQueue();
			frontier.enqueue(start, 0);
			var cameFrom:Dictionary = new Dictionary(true);
			var costSoFar:Dictionary = new Dictionary(true);
			costSoFar[start] = 0;
			
			while (!frontier.isEmpty())
			{
				if (frontier.front() == null) continue;
				var current:Node = frontier.dequeue();
				
				if (current == goal) break;
					
				for each (var next:Node in current.neighbors()) 
				{
					var newCost:int = costSoFar[current] + MOVE_COST;
					
					if (costSoFar[next] == null || newCost < costSoFar[next])
					{
						costSoFar[next] = newCost;
						var priority:int = newCost + h(goal, next);
						frontier.enqueue(next, priority);
						cameFrom[next] = current;
					}
				}
			}
			
			// Construct the path, working backwards from goal
			var path:Vector.<Node> = new Vector.<Node>();
			
			var pathHead:Node = goal;
			path.push(pathHead);
			if (cameFrom[pathHead] == null)
				return null;
			
			while (pathHead != start)
			{
				pathHead = cameFrom[pathHead];
				path.unshift(pathHead);
			}
			
			return path;
		}
		
		protected function f(from:Node, to:Node):Number
		{
			return g(from, to) + h(from, to);
		}
		
		/// Actual cost to reach a target node
		protected function g(from:Node, to:Node):Number 
		{
			return 0;
		}
		
		/// Estimated (heuristic) cost to reach the goal node
		protected function h(from:Node, to:Node):Number
		{
			var dx:Number = Math.abs(from.x - to.x);
			var dy:Number = Math.abs(from.y - to.y);
			return MOVE_COST * (dx + dy);
		}
		
	}

}