package engine {
	
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import com.adobe.serialization.json.JSON;
	import engine.Doorway;
	import display.Overworld;
	
	public final class LevelControl extends Sprite {
		
		private static var instance:LevelControl = new LevelControl();
		private var overworld:Overworld = Overworld.getInstance();
		
		private var area:uint;
		private var levelProgress:uint;
		
		private var tilesRequest:URLRequest = new URLRequest("Tiles.json");
		private var tilesLoader:URLLoader = new URLLoader();
		private var levelsRequest:URLRequest = new URLRequest("Levels.json");
		private var levelsLoader:URLLoader = new URLLoader();
		private var Tiles:TileSpriteSheet, copyFrom:Rectangle; 
		private var tilePoint:Point, tile:int;
		private var levelBitmap:Bitmap, levelData:BitmapData;
		private var levelRect:Rectangle;
		/**
		 * overTiles and overTilesData will hold any tiles that are
		 * in front of the player and everything else. These include water tiles
		 * and animation tiles.
		 */
		private var enemyContainer:Sprite = new Sprite();
		private var npcContainer:Sprite = new Sprite();
		private var overTiles:Bitmap, overTilesData:BitmapData;
		
		private var myData:Object, levelJson:Object;
		private var levelXmargin:int, levelYmargin:int;
		
		private var enemies:Array = new Array();
		private var npcLocations:Array = new Array();
		private var doorways:Array = new Array();
		private var doorExits:Array = new Array();
		
		private var doorNum:int = 0;
		private var levelX:int, levelY:int;
		private var areaX:int, areaY:int;
		private var levelxOffset:int, levelyOffset:int;
		private var prevLvlX:int = 0, prevLvlY:int = 0;
		private var largestLvlX:int = 0, largestLvlY:int = 0;
		private var largestRow:int = 0, largestCol:int = 0;
		private var levelBoxes:Array = new Array();
		private var levels:Object;
		private var camCenter:Point = new Point(384, 240);
		private var minX:int, maxX:int, minY:int, maxY:int;
		private var count:int = 0;
		
		public final function LevelControl() {
			if (instance) throw new Error ("Do not create an instance of this class; use getInstance() instead."); 
			doorExits = [1, 0];
			this.cacheAsBitmap = true;
			Tiles = new TileSpriteSheet();
			tilesLoader.addEventListener(Event.COMPLETE, loadFiles);
			tilesLoader.load(tilesRequest);
			levelsLoader.addEventListener(Event.COMPLETE, loadLevelsJson);
			levelsLoader.load(levelsRequest);
			
			levelBitmap = new Bitmap();
			levelBitmap.smoothing = true;
			overTiles = new Bitmap();
		}
		public static function getInstance():LevelControl {
			return instance;
		}
		private function loadFiles(e:Event):void {
			myData = JSON.decode(tilesLoader.data);
		}
		private function loadLevelsJson(e:Event):void {
			levelJson = JSON.decode(levelsLoader.data);
			levels = levelJson.levels;
		}
		public final function startGame():void {
			addChildAt(levelBitmap, 0);
			addChildAt(enemyContainer, 1);
			addChildAt(npcContainer, 2);
			addChildAt(overTiles, 3);
			area = 0;
			levelProgress = 1;
			constructArea();
			createDoorways();
		}
		/*public final function createPlayer():void {
			player = new Player(myData.tiles);
			player.gotoLevel(levels[area][levelProgress], levelXmargin, levelYmargin)
			
			trace(getChildIndex(overTiles));
		}*/
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
										if (myData.tiles[tile].tileType == "door"){
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
		private function constructArea():void {
			/*for (var a:int = 0; a < enemies.length; a++){
				removeChild(enemies[a]);
			}
			for (var b:int = 0; b < npcs.length; b++){
				removeChild(npcs[b]);
			}
			enemies = [];
			npcs = [];*/
			
			getAreaBounds();
			
			levelData = new BitmapData(areaX, areaY);
			levelRect = new Rectangle(0, 0, areaX, areaY);
			levelData.fillRect(levelRect, 0x00000000);
			overTilesData = new BitmapData(areaX, areaY);
			overTilesData.fillRect(levelRect, 0x00000000);
			var seed:Number = Math.floor(Math.random() * 100); 
			var channels:uint = BitmapDataChannel.RED | BitmapDataChannel.BLUE | BitmapDataChannel.GREEN;
			//levelData.perlinNoise(50, 40, 6, seed, false, true, channels, false, null); 
			
			levelxOffset = 0;
			levelyOffset = 0;
			for (var h:int = 0; h < levels[area][0].length; h++){/** Loops through area header up/down for level #'s */
				for (var i:uint = 0; i < levels[area][0][0].length; i++){/** Loops through area header left/right */
					var lvl:uint = levels[area][0][h][i];/** lvl is set as the level # found in the area */
					npcLocations[lvl] = [];/** Creating spaces for npcs for each level */
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
						levelBoxes[lvl] = [];
						levelBoxes[lvl][0] = levelxOffset *32;
						levelBoxes[lvl][1] = levelyOffset *32;
						levelBoxes[lvl][2] = levels[area][lvl][0].length *32;
						levelBoxes[lvl][3] = levels[area][lvl].length *32;
						
						/** Constructing the actual tiles */
						for (var j:uint = 0; j < levels[area][lvl].length; j++){
							for (var k:uint = 0; k < levels[area][lvl][0].length; k++){
								var arrayValue:int = levels[area][lvl][j][k];
								if (arrayValue > 0){
									var tile:int = arrayValue;
									copyFrom = new Rectangle(myData.tiles[tile].frame.x, myData.tiles[tile].frame.y, myData.tiles[tile].frame.w, myData.tiles[tile].frame.h);
									tilePoint = new Point(k*32 + levelxOffset*32, j*32 + levelyOffset*32);
									if (myData.tiles[tile].extraType != "frontal"){
										levelData.copyPixels(Tiles, copyFrom, tilePoint); 
									} else {
										overTilesData.copyPixels(Tiles, copyFrom, tilePoint); 
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
			setLevelBounds();
			
			levelBitmap.bitmapData = levelData;
			overTiles.bitmapData = overTilesData;
			this.scrollRect = new Rectangle(0, 0, 768, 480);
			
			/*if (area == 0){
				enemies[0] = new SmallEnemy(220, 820, myData.tiles);
				enemies[0].gotoNewLevel(levels[area][levelProgress], levelXmargin, levelYmargin);
				addChildAt(enemies[0], 1);
				
				enemies[1] = new SmallEnemy(420, 800, myData.tiles);
				enemies[1].gotoNewLevel(levels[area][levelProgress], levelXmargin, levelYmargin);
				addChildAt(enemies[1], 1);
				
				npcs[0] = new NPC(190, 600, myData.tiles);
				npcs[0].npcIndex = 0;
				npcs[0].gotoNewLevel(levels[area][levelProgress], levelXmargin, levelYmargin);
				addChildAt(npcs[0], 1);
			}*/
			
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
						//Start of new row, reset
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
			 * of the rectangular space that area/levels needs to fit in.
			 */
			areaX = largestRow;
			areaY = largestCol;
			trace(largestRow +","+ largestCol);
		}
		private function updateTile(yIndex:int = 0, xIndex:int = 0):void {
			/*for (var a:int = 0; a < enemies.length; a++){
				enemies[a].enemyEnterFrame();
			}
			for (var b:int = 0; b < npcs.length; b++){
				npcs[b].npcEnterFrame();
			}*/
			
			/** 
			 * The level array can be rewritten from here. The two parameters 
			 * indicate the location (on the array) of the tile to be rewritten. 
			 * Currently it simply loops through the first 6 tiles and air as a demonstration.
			 */
			yIndex = 24;
			xIndex = 10;
			if (levelProgress == 1){
				if (count < 6){
					//Count up and modify the level array according to count.
					count++;
					levels[area][levelProgress][yIndex][xIndex] = count;
					if (count == 0){
						//if the tile is air, fill it with black...
						var tileRect:Rectangle = new Rectangle(xIndex*32, yIndex*32, 32, 32);
						levelData.fillRect(tileRect, 0);
					} else {
						//otherwise, paste the new tile of the modified level array
						tile = levels[area][levelProgress][yIndex][xIndex];
						copyFrom = new Rectangle(myData.tiles[tile].frame.x, myData.tiles[tile].frame.y,  myData.tiles[tile].frame.w, myData.tiles[tile].frame.h);
						tilePoint = new Point(xIndex*32, yIndex*32);
						levelData.copyPixels(Tiles, copyFrom, tilePoint);
						levelBitmap.bitmapData = levelData;
					}
				} else {
					//if count is over 6, reset it.
					count = 0;
				}
				//trace(levels[area][levelProgress][yIndex+1][xIndex]);
			}
		}
		public final function removeDeadEnemy(index:int):void {
			removeChild(enemies[index]);
			enemies.splice(index, 1);
		}
		public final function levelScroll(xPos:Number, yPos:Number):void {
			var levelRect = this.scrollRect;
			if (area == 0){
				updateTile();
			}
			if (levelX > 768){
				if (xPos > camCenter.x && camCenter.x < maxX){
					camCenter.x = xPos;
				}
				if (xPos < camCenter.x && camCenter.x > minX){
					camCenter.x = xPos;
				}
				if (camCenter.x > maxX){
					camCenter.x = maxX;
				}
				if (camCenter.x < minX){
					camCenter.x = minX;
				}
			}
			if (levelY > 480){
				if (yPos > camCenter.y && camCenter.y < maxY){
					camCenter.y = yPos;
				}
				if (yPos < camCenter.y && camCenter.y > minY){
					camCenter.y = yPos;
				}
				if (camCenter.y > maxY){
					camCenter.y = maxY;
				}
				if (camCenter.y < minY){
					camCenter.y = minY;
				}
			}
			levelRect.x = (camCenter.x-384);
			levelRect.y = (camCenter.y-240);
			this.scrollRect = levelRect;
		}
		
		private function setLevelBounds():void {
			/** Update the level boundaries */
			levelXmargin = levelBoxes[levelProgress][0];
			levelYmargin = levelBoxes[levelProgress][1];
			levelX = levelBoxes[levelProgress][2];
			levelY = levelBoxes[levelProgress][3];
			/** Update the camera position */
			minX = 384 + levelXmargin;
			maxX = levelX - 384 + levelXmargin;
			minY = 240 + levelYmargin;
			maxY = levelY - 240 + levelYmargin;
			camCenter.x = minX;
			camCenter.y = minY;
			trace(minX + "-" + maxX + "-" + minY + "-" + maxY);
		}
		
		/** Communication with Game */
		public final function getLevelData():Object {
			var dataObject:Object = new Object();
			dataObject.areaNum = area;
			dataObject.levelNum = levelProgress;
			dataObject.tiles = myData.tiles;
			dataObject.levelGrid = levels[area][levelProgress];
			/** Gets rid of negatives in level tiles array */
			for (var a:uint = 0; a < dataObject.levelGrid.length; a++){
				for (var b:uint = 0; b < dataObject.levelGrid[a].length; b++){
					if (dataObject.levelGrid[a][b] < 0) dataObject.levelGrid[a][b] = 0; 
				}
			}
			dataObject.xMargin = levelXmargin;
			dataObject.yMargin = levelYmargin;
			dataObject.doorways = doorways;
			dataObject.npcLocations = npcLocations;
			return dataObject;
		}
		
		public final function playerIsInNextLevel(xPos:Number, yPos:Number):Boolean {
			if ((xPos > levelX + levelXmargin) || (xPos < levelXmargin) || (yPos < levelYmargin) || (yPos > levelY + levelYmargin)){
				updateLevel(xPos, yPos);
				return true;
			}
			return false;
			//player.gotoLevel(levels[area][levelProgress], levelXmargin, levelYmargin);
		}
		
		private function updateLevel(xPos:Number, yPos:Number):void {
			for (var a:uint = 1; a < levelBoxes.length; a++){
				if (xPos > levelBoxes[a][0] && xPos < levelBoxes[a][2] + levelBoxes[a][0]){
					if (yPos > levelBoxes[a][1] && yPos < levelBoxes[a][3] + levelBoxes[a][1]){
						levelProgress = a;
						setLevelBounds();
						trace("Next level: " + levelProgress);
					}
				}
			}
		}
		
		public final function accessContainer(container:String, child:DisplayObject, isAdd:Boolean):void {
			if (isAdd == true){
				if (container == "enemy") enemyContainer.addChild(child);
				if (container == "npc") npcContainer.addChild(child);
			} else {
				if (container == "enemy") enemyContainer.removeChild(child);
				if (container == "npc") npcContainer.removeChild(child);
			}
		}
		
		
	}
}