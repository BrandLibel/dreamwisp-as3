package dreamwisp.world.tile {
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * This class is used to construct the level by blitting the tiles into a BitmapData. 
	 */
	
	internal final class TilePlacer {
		
		private static const tileSheet:BitmapData = Data.tileSheet;
		private static const tileData:Object = Data.tiles;
		
		private static var _backTiles:BitmapData;
		private static var _frontTiles:BitmapData;
		
		/**
		 * Produces a bitmapdata to be given to a graphics handler.
		 * @param	tileGrid The 2d array representing the positions of each tile.
		 * @param	width The width of the level area.
		 * @param	height The height of the level area.
		 * @return The bitmapdata containing the tiles.
		 */
		internal static function build(tileGrid:Array, width:uint, height:uint):Vector.<Tile> {
			var levelRect:Rectangle = new Rectangle(0, 0, width, height);
			_backTiles = new BitmapData(width, height);
			_backTiles.fillRect(levelRect, 0x00000000);
			_frontTiles = new BitmapData(width, height);
			_frontTiles.fillRect(levelRect, 0x00000000);
			for (var a:uint = 0; a < tileGrid.length; a++) {
				for (var b:uint = 0; b < tileGrid[0].length; b++) {
					
					var val:int;
					if (tileGrid[a][b] is Array) {
						for (var c:uint = 0; c < tileGrid[a][b].length; c++) { // 3d array
							// 3 dimensions allow for decorative tiles, placed over normal back tiles
							val = tileGrid[a][b][c];
							if (val > 0) pasteTile(a, b, val);
						}
					} else {
						val = tileGrid[a][b];
						
						if (val > 0) //pasteTile(a, b, val);
					}
					
				}
			}
			return new Vector.<Tile>;
		}
		
		internal static function pasteTile(a:uint, b:uint, tile:int):void {
			var frame:Object = tileData.tiles[tile].frame;
			var copyFrom:Rectangle = new Rectangle(frame.x, frame.y, frame.w, frame.h);
			var sprite:Object = tileData.tiles[tile].spriteSourceSize;
			var tilePoint:Point = new Point(b * Data.TILE_SIZE + sprite.x, a * Data.TILE_SIZE + sprite.y);
			if (tileData.tiles[tile].isFrontal) {
				_frontTiles.copyPixels(tileSheet, copyFrom, tilePoint);
			} else {
				_backTiles.copyPixels(tileSheet, copyFrom, tilePoint);
			}
		}
		
		internal static function get frontTiles():BitmapData {
			return _frontTiles;
		}
		
		internal static function get backTiles():BitmapData {
			return _backTiles;
		}
		
	}

}