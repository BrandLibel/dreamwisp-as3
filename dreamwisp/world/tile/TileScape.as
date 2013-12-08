package dreamwisp.world.tile {
	
	import dreamwisp.world.base.Location;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class TileScape {
		
		private var tileRect:Rectangle;
		private var _tileWidth:uint;
		private var _tileHeight:uint;
		
		private var _tileGrid:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>;
		/// Vector of points with x & y pos of tile on grid, only for tiles that require updating. 
		private var tileCoords:Vector.<Point> = new Vector.<Point>;
		
		private var canvasData:BitmapData;
		private var canvas:Bitmap;
		
		private var location:Location;
		
		//private var tileComposer:TileComposer;
		/// JSON object containing all tile blueprints
		private var tileList:Object;
		/// PNG spritesheet of all tiles
		private var tileSheet:BitmapData;
		
		public function TileScape(location:Location, tileList:Object, tileSheet:BitmapData, tileWidth:uint = 32, tileHeight:uint = 32) {
			this.location = location;
			this.tileList = tileList;
			this.tileSheet = tileSheet;
			this.tileWidth = tileWidth;
			this.tileHeight = tileHeight;
			tileRect = new Rectangle(0, 0, tileWidth, tileHeight);
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
					tileGrid[a][b] = compose(tileMap[a][b]);
					var tile:Tile = tileGrid[a][b];
					tile.x = b * tileWidth;
					tile.y = a * tileHeight;
					destPoint.x = tile.x;
					destPoint.y = tile.y
					if (tile.hasAnimation) tileCoords.push(new Point(b, a));
					tile.render(1);
					canvasData.copyPixels(tile.bitmap.bitmapData, tileRect, destPoint);
					//if (tile.body) Level(location).solidBodys.push(tile.body);
				}
			}
			
			
			//MonsterDebugger.trace(this, tileGrid);
		}
		
		/// Visually renders the tile specified at the coordinates.
		public function drawTile(row:uint, col:uint):void {
			const destPoint:Point = new Point(col * tileWidth, row * tileHeight);
			var tile:Tile = tileGrid[row][col];
			tile.render(1);
			canvasData.copyPixels(tile.bitmap.bitmapData, tileRect, destPoint);	
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
			tileGrid[row][col] = compose(newTileNum);
			if (tileGrid[row][col].hasAnimation) tileCoords.push(newPoint);
			drawTile(row, col);
		}
		
		private function compose(tileNum:uint):Tile {
			const blueprint:Object = tileList.tiles[tileNum];
			const presets:Object = tileList.presets;
			return new Tile(blueprint, presets, tileSheet, tileWidth, tileHeight);
		}
		
		public function get tileGrid():Vector.<Vector.<Tile>> { return _tileGrid; }
		
		public function set tileGrid(value:Vector.<Vector.<Tile>>):void { _tileGrid = value; }
		
		public function get tileWidth():uint { return _tileWidth; }
		
		public function set tileWidth(value:uint):void { _tileWidth = value; }
		
		public function get tileHeight():uint { return _tileHeight; }
		
		public function set tileHeight(value:uint):void { _tileHeight = value; }
		
	}

}