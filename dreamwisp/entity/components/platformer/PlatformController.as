package dreamwisp.entity.components.platformer {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.components.Physics;
	import dreamwisp.world.tile.Tile;
	import statemachine.StateMachine;
	import statemachine.StateMachineEvent;
	
	/**
	 * ...
	 * @author Brandon Li
	 */
	public class PlatformController {
		
		public var host:Entity;
		private var body:Body;
		private var physics:Physics;
		
		public var movementSM:StateMachine;
		public var currentState:IPlatformMovementState;
		private var groundState:IPlatformMovementState;
		private var ladderState:IPlatformMovementState;
		private var airState:IPlatformMovementState;
		
		public var walking:Boolean;
		
		public var acceleration:Number = 0;
		public var friction:Number = 0;
		protected var bonus_speed:Number = 0;
		public var maxWalkSpeed:Number = 6;
		public var walkAcceleration:Number;
		public var jumpPower:int;
		public var terminalVelocityX:uint;
		public var terminalVelocityY:uint = 25;
		
		public var canGrabLadder:Boolean = true;
		private var pressingUp:Boolean = false;
		
		// tile collision variables
		//public var tile_size:uint = Data.TILE_SIZE;
		private var tileWidth:uint;
		private var tileHeight:uint;
		
				
		private var tileGrid:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>;
		/// Object containing location-specific properties 
		internal var environment:Object;
		
		private var over:String;
		private var currentTile:Tile;
		
		public var onSlope:Boolean = false;
		protected var x_slope_detector:int;
		protected var y_slope_detector:int;
		protected var this_slope:int;
		protected var x_offset:Number;
		
		protected var bottom:uint;
		private var prev_bottom:Number;
		internal var left:int;
		internal var right:int;
		internal var top:uint;
		internal var center:Tile;
		internal var center_x:int;
		internal var center_y:uint;
		internal var bottom_left:Tile;
		internal var bottom_center:Tile;
		internal var bottom_right:Tile;
		internal var top_left:Tile;
		internal var top_center:Tile;
		internal var top_right:Tile;
		internal var above_left:Tile;
		internal var above:Tile;
		internal var above_right:Tile;
		internal var below_left:Tile;
		internal var below:Tile;
		internal var below_right:Tile;
		
		public function PlatformController(entity:Entity, maxWalkSpeed:uint, walkAcceleration:Number, jumpPower:int):void {
			host = entity;
			body = host.body;
			physics = host.physics;
			
			this.maxWalkSpeed = maxWalkSpeed;
			this.walkAcceleration = walkAcceleration;
			this.jumpPower = jumpPower;
			
			environment = new Object();
			environment.gravity = 1.6;
			environment.tileWidth = 32;
			environment.tileHeight = 32;
			tileWidth = 32;
			tileHeight = 32;
			
			movementSM = new StateMachine();
			movementSM.addState( "groundState", { enter: onStateChange }  );
			movementSM.addState( "ladderState", { enter: onStateChange }  );
			movementSM.addState( "airState", { enter: onStateChange } );
			
			groundState = new GroundState(this);
			ladderState = new LadderState(this);
			airState = new AirState(this);
			
			movementSM.initialState = "airState";
			//MonsterDebugger.trace(this, currentState);
		}
		
		private function onStateChange(e:StateMachineEvent):void {
			// access state by string name
			currentState = this[e.currentState];
			currentState.enter();
			//MonsterDebugger.trace(this, "changed state: " + e.currentState);
			
		}
		
		public function update():void {			
			registerGround();
			checkCollisions();
			currentState.update();
		}
		
		public function moveLeft():void {
			body.facingDirection = -1;
			currentState.moveLeft();
		}
		
		public function moveRight():void {
			//if (currentState != groundState) return;
			body.facingDirection = 1;
			currentState.moveRight();
		}
		
		public function moveUp():void {
			currentState.moveUp();
		}
		
		public function moveDown():void {
			currentState.moveDown();
		}
		
		public function jump():void {
			MonsterDebugger.trace(this, "canJump: " + canJump());
			// prevent re-grabbing ladder while holding up
			if (currentState is LadderState && pressingUp) canGrabLadder = false;
			// disallow jumping while there's a solid edge directly above
			//if (above_left.solid.down || above_right.solid.down) { // causes problems when hugging walls 
			if (above.solid.down && below.solid.up){ // doesn't work if above is not exactly centered
			//if (hasTileAbove()){
				return;
			}
			
			currentState.jump();
			//MonsterDebugger.trace(this, onSlope);
			//MonsterDebugger.trace(this, currentState);
		}
		
		public function grabLadder():void {
			if (canGrabLadder) {
				physics.xVelocity = 0;
				physics.yVelocity = 0;
				movementSM.changeState( "ladderState" );
				// centering the entity in the ladder, x = 0 + 
				body.x = ( center_x * tileWidth) + (tileWidth - body.width ) / 2;
			}
		}
		
		public function pressUp():void {
			pressingUp = true;
		}
		
		public function releaseUp():void {
			pressingUp = false;
			canGrabLadder = true;
		}
		
		public function setTileGrid(tileGrid:Vector.<Vector.<Tile>>):void 
		{
			this.tileGrid = tileGrid;
		}
		
		private function registerGround():void {
			bonus_speed = 0;
			var left_foot_x:uint = Math.floor(body.x/tileWidth);
			var right_foot_x:uint = Math.floor((body.x+(body.width-1))/tileWidth);
			var foot_y:uint = Math.floor((body.y+body.height)/tileHeight);
			if (foot_y >= 0 && foot_y < tileGrid.length){
				if (left_foot_x >= 0 && left_foot_x < tileGrid[0].length){
					var left_foot:Tile = tileGrid[foot_y][left_foot_x];
				}
				if (right_foot_x >= 0 && right_foot_x < tileGrid[0].length){
					var right_foot:Tile = tileGrid[foot_y][right_foot_x];
				}
			}
			if (left_foot && left_foot.solid.up == true) {
				currentTile = left_foot;
			} else {
				//MonsterDebugger.trace(this, "using right tile");
				currentTile = right_foot;
			}
			
			if (currentTile) {
				over = currentTile.type;
				if (!currentTile.solid.up && !(currentState is LadderState) && !onSlope) movementSM.changeState("airState"); 
				acceleration = currentTile.acceleration;
				friction = currentTile.friction;
				//if (host is Player) MonsterDebugger.trace(this, friction);
				bonus_speed = currentTile.bonusSpeed;
			}
		}
		
		private function checkCollisions():void {
			getEdges();
			//checkForSlope();
			collideSlopes();
		
			body.y += physics.yVelocity;
			getEdges();
			/// Collision to the bottom.
			if (physics.yVelocity > 0 && !onSlope) {
				if (bottom < tileGrid.length){
					if (bottom_right.solid.up || bottom_left.solid.up) {
						// ignoring platform-ladders when climbing down ladder
						if (currentState is LadderState && bottom_center.type == "ladder" ) return;
						collideBottom();
					} 
				}
			}
			/// Collision to the top. 
			if (physics.yVelocity < 0) {
				if (top_right && top_left) {
					if (top_right.solid.down || top_left.solid.down) {
						collideTop();
					}
				}
			}
			body.x += physics.xVelocity;
			getEdges();
			/// Collision to the left. 
			if (physics.xVelocity < 0) {
				if ((top_left.solid.right || bottom_left.solid.right) && !onSlope){
					collideLeft();
				}
			}
			/// Collision to the right. 
			if (physics.xVelocity > 0) {
				if (bottom < tileGrid.length){
					if ((top_right.solid.left || bottom_right.solid.left) && !onSlope){
						collideRight();
					}
				}
			}
			prev_bottom = bottom;
		}
		
		protected function collideBottom():void {
			if (body.height >= 30) {
				//MonsterDebugger.trace(this, "large entity collision: " + body.y);
			}
			if (body.height < 30) {
				//MonsterDebugger.trace(this, "small entity collision: " + body.y);
			}
			//MonsterDebugger.trace(this, over);
			//MonsterDebugger.trace(this, "colliding bottom : " + y, "", "", 0xD50000);
			body.y = bottom * tileHeight-body.height;
			//MonsterDebugger.trace(this, "colliding bottom", "", "", 0x1FC501);
			
			physics.yVelocity = 0;
			currentState.collideBottom();
			//react();
			//MonsterDebugger.trace(this, "collided");
		}
		
		protected function collideTop():void {
			body.y = bottom * tileHeight + 1 /*+ (body.height-1)*/;
			physics.yVelocity = 0;
			//react();
			currentState.collideTop();
			
		}
		
		protected function collideLeft():void {
			body.x = (left + 1) * tileWidth /*+ body.width*/;
			physics.xVelocity = 0;
			//react();
			//MonsterDebugger.trace(this, "colliding left" );
			currentState.collideLeft();
			
		}
		
		protected function collideRight():void {
			body.x = right * tileWidth-body.width;
			physics.xVelocity = 0;
			//react();
			//MonsterDebugger.trace(this, "colliding right" );
			currentState.collideRight();
		}
		
		private function getEdges():void {
			/// Testing for edges 
			right = Math.floor((body.x+(body.width-1))/tileWidth);
			left = Math.floor((body.x)/tileWidth);
			bottom = Math.floor((body.y+(body.height-1))/tileHeight);
			top = Math.floor((body.y)/tileHeight);
			center_x = Math.floor((body.x + (body.width/2)) / tileWidth);
			center_y = Math.floor((body.y + (body.height / 2)) / tileHeight);
			// prevent edges from being out of bounds
			if (right >= tileGrid[0].length) right = tileGrid[0].length-1;
			if (left < 0) left = 0;
			if (center_x < 0) center_x = 0;
			if (center_x >= tileGrid[0].length) center_x = tileGrid[0].length - 1;
			if (center_y < tileGrid.length && center_y >= 0){
				center = tileGrid[center_y][center_x];
			}
			if (top < tileGrid.length && top >= 0){
				top_left = tileGrid[top][left];
				top_center = tileGrid[top][center_x];
				top_right = tileGrid[top][right];
			}
			if (top-1 < tileGrid.length && top-1 >= 0){
				above_left = tileGrid[top-1][left];
				above = tileGrid[top-1][center_x];
				above_right = tileGrid[top-1][right];
			}
			if (bottom < tileGrid.length && bottom >= 0){
				bottom_left = tileGrid[bottom][left];
				bottom_right = tileGrid[bottom][right];
				bottom_center = tileGrid[bottom][center_x];
			}
			if (bottom+1 < tileGrid.length && bottom+1 >= 0){
				below_left = tileGrid[bottom+1][left];
				below = tileGrid[bottom+1][center_x];
				below_right = tileGrid[bottom+1][right];
			}
		}
		
		private final function checkForSlope():void {
			onSlope = false;
			
			//TODO: Within this function, replace all occurences of body.x and body.y
			//		with centerX and centerY respectively in order to have equal
			//		slope up and slope down movement.
			/*var (body.x + body.width / 2):Number = (body.x + body.width / 2);
			var (body.y + body.height / 2):Number = (body.y + body.height / 2);*/
			
			// when performing slope calculations, center x pos (body.x + body.width/2)
			// is used 
			
			x_slope_detector = Math.floor(((body.x + body.width / 2)) / tileWidth);
			y_slope_detector = Math.floor(((body.y + body.height / 2)) / tileHeight);
			
			if (x_slope_detector < 0) x_slope_detector = 0;
			
			var tile:Tile;
			
			if (y_slope_detector < tileGrid.length && y_slope_detector >= 0){
				if (currentState == airState) {
					tile = tileGrid[y_slope_detector][x_slope_detector];
					if (tile.type == "slope_up" || tile.type == "slope_down") {
						if (tile.type == "slope_up") {
							//MonsterDebugger.trace(this, "on slope from air", "", "", 0x0073F2);
							x_offset = tileWidth-(body.x + body.width / 2) % tileWidth;
						}
						/// could be an "else"...               
						if (tile.type == "slope_down") {
							//MonsterDebugger.trace(this, "on slope from air", "", "", 0x0073F2);
							x_offset = (body.x + body.width / 2) % tileWidth;
						}
						if (physics.yVelocity < 0) {
							trace("");
						}
						if ((body.y + body.height / 2) > Math.floor((body.y /*+ body.height / 2*/)/tileHeight)*tileHeight-body.height+x_offset && physics.yVelocity > 0) {
							/// rebounce fix here
							trace("bounce!");
							/*MonsterDebugger.trace(this, "bouncey bouncey", "", "", 0x0073F2);
							physics.yVelocity = 0;
							body.y--;
							movementSM.changeState("groundState");
							//onSlope = true;*/
						}
					}
				}
				/// could NOT be an else  
				if (currentState != airState) {
					if (tileGrid[y_slope_detector+1][x_slope_detector].type == "slope_up" || tileGrid[y_slope_detector+1][x_slope_detector].type == "slope_down") {
						body.y = (y_slope_detector+1)*tileHeight+tileHeight/2+1;
						y_slope_detector += 1;
						//trace("not on slope");
					}
					tile = tileGrid[y_slope_detector][x_slope_detector];
					if (tile.type == "slope_up" || tile.type == "slope_down") {
						if (tile.type == "slope_up") {
							x_offset = tileWidth - (body.x + body.width / 2) % tileWidth;
						}
						/// could be an "else"...               
						if (tile.type == "slope_down") {
							x_offset = (body.x + body.width / 2) % tileWidth;
						}
						body.y = Math.floor((body.y /*+ body.height / 2*/)/tileHeight)*tileHeight-body.height+x_offset;
						onSlope = true;
						if (physics.xVelocity > 15){
							trace("reducing speed");
							physics.xVelocity = 15;
						}
						if (physics.xVelocity < -15){
							trace("reducing speed");
							physics.xVelocity = -15;
						}
						//trace("onaslope");
					}
				}
			}
			if (currentState == groundState && !onSlope) {
				body.y = -(body.height / 2) + y_slope_detector * tileHeight + tileHeight / 2 + 1;
				// bugfix for collision differences between entitys with height < 30
				if (body.height < 30) {
					body.y =  y_slope_detector * tileHeight + tileHeight / 2 + 1;
					// during collisions,
					// 821.44 with
					// 818.74 commented out
				}
				
				// temporary test code for debugging
				if (body.height < 30) {
					// for small entitys
					body.y;
					trace(""); // 817 without vs 809.5 with vs 817 without either
				} else {
					// for non-small entitys
					body.y;
					trace(""); // 913 without vs 898 with vs 898 without either
				}
			}
		}
		
		private function collideSlopes():void {
			onSlope = false;
			
			var centerX:Number = body.x + body.width / 2;
			var centerY:Number = body.y + body.height / 2;
			
			var xSlopeDetector:int = Math.floor(centerX / tileWidth);
			var ySlopeDetector:int = Math.floor(centerY / tileHeight);
			
			var tile:Tile;
			
			if (xSlopeDetector < 0) xSlopeDetector = 0;
			if (ySlopeDetector < 0) ySlopeDetector = 0;
			
			if (currentState == airState) {
				tile = tileGrid[ySlopeDetector][xSlopeDetector];
				if (tile.type == "slope_up" || tile.type == "slope_down") {
					if (tile.type == "slope_up") {
						
					} else if (tile.type == "slope_down") {
						
					}
				}
			}
			
			if (currentState != airState) {
				// prevent xSlopeDetector from exceeding array bounds
				if (xSlopeDetector >= tileGrid[0].length) xSlopeDetector = tileGrid[0].length - 1;
				if (tileGrid[ySlopeDetector+1][xSlopeDetector].type == "slope_up" || tileGrid[ySlopeDetector+1][xSlopeDetector].type == "slope_down") {
					centerY = (ySlopeDetector+1)*tileHeight+tileHeight/2+1;
					ySlopeDetector += 1;
					//trace("not on slope");
				} 
				tile = tileGrid[ySlopeDetector][xSlopeDetector];
				if (tile.type == "slope_up" || tile.type == "slope_down") {
					
					if (tile.type == "slope_up") { // /|
						// BASIC: centerY = tileY + (tileHeight - (centerX - tileX)) - body.height / 2;
						centerY = tile.y + (tileHeight - (centerX - tile.x)) - body.height / 2;
					} else if (tile.type == "slope_down") { // |\
						// BASIC: centerY = 
						centerY = tile.y + (centerX - tile.x) - body.height / 2;
					}
					onSlope = true;
				}
				
			}
			
			if (currentState == groundState && !onSlope) {
				
				centerY = ySlopeDetector * tileHeight + (tileHeight / 2) + 1;
				
				// bugfix for collision differences between entitys with height < 30
				// TODO: DOES NOT WORK FOR ALL SIZES, FIX UNDERLYING PROBLEM
				if (body.height < 30) {
					centerY = (body.height / 2) + ySlopeDetector * tileHeight + (tileHeight / 2) + 1;
					// during collisions,
					// 821.44 with
					// 818.74 commented out
				}
				
				// temporary test code for debugging
				if (body.height < 30) {
					// for small entitys
					body.y;
					trace(""); // 817 without vs 809.5 with vs 817 without either
				} else {
					// for non-small entitys
					body.y;
					trace(""); // 913 without vs 898 with vs 898 without either
				}
			}
			
			// at the end, center pos values are converted back to top-left values 
			body.x = centerX - body.width / 2;
			body.y = centerY - body.height / 2;
			
		}
		
		private function canJump():Boolean {
			if (above_left.solid.down || above_right.solid.down) return false;
			
			return true;
		}	
		
		public function testY(height:Number):Number {
			return -(height / 2) + y_slope_detector * tileHeight + tileHeight / 2 + 1;
		}
		
	}

}