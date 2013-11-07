package dreamwisp.world.tile {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.hosts.Entity;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	
	/**
	 * 
	 */
	
	//TODO: tile extends Entity. Tile has body and view. Body uses Swift geometry.
	
	//TODO: Position-based list sorting in order to improve performance of ray-casting algorithm.
	//		Differentiate between solid/opaque bodies which are able to collide with light, and only
	//		populate this 'lighting' entity list with solid/opaque things.
	
	public dynamic final class Tile extends Entity {
		
		private static const tileSheet:BitmapData = Data.tileSheet;
		private static const tilePresets:Object = Data.tilePresets;
		
		private static const ORIGIN:Point = new Point();
		private static const PROP_HITS:String = "hits";
		private static const TILE_RECT:Rectangle = new Rectangle(0, 0, Data.TILE_SIZE, Data.TILE_SIZE);
		
		private static const TYPE_AIR:String = "air";
		private static const TYPE_CUSTOM:String = "custom";
		
		private var _x:uint = 0;
		private var _y:uint = 0;
		
		public var type:String;
		///Object containing booleans left, right, up, down determining 
		///whether a SolidBody collides or passes through that direction.
		public var solid:Object;
		public var acceleration:Number;
		public var friction:Number;
		public var bonusSpeed:Number;
		
		public var slopeUp:Boolean;
		public var slopeDown:Boolean;
		public var isLadder:Boolean;
		public var isWater:Boolean;
		
		public var isOpaque:Boolean = false;
		
		/// Bitmap, which is how the tile currently looks 
		public var bitmap:Bitmap = new Bitmap();
		/// Object containing x, y, w, and h of bitmap in the spritesheet
		public var frame:Object;
		/// Array of objects containing x, y, w, and h of bitmap in the spritesheet
		public var frames:Array;
	
		private var ticks:uint = 0;
		private var currentFrame:uint = 1;
		/// The amount of game ticks it takes to equal one currentFrame change
		private var rateOfAnimation:uint;
		
		private var tileMap:Array;
		
		public var created:Signal;
		//public var destroyed:Signal;
		
		public function Tile(blueprint:Object) {
			tileMap;
			// TODO: create tile maps, a 1d array containing list of all surrounding tiles NW, N, NE, W, E, SW, S, SE
			init(blueprint);
		}
		
		private function init(blueprint:Object):void {
			if (blueprint.presets) unpack(blueprint.presets);
			// unique tile properties, if specified in the blueprint, which override the presets
			if (blueprint.solid) solid = blueprint.solid;
			if (blueprint.tileType)  type = blueprint.tileType;
			
			if (blueprint.hits) this["hits"] = blueprint.hits;
			if (blueprint.frame) { // only a single frame
				frame = blueprint.frame
			} else if (blueprint.frames){  // tile with multiple frames for animation
				rateOfAnimation = blueprint.rateOfAnimation;
				//currentFrame = (blueprint.startOnFrame == 0) : blueprint.startOnFrame;
				frames = new Array()
				frames = blueprint.frames.concat();
			}
			
			if (type != TYPE_AIR) body = new Body(this, Data.TILE_SIZE, Data.TILE_SIZE);
			
			created = new Signal(Tile);
			destroyed = new Signal(Tile);
			
		}
		
		private function unpack(presets:Array):void {
			if (presets.length == 1) {
				// dealing with a single preset
				const presetName:String = presets[0];
				type = presetName;
				const presetObject:Object = tilePresets.presets[presetName];
				// copying all properties from the preset
				for (var name:String in presetObject) {
					this[name] = presetObject[name];
				}
				
				return;
			} else {
				// for more than one tile preset
				
				/*for (var name:String in ) {
					
				}*/
			}
		}
		
		override public function update():void {
			//MonsterDebugger.trace(this, this/*"incrementing frames!"*/);
			// TODO: this is a never-ending animation
			ticks++;
			if (ticks == rateOfAnimation) {
				//MonsterDebugger.trace(this, "updating tile" + currentFrame);
				//MonsterDebugger.trace(this, "x: " + x/32 + " y: " + y/32);
				ticks = 0;
				currentFrame++;
				
				if (currentFrame > frames.length) currentFrame = 1;
			}
		}
		
		override public function render():void {
			drawTile();
			//erase();
		}
		
		/**
		 * 
		 * @param	erase Whether or not to erase the prev tile bitmap before drawing
		 */
		public function drawTile(erase:Boolean = false):void {
			if (type == TYPE_AIR) {
				bitmap.bitmapData = new BitmapData(Data.TILE_SIZE, Data.TILE_SIZE);
				bitmap.bitmapData.fillRect(TILE_RECT, 0); // air is blank
				return;
			}
			
			var frame:Object = (frames) ? frames[currentFrame-1] : frame;
			var copyFrom:Rectangle = new Rectangle(frame.x, frame.y, frame.w, frame.h);
			
			if (erase && bitmap.bitmapData) {
				//bitmap.bitmapData.dispose();
				bitmap.bitmapData.fillRect(TILE_RECT, 0);
			}
			if (!bitmap.bitmapData) bitmap.bitmapData = new BitmapData(Data.TILE_SIZE, Data.TILE_SIZE);
			
			bitmap.bitmapData.copyPixels(tileSheet, copyFrom, ORIGIN);
		}
		
		private function erase():void {
			bitmap.bitmapData.fillRect(TILE_RECT, 0);
		}
		
		public final function hit(damage:int = 1):void {
			if (!this.hasOwnProperty("hits")) return;
			this["hits"] -= damage;// hits--;
			//TODO change visual appearance of damaged tile
			if (this["hits"] <= 0) {
				//TODO remove tile.
				destroyed.dispatch(this);
			}
			
		}
		
		public final function setFire():void {
			// if (flammable)
		}
		
		/**
		 * If the tile has more than one frame, it has animation.
		 * Only if this is true will Tile be added to an array
		 * where it can be updated and rendered; otherwise, it will
		 * simply be a static object.
		 */ 
		public function get hasAnimation():Boolean {
			if (!frames) return false;
			return (frames.length > 1) ? true : false;
		}
		
		public function get x():uint {
			return _x;
		}
		
		public function set x(value:uint):void {
			_x = value;
			if (body) body.x = value;
		}
		
		public function get y():uint {
			return _y;
		}
		
		public function set y(value:uint):void {
			_y = value;
			if (body) body.y = value;
		}
		
		public function get completeSolid():Boolean {
			if (!solid.left) return false;
			if (!solid.right) return false;
			if (!solid.up) return false;
			if (!solid.down) return false;
			return true;
		}
		
	}

}