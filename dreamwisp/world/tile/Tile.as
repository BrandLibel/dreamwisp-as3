package dreamwisp.world.tile
{
	import com.demonsters.debugger.MonsterDebugger;
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

	//TODO: Position-based list sorting in order to improve performance of ray-casting algorithm.
	//		Differentiate between solid/opaque bodies which are able to collide with light, and only
	//		populate this 'lighting' entity list with solid/opaque things.
	
	public class Tile extends Entity
	{
		private var tilePresets:Object;
		
		private static const ORIGIN:Point = new Point();
		private var tileRect:Rectangle;
		
		private static const TYPE_AIR:String = "air";
		
		protected var tileScape:TileScape;
		
		internal var point:Point;
		private var tileWidth:uint = 1;
		private var tileHeight:uint = 1;
		
		public var type:String;
		private var id:uint;
		///Object containing booleans left, right, up, down determining 
		///whether a SolidBody collides or passes through that direction.
		protected var solid:Object;
		/// Object similar to solid but determines kill directions
		private var kills:Object;
		public var acceleration:Number;
		public var friction:Number;
		public var bonusSpeed:Number;
		
		public var isOpaque:Boolean = false;
		protected var isOccupied:Boolean = false;
		
		/// Bitmap, which is how the tile currently looks 
		private var bitmap:Bitmap;
		/// Array of objects containing x, y, w, and h of bitmap in the spritesheet
		private var frames:Array;
	
		private var ticks:uint = 0;
		private var currentFrame:uint = 1;
		/// The amount of game ticks it takes to equal one currentFrame change
		private var rateOfAnimation:uint;
		private var spriteSheet:SpriteSheet;
		protected var xOffset:int = 0;
		protected var yOffset:int = 0;
		protected var alpha:Number = 1;
		
		public static const NIL:Tile = new Tile(null, null, null);
		private var isNIL:Boolean = false;
		
		/**
		 * 
		 * @param	blueprint The properties to create this tile with.
		 * @param	tilePresets A list of common tile properties that can be combined.
		 * @param	tileSheet The PNG image containing all tile graphics.
		 */
		public function Tile(blueprint:Object, tilePresets:Object, tileScape:TileScape)
		{
			isNIL = (blueprint == null && tilePresets == null && tileScape == null);
			
			this.tilePresets = tilePresets;
			
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
			
			body = new Body(this, tileWidth, tileHeight);
			point = new Point();
			
			// TODO: create tile maps, a 1d array containing list of all surrounding tiles NW, N, NE, W, E, SW, S, SE
			if (blueprint)
				init(blueprint);
			else
			{
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
			}
		}
		
		private function init(blueprint:Object):void
		{
			if (blueprint.presets) unpack(blueprint.presets);
			
			// unique tile properties, if specified in the blueprint, which override the presets
			id = blueprint.guid;
			if (blueprint.solid)
			{
				solid = new Object();
				solid.up = blueprint.solid.up;
				solid.left = blueprint.solid.left;
				solid.down = blueprint.solid.down;
				solid.right = blueprint.solid.right;
			}
			if (blueprint.kills)
				kills = blueprint.kills;
			else
			{
				kills = new Object();
				kills.up = false;
				kills.left = false;
				kills.down = false;
				kills.right = false;
			}
			if (blueprint.tileType)  type = blueprint.tileType;
			
			if (blueprint.hits) this["hits"] = blueprint.hits;
			if (blueprint.frame) { // only a single frame
				//frame = blueprint.frame
			} else if (blueprint.frames){  // tile with multiple frames for animation
				rateOfAnimation = blueprint.rateOfAnimation;
				//currentFrame = (blueprint.startOnFrame == 0) : blueprint.startOnFrame;
				frames = new Array()
				frames = blueprint.frames.concat();
			}
			setStartPixels();
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
		
		protected function transformPixels():void 
		{
			const bitmapData:BitmapData = bitmap.bitmapData;
			bitmapData.lock();
			const length:uint = tileRect.width * tileRect.height;
			const ct:ColorTransform = view.displayObject.transform.colorTransform;
			
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
		}

		/**
		 * 
		 * @param	presets The preset names listed in this tile's blueprint.
		 */
		private function unpack(presets:Array):void
		{
			if (presets.length == 1)
			{
				// dealing with a single preset
				const presetName:String = presets[0];
				type = presetName;
				const presetObject:Object = tilePresets[presetName];
				// copying all properties from the preset
				for (var name:String in presetObject)
				{
					if (this.hasOwnProperty(name))
						this[name] = presetObject[name];
				}
			}
			else
			{
				// for more than one tile preset, manage priorities and overwrites
				
				/*for (var name:String in ) {
					
				}*/
			}
		}
		
		override public function update():void
		{
			ticks++;
			if (ticks == rateOfAnimation)
			{
				ticks = 0;
				currentFrame++;
				
				if (currentFrame > frames.length) currentFrame = 1;
			}
			
			isOccupied = false;
		}

		override public function render(interpolation:Number):void 
		{
			if (isEmpty())
				return;
			
			const bitmapData:BitmapData = bitmap.bitmapData;
			
			
			// try-catch is to stop from drawing on a disposed bitmap 
			try {
				tileScape.getCanvas().bitmapData.copyPixels(bitmapData, tileRect, new Point(point.x + xOffset, point.y + yOffset), null, null, true);
			}
			catch (aError:ArgumentError) {
				
			}
			
			
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
		
		public function getID():uint 
		{
			return id;
		}
		
		public function isPlatform():Boolean
		{
			return (solid.up && !solid.left && !solid.right && !solid.down);
		}
		
		public function isCompleteSolid():Boolean
		{
			return (solid.left && solid.right && solid.up && solid.down);
		}
		
		public function isEmpty():Boolean
		{
			return isNIL;
		}
		
		override public function destroy():void 
		{
			// destroyed.dispatch() doesn't apply to Tiles; it needs only this:
			bitmap.bitmapData.dispose();
		}
		
	}

}