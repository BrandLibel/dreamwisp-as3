package dreamwisp.world.tile
{
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.components.View;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.input.InputState;
	import dreamwisp.visual.Blitter;
	import dreamwisp.visual.SpriteSheet;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	
	/**
	 * 
	 */
		
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
		
		private var _x:uint = 0;
		private var _y:uint = 0;
		internal var point:Point;
		private var tileWidth:uint = 1;
		private var tileHeight:uint = 1;
		
		public var type:String;
		private var id:uint;
		///Object containing booleans left, right, up, down determining 
		///whether a SolidBody collides or passes through that direction.
		private var solid:Object;
		public var acceleration:Number;
		public var friction:Number;
		public var bonusSpeed:Number;
		
		public var isOpaque:Boolean = false;
		
		/// Bitmap, which is how the tile currently looks 
		private var bitmap:Bitmap;
		/// Array of objects containing x, y, w, and h of bitmap in the spritesheet
		private var frames:Array;
	
		private var ticks:uint = 0;
		private var currentFrame:uint = 1;
		/// The amount of game ticks it takes to equal one currentFrame change
		private var rateOfAnimation:uint;
		
		private var spriteSheet:SpriteSheet;
		
		public static const NIL:Tile = new Tile(null, null, null);
				
		/**
		 * 
		 * @param	blueprint The properties to create this tile with.
		 * @param	tilePresets A list of common tile properties that can be combined.
		 * @param	tileSheet The PNG image containing all tile graphics.
		 */
		public function Tile(blueprint:Object, tilePresets:Object, tileScape:TileScape)
		{
			this.tilePresets = tilePresets;
			
			if (tileScape != null)
			{
				this.spriteSheet = tileScape.spriteSheet;
				this.tileWidth = tileScape.tileWidth;
				this.tileHeight = tileScape.tileHeight;
				destroyed = new Signal(Tile);
			}
			
			this.tileRect = new Rectangle(0, 0, tileWidth, tileHeight);
			
			this.tileScape = tileScape;
			
			bitmap = new Bitmap();
			bitmap.bitmapData = new BitmapData(tileWidth, tileHeight);
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
			}
		}
		
		private function init(blueprint:Object):void
		{
			if (blueprint.presets) unpack(blueprint.presets);
			
			// unique tile properties, if specified in the blueprint, which override the presets
			id = blueprint.guid;
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
		
		public function drawSelfOnGrid():void 
		{
			// update tile appearance
			//tileScape.drawTile(this);
			var matrix:Matrix = new Matrix();
			matrix.translate(x, y);
			
			// stop from drawing on a disposed bitmap 
			try {
				tileScape.getCanvas().bitmapData.draw(view.displayObject, matrix, view.displayObject.transform.colorTransform);
			}
			catch (aError:ArgumentError) {
				
			}
			
		}
		
		/**
		 * 
		 * @param	erase Whether or not to erase the prev tile bitmap before drawing
		 */
		public function drawTile(erase:Boolean = false):void
		{
			if (this === NIL)
				return;
			if (type == TYPE_AIR)
			{
				bitmap.bitmapData.fillRect(tileRect, 0); // air is blank
				return;
			}
						
			if (erase && bitmap.bitmapData)
			{
				bitmap.bitmapData.fillRect(tileRect, 0);
			}
			
			var frame:Object = spriteSheet.access("frames", id).frame;
			var srcRect:Rectangle = new Rectangle(frame.x, frame.y, tileWidth, tileHeight);
			bitmap.bitmapData.copyPixels(spriteSheet.getImage(), srcRect, ORIGIN);
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
			return _x / tileWidth;
		}
		
		/**
		 * The y-position in grid
		 */
		public function row():uint
		{
			return _y / tileHeight;
		}
		
		public function isCompleteSolid():Boolean
		{
			if (!solid.left || !solid.right || !solid.up || !solid.down)
				return false;
			return true;
		}
		
	}

}