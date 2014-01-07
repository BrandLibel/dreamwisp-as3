package dreamwisp.entity.components.platformer 
{
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.components.IPhysics;
	import dreamwisp.entity.components.platformer.IPlatformMovementState;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.world.tile.Tile;
	import statemachine.StateMachine;
	import tools.Belt;
	/**
	 * ...
	 * @author Brandon
	 */
	public class PlatformPhysics implements IPhysics 
	{
		private static const DEFAULT_TILE_WIDTH:uint = 32;
		private static const DEFAULT_TILE_HEIGHT:uint = 32;
		internal static const GRAVITY:Number = 1.6;
		
		private var tileWidth:uint = DEFAULT_TILE_WIDTH;
		private var tileHeight:uint = DEFAULT_TILE_HEIGHT;
		private var tileGrid:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>;
		private var maxSpeedY:uint = 25;
		
		private var entity:Entity;
		private var body:Body;
		private var maxWalkSpeed:uint;
		private var walkAcceleration:Number;
		private var jumpPower:int;
		
		private var _velocityX:Number = 0;
		private var _velocityY:Number = 0;
		private var friction:Number = 0.25;
		
		private var movementSM:StateMachine;
		private var currentState:IPlatformMovementState;
		private var groundState:IPlatformMovementState;
		private var ladderState:IPlatformMovementState;
		private var airState:IPlatformMovementState;
		
		public function PlatformPhysics(entity:Entity, maxWalkSpeed:uint, walkAcceleration:Number, jumpPower:int) 
		{
			this.jumpPower = jumpPower;
			this.walkAcceleration = walkAcceleration;
			this.maxWalkSpeed = maxWalkSpeed;
			this.entity = entity;
			this.body = entity.body;
			
			movementSM = new StateMachine();
			movementSM.addState( "groundState", { enter: onEnterGround }  );
			movementSM.addState( "ladderState", { enter: onEnterLadder }  );
			movementSM.addState( "airState", { enter: onEnterAir } );
			
			//groundState = new GroundState(this);
			//ladderState = new LadderState(this);
			//airState = new AirState(this);
		}
		
		/* INTERFACE dreamwisp.entity.components.IPhysics */
		
		public function setTileGrid(tileGrid:Vector.<Vector.<Tile>>):void 
		{
			this.tileGrid = tileGrid;
		}
		
		public function moveLeft():void 
		{
			//currentState.moveLeft();
			velocityX -= 2;
		}
		
		public function moveRight():void 
		{
			//currentState.moveRight();
			velocityX += 2;
		}
		
		public function moveDown():void 
		{
			currentState.moveDown();
			// if on ladder, do ladder movements
			// if not, try to attach to a ladder
		}
		
		public function moveUp():void 
		{
			currentState.moveUp();
			// if on ladder, do ladder movements
			// if not, try to attach to a ladder
		}
		
		public function jump():void 
		{
			currentState.jump();
		}
		
		public function update():void 
		{
			rightEdge();
			leftEdge();
			topEdge();
			bottomEdge();
			
			var tile:Tile = topLeftTile();
			tile = topMidTile();
			tile = topRightTile();
			tile = bottomLeftTile();
			tile = bottomMidTile();
			tile = bottomRightTile();
			
			fall();
			//body.y += velocityY;
			translateY();
			translateX();
			
		}
		
		/**
		 * Applies net velocity to y-position while checking for collisions.
		 * This should be used instead of directly setting body.x
		 */
		private function translateX():void 
		{
			
			body.x += velocityX;
			velocityX *= 0.8;
			// check collision to the right
			if (velocityX > 0)
			{
				if (topRightTile().isSolidLeft() || bottomRightTile().isSolidLeft())
				{
					body.x = rightEdge() * tileWidth - body.width;
					velocityX = 0;
					
				}
			}
			// check collision to the left
			else if (velocityX < 0)
			{
				if (topLeftTile().isSolidRight() || topLeftTile().isSolidRight())
				{
					body.x = (leftEdge() + 1) * tileWidth;
					velocityX = 0;
				}
			}
		}
		
		/**
		 * Applies net velocity to y-position while checking for collisions.
		 * This should be used instead of directly setting body.y
		 */
		private function translateY():void
		{
			body.y += velocityY;
			
			// check collision below
			if (velocityY > 0)
			{
				if (bottomLeftTile().isSolidUp() || bottomRightTile().isSolidUp())
				{
					body.y = bottomEdge() * tileHeight-body.height;
					velocityY = 0;
				}
			}
			// check collision above
			else if (velocityY < 0)
			{
				if (topLeftTile().isSolidUp() || topRightTile().isSolidUp())
				{
					body.y = bottomEdge() * tileHeight + 1;
					velocityY = 0;
				}
			}
		}
		
		// currentState.update() calls these internal methods in the order they decide
		
		/**
		 * Accelerates downward because solid ground is not underneath.
		 */
		internal function fall(gravModifier:Number = 1):void
		{
			velocityY += (GRAVITY * gravModifier);
			// never exceed max speed
			if (Math.abs(velocityY) > maxSpeedY)
				velocityY = Belt.getSignOf(velocityY) * maxSpeedY;
			//if ()
		}
		
		internal function canJump():Boolean
		{
			
			return false;
		}
		
		// Getting the 4 edges
		
		/**
		 * Returns the tile column (x) the Entity's right edge occupies.
		 * If out of bounds, it defaults to the extreme.
		 */
		internal function rightEdge():Number
		{
			var edgeVal:Number = Math.floor((body.x + (body.width - 1)) / tileWidth);
			// Entity is beyond left of the tileGrid
			if (edgeVal < 0) return 0;
			
			// Entity is beyond right of the tileGrid
			if (edgeVal >= tileGrid[0].length) edgeVal = (tileGrid.length - 1);
			
			return edgeVal;
		}
		
		/**
		 * Returns the tile column (x) the Entity's left edge occupies.
		 * If out of bounds, it defaults to the extreme.
		 */
		internal function leftEdge():Number
		{
			// Entity is beyond left of the tileGrid
			if (body.x < 0) return 0;
			
			var edgeVal:Number = Math.floor((body.x) / tileWidth);
			// Entity is beyond right of the tileGrid
			if (edgeVal >= tileGrid[0].length) edgeVal = (tileGrid[0].length -1);
			
			return edgeVal;
		}
		
		/**
		 * Returns the tile row (y) the Entity's bottom edge occupies.
		 * If out of bounds, it defaults to the extreme.
		 */
		internal function bottomEdge():Number
		{
			var edgeVal:Number = Math.floor((body.y + (body.height - 1)) / tileHeight);
			// Entity is beyond top of the tileGrid
			if (edgeVal < 0) return 0;
			
			// Entity is beyond bottom of the tileGrid
			if (edgeVal >= tileGrid.length) edgeVal = (tileGrid.length -1);
			return edgeVal;
		}
		
		/**
		 * Returns the tile row (y) the Entity's top edge occupies.
		 * If out of bounds, it defaults to the extreme.
		 */
		internal function topEdge():Number 
		{
			// Entity is beyond top of the tileGrid
			if (body.y < 0) return 0;
			
			var edgeVal:Number = Math.floor((body.y) / tileHeight);
			// Entity is beyond bottom of the tileGrid
			if (edgeVal >= tileGrid.length) edgeVal = (tileGrid.length -1);
			
			return edgeVal;
		}
		
		// Getting the center lines
		
		/**
		 * The line that divides the Entity into left and right
		 */
		internal function midVertical():Number
		{
			var lineVal:Number = Math.floor((body.x + (body.width / 2)) / tileWidth);
			if (lineVal < 0) lineVal = 0;
			if (lineVal >= tileGrid.length) lineVal = (tileGrid.length -1);
			return lineVal;
		}
		
		/**
		 * The line that divides the Entity into top and bottom
		 */
		internal function midHorizontal():Number 
		{
			var lineVal:Number = Math.floor((body.y + (body.height / 2)) / tileHeight);
			return lineVal;
		}
		
		internal function centerTile():Tile
		{
			return tileGrid[midHorizontal()][midVertical()];
		}
		
		// Getting the tiles along TOP edge
		
		internal function topLeftTile():Tile
		{
			return tileGrid[topEdge()][leftEdge()];
		}
		
		internal function topMidTile():Tile
		{
			return tileGrid[topEdge()][midVertical()];
		}
		
		internal function topRightTile():Tile
		{
			return tileGrid[topEdge()][rightEdge()];
		}
		
		// Getting the tiles along BOTTOM edge
		
		internal function bottomLeftTile():Tile
		{
			return tileGrid[bottomEdge()][leftEdge()];
		}
		
		internal function bottomMidTile():Tile
		{
			return tileGrid[bottomEdge()][midVertical()];
		}
		
		internal function bottomRightTile():Tile
		{
			return tileGrid[bottomEdge()][rightEdge()];
		}
		
		// State machine
		
		internal function changeState(state:String):void 
		{
			movementSM.changeState(state);
		}
		
		public function get velocityX():Number { return _velocityX; }
		
		public function set velocityX(value:Number):void { _velocityX = value; }
		
		public function set velocityY(value:Number):void { _velocityY = value; }
		
		public function get velocityY():Number { return _velocityY; }
		
		private function onEnterGround():void 
		{
			currentState = groundState;
			currentState.enter();
		}
		
		private function onEnterLadder():void 
		{
			currentState = ladderState;
			currentState.enter();
		}
		
		private function onEnterAir():void 
		{
			currentState = airState;
			currentState.enter();
		}
		
	}

}