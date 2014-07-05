package dreamwisp.entity.components.platformer 
{
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.components.Physics;
	import dreamwisp.entity.components.platformer.IPlatformMovementState;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.world.tile.Tile;
	import dreamwisp.world.tile.TileScape;
	import org.osflash.signals.Signal;
	import statemachine.StateMachine;
	import statemachine.StateMachineEvent;
	import tools.Belt;
	/**
	 * ...
	 * @author Brandon
	 */
	public class PlatformPhysics extends Physics
	{
		private static const DEFAULT_TILE_WIDTH:uint = 32;
		private static const DEFAULT_TILE_HEIGHT:uint = 32;
		private static const DEFAULT_GRAVITY:Number = 1.6;
		
		private var tileWidth:uint = DEFAULT_TILE_WIDTH;
		private var tileHeight:uint = DEFAULT_TILE_HEIGHT;
		private var tileScape:TileScape;
		private var prevRow:uint;
		
		private var entity:Entity;
		private var body:Body;
		
		public var isWalking:Boolean;
		public var maxWalkSpeed:uint;
		public var walkAcceleration:Number;
		public var friction:Number = 0.6;
		
		public var jumpPower:Number;
		public var gravity:Number = 1.3;
		internal var jumpsMade:uint = 0;
		internal var jumpsAllowed:uint = 1;
		/**
		 * No parameters, must return boolean
		 */
		public var canJump:Function;
		
		private var movementSM:StateMachine;
		internal var currentState:IPlatformMovementState;
		internal var groundState:IPlatformMovementState;
		internal var ladderState:IPlatformMovementState;
		internal var fallState:IPlatformMovementState;
		internal var riseState:IPlatformMovementState;
		
		public var jumped:Signal;
		public var collidedTile:Signal;
		public var steppedNewTile:Signal;
		public var touchedKillerTile:Signal;

		public function PlatformPhysics(entity:Entity, maxWalkSpeed:uint, walkAcceleration:Number, jumpPower:int, maxSpeedY:uint) 
		{
			super(entity, maxWalkSpeed, maxSpeedY);
			this.jumpPower = jumpPower;
			this.walkAcceleration = walkAcceleration;
			this.maxWalkSpeed = maxWalkSpeed;
			this.entity = entity;
			this.body = entity.body;
			
			canJump = function():Boolean
			{
				if (isBlockedAbove())
					return false;
				return hasJumpsRemaining(); 
			};
			
			jumped = new Signal();
			collidedTile = new Signal(Tile);
			steppedNewTile = new Signal(Tile);
			touchedKillerTile = new Signal();
			
			movementSM = new StateMachine();
			groundState = new GroundState(this, entity);
			ladderState = new LadderState(this, entity);
			fallState = new FallState(this, entity);
			riseState = new RiseState(this, entity);
			movementSM.addState( "groundState" );
			movementSM.addState( "ladderState" );
			movementSM.addState( "fallState" );
			movementSM.addState( "riseState" );
			changeState( "fallState" );
		}
		
		// State machine
		
		public function setStateCallbacks(eGround:Function = null, eLadder:Function = null, eFall:Function = null, eRise:Function = null):void 
		{
			movementSM.getStateByName("groundState").enter = eGround;
			movementSM.getStateByName("ladderState").enter = eLadder;
			movementSM.getStateByName("fallState").enter = eFall;
			movementSM.getStateByName("riseState").enter = eRise;
		}
		
		internal function changeState(state:String):void 
		{
			movementSM.changeState(state);
			currentState = this[state];
			currentState.enter();
		}
		
		/* INTERFACE dreamwisp.entity.components.IPhysics */
		
		public function setTileScape(tileScape:TileScape):void 
		{
			this.tileScape = tileScape;
		}
		
		public function getTileScape():TileScape
		{
			return tileScape;
		}
		
		override public function moveLeft():void 
		{
			currentState.moveLeft();
		}
		
		override public function moveRight():void 
		{
			currentState.moveRight();
		}
		
		override public function moveDown():void 
		{
			currentState.moveDown();
			// if on ladder, do ladder movements
			// if not, try to attach to a ladder
		}
		
		override public function moveUp():void 
		{
			currentState.moveUp();
			// if on ladder, do ladder movements
			// if not, try to attach to a ladder
		}
		
		override public function update():void 
		{
			super.update();
			
			// apply friction when stopped moving
			if (!isWalking)
			{
				accelerationX = 0;
				velocityX *= (friction);
				if (Math.abs(velocityX) < maxWalkSpeed * 0.1)
					velocityX = 0;
			}
			currentState.update();
			isWalking = false;
			
			// project physical presence to tiles
			topLeftTile().occupy(entity);
			topRightTile().occupy(entity);
			bottomLeftTile().occupy(entity);
			bottomRightTile().occupy(entity);
		}
		
		/**
		 * Aligns view with body to prevent visual clipping collisions.
		 */
		//private function render(interpolation:Number):void
		//{
			//var prevX:Number = body.x;
			//var prevY:Number = body.y;
			//body.x = entity.view.movieClip.x;
			//body.y = entity.view.movieClip.y;
			//if (bodyCollides())
			//{
				//body.x = entity.view.movieClip.x = prevX;
				//body.y = entity.view.movieClip.y = prevY;
			//}
			//body.x = prevX;
			//body.y = prevY;
		//}
		
		/**
		 * Applies net velocity to x-position while checking for collisions.
		 * This should be used instead of directly setting body.x
		 */
		override protected function travelX():void 
		{
			super.travelX();
			var tileToCollide:Tile;
			// check collision to the right
			if (velocityX > 0)
			{
				// setting the tile to dispatch for collision
				if (topRightTile().isSolidLeft() && bottomRightTile().isSolidLeft())
					tileToCollide = midRightTile();
				else if (topRightTile().isSolidLeft())
					tileToCollide = topRightTile();
				else if (bottomRightTile().isSolidLeft())
					tileToCollide = bottomRightTile();
				
				if (topRightTile().isSolidLeft() || bottomRightTile().isSolidLeft())
					collideRight(tileToCollide);
					
				if (topRightTile().killsLeft() || bottomRightTile().killsLeft())
					touchedKillerTile.dispatch();
			}
			// check collision to the left
			else if (velocityX < 0)
			{
				// setting the tile to dispatch for collision
				if (topLeftTile().isSolidRight() || bottomLeftTile().isSolidRight())
					tileToCollide = midLeftTile();
				else if (topLeftTile().isSolidRight())
					tileToCollide = topLeftTile();
				else if (bottomLeftTile().isSolidRight())
					tileToCollide = bottomLeftTile();
				
				if (topLeftTile().isSolidRight() || bottomLeftTile().isSolidRight())
					collideLeft(tileToCollide);
					
				if (topLeftTile().killsRight() || bottomLeftTile().killsRight())
					touchedKillerTile.dispatch();
			}
		}
		
		private function collideLeft(tileToCollide:Tile):void
		{
			// hit a wall to the left
			body.x = (leftEdge() + 1) * tileWidth;
			velocityX = 0;
			currentState.collideLeft();
			collidedTile.dispatch(tileToCollide);
		}
		
		private function collideRight(tileToCollide:Tile):void 
		{
			// hit a wall to the right
			body.x = rightEdge() * tileWidth - body.width;
			velocityX = 0;
			currentState.collideRight();
			collidedTile.dispatch(tileToCollide);
		}
		
		/**
		 * Applies net velocity to y-position while checking for collisions.
		 * This should be used instead of directly setting body.y
		 */
		override protected function travelY():void
		{
			super.travelY();
			var tileToCollide:Tile;
			// check collision below
			if (velocityY > 0)
			{
				// setting the tile to dispatch for collision
				if (bottomLeftTile().isSolidUp() && bottomRightTile().isSolidUp())
					tileToCollide = bottomMidTile();
				else if (bottomLeftTile().isSolidUp())
					tileToCollide = bottomLeftTile();
				else if (bottomRightTile().isSolidUp())
					tileToCollide = bottomRightTile();
					
				if (bottomLeftTile().isSolidUp() || bottomRightTile().isSolidUp())
				{		
					if (bottomLeftTile().isPlatform() || bottomRightTile().isPlatform())
					{
						if (prevRow < bottomEdge())
							collideBottom(tileToCollide);
					} 
					else 
						collideBottom(tileToCollide);
				}
				if (bottomLeftTile().killsUp() || bottomRightTile().killsUp())
					touchedKillerTile.dispatch();
			}
			// check collision above
			else if (velocityY < 0)
			{
				// setting the tile to dispatch for collision
				if (topLeftTile().isSolidDown() && topRightTile().isSolidDown())
					tileToCollide = topMidTile();
				else if (topLeftTile().isSolidDown())
					tileToCollide = topLeftTile();
				else if (topRightTile().isSolidDown())
					tileToCollide = topRightTile();
					
				if (topLeftTile().isSolidDown() || topRightTile().isSolidDown())
					collideTop(tileToCollide);
				if (topLeftTile().killsDown() || topRightTile().killsDown())
					touchedKillerTile.dispatch();
			}
			prevRow = bottomEdge();
		}
		
		private function collideTop(tileToCollide:Tile):void
		{
			// hit the ceiling
			body.y = bottomEdge() * tileHeight + 1;
			velocityY = 0;
			currentState.collideTop();
			collidedTile.dispatch(tileToCollide);
		}
		
		private function collideBottom(tileToCollide:Tile):void 
		{
			// hit the floor
			body.y = bottomEdge() * tileHeight-body.height;
			velocityY = 0;
			currentState.collideBottom();
			collidedTile.dispatch(tileToCollide);
		}
		
		public function jump():void 
		{
			if (!canJump())
				return;
			currentState.jump();
			velocityY = jumpPower;
			changeState("riseState");
			jumpsMade++;
			jumped.dispatch();
		}
		
		public function jumpSpecial(specialJumpPower:int = 0):void 
		{
			currentState.jump();
			velocityY = specialJumpPower;
			changeState("riseState");
			jumpsMade++;
			jumped.dispatch();
		}
		
		public function bodyCollides():Boolean
		{
			return (topLeftTile().isSolidUp() || topRightTile().isSolidUp() || bottomLeftTile().isSolidUp() || bottomRightTile().isSolidUp());
		}
		
		public function isOnGround():Boolean
		{
			return (currentState == groundState);
		}
		
		/**
		 * Returns true if this is completely covered in solid tiles.
		 */
		public function isEncased():Boolean
		{
			return (topLeftTile().isCompleteSolid() 
				&& topRightTile().isCompleteSolid()
				&& bottomLeftTile().isCompleteSolid()
				&& bottomRightTile().isCompleteSolid());
		}
		
		public function isBlockedAbove():Boolean
		{
			var heightDiff:uint = Math.abs(tileHeight - body.height) + 1;
			var aboveEdge:int =  (Math.floor((body.y - heightDiff) / tileHeight));
			return (tileScape.tileAt(aboveEdge, leftEdge()).isSolidDown()
				|| tileScape.tileAt(aboveEdge, rightEdge()).isSolidDown());
		}
		
		public function hasJumpsRemaining():Boolean
		{
			return jumpsMade < jumpsAllowed;
		}
		
		// currentState.update() calls these internal methods in the order they decide
		
		/**
		 * Accelerates downward because solid ground is not underneath.
		 */
		internal function fall(gravModifier:Number = 1):void
		{
			velocityY += (gravity * gravModifier);
			// never exceed max speed
			if (Math.abs(velocityY) > maxSpeedY)
				velocityY = Belt.getSignOf(velocityY) * maxSpeedY;
		}
		
		// Getting the 4 edges
		
		/**
		 * Returns the tile column (x) the Entity's right edge occupies.
		 * If out of bounds, it defaults to the extreme.
		 */
		internal function rightEdge():int
		{
			var edgeVal:int = Math.floor((body.x + (body.width - 1)) / tileWidth);
			return edgeVal;
		}
		
		/**
		 * Returns the tile column (x) the Entity's left edge occupies.
		 * If out of bounds, it defaults to the extreme.
		 */
		internal function leftEdge():int
		{
			var edgeVal:int = Math.floor((body.x) / tileWidth);
			return edgeVal;
		}
		
		/**
		 * Returns the tile row (y) the Entity's bottom edge occupies.
		 * If out of bounds, it defaults to the extreme.
		 */
		internal function bottomEdge():int
		{
			var edgeVal:int = Math.floor((body.y + (body.height - 1)) / tileHeight);
			return edgeVal;
		}
		
		/**
		 * Returns the tile row (y) the Entity's top edge occupies.
		 * If out of bounds, it defaults to the extreme.
		 */
		internal function topEdge():int 
		{
			var edgeVal:int = Math.floor((body.y) / tileHeight);
			return edgeVal;
		}
		
		// Getting the center lines
		
		/**
		 * The line that divides the Entity into left and right halves
		 */
		internal function midVertical():Number
		{
			var lineVal:Number = Math.floor((body.x + (body.width / 2)) / tileWidth);
			return lineVal;
		}
		
		/**
		 * The line that divides the Entity into top and bottom halves
		 */
		internal function midHorizontal():Number 
		{
			var lineVal:Number = Math.floor((body.y + (body.height / 2)) / tileHeight);
			return lineVal;
		}
		
		internal function centerTile():Tile
		{
			return tileScape.tileAt(midHorizontal(), midVertical());
		}
		
		// Getting the tiles along MID edge
		internal function midLeftTile():Tile
		{
			return tileScape.tileAt(midHorizontal(), leftEdge());
		}
		
		internal function midRightTile():Tile
		{
			return tileScape.tileAt(midHorizontal(), rightEdge());
		}
		
		// Getting the tiles along TOP edge
		
		internal function topLeftTile():Tile
		{
			return tileScape.tileAt(topEdge(), leftEdge());
		}
		
		internal function topMidTile():Tile
		{
			return tileScape.tileAt(topEdge(), midVertical());
		}
		
		internal function topRightTile():Tile
		{
			return tileScape.tileAt(topEdge(), rightEdge());
		}
		
		// Getting the tiles along BOTTOM edge
		
		internal function bottomLeftTile():Tile
		{
			return tileScape.tileAt(bottomEdge(), leftEdge());
		}
		
		internal function bottomMidTile():Tile
		{
			return tileScape.tileAt(bottomEdge(), midVertical());
		}
		
		internal function bottomRightTile():Tile
		{
			return tileScape.tileAt(bottomEdge(), rightEdge());
		}
		
		// Getting the tiles BELOW the player
		
		internal function belowLeftTile():Tile 
		{
			return tileScape.tileAt(bottomEdge()+1, leftEdge());
		}
		
		internal function belowMidTile():Tile 
		{
			return tileScape.tileAt(bottomEdge()+1, midVertical());
		}
		
		internal function belowRightTile():Tile 
		{
			return tileScape.tileAt(bottomEdge()+1, rightEdge());
		}
		
		/**
		 * The horizontal line that intersects the feet 
		 * @return
		 */
		internal function footLine():uint
		{
			return Math.floor((body.y + body.height + 1) / tileHeight);
		}
		
		public function primaryFoot():Tile 
		{
			var leftFoot:Tile = tileScape.tileAt(footLine(), leftEdge());
			var midFoot:Tile = tileScape.tileAt(footLine(), midVertical());
			var rightFoot:Tile = tileScape.tileAt(footLine(), rightEdge());
			if (midFoot.isSolidUp())
				return midFoot;
			else if (leftFoot.isSolidUp())
				return leftFoot;
			else
				return rightFoot;
		}
		
	}

}