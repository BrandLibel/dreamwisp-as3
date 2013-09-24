package dreamwisp.world.tile {
	
	import dreamwisp.world.base.Location;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import project.world.Level;
	/**
	 * ...
	 * @author Brandon
	 */
	public class TileScape {
		
		private const TILE_RECT:Rectangle = new Rectangle(0, 0, Data.TILE_SIZE, Data.TILE_SIZE);
		
		private var _tileGrid:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>;
		/// Vector of points with x & y pos of tile on grid, only for tiles that require updating. 
		private var tileCoords:Vector.<Point> = new Vector.<Point>;
		
		private var canvasData:BitmapData;
		private var canvas:Bitmap;
		
		private var location:Location;
		
		public function TileScape(location:Location) {
			this.location = location;
			init();
		}
		
		private function init():void {
			canvasData = new BitmapData(location.rect.width, location.rect.height, true, 0x00000000);
			canvas = new Bitmap(canvasData);
			location.view.addDisplayObject(canvas, 1);
			//location.view.addGraphic(canvasData, 0, 0, 1);
		}
		
		public function update():void {
			for each (var point:Point in tileCoords) tileGrid[point.y][point.x].update();
		}
		
		public function render():void {
			for each (var point:Point in tileCoords) drawTile(point.y, point.x);
		}
		
		/**
		 * Constructs the entire level by blitting all tiles. 
		 * The tiles are separated into the correct layer in the LevelView.
		 */
		public final function build(tileMap:Array):void {
			var destPoint:Point = new Point();
			for (var a:uint = 0; a < tileMap.length; a++) {
				tileGrid.push(new <Tile>[]);
				for (var b:uint = 0; b < tileMap[0].length; b++) {
					tileGrid[a][b] = TileComposer.compose(tileMap[a][b]);
					var tile:Tile = tileGrid[a][b];
					tile.x = b * Data.TILE_SIZE;
					tile.y = a * Data.TILE_SIZE;
					destPoint.x = tile.x;
					destPoint.y = tile.y
					if (tile.hasAnimation) tileCoords.push(new Point(b, a));
					tile.render();
					canvasData.copyPixels(tile.bitmap.bitmapData, TILE_RECT, destPoint);
					if (tile.body) Level(location).solidBodys.push(tile.body);
				}
			}
			
			
			//MonsterDebugger.trace(this, tileGrid);
		}
		
		/// Visually renders the tile specified at the coordinates.
		public function drawTile(row:uint, col:uint):void {
			const destPoint:Point = new Point(col * Data.TILE_SIZE, row * Data.TILE_SIZE);
			var tile:Tile = tileGrid[row][col];
			tile.render();
			canvasData.copyPixels(tile.bitmap.bitmapData, TILE_RECT, destPoint);	
		}
		
		/**
		 * Changes the tileGrid tile specified at the coordinates into a new tile. 
		 * @param	row
		 * @param	col
		 * @param	newTileNum
		 */
		public function alterTile(row:uint, col:uint, newTileNum:uint):void {
			/*var currentTile:uint = tileGrid[row][col];
			tileGrid[row][col] = newTile;
			//TilePlacer.pasteTile(row, col, newTile);*/
			//var newTile:Tile = tileGrid[row][col];
			const newPoint:Point = new Point(col, row);
			// setup - removing update list
			for (var i:int = 0; i < tileCoords.length; i++) {
				if (tileCoords[i].equals(newPoint)) {
					tileCoords.splice(i, 1);
					break;
				}
			}
			tileGrid[row][col] = TileComposer.compose(newTileNum);
			if (tileGrid[row][col].hasAnimation) tileCoords.push(newPoint);
			drawTile(row, col);
		}
		
		public function get tileGrid():Vector.<Vector.<Tile>> { return _tileGrid; }
		
		public function set tileGrid(value:Vector.<Vector.<Tile>>):void { _tileGrid = value; }		
		
	}

}