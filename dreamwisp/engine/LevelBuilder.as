package engine {
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import com.adobe.serialization.json.JSON;
	import engine.LevelHandler;
	import display.LevelDisplay;
	
	public final class LevelBuilder {
		
		private var tilesRequest:URLRequest = new URLRequest("Tiles.json");
		private var tilesLoader:URLLoader = new URLLoader();
		private var levelsRequest:URLRequest = new URLRequest("Levels.json");
		private var levelsLoader:URLLoader = new URLLoader();
		private var tileSheet:TileSpriteSheet, copyFrom:Rectangle; 
		private var tilePoint:Point, tile:int;
		private var levelRect:Rectangle;
		private var stageSizeRect:Rectangle;
		
		private var area:uint;
		private var levelProgress:uint;
		
		private var npcLocations:Array = new Array();
		private var doorways:Array = new Array();
		private var doorExits:Array = new Array();
		private var doorNum:int = 0;
		
		private var areaX:int, areaY:int;
		private var levelxOffset:int, levelyOffset:int;
		private var prevLvlX:int = 0, prevLvlY:int = 0;
		private var largestLvlX:int = 0, largestLvlY:int = 0;
		private var largestRow:int = 0, largestCol:int = 0;
		private var levelBoxes:Array = new Array();
		
		private var tileData:Object, levelJson:Object;
		private var levels:Object;
		private var baseTilesData:BitmapData;
		private var overTilesData:BitmapData;
		
		private var count:uint = 0;
	
		private var levelDisplay:LevelDisplay = LevelDisplay.getInstance();
		
		public final function LevelBuilder(w:uint, h:uint) {
			stageSizeRect = new Rectangle(0, 0, w, h)
			tilesLoader.addEventListener(Event.COMPLETE, loadFiles);
			tilesLoader.load(tilesRequest);
			levelsLoader.addEventListener(Event.COMPLETE, loadLevelsJson);
			levelsLoader.load(levelsRequest);
			tileSheet = new TileSpriteSheet();
		}
		
		private function loadFiles(e:Event):void {
			tileData = JSON.parse (tilesLoader.data);
		}
		private function loadLevelsJson(e:Event):void {
			levelJson = JSON.parse(levelsLoader.data);
			levels = levelJson.levels;
		}
		
		public final function build(a:uint, l:uint):void {
			area = a;
			levelProgress = l;
			createArea();
			createDoorways();
		}
		
		private function createDoorways():void {
			for (var g:int = 0; g < levels.length; g++){
				levelxOffset = 0;
				levelyOffset = 0;
				for (var h:int = 0; h < levels[g][0].length; h++){
					for (var i:int = 0; i < levels[g][0][0].length; i++){
						var lvl:int = levels[g][0][h][i];
						if (lvl != 0){
							if (i != 0 && levels[area][0][h][i-1] != 0){
								levelxOffset += levels[area][ levels[area][0][h][i-1] ][0].length;
							}
							if (h != 0){
								if (levels[area][0][h-1][i] != 0){
									levelyOffset += levels[area][ levels[area][0][h-1][i] ].length;
								}
							} else if (i != 0){
								levelyOffset += levels[area][ levels[area][0][h][i-1] ].length - levels[area][lvl].length;
							}
							for (var j:int = 0; j < levels[g][lvl].length; j++){
								for (var k:int = 0; k < levels[g][lvl][0].length; k++){
									if (levels[g][lvl][j][k] > 0){
										tile = levels[g][lvl][j][k];
										tilePoint = new Point(k*32 + levelxOffset*32, j*32 + levelyOffset*32);
										if (tileData.tiles[tile].tileType == "door"){
											doorways.push(new Doorway(doorNum, g, lvl, tilePoint, doorExits[doorNum]));
											doorNum++;
										}
									}
								}
							}
						}
					}
				}
			}
		}
		
		private function createArea():void {
			getAreaBounds();
			
			levelRect = new Rectangle(0, 0, areaX, areaY);
			baseTilesData = new BitmapData(areaX, areaY);
			baseTilesData.fillRect(levelRect, 0x00000000);
			overTilesData = new BitmapData(areaX, areaY);
			overTilesData.fillRect(levelRect, 0x00000000);
			
			levelxOffset = 0;
			levelyOffset = 0;
			for (var h:int = 0; h < levels[area][0].length; h++){/** Loops through area header up/down for level #'s */
				for (var i:uint = 0; i < levels[area][0][0].length; i++){/** Loops through area header left/right */
					var lvl:uint = levels[area][0][h][i];/** lvl is set as the level # found in the area */
					npcLocations[lvl] = [];/** Creating spaces in npc array for each level */
					if (lvl != 0){
						if (i != 0 && levels[area][0][h][i-1] != 0){
							levelxOffset += levels[area][ levels[area][0][h][i-1] ][0].length;
						}
						if (h != 0){
							if (levels[area][0][h-1][i] != 0){
								levelyOffset += levels[area][ levels[area][0][h-1][i] ].length;
							}
						} else if (i != 0){
							levelyOffset += levels[area][ levels[area][0][h][i-1] ].length - levels[area][lvl].length;
						}
						var levelProperties:Object = new Object();
						levelBoxes[lvl] = levelProperties;
						levelBoxes[lvl].xMargin = levelxOffset *32;
						levelBoxes[lvl].yMargin = levelyOffset *32;
						levelBoxes[lvl].lvlWidth = levels[area][lvl][0].length *32;
						levelBoxes[lvl].lvlHeight = levels[area][lvl].length *32;
						
						/** Constructing the actual tiles */
						for (var j:uint = 0; j < levels[area][lvl].length; j++){
							for (var k:uint = 0; k < levels[area][lvl][0].length; k++){
								var arrayValue:int = levels[area][lvl][j][k];
								if (arrayValue > 0){
									var tile:int = arrayValue;
									var frame:Object = tileData.tiles[tile].frame;
									var sprite:Object = tileData.tiles[tile].spriteSourceSize;
									copyFrom = new Rectangle(frame.x, frame.y, frame.w, frame.h);
									tilePoint = new Point(k*32 + levelxOffset*32 + sprite.x, j*32 + levelyOffset*32 + sprite.y);
									if (tileData.tiles[tile].extraType != "frontal"){
										baseTilesData.copyPixels(tileSheet, copyFrom, tilePoint);
									} else {
										overTilesData.copyPixels(tileSheet, copyFrom, tilePoint); 
									}
								} else if (arrayValue < 0){
									/** Negative values are non player characters */
									npcLocations[lvl].push([-arrayValue, k*32, j*32]);
								}
							}
						}
					}
				}
			}
			levelDisplay.addToContainer("baseTiles", null, baseTilesData);
			levelDisplay.addToContainer("overTiles", null, overTilesData);
			levelDisplay.setRect(stageSizeRect);
		}
		
		private function getAreaBounds():void {
			/** Resetting values of the area whenever this function is called */ 
			prevLvlY = 0;
			largestLvlY = 0;
			prevLvlX = 0;
			largestLvlX = 0;
			largestCol = 0;
			largestRow = 0;
			/** Determining height of the area by looping through each row and 
			 *	getting the tallest level of each. The height of each of these
			 *	tallest levels is added to the 'largestCol' value.
			 */
			for (var a:int = 0; a < levels[area][0].length; a++){
				for (var b:int = 0; b < levels[area][0][0].length; b++){
					var lvl:int = levels[area][0][a][b];
					if (largestLvlY < prevLvlY){
						largestLvlY = prevLvlY;
					}
					if (lvl != 0){
						var prelvl:int = levels[area][0][a][b-1];
						prevLvlY = levels[area][prelvl].length * 32;
						largestLvlY = levels[area][lvl].length * 32;
					}
					if (b == 0){
						///Start of new row, reset
						largestCol += largestLvlY;
						prevLvlY = 0;
						largestLvlY = 0;
					}
				}
			}
			/** 
			 * Determining width of the area by looping through each column and 
			 * getting the widest level of each. The width of each of these
			 * widest levels is added to the 'largestRow' value.
			 */
			for (var d:int = 0; d < levels[area][0][0].length; d++){
				for (var c:int = 0; c < levels[area][0].length; c++){
					var lvlC:int = levels[area][0][c][d];
					if (largestLvlX < prevLvlX){
						largestLvlX = prevLvlX;
					}
					if (lvlC != 0){
						if (c != 0){
							var prelvlC:int = levels[area][0][c-1][d];
						}
						prevLvlX = levels[area][prelvlC][0].length * 32;
						largestLvlX = levels[area][lvlC][0].length * 32;
					}
					if (c == 0){
						//Start of new column, reset
						largestRow += largestLvlX;
						prevLvlX = 0;
						largestLvlX = 0;
					}
				}
			}
			/** 
			 * The largestRow and largestCol represent the 'width and height'
			 * of the rectangular space that area needs to fit in.
			 */
			areaX = largestRow;
			areaY = largestCol;
			trace(largestRow +","+ largestCol);
		}
		
		public final function getLevelBounds():Object {
			/** Update the level boundaries for LevelHandler */
			var levelProperties:Object = new Object();
			levelProperties.xMargin = levelBoxes[levelProgress].xMargin;
			levelProperties.yMargin = levelBoxes[levelProgress].yMargin;
			levelProperties.levelX = levelBoxes[levelProgress].lvlWidth;
			levelProperties.levelY = levelBoxes[levelProgress].lvlHeight;
			return levelProperties;
		}
		
		public final function updateTile(row:uint = 0, col:uint = 0):void {
			/** 
			 * The level array can be rewritten from here. The two parameters 
			 * indicate the location (on the array) of the tile to be rewritten. 
			 * Currently it simply loops through the first 6 tiles and air as a demonstration.
			 */
			
			row = 24;
			col = 10;
			var currentTile:uint = levels[area][levelProgress][row][col];
			if (levelProgress == 1){
				if (count < 6){
					/** Count up and modify the level array according to count. */
					count++;
					levels[area][levelProgress][row][col] = count;
					if (count == 0){
						/** if the tile is air, fill it with black... */
						var tileRect:Rectangle = new Rectangle(col*32, row*32, 32, 32);
						baseTilesData.fillRect(tileRect, 0);
					} else {
						/** otherwise, paste the new tile of the modified level array */
						tile = levels[area][levelProgress][row][col];
						copyFrom = new Rectangle(tileData.tiles[tile].frame.x, tileData.tiles[tile].frame.y,  tileData.tiles[tile].frame.w, tileData.tiles[tile].frame.h);
						tilePoint = new Point(col*32, row*32);
						baseTilesData.copyPixels(tileSheet, copyFrom, tilePoint);
						levelDisplay.addToContainer("baseTiles", null, baseTilesData);
					}
				} else {
					/** If count is over 6, reset it. */
					count = 0;
				}
			}
			updateTileX();
		}
		public final function updateTileX(row:uint = 0, col:uint = 0):void {
			/** 
			 * The level array can be rewritten from here. The two parameters 
			 * indicate the location (on the array) of the tile to be rewritten. 
			 * Currently it simply loops through the first 6 tiles and air as a demonstration.
			 */
			
			row = 26;
			col = 8;
			var currentTile:uint = levels[area][levelProgress][row][col];
			if (levelProgress == 1){
				if (count < 6){
					/** Count up and modify the level array according to count. */
					count++;
					levels[area][levelProgress][row][col] = count;
					if (count == 0){
						/** if the tile is air, fill it with black... */
						var tileRect:Rectangle = new Rectangle(col*32, row*32, 32, 32);
						baseTilesData.fillRect(tileRect, 0);
					} else {
						/** otherwise, paste the new tile of the modified level array */
						tile = levels[area][levelProgress][row][col];
						copyFrom = new Rectangle(tileData.tiles[tile].frame.x, tileData.tiles[tile].frame.y,  tileData.tiles[tile].frame.w, tileData.tiles[tile].frame.h);
						tilePoint = new Point(col*32, row*32);
						baseTilesData.copyPixels(tileSheet, copyFrom, tilePoint);
						levelDisplay.addToContainer("baseTiles", null, baseTilesData);
					}
				} else {
					/** If count is over 6, reset it. */
					count = 0;
				}
			}
		}
		
		public final function getLevelData():Object {
			var dataObject:Object = new Object();
			dataObject.areaNum = area;
			dataObject.levelNum = levelProgress;
			dataObject.tiles = tileData.tiles;
			dataObject.levelGrid = levels[area][levelProgress];
			/** Gets rid of negatives in level tiles array */
			for (var a:uint = 0; a < dataObject.levelGrid.length; a++){
				for (var b:uint = 0; b < dataObject.levelGrid[a].length; b++){
					if (dataObject.levelGrid[a][b] < 0) dataObject.levelGrid[a][b] = 0; 
				}
			}
			dataObject.xMargin = levelBoxes[levelProgress].xMargin;
			dataObject.yMargin = levelBoxes[levelProgress].yMargin;
			dataObject.doorways = doorways;
			dataObject.npcLocations = npcLocations;
			return dataObject;
		}
		
		public final function updateLevel(xPos:Number, yPos:Number):Object {
			for (var a:uint = 1; a < levelBoxes.length; a++){
				if (xPos > levelBoxes[a].xMargin && xPos < levelBoxes[a].lvlWidth + levelBoxes[a].xMargin){
					if (yPos > levelBoxes[a].yMargin && yPos < levelBoxes[a].lvlHeight + levelBoxes[a].yMargin){
						levelProgress = a;
					}
				}
			}
			//trace("LEVEL PROGRESS:" + area + "," + levelProgress);
			var levelProperties:Object = getLevelBounds();
			return levelProperties;
		}
		
		
	}
	
}