package engine {
	
	import flash.geom.Point;
	import display.LevelDisplay;
	import engine.LevelBuilder;
	
	public final class LevelHandler {
		
		private static var instance:LevelHandler = new LevelHandler();
		
		private const sWidth:uint = 768;
		private const sHeight:uint = 480;
		private const tSize:uint = 32;
		
		private var camCenter:Point = new Point(sWidth/2, sHeight/2);
		private var minX:uint, maxX:uint, minY:uint, maxY:uint;
		private var levelWidth:uint, levelHeight:uint;
		private var levelXmargin:uint, levelYmargin:uint;
		
		private var levelBuilder:LevelBuilder = new LevelBuilder(sWidth, sHeight);
		private var levelDisplay:LevelDisplay = LevelDisplay.getInstance();
		
		public final function LevelHandler() {
			if (instance) throw new Error ("Do not create an instance of this class; use getInstance() instead.");
		}
		
		public static function getInstance():LevelHandler {
			return instance; 
		}
		
		public final function buildArea(a:uint, l:uint):void {
			levelBuilder.build(a, l);
			updateCamera();
		}
		
		public final function levelScroll(xPos:Number, yPos:Number):void {
			var levelRect = levelDisplay.scrollRect;
			
			//levelBuilder.updateTile();
			
			if (levelWidth > sWidth){
				if (xPos > camCenter.x && camCenter.x < maxX) camCenter.x = xPos;
				if (xPos < camCenter.x && camCenter.x > minX) camCenter.x = xPos;
				if (camCenter.x > maxX) camCenter.x = maxX;
				if (camCenter.x < minX) camCenter.x = minX;
			}
			if (levelHeight > sHeight){
				if (yPos > camCenter.y && camCenter.y < maxY) camCenter.y = yPos; 
				if (yPos < camCenter.y && camCenter.y > minY) camCenter.y = yPos;
				if (camCenter.y > maxY) camCenter.y = maxY;
				if (camCenter.y < minY) camCenter.y = minY;
			}
			levelRect.x = (camCenter.x-(sWidth/2));
			levelRect.y = (camCenter.y-(sHeight/2));
			levelDisplay.setRect(levelRect);
		}
		
		private function updateCamera():void {
			var levelProperties:Object = levelBuilder.getLevelBounds();
			with (levelProperties){
				levelWidth = levelX;
				levelHeight = levelY;
				minX = (sWidth/2) + xMargin;
				maxX = levelX - (sWidth/2) + xMargin;
				minY = (sHeight/2) + yMargin;
				maxY = levelY - (sHeight/2) + yMargin;
				levelXmargin = xMargin;
				levelYmargin = yMargin;
				camCenter.x = minX;
				camCenter.y = minY;
			}
			trace(levelWidth + levelXmargin);
		}
		
		public final function playerIsInNextLevel(xPos:Number, yPos:Number):Boolean {
			if ((xPos > levelWidth + levelXmargin) || (xPos < levelXmargin) || (yPos < levelYmargin) || (yPos > levelHeight + levelYmargin)){
				levelBuilder.updateLevel(xPos, yPos);
				updateCamera();
				return true;
			}
			return false;
			
			//player.gotoLevel(levels[area][levelProgress], levelXmargin, levelYmargin);
		}
		
		public final function getLevelData():Object {
			return levelBuilder.getLevelData();
		}
		
		
		
	}
	
}