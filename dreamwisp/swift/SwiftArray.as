package dreamwisp.swift {
	import com.demonsters.debugger.MonsterDebugger;
	
	/**
	 * Creates a pseudo multidimensional array. 
	 * For performance reasons, it only contains a one dimensional array.
	 * Various functions allow it to behave like it has multiple dimensions. 
	 * @author Brandon
	 */
	
	public class SwiftArray {
		
		public var array:Array;
		
		public var rows:uint;
		public var cols:uint;
		
		public function SwiftArray(rows:uint = 8, cols:uint = 8) {
			
			this.rows = rows;
			this.cols = cols;
			array = new Array();
			fill();
			
			/*array = [00, 01, 02, 03, 04, 05, 06, 07,
					 10, 11, 12, 13, 14, 15, 16, 17,
					 20, 21, 22, 23, 24, 25, 26, 27,
					 30, 31, 32, 33, 34, 35, 36, 37,
					 40, 41, 42, 43, 44, 45, 46, 47,
					 50, 51, 52, 53, 54, 55, 56, 57,
					 60, 61, 62, 63, 64, 65, 66, 67,
					 70, 71, 72, 73, 74, 75, 76, 77, 
					 ];*/
		}
		
		public function fill():void {
			if (array.length == 0) {
				for (var i:uint = 0; i < rows*cols; i++) {
					array.push(0);
				}
			}
		}
		
		public function access(row:uint = 0, col:uint = 0):* {
			return ( array[row * rows + col] );
		}
		
		public function removeRow(row:uint = 0):void {
			var i:uint = (row * rows);
			array.splice(i, cols);
			rows--;
		}
		
		public function removeCol(col:uint = 0):void {
			//var i:uint = col;
			for (var i:uint = col; i < cols*rows; i += (rows-1)) {
				MonsterDebugger.trace(this, array.splice(i, 1));
			}
			cols--;
		}
		
		public function resize(rowChange:int = 0, colChange:int = 0):void {
			rows += rowChange;
			cols += colChange;
		}
		
	}

}