package dreamwisp.world.tile
{
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.swift.geom.SwiftRectangle;
	import dreamwisp.visual.SpriteSheet;
	import dreamwisp.world.base.Location;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	//public class TileScape
	//{
		//public function TileScape(width:Number, height:Number, spriteSheet:SpriteSheet, tiles:Object) 
		//{
			//
		//}
	//}
	 
	public class TileScape
	{
		private var tileRect:Rectangle;
		private var _tileWidth:uint;
		private var _tileHeight:uint;
		
		private var tileGrid:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>;
		/// The list of tiles which currently need to be updated.
		private var activeTiles:Vector.<Tile> = new Vector.<Tile>;
		
		private var canvasData:BitmapData;
		private var canvas:Bitmap;
		
		/// JSON object containing all tile blueprints
		private var tileList:Object;
		/// PNG spritesheet of all tiles
		private var tileSheet:BitmapData;
		internal var spriteSheet:SpriteSheet;
		protected var tileData:Array;
		protected var tilePresets:Object;
				
		/**
		 *
		 * @param	width The width of the client level in pixels.
		 * @param	height The height of the client level in pixels.
		 * @param	spriteSheet The spritesheet containing tile bitmaps this draws from
		 * @param	tiles The JSON file with all tile information, incl. properties and dimensions.
		 */
		public function TileScape(width:Number, height:Number, spriteSheet:SpriteSheet, tiles:Object)
		{
			readTileData(tiles);
			tileRect = new Rectangle(0, 0, tileWidth, tileHeight);
			
			canvasData = new BitmapData(width, height, true, 0x00000000);
			canvas = new Bitmap(canvasData);
			
			this.spriteSheet = spriteSheet;
		}
		
		private function readTileData(tiles:Object):void
		{
			// reading the file header info
			if (tiles.hasOwnProperty("meta"))
			{
				tileWidth = tiles.meta.width;
				tileHeight = tiles.meta.height;
			}
			else
				throw new Error("The Tiles.json data file is missing the 'meta' section!");
			
			// store the list of tile data
			if (tiles.hasOwnProperty("tiles"))
				tileData = tiles.tiles;
			else
				throw new Error("The Tiles.json data file is missing the 'tiles' section!");
			
			// presets are a set of common properties
			if (tiles.hasOwnProperty("presets"))
				tilePresets = tiles.presets;
		}
		
		public function update():void
		{
			for each (var tile:Tile in activeTiles)
				tile.update();
		}
		
		public function render():void
		{
			//for each (var tile:Tile in activeTiles)
				//drawTile(tile.
		}
		
		/**
		 * Constructs a grid of tiles.
		 * @param	tileMap a 2d-array of uints representing tile types.
		 */
		public function build(tileMap:Array):void
		{
			var destPoint:Point = new Point();
			for (var a:uint = 0; a < tileMap.length; a++)
			{
				tileGrid.push(new <Tile>[]);
				for (var b:uint = 0; b < tileMap[0].length; b++)
				{
					var tileNum:uint = tileMap[a][b];
					if (tileNum == 0)
					{
						tileGrid[a][b] = null;
						continue;
					}
					
					var tile:Tile = compose(tileNum);
					tileGrid[a][b] = tile;
					tile.x = b * tileWidth;
					tile.y = a * tileHeight;
					destPoint.x = tile.x;
					destPoint.y = tile.y
					if (tile.hasAnimation)
					{
						activeTiles.push(tile);
					}
					
					tile.render(1);
					canvasData.copyPixels(tile.bitmapData(), tileRect, destPoint);
				}
			}
		}
		
		public function drawTile(tile:Tile):void 
		{
			tile.drawTile();
			canvasData.copyPixels(tile.bitmapData(), tileRect, tile.point);
		}
		
		/// Visually renders the tile specified at the coordinates.
		private function drawTileAt(row:uint, col:uint):void
		{
			const destPoint:Point = new Point(col * tileWidth, row * tileHeight);
			var tile:Tile = tileGrid[row][col];
			drawTile(tile);
		}
		
		/**
		 * Changes the tileGrid tile specified at the coordinates into a new tile.
		 * @param	row
		 * @param	col
		 * @param	newTileNum
		 */
		public function alterTile(row:uint, col:uint, newTileNum:uint):void
		{
			/*var currentTile:uint = tileGrid[row][col];
			   tileGrid[row][col] = newTile;
			 //TilePlacer.pasteTile(row, col, newTile);*/
			//var newTile:Tile = tileGrid[row][col];
			const newPoint:Point = new Point(col, row);
			const tile:Tile = tileGrid[row][col];
			
			// no dupes in the active tiles list
			if (tile.hasAnimation)
			{
				if (activeTiles.indexOf(tile) == -1)
					activeTiles.push(tile);
			}
			
			tileGrid[row][col] = compose(newTileNum);
			drawTileAt(row, col);
		}
		
		/**
		 * Gets the tile at the specified grid position.
		 * Empty locations (null tiles) should be treated as air. 
		 * @return null if the coordinates are out of bounds
		 */
		public function tileAt(row:uint, col:uint):Tile
		{
			if (row >= tileGrid.length || col >= tileGrid[0].length)
				return Tile.NIL;
			if (tileGrid[row][col] == null)
				return Tile.NIL;
			return tileGrid[row][col];
		}
		
		public function getTilesWithID(id:uint):Vector.<Tile>
		{
			var tiles:Vector.<Tile> = new Vector.<Tile>();
			for (var i:int = 0; i < tileGrid.length; i++) 
			{
				for (var j:int = 0; j < tileGrid[0].length; j++) 
				{
					var tile:Tile = tileAt(i, j);
					if (tile.getID() == id)
						tiles.push(tile);
				}
			}
			return tiles;
		}
		
		public function isEmpty(row:uint, col:uint):Boolean
		{
			return (tileAt(row, col) == Tile.NIL);
		}
		
		public function purge():void 
		{
			for (var i:int = 0; i < tileGrid.length; i++) 
			{
				for (var j:int = 0; j < tileGrid[0].length; j++) 
				{
					if (!isEmpty(i, j))
						tileAt(i, j).destroy();
				}
			}
			canvasData.dispose();
		}
		
		/**
		 * The number of horizontal spaces on the grid
		 */
		public function gridWidth():uint
		{
			return tileGrid[0].length;
		}
		
		/**
		 * The number of vertical spaces on the grid
		 */
		public function gridHeight():uint
		{
			return tileGrid.length;
		}
		
		protected function compose(tileNum:uint):Tile
		{
			const blueprint:Object = tileData[tileNum]; //tileList.tiles[tileNum];
			//const presets:Object = tilePresets;
			//MonsterDebugger.trace(this, tileNum);
			return new Tile(blueprint, tilePresets, this);
		}
		
		public function get tileWidth():uint { return _tileWidth; }
		
		public function set tileWidth(value:uint):void { _tileWidth = value; }
		
		public function get tileHeight():uint { return _tileHeight; }
		
		public function set tileHeight(value:uint):void { _tileHeight = value; }
		
		public function getCanvas():Bitmap { return canvas; }
		
		public function bounds():SwiftRectangle 
		{
			return new SwiftRectangle(0, 0, gridWidth() * tileWidth, gridHeight() * tileHeight);
		}
	}

}