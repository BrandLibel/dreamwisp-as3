package dreamwisp.visual.lighting {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.components.platformer.PlatformPhysics;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.world.tile.Tile;
	import dreamwisp.world.tile.TileScape;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	//import project.world.Level;
	
	/**
	 * A LightSource is a Sprite and Inverse Mask that is added to a Darkness sprite.
	 * It 
	 * @author Brandon
	 */
	
	public class LightSource {
		
		private static const BLUR_FILTER:BlurFilter = new BlurFilter(100, 100, 2);
		private static const BLUR_FILTER_WEAK:BlurFilter = new BlurFilter(25, 25, 2);
		
		private var _lightMask:Sprite;
		private var _colorMask:Sprite;
		
		/// x value, offset in relation to host 
		private var _x:Number;
		/// y value, offset in relation to host
		private var _y:Number;
		
		private var host:Entity;
				
		/// The distance, in pixels, that the light will reach.
		public var lightPower:uint = 100;
		/// The density of points in the ray to check for collisions on environment.
		public var lightStep:uint = 50;
		/// The angle that the light can reach.
		private var lightAngle:uint = 360;
		/// Amount of degrees between each ray, lightAngle/lightAngleStep
		private var lightAngleStep:uint = 60;
		/// The distance, in pixels, that a light ray can continue to shine after a collision.
		private var lightPenetration:uint = 0;
		
		private var lightColor:uint = 0xFEF87A;
		
		private var lightFlickers:Boolean = false;
		
		private var sorted:Boolean = false;
		
		public function LightSource(entity:Entity, x:Number = 0, y:Number = 0) {
			host = entity;
			this.x = x;
			this.y = y;
		}
		
		public function customizeLight(reach:uint, rayDensity:uint, degBetweenRays:uint, flickers:Boolean = false, color:uint = 0xFEF87A):void {
			lightPower = reach;
			lightStep = rayDensity;
			lightAngleStep = 360 / degBetweenRays;
			lightFlickers = flickers;
			lightColor = color;
		}
		
		public function setLightMask(strength:Number = 1, radius:Number = 50):void {
			if (!lightMask) lightMask = new Sprite();
			lightMask.blendMode = BlendMode.ERASE;
			lightMask.graphics.beginFill(0, strength);
			lightMask.graphics.drawCircle(0, 0, radius);
			lightMask.graphics.endFill();
			lightMask.filters = [BLUR_FILTER_WEAK];
		}
		
		public function setColorMask(color:uint = 0xFFFF80, strength:Number = 1, radius:Number = 50):void {
			if (!colorMask) colorMask = new Sprite();
			colorMask.graphics.beginFill(color, strength); 
			colorMask.graphics.drawCircle(0, 0, radius);
			colorMask.graphics.endFill();
			colorMask.filters = [BLUR_FILTER_WEAK];
		}
		
		private function sortBodyByDistance(a:Body, b:Body):int {
			// a squared + b squared = c squared
			sorted = true;
			var dist1:Number = Math.sqrt(Math.pow(Math.abs(a.centerX - host.body.centerX),2) + Math.pow(Math.abs(a.centerY - host.body.centerY),2)) ;
			var dist2:Number = Math.sqrt(Math.pow(Math.abs(b.centerX - host.body.centerX),2) + Math.pow(Math.abs(b.centerY - host.body.centerY),2)) ;
			//MonsterDebugger.trace(this, dist1 + ", " + dist2);
			if (dist1 < dist2) {
				return -1;
			}
			else if (dist1 > dist2) {
				return 1;
			}
			else {
				return 0;
			}
		}
		
		public function render():void {
			/*if (!sorted) {
				Level(host.myLocation).solidBodys.sort(sortBodyByDistance);
				Level(host.myLocation).solidBodys.splice(0, 1);
				//Level(host.myLocation).solidBodys.splice(20, 264);
				//MonsterDebugger.trace(this, Level(host.myLocation).solidBodys,"","",0xD20000);
			}*/
			
			// calculate ray light
			lightMask.graphics.clear();
			lightMask.graphics.beginFill(lightColor, 1);  //0x2FB1FF, 1);
			lightMask.graphics.lineStyle(1, 0xFFFFFF, 0);
			lightMask.graphics.moveTo(x, y);
			for (var n:Number = 0; n < lightAngle; n += (lightAngle / lightAngleStep) ) {
				// move pen to origin of light source
				//hostGraphics.moveTo(x, y);
				// n is the angle of the ray in degrees, converting it to radians for math functions
				n = n * (Math.PI / 180);
				// checking points along the ray for hit testing on solids
				//MonsterDebugger.trace(this, "x: " + x);
				var i:int = 0;
				stepLoop:for (i; i <= lightStep; i++) {
					/*for each (var entity:Entity in host.myLocation.entityManager.entitys) {
						//this line prevents light source from blocking itself
						if (entity === host) break;
						lightPenetration = entity.body.width / 4;
						if (entity.body.touchesPoint(host.body.centerX + (lightPower / lightStep * i) * Math.cos(n), host.body.centerY + (lightPower / lightStep * i) * Math.sin(n))) {
							break stepLoop;
						}
					}*/
					// TODO - REPLACE TILE LIST WITH A DENSER 2D ARRAY OF "OPAQUE" BOOLEANS
					// EVERY ENTITY THAT OCCUPIES A LOCATION WOULD TAKE UP SPACE IN THIS OPACITY MAP
					// testing light collision upon the tileScape, good performance
					var tileScape:TileScape = PlatformPhysics(host.physics).getTileScape();
					var gridX:int = Math.floor((host.body.centerX + (lightPower / lightStep * i) * Math.cos(n)) / tileScape.tileWidth);
					var gridY:int = Math.floor((host.body.centerY + (lightPower / lightStep * i) * Math.sin(n)) / tileScape.tileHeight);
					// break when out of bounds or in a square that contains a completely solid tile
					if (gridY >= tileScape.gridHeight() || gridY < 0) {
						break stepLoop;
					}
					if (gridX >= tileScape.gridWidth() || gridX < 0) {
						break stepLoop;
					}
					if (tileScape.tileAt(gridY, gridX).isOpaque) {
						lightPenetration = (tileScape.tileHeight + tileScape.tileWidth) / 8;
						break stepLoop;
					}
					
					/*bodyLoop:for each (var body:Body in Level(host.myLocation).solidBodys) {
						if (body == host.body) {
							//MonsterDebugger.trace(this, "hit self");
							break bodyLoop;
						}
						
						lightPenetration = body.width / 4;
						//MonsterDebugger.trace(this, "hit other");
						if (body.touchesPoint(host.body.centerX + (lightPower / lightStep * i) * Math.cos(n), host.body.centerY + (lightPower / lightStep * i) * Math.sin(n))) {
							//MonsterDebugger.trace(this, "hit other");
							break stepLoop;
						}
					}*/
				}
				// drawing up to the point where the ray stops
				lightMask.graphics.lineTo(x + (lightPower / lightStep * (i + lightPenetration)) * Math.cos(n), y + (lightPower / lightStep * (i + lightPenetration)) * Math.sin(n));
				// convert n back to degrees for the loop
				n = n / (Math.PI / 180);
				//MonsterDebugger.trace(this, "RAY ANGLE: " + n);
				//MonsterDebugger.trace(this, "ADDING: " + (lightAngle / lightAngleStep));
			}
			// connect final line to starting point, creating a full circle
			lightMask.graphics.lineTo(x + (lightPower / lightStep * (i + lightPenetration)) * Math.cos(0), y + (lightPower / lightStep * (i + lightPenetration)) * Math.sin(0))
			lightMask.graphics.endFill();
			// random alpha is a continuous flicker effect
			if (lightFlickers) lightMask.alpha = Math.random();
			//hostGraphics.lineTo(x, y);
			
			
			colorMask.graphics.copyFrom(lightMask.graphics);
			//colorMask.graphics.
			colorMask.alpha = lightMask.alpha / 3;
			//setColorMask(0x16BEFE);
			
			lightMask.x = host.body.x// + x;
			lightMask.y = host.body.y// + y;
			colorMask.x = lightMask.x;
			colorMask.y = lightMask.y;
		}
		
		public function get x():Number { return _x; }
		
		public function set x(value:Number):void { _x = value; }
		
		public function get y():Number { return _y; }
		
		public function set y(value:Number):void { _y = value; }
		
		public function get lightMask():Sprite { return _lightMask; }
		
		public function set lightMask(value:Sprite):void { _lightMask = value; }
		
		public function get colorMask():Sprite { return _colorMask; }
		
		public function set colorMask(value:Sprite):void { _colorMask = value; }
		
	}

}