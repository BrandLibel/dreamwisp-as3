package dreamwisp.world.tile {
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Brandon
	 */
	public class TileComposer {
		
		private static const tileList:Object = Data.tiles;
		
		
		public static function compose(tileNum:uint):Tile {
			const blueprint:Object = tileList.tiles[tileNum];
			
			return new Tile(blueprint);
		}
		
		/*public static function compose(tile:Tile, tileNum:uint):void {
			const blueprint:Object = tileList.tiles[tileNum];
			// loading presets
			
			tile.solid.left = blueprint.solid.left;
			tile.solid.right = blueprint.solid.right;
			tile.solid.up = blueprint.solid.up;
			tile.solid.down = blueprint.solid.down;
			tile.sold = blueprint.solid;
			tile.tileType = blueprint.tileType;
			
			tile.frames = blueprint.frames.concat();
			
			
			// ignoring presets for now, advanced stuff for later on
			if (blueprint.presets) {
				var presetDataObjects:Array;
				for each (var tilePresetName:String in blueprint.presets) {
					const preset:Object = tilePresets.presets[tilePresetName];
					presetDataObjects.push(preset);
					for each (var property:* in preset.weak) {
						presetDataObjects[0].weak[property] = weak;
					}
					for each (var property:* in presets.strong) {
						
					}
				}
				for (var i:uint = 1; i < presetDataObjects.length; i++) {
					
				}
			}
			
			drawTile(blueprint);
		}*/
		
		internal static function drawTile(blueprint:Object):void {
			/*var frame:Object = tileList.tiles[tile].frame;
			var copyFrom:Rectangle = new Rectangle(frame.x, frame.y, frame.w, frame.h);
			var sprite:Object = tileList.tiles[tile].spriteSourceSize;
			var tilePoint:Point = 
				new Point (b * Data.TILE_SIZE + sprite.x, a * Data.TILE_SIZE + sprite.y);*/
			
			/*if (tileList.tiles[tile].isFrontal) {
				_frontTiles.copyPixels(tileSheet, copyFrom, tilePoint);
			} else {
				_backTiles.copyPixels(tileSheet, copyFrom, tilePoint);
			}*/
		}
		
	}

}