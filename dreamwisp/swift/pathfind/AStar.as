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
		protected var nodeList:SwiftArray;
		protected var tileScape:TileScape;
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
			this.tileScape = tileScape;
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
		 * Finds the lowest cost path from a start node to a goal node.
		 * Returns the nearest if the goal is unreachable, and null if goal is an invalid node.
		 * @param	sRow the row coordinate of the start node
		 * @param	sCol the column coordinate of the start node
		 * @param	gRow the row coordinate of the goal node
		 * @param	gCol the column coordinate of the goal node
		 */
		public function findPath(sRow:uint, sCol:uint, gRow:uint, gCol:uint):Vector.<Node> 
		{
			var start:Node = nodeList.access(sRow, sCol);
			var goal:Node = nodeList.access(gRow, gCol);
			if (start == null || goal == null)
				return null;
			start.h = h(start, goal);
				
			var frontier:PriorityQueue = new PriorityQueue();
			frontier.enqueue(start, 0);
			var cameFrom:Dictionary = new Dictionary(true);
			var costSoFar:Dictionary = new Dictionary(true);
			costSoFar[start] = 0;
			var nearest:Node = start;
			
			while (!frontier.isEmpty())
			{
				if (frontier.front() == null) continue;
				var current:Node = frontier.dequeue();
				
				if (current == goal) break;
					
				for each (var next:Node in current.neighbors()) 
				{
					var newCost:int = costSoFar[current] + cost(current, next);
					next.h = h(goal, next);
					if (next.h < nearest.h && next != goal) // nearest is the lowest cost non-goal node
						nearest = next;
					if (costSoFar[next] == null || newCost < costSoFar[next])
					{
						costSoFar[next] = newCost;
						var priority:int = newCost + next.h;
						
						frontier.enqueue(next, priority);
						cameFrom[next] = current;
					}
				}
			}
			
			// Construct the path, working backwards from goal
			var path:Vector.<Node> = new Vector.<Node>();
			
			var pathHead:Node = goal;
			// goal is unreachable - settle for nearest to goal
			if (isUnreachable(cameFrom, goal))
				pathHead = nearest;
				
			path.push(pathHead);
			
			while (pathHead != start)
			{
				pathHead = cameFrom[pathHead];
				path.unshift(pathHead);
			}
			return path;
		}
		
		public function findPathFrom(node:Node, gRow:uint, gCol:uint):Vector.<Node> 
		{
			return findPath(node.y, node.x, gRow, gCol);
		}
		
		public function getNode(row:uint, col:uint):Node
		{
			return nodeList.access(row, col);
		}
		
		/// Determines whether it's impossible to form a path to the goal
		protected function isUnreachable(path:Dictionary, goal:Node):Boolean
		{
			return path[goal] == null;
		}
		
		/// Actual cost to travel between two adjacent nodes
		protected function cost(from:Node, to:Node):Number 
		{
			return MOVE_COST;
		}
		
		/// Estimated (heuristic) cost to reach the goal node
		protected function h(from:Node, to:Node):Number
		{
			var dx:Number = Math.abs(from.y - to.y);
			var dy:Number = Math.abs(from.x - to.x);
			return MOVE_COST * (dx + dy);
		}
		
	}

}