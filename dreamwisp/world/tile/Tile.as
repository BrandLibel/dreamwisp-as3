package dreamwisp.world.tile
{
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.input.InputState;
	import dreamwisp.visual.Blitter;
	import dreamwisp.visual.SpriteSheet;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	
	/**
	 * 
	 */
		
	//TODO: Position-based list sorting in order to improve performance of ray-casting algorithm.
	//		Differentiate between solid/opaque bodies which are able to collide with light, and only
	//		populate this 'lighting' entity list with solid/opaque things.
	
	public dynamic class Tile extends Entity
	{
		private var tilePresets:Object;
		private var tileSheet:BitmapData;
		
		private static const ORIGIN:Point = new Point();
		private var tileRect:Rectangle;
		
		private var tileNum:uint = 0;
		
		private static const TYPE_AIR:String = "air";
		private static const TYPE_CUSTOM:String = "custom";
		
		private var _x:uint = 0;
		private var _y:uint = 0;
		private var tileWidth:uint;
		private var tileHeight:uint;
		
		public var type:String;
		///Object containing booleans left, right, up, down determining 
		///whether a SolidBody collides or passes through that direction.
		private var solid:Object;
		public var acceleration:Number;
		public var friction:Number;
		public var bonusSpeed:Number;
		
		public var slopeUp:Boolean;
		public var slopeDown:Boolean;
		public var isLadder:Boolean;
		public var isWater:Boolean;
		
		public var isOpaque:Boolean = false;
		
		/// Bitmap, which is how the tile currently looks 
		private var bitmap:Bitmap = new Bitmap();
		/// Object containing x, y, w, and h of bitmap in the spritesheet
		//public var frame:Object;
		/// Array of objects containing x, y, w, and h of bitmap in the spritesheet
		private var frames:Array;
	
		private var ticks:uint = 0;
		private var currentFrame:uint = 1;
		/// The amount of game ticks it takes to equal one currentFrame change
		private var rateOfAnimation:uint;
		
		private var tileMap:Array;
		private var spriteSheet:SpriteSheet;
		private var blitter:Blitter;
		
		public var created:Signal;
		//public var destroyed:Signal;
		
		//private var state:uint;
		//private static const STATE_IDLE:uint = 0;
		//private static const STATE_
		
		/**
		 * 
		 * @param	blueprint The properties to create this tile with.
		 * @param	tilePresets A list of common tile properties that can be combined.
		 * @param	tileSheet The PNG image containing all tile graphics.
		 */
		public function Tile(blueprint:Object, tilePresets:Object, spriteSheet:SpriteSheet, tileWidth:uint, tileHeight:uint)
		{
			tileMap;
			this.spriteSheet = spriteSheet;
			//this.blitter = blitter;
			this.tilePresets = tilePresets;
			this.tileSheet = tileSheet;
			this.tileWidth = tileWidth;
			this.tileHeight = tileHeight;
			this.tileRect = new Rectangle(0, 0, tileWidth, tileHeight);
			
			// TODO: create tile maps, a 1d array containing list of all surrounding tiles NW, N, NE, W, E, SW, S, SE
			init(blueprint);
		}
		
		private function init(blueprint:Object):void
		{
			if (blueprint.presets) unpack(blueprint.presets);
			// unique tile properties, if specified in the blueprint, which override the presets
			if (blueprint.guid) tileNum = blueprint.guid;
			if (blueprint.solid) solid = blueprint.solid;
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
			
			body = new Body(this, tileWidth, tileHeight);
			
			created = new Signal(Tile);
			destroyed = new Signal(Tile);
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
			//MonsterDebugger.trace(this, this/*"incrementing frames!"*/);
			//TODO: this is a never-ending animation, need to control 
			//		start and stop
			ticks++;
			if (ticks == rateOfAnimation)
			{
				//MonsterDebugger.trace(this, "updating tile" + currentFrame);
				//MonsterDebugger.trace(this, "x: " + x/32 + " y: " + y/32);
				ticks = 0;
				currentFrame++;
				
				if (currentFrame > frames.length) currentFrame = 1;
			}
		}
		
		override public function render(interpolation:Number):void
		{
			drawTile();
			//erase();
		}
		
		/**
		 * 
		 * @param	erase Whether or not to erase the prev tile bitmap before drawing
		 */
		public function drawTile(erase:Boolean = false):void
		{
			if (type == TYPE_AIR)
			{
				bitmap.bitmapData = new BitmapData(tileWidth, tileHeight);
				bitmap.bitmapData.fillRect(tileRect, 0); // air is blank
				return;
			}
			
			var frame:Object = (frames) ? frames[currentFrame-1] : frame;
			//var copyFrom:Rectangle = new Rectangle(frame.x, frame.y, frame.w, frame.h);
			
			if (erase && bitmap.bitmapData)
			{
				//bitmap.bitmapData.dispose();
				bitmap.bitmapData.fillRect(tileRect, 0);
			}
			if (!bitmap.bitmapData) bitmap.bitmapData = new BitmapData(tileWidth, tileHeight);
			
			//blitter.blit("tiles", tileNum-1, 0, 0, currentFrame-1, bitmap.bitmapData);
			bitmap.bitmapData.copyPixels(spriteSheet.getImage(), new Rectangle(0, 0, 32, 32), ORIGIN);
		}
		
		private function erase():void
		{
			bitmap.bitmapData.fillRect(tileRect, 0);
		}
		
		public function isSolidUp():Boolean { return solid.up; }
		
		public function isSolidLeft():Boolean { return solid.left; }
		
		public function isSolidRight():Boolean { return solid.right; }
		
		public function isSolidDown():Boolean { return solid.down; }
		
		public final function hit(damage:int = 1):void
		{
			if (!this.hasOwnProperty("hits")) return;
			this["hits"] -= damage;// hits--;
			//TODO change visual appearance of damaged tile
			if (this["hits"] <= 0)
			{
				//TODO remove tile.
				destroyed.dispatch(this);
			}
		}
		
		public final function setFire():void
		{
			// if (flammable)
		}
		
		public function bitmapData():BitmapData
		{
			return bitmap.bitmapData;
		}
		
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
		
		public function set x(value:uint):void { body.x = value; }
		
		public function get y():uint { return body.y; }
		
		public function set y(value:uint):void { body.y = value; }
		
		public function isCompleteSolid():Boolean
		{
			if (!solid.left || !solid.right || !solid.up || !solid.down)
				return false;
			return true;
		}
		
	}

}