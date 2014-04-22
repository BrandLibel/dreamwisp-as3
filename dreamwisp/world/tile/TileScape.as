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
		
		private var myBounds:SwiftRectangle;
				
		/**
		 *
		 * @param	width the width of the entire scape in pixels.
		 * @param	height the height of the entire scape in pixels.
		 * @param	spriteSheet contains tile bitmaps & rect data this draws from
		 * @param	tiles info list in JSON, incl. properties and dimensions.
		 * @param	tileMap a 2d array with layout of initial level to build; goes empty if null
		 */
		public function TileScape(width:Number, height:Number, spriteSheet:SpriteSheet, tiles:Object, tileMap:Array = null)
		{
			readTileData(tiles);
			tileRect = new Rectangle(0, 0, tileWidth, tileHeight);
			
			canvasData = new BitmapData(width, height, true, 0x00000000);
			canvas = new Bitmap(canvasData);
			this.spriteSheet = spriteSheet;
			
			myBounds = new SwiftRectangle(0, 0, width, height);
			
			var rows:uint = 0;
			var cols:uint = 0;
			if (tileMap != null)
			{
				rows = tileMap.length;
				cols = tileMap[0].length;
			}
			else 
			{
				// default to an empty NIL layout 
				rows = height / tileHeight;
				cols = width / tileWidth;
			}
			build(rows, cols, tileMap);
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
		private function build(rows:uint, cols:uint, tileMap:Array):void
		{
			var destPoint:Point = new Point();
			for (var a:uint = 0; a < rows; a++)
			{
				tileGrid.push(new <Tile>[]);
				for (var b:uint = 0; b < cols; b++)
				{
					var tileNum:uint = (tileMap == null) ? 0 : tileMap[a][b];
					
					var tile:Tile = compose(tileNum);
					insertTile(a, b, tile);
				}
			}
		}
		
		public function drawTile(tile:Tile):void 
		{
			tile.drawTile();
			canvasData.copyPixels(tile.bitmapData(), tileRect, tile.point);
		}
		
		public function insertTile(row:uint, col:uint, tile:Tile):void 
		{
			var destPoint:Point = new Point();
			tileGrid[row][col] = tile;
			tile.x = col * tileWidth;
			tile.y = row * tileHeight;
			destPoint.x = tile.x;
			destPoint.y = tile.y;
			if (tile.hasAnimation)
			{
				activeTiles.push(tile);
			}
			tile.render(1);
			canvasData.copyPixels(tile.bitmapData(), tileRect, destPoint);
			if (tile.isEmpty())
				canvasData.fillRect(new Rectangle(tile.x, tile.y, tileWidth, tileHeight), 0x00000000);
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
			insertTile(row, col, compose(newTileNum));
		}
		
		/**
		 * Adds a new row to the bottom edge of the TileScape
		 * @param	tileNum the type of tile to add, defaults to 0
		 */
		public function addRow(tileNum:uint = 0):void 
		{
			updateBitmapSize(0, tileHeight);
			tileGrid[tileGrid.length] = new Vector.<Tile>();
			for (var i:uint = 0; i < tileGrid[0].length; i++){
				tileGrid[tileGrid.length -1].push( Tile.NIL );
			}
		}
		
		/**
		 * Adds a new column to the right edge of the TileScape
		 * @param	tileNum the type of tile to add, defaults to 0
		 */
		public function addCol(tileNum:uint = 0):void 
		{
			updateBitmapSize(tileWidth, 0);
			for (var i:uint = 0; i < tileGrid.length; i++){
				tileGrid[i].push( Tile.NIL );
			}
		}
		
		/**
		 * Removes the bottom-most row.
		 * This should not be used because it doesn't visually remove.
		 * @return the Tiles removed
		 */
		public function removeRow():Vector.<Tile>
		{
			updateBitmapSize(0, -tileHeight);
			return tileGrid.pop();
		}
		
		/**
		 * Removes the right-most column
		 * This should not be used because it doesn't visually remove.
		 * @return the Tiles removed
		 */
		public function removeCol():Vector.<Tile>
		{
			updateBitmapSize(-tileWidth, 0);
			var tilesRemoved:Vector.<Tile> = new Vector.<Tile>();
			for (var i:int = 0; i < tileGrid.length; i++)
			{
				var removedTile:Tile = tileGrid[i][ tileGrid[i].length -1 ];
				if (!removedTile.isEmpty())
					insertTile(removedTile.row(), removedTile.col(), Tile.NIL);
				tileGrid[i].pop();
				tilesRemoved.push( removedTile );
			}
			return tilesRemoved;
		}
		
		/**
		 * Adjusts the size of my drawable bitmap area,
		 * usually in response to a change in tileGrid dimensions.
		 */
		private function updateBitmapSize(deltaX:int, deltaY:int):void 
		{
			var prevBitmapData:BitmapData = canvasData;
			var prevRect:Rectangle = new Rectangle(myBounds.x, myBounds.y, myBounds.width, myBounds.height);
			
			canvasData = new BitmapData(canvasData.width + deltaX, canvasData.height + deltaY);
			myBounds.width += deltaX;
			myBounds.height += deltaY;
		
			canvasData.fillRect(new Rectangle(prevRect.x, prevRect.y, prevRect.width + deltaX, prevRect.height + deltaY), 0x00000000);
			canvasData.copyPixels(prevBitmapData, prevRect, new Point(0, 0));
			canvas.bitmapData = canvasData;
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
		
		public function swapTiles(id1:uint, id2:uint):void 
		{
			for (var i:int = 0; i < tileGrid.length; i++) 
			{
				for (var j:int = 0; j < tileGrid[0].length; j++) 
				{
					var tile:Tile = tileGrid[i][j];
					if (tile.getID() == id1)
						alterTile(i, j, id2)
					else if (tile.getID() == id2)
						alterTile(i, j, id1);
				}
			}
		}
		
		/**
		 * Turns all tiles into NIL
		 */
		public function empty():void 
		{
			for (var i:int = 0; i < tileGrid.length; i++) 
			{
				for (var j:int = 0; j < tileGrid[0].length; j++) 
				{
					alterTile(i, j, 0);
				}
			}
		}
		
		public function isEmpty(row:uint, col:uint):Boolean
		{
			return (tileAt(row, col).isEmpty());
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
		
		public function width():uint
		{
			return gridWidth() * tileWidth;
		}
		
		public function height():uint
		{
			return gridHeight() * tileHeight;
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
			if (tileNum == 0)
				return Tile.NIL;
			const blueprint:Object = tileData[tileNum];
			return new Tile(blueprint, tilePresets, this);
		}
		
		/**
		 * Returns a 2d array containing the IDs of the tileGrid.
		 */
		public function makeTileMap():Array
		{
			var tileMap:Array = [];
			for (var row:int = 0; row < tileGrid.length; row++) 
			{
				tileMap.push(new Array());
				for (var col:int = 0; col < tileGrid[0].length; col++) 
				{
					tileMap[row][col] = tileAt(row, col).getID();
				}
			}
			return tileMap;
		}
		
		public function toString():String
		{
			var str:String = "";
			const comma:String = ",";
			for (var row:int = 0; row < tileGrid.length; row++) 
			{
				str += "\t[";
				for (var col:int = 0; col < tileGrid[0].length; col++) 
				{
					str += tileAt(row, col).getID();
					if (col != tileGrid[0].length - 1)
						str += comma;
				}
				str += "]";
				if (row != tileGrid.length -1)
					str += comma;
				str += "\n";
			}
			return str;
		}
		
		public function get tileWidth():uint { return _tileWidth; }
		
		public function set tileWidth(value:uint):void { _tileWidth = value; }
		
		public function get tileHeight():uint { return _tileHeight; }
		
		public function set tileHeight(value:uint):void { _tileHeight = value; }
		
		public function getCanvas():Bitmap { return canvas; }
		
		public function bounds():SwiftRectangle { return myBounds; }
	}

}