package dreamwisp.entity.components.platformer 
{
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.components.TileBasedPhysics;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.world.tile.Tile;
	import dreamwisp.world.tile.TileScape;
	import org.osflash.signals.Signal;
	import statemachine.StateMachine;
	import tools.Belt;
	/**
	 * ...
	 * @author Brandon
	 */
	public class PlatformPhysics extends TileBasedPhysics
	{
		private static const DEFAULT_GRAVITY:Number = 1.6;
		public static const COLLIDE_DIR_LEFT:uint = 0;
		public static const COLLIDE_DIR_UP:uint = 1;
		public static const COLLIDE_DIR_RIGHT:uint = 2;
		public static const COLLIDE_DIR_DOWN:uint = 3;
		
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
		/// No params, must return boolean
		public var canJump:Function;
		
		private var movementSM:StateMachine;
		internal var currentState:PlatformState;
		internal var groundState:PlatformState;
		internal var ladderState:PlatformState;
		internal var fallState:PlatformState;
		internal var riseState:PlatformState;
		
		public var jumped:Signal;
		public var collidedTile:Signal;
		public var steppedNewTile:Signal;
		public var touchedKillerTile:Signal;
		
		private var prevRow:uint;

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
				if (isBlockedAbove() || currentState != groundState)
					return false;
				return hasJumpsRemaining(); 
			};
			
			jumped = new Signal();
			collidedTile = new Signal(Tile, uint);
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
		
		public function changeState(state:String):void 
		{
			movementSM.changeState(state);
			currentState = this[state];
			currentState.enter();
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
			collideSlope();
			
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
		
		public var ignoresGhosts:Boolean = true;
		public function ignoresCollision(tile:Tile):Boolean
		{
			return (isOnSlope || (tile.isGhost() && ignoresGhosts) );
		}
		
		/**
		 * Applies net velocity to x-position while checking for collisions.
		 * This should be used instead of directly setting body.x
		 */
		override protected function travelX():void 
		{
			super.travelX();
			var tileToCollide:Tile;
			var tileThatKills:Tile;
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
				
				// setting the tile to dispatch for killing the entity
				if (topRightTile().killsLeft() && bottomRightTile().killsLeft())
					tileThatKills = midRightTile();
				else if (topRightTile().killsLeft())
					tileThatKills = topRightTile();
				else if (bottomRightTile().killsLeft())
					tileThatKills = bottomRightTile();
				
				if (topRightTile().killsLeft() || bottomRightTile().killsLeft())
					touchKillerTile(tileThatKills);
			}
			// check collision to the left
			else if (velocityX < 0)
			{
				// setting the tile to dispatch for collision
				if (topLeftTile().isSolidRight() && bottomLeftTile().isSolidRight())
					tileToCollide = midLeftTile();
				else if (topLeftTile().isSolidRight())
					tileToCollide = topLeftTile();
				else if (bottomLeftTile().isSolidRight())
					tileToCollide = bottomLeftTile();
				
				if (topLeftTile().isSolidRight() || bottomLeftTile().isSolidRight())
					collideLeft(tileToCollide);
				
				// setting the tile to dispatch for killing the entity
				if (topLeftTile().killsRight() && bottomLeftTile().killsRight())
					tileThatKills = midLeftTile();
				else if (topLeftTile().killsRight())
					tileThatKills = topLeftTile();
				else if (bottomLeftTile().killsRight())
					tileThatKills = bottomLeftTile();
					
				if (topLeftTile().killsRight() || bottomLeftTile().killsRight())
					touchKillerTile(tileThatKills);
			}
		}
		
		private function touchKillerTile(tile:Tile):void 
		{
			if (ignoresCollision(tile))
				return;
			touchedKillerTile.dispatch();
		}
		
		/// Hit a wall to the left
		protected function collideLeft(tile:Tile):void
		{
			if (isOnSlope || ignoresCollision(tile))
				return;
			body.x = (leftEdge() + 1) * tileWidth;
			velocityX = 0;
			currentState.collideLeft();
			collidedTile.dispatch(tile, COLLIDE_DIR_LEFT);
		}
		
		/// Hit a wall to the right
		protected function collideRight(tile:Tile):void 
		{
			if (isOnSlope || ignoresCollision(tile))
				return;
			body.x = rightEdge() * tileWidth - body.width;
			velocityX = 0;
			currentState.collideRight();
			collidedTile.dispatch(tile, COLLIDE_DIR_RIGHT);
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
				if (bottomLeftTile().isSolidUp() && bottomRightTile().isSolidUp() && !ignoresCollision(bottomMidTile()))
					tileToCollide = bottomMidTile();
				else if (bottomLeftTile().isSolidUp() && !ignoresCollision(bottomLeftTile()))
					tileToCollide = bottomLeftTile();
				else if (bottomRightTile().isSolidUp() && !ignoresCollision(bottomRightTile()))
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
		
		/// Hit the ceiling
		protected function collideTop(tile:Tile):void
		{
			if (ignoresCollision(tile))
				return;
			body.y = bottomEdge() * tileHeight + 1;
			velocityY = 0;
			currentState.collideTop();
			collidedTile.dispatch(tile, COLLIDE_DIR_UP);
		}
		
		/// Hit the floor
		protected function collideBottom(tile:Tile):void 
		{
			if (tile == null) // null means all tiles below ignored collisions
				return;
			body.y = bottomEdge() * tileHeight-body.height;
			velocityY = 0;
			currentState.collideBottom();
			collidedTile.dispatch(tile, COLLIDE_DIR_DOWN);
		}
		
		public var isOnSlope:Boolean = false;
		private function collideSlope():void 
		{
			var tile:Tile = bottomMidTile();
			isOnSlope = false;
			
			if (currentState == fallState)
			{
				tile = centerTile();
				// 'pull' glitch description: (entity falls to slope with speed > normal)
				// falling -> slope detected before feet touch -> correct y on slope
				// SOLUTION: wait until entity clips into slope, then react with following:
				if (body.y > slopeY(tile) && tile.isSlope())
				{
					body.y = slopeY(tile)
					isOnSlope = true;
					if (currentState != groundState)
						changeState("groundState");
				}
			}
			else if (currentState == groundState)
			{
				tile = bottomMidTile();
				setYOnSlope(tile);
				tile = primaryFoot();
				setYOnSlope(tile);
				// 'bounce' glitch description:
				// hits slope -> correct y on slope -> next update() -> fail groundState slope ->
				// collideBottom() simulator -> clips to ground below -> next update() -> 
				// collides bottom -> groundState slope? -> correct y on slope
				// SOLUTION: prevent 'fail groundState slope' with the following:
				if (!isOnSlope)
					setYOnSlope(centerTile());
			}
			
			// Simulate regular collideBottom(). On the last frame of climbing up a slope /[]\
			// the entity ends up horizontally clipped inside the solid tile []. 
			// This happens because at this point it is reading the [] and no longer sees a tile,
			// causing it to skip any kind of body.y adjustment until it proceeds to collision code.
			// This solves the problem by doing a regular collision to the [] non slope tile.
			if (!isOnSlope && currentState == groundState && tile.isSolidUp())
				body.y = tile.y / tileHeight * tileHeight-body.height;
		}
		
		private function setYOnSlope(tile:Tile):void 
		{
			if (!tile.isSlope())
				return;
				
			body.y = slopeY(tile);
			
			// escape when stuck in ground after stepping off slope /[]\.
			while (bottomMidTile().isSolidUp())
				body.y--;
			
			isOnSlope = true;
			if (currentState != groundState)
				changeState("groundState");
		}
		
		private function slopeY(tile:Tile):Number
		{
			// Equation: y = mx + b
			// m is slope direction (up or down)
			// with (0, 0) in top left, up is negative
			// x is entity distance from the tile's origin
			// b is y intercept
			var x:Number = body.centerX - tile.x;
			var m:Number = (tile.type == "slope_up") ? -1 : 1;
			var b:Number = (tile.type == "slope_up") ? tileHeight: 0;
			b += tile.y - body.height;
			return (m * x) + b;
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
		 * Returns true if this is completely covered in solid, non-ghost tiles.
		 */
		public function isEncased():Boolean
		{
			return (
				topLeftTile().isCompleteSolid() && !ignoresCollision(topLeftTile()) &&
				topRightTile().isCompleteSolid() && !ignoresCollision(topRightTile()) &&
				bottomLeftTile().isCompleteSolid() && !ignoresCollision(bottomLeftTile()) &&
				bottomRightTile().isCompleteSolid() && !ignoresCollision(bottomRightTile())
			);
		}
		
		public function isBlockedAbove():Boolean
		{
			var heightDiff:uint = Math.abs(tileHeight - body.height) + 1;
			var aboveEdge:int =  (Math.floor((body.y - heightDiff) / tileHeight));
			var above1:Tile = tileScape.tileAt(aboveEdge, leftEdge());
			var above2:Tile = tileScape.tileAt(aboveEdge, rightEdge());
			return (
				above1.isSolidDown() && !ignoresCollision(above1) ||
				above2.isSolidDown() && !ignoresCollision(above2)
			);
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
		
		private function leftFoot():Tile 
		{
			return tileScape.tileAt(footLine(), leftEdge());
		}
		
		private function midFoot():Tile 
		{
			return tileScape.tileAt(footLine(), midVertical());
		}
		
		private function rightFoot():Tile 
		{
			return tileScape.tileAt(footLine(), rightEdge())
		}
		
		public function primaryFoot():Tile 
		{
			var leftFoot:Tile = this.leftFoot();
			var midFoot:Tile = this.midFoot();
			var rightFoot:Tile = this.rightFoot();
			if ((midFoot.isSolidUp() || midFoot.isSlope()) && !ignoresCollision(midFoot))
				return midFoot;
			else if ((leftFoot.isSolidUp() || leftFoot.isSlope()) && !ignoresCollision(leftFoot))
				return leftFoot;
			else
				return rightFoot;
		}
		
	}

}