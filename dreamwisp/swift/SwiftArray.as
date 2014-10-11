package dreamwisp.swift
{
	import com.demonsters.debugger.MonsterDebugger;
	
	/**
	 * Creates a pseudo two-dimensional array.
	 * It only contains a one dimensional array with write/access methods to simulate two dimensions.
	 * @author Brandon
	 */
	
	public class SwiftArray
	{
		private var array:Array;
		
		private var rows:uint;
		private var cols:uint;
		
		public function SwiftArray(rows:uint, cols:uint)
		{
			this.rows = rows;
			this.cols = cols;
			array = new Array();
		}
		
		public function access(row:uint, col:uint):*
		{
			var index:uint = (row * cols) + col;
			if (index >= size())
				throw new Error("Row and col index exceeded grid bounds.");
			return array[index];
		}
		
		public function put(row:uint, col:uint, item:*):void
		{
			var index:uint = (row * cols) + col;
			if (index >= size())
				throw new Error("Row and col index exceeded grid bounds.");
			array[index] = item;
		}
		
		public function removeRow(row:uint = 0):void
		{
			var i:uint = (row * rows);
			array.splice(i, cols);
			rows--;
		}
		
		public function removeCol(col:uint = 0):void
		{
			for (var i:uint = col; i < cols * rows; i += (rows - 1))
				MonsterDebugger.trace(this, array.splice(i, 1));
			cols--;
		}
		
		public function resize(rowChange:int = 0, colChange:int = 0):void
		{
			rows += rowChange;
			cols += colChange;
		}
		
		public function numRows():uint
		{
			return rows;
		}
		
		public function numCols():uint
		{
			return cols;
		}
		
		public function size():uint
		{
			return rows * cols;
		}
	
	}

}