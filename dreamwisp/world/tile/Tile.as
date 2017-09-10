package dreamwisp.world.tile
{
	//import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.components.View;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.visual.SpriteSheet;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	
	public class Tile extends Entity
	{
		private var isNIL:Boolean = false;
		public static const NIL:Tile = new Tile(null, null);
		private static const ORIGIN:Point = new Point();
		
		protected var tileScape:TileScape;
		
		internal var point:Point;
		private var tileRect:Rectangle;
		protected var tileWidth:uint = 1;
		protected var tileHeight:uint = 1;
		/// Reusable drawing rectangle
		private var drawRect:Rectangle;
		
		public var type:String;
		///Object containing booleans left, right, up, down determining 
		///whether a SolidBody collides or passes through that direction.
		protected var solid:Object;
		/// Object similar to solid but determines kill directions
		private var kills:Object;
		
		private var _isGhost:Boolean;
		public var isOpaque:Boolean = false;
		protected var isOccupied:Boolean = false;
		
		/// Bitmap, which is how the tile currently looks 
		private var bitmap:Bitmap;
		/// Array of objects containing x, y, w, and h of bitmap in the spritesheet
		private var frames:Array;
		private var spriteSheet:SpriteSheet;
		
		/// Only set this in update(), not render(). Offsets determine if adjacent tiles become dirty!
		protected var xOffset:int = 0;
		private var prevXOffset:int = 0;
		/// Only set this in update(), not render(). Offsets determine if adjacent tiles become dirty!
		protected var yOffset:int = 0;
		private var prevYOffset:int = 0;
		protected var alpha:Number = 1;
		
		/// Determines whether or not a tile should re-copyPixels() to tilescape canvas
		protected var isDirty:Boolean = true;
		
		/**
		 * 
		 * @param	blueprint The properties to create this tile with.
		 * @param	tileSheet The PNG image containing all tile graphics.
		 */
		public function Tile(blueprint:Object, tileScape:TileScape)
		{
			isNIL = (blueprint == null && tileScape == null);
			
			if (tileScape != null)
			{
				this.spriteSheet = tileScape.spriteSheet;
				this.tileWidth = tileScape.tileWidth;
				this.tileHeight = tileScape.tileHeight;
			}
			
			this.tileRect = new Rectangle(0, 0, tileWidth, tileHeight);
			this.tileScape = tileScape;
			
			bitmap = new Bitmap();
			bitmap.bitmapData = new BitmapData(tileWidth, tileHeight, true, 0);
			view = new View(this, bitmap);
			
			drawRect = new Rectangle(0, 0, tileWidth, tileHeight);
			body = new Body(this, tileWidth, tileHeight);
			point = new Point();
			
			solid = new Object();
			solid.up = false;
			solid.left = false;
			solid.down = false;
			solid.right = false;
			kills = new Object();
			kills.up = false;
			kills.left = false;
			kills.down = false;
			kills.right = false;
			if (blueprint)
				init(blueprint);
		}
		
		private function init(blueprint:Object):void
		{
			if (blueprint.guid) id = blueprint.guid;
			if (blueprint.name) name = type = blueprint.name;
			
			if (blueprint.solid)
			{
				solid.up = blueprint.solid.up;
				solid.left = blueprint.solid.left;
				solid.down = blueprint.solid.down;
				solid.right = blueprint.solid.right;
			}
			if (blueprint.kills)
			{
				kills.up = blueprint.kills.up;
				kills.left = blueprint.kills.left;
				kills.down = blueprint.kills.down;
				kills.right = blueprint.kills.right;
			}
			_isGhost = blueprint.isGhost;
			setStartPixels();
		}
		
		public function setSolidDirections(solidFrom:Object):void 
		{
			solid.up = solidFrom.up;
			solid.left = solidFrom.left;
			solid.down = solidFrom.down;
			solid.right = solidFrom.right;
		}
		
		protected function setStartPixels():void 
		{
			const bitmapData:BitmapData = bitmap.bitmapData;
			// update tile frame appearance (the pixels)
			if (bitmapData != null)
				bitmapData.fillRect(tileRect, 0);
			var frame:Object = spriteSheet.access("frames", id - 1).frame;  // minus 1 since air is 0 but ommitted from sprite sheet
			var srcRect:Rectangle = new Rectangle(frame.x, frame.y, tileWidth, tileHeight);
			bitmap.bitmapData.copyPixels(spriteSheet.getImage(), srcRect, ORIGIN);
		}
		
		/**
		 * Redraws pixels in bitmapData based on tile's current alpha.
		 * Optimized method but still slow; avoid calls when possible.
		 */ 
		protected function transformPixels():void 
		{
			const bitmapData:BitmapData = bitmap.bitmapData;
			const length:uint = tileWidth * tileHeight;
			const ct:ColorTransform = view.displayObject.transform.colorTransform;
			
			bitmapData.lock();
			
			for (var i:int = 0; i < length; i++)
			{
				const x:int = i % tileRect.width;
				const y:int = i / tileRect.height;
				
				const ARGB:uint = bitmapData.getPixel32(x, y);
				const alpha:uint = ((ARGB >> 24) & 0xFF) * this.alpha;
				const red:uint = ((ARGB >> 16) & 0xFF) * ct.redMultiplier;
				const green:uint = ((ARGB >> 8) & 0xFF) * ct.greenMultiplier;
				const blue:uint = (ARGB & 0xFF) * ct.blueMultiplier;
				const newARGB:uint = ( (alpha << 24) | (red << 16) | (green << 8) | blue );
				
				bitmapData.setPixel32(x, y, newARGB);
			}
			
			bitmapData.unlock();
			
			// modification of the body corrupts the soul
			isDirty = true;
		}
		
		override public function update():void
		{	
			isOccupied = false;
			if (hasOffsetChanged())
				isDirty = true;
		}
		
		override public function render(interpolation:Number):void 
		{
			if (isEmpty())
				return;
			
			if (isDirty)
			{
				drawRect.x = point.x + prevXOffset;
				drawRect.y = point.y + prevYOffset;
				drawRect.width = tileWidth;
				drawRect.height = tileHeight;
				tileScape.getCanvas().bitmapData.fillRect(drawRect, 0);
				
				// draw order of tiles will get messed up if offsets are not 0, hence this code
				if (hasOffsetChanged())
				{
					const x:Number = point.x + prevXOffset;
					const y:Number = point.y + prevYOffset;
					
					// all that touch this dirty tile must be redrawn
					var topLeft:Tile 	= tileScape.tileAtPoint(x, 				y				);
					var topRight:Tile 	= tileScape.tileAtPoint(x + tileWidth,	y				);
					var botLeft:Tile 	= tileScape.tileAtPoint(x, 				y + tileHeight	);
					var botRight:Tile 	= tileScape.tileAtPoint(x + tileWidth,	y + tileHeight	);
					if (topLeft  != this) topLeft.renderSelf (interpolation);
					if (topRight != this) topRight.renderSelf(interpolation);
					if (botLeft  != this) botLeft.renderSelf (interpolation);
					if (botRight != this) botRight.renderSelf(interpolation);
				}
				
				renderSelf(interpolation);
				
				prevXOffset = xOffset;
				prevYOffset = yOffset;
				
				// only at the final line of rendering can the soul be cleansed
				isDirty = false;
			}
		}
		
		private function renderSelf(interpolation:Number):void 
		{
			if (isEmpty())
				return;
			const bitmapData:BitmapData = bitmap.bitmapData;
			// using the same point to avoid object construction & allocation
			point.x += xOffset;
			point.y += yOffset;
			tileScape.getCanvas().bitmapData.copyPixels(bitmapData, tileRect, point, null, null, true);			
			point.x -= xOffset;
			point.y -= yOffset;
		}
		
		private function hasOffsetChanged():Boolean
		{
			return (xOffset != prevXOffset || yOffset != prevYOffset);
		}
		
		private function erase():void
		{
			bitmap.bitmapData.fillRect(tileRect, 0);
		}
		
		public function isSolidUp():Boolean { return solid.up; }
		public function isSolidLeft():Boolean { return solid.left; }
		public function isSolidRight():Boolean { return solid.right; }
		public function isSolidDown():Boolean { return solid.down; }
		
		public function killsUp():Boolean { return kills.up; }
		public function killsLeft():Boolean { return kills.left; }
		public function killsRight():Boolean { return kills.right; }
		public function killsDown():Boolean { return kills.down; }
		
		/// Whether or not PlatformPhysics ignores this Tile's isSolid or kills functions
		public function isGhost():Boolean { return _isGhost; }
		
		public function isSlope():Boolean
		{
			return (type == "slope_up" || type == "slope_down");
		}
		
		/**
		 * Indicates that an Entity is currently touching 
		 */
		public function occupy(entity:Entity):void 
		{
			isOccupied = true;
		}
		
		public function collides(body:Body):Boolean
		{
			return bitmapData().hitTest(point, alpha * 255, body.getAsRectangle().rect());
		}
		
		public function bitmapData():BitmapData { return bitmap.bitmapData; }
		
		/**
		 * If the tile has more than one frame, it has animation.
		 * Only if this is true will Tile be added to an array
		 * where it can be updated and rendered; otherwise, it will
		 * simply be a static object.
		 */ 
		public function get hasAnimation():Boolean
		{
			if (!frames) return false;
			return (frames.length > 1) ? true : false;
		}
		
		public function get x():uint { return body.x; }
		
		public function set x(value:uint):void 
		{
			body.x = value;
			point.x = value;
		}
		
		public function get y():uint { return body.y; }
		
		public function set y(value:uint):void 
		{
			body.y = value;
			point.y = value;
		}
		
		/**
		 * The x-position in grid
		 */
		public function col():uint
		{
			return body.x / tileWidth;
		}
		
		/**
		 * The y-position in grid
		 */
		public function row():uint
		{
			return body.y / tileHeight;
		}
		
		public function isPlatform():Boolean
		{
			return (solid.up && !solid.left && !solid.right && !solid.down);
		}
		
		public function isCompleteSolid():Boolean
		{
			return (solid.left && solid.right && solid.up && solid.down);
		}
		
		public function isKiller():Boolean
		{
			return (kills.left || kills.right || kills.up || kills.down);
		}
		
		public function isEmpty():Boolean
		{
			return isNIL;
		}
		
		override public function destroy():void 
		{
			// destroyed.dispatch() doesn't apply to Tiles; we need only this:
			bitmap.bitmapData.dispose();
		}
		
	}

}