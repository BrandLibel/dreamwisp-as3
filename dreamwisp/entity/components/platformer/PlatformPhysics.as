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
		
		private var entity:Entity;
		private var body:Body;
		
		internal var isWalking:Boolean;
		internal var maxWalkSpeed:uint;
		internal var walkAcceleration:Number;
		internal var jumpPower:int;
		
		internal var friction:Number = 0.25;
		internal var gravity:Number = DEFAULT_GRAVITY;
		
		private var movementSM:StateMachine;
		private var currentState:IPlatformMovementState;
		private var groundState:IPlatformMovementState;
		private var ladderState:IPlatformMovementState;
		private var airState:IPlatformMovementState;
		private var tileScape:TileScape;
		
		public var steppedNewTile:Signal;

		public function PlatformPhysics(entity:Entity, maxWalkSpeed:uint, walkAcceleration:Number, jumpPower:int) 
		{
			super(entity, maxWalkSpeed, 25);
			this.jumpPower = jumpPower;
			this.walkAcceleration = walkAcceleration;
			this.maxWalkSpeed = maxWalkSpeed;
			this.entity = entity;
			this.body = entity.body;
			
			groundState = new PlatformerGroundState(this, entity);
			ladderState = new PlatformerLadderState(this, entity);
			airState = new PlatformerAirState(this, entity);
			
			movementSM = new StateMachine();
			movementSM.addState( "groundState", { enter: onStateChange }  );
			movementSM.addState( "ladderState", { enter: onStateChange }  );
			movementSM.addState( "airState", { enter: onStateChange } );
			movementSM.initialState =  "airState";
			
			steppedNewTile = new Signal(Tile);
		}
		
		// State machine
		
		internal function changeState(state:String):void 
		{
			movementSM.changeState(state);
		}
		
		private function onStateChange(e:StateMachineEvent):void 
		{
			currentState = this[e.currentState];
			currentState.enter();
		}
		
		/* INTERFACE dreamwisp.entity.components.IPhysics */
		
		public function setTileScape(tileScape:TileScape):void 
		{
			this.tileScape = tileScape;
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
			travelX();
			travelY();
			
			currentState.update();
		}
		
		/**
		 * Aligns view with body to prevent visual clipping collisions.
		 */
		public function render(interpolation:Number):void
		{
			var prevX:Number = body.x;
			var prevY:Number = body.y;
			body.x = entity.view.movieClip.x;
			body.y = entity.view.movieClip.y;
			if (bodyCollides())
			{
				body.x = entity.view.movieClip.x = prevX;
				body.y = entity.view.movieClip.y = prevY;
			}
			body.x = prevX;
			body.y = prevY;
		}
		
		/**
		 * Applies net velocity to x-position while checking for collisions.
		 * This should be used instead of directly setting body.x
		 */
		override protected function travelX():void 
		{
			super.travelX();
			velocityX *= 0.8;
			// check collision to the right
			if (velocityX > 0)
			{
				if (topRightTile().isSolidLeft() || bottomRightTile().isSolidLeft())
				{
					// hit a wall to the right
					body.x = rightEdge() * tileWidth - body.width;
					velocityX = 0;
					currentState.collideRight();
				}
			}
			// check collision to the left
			else if (velocityX < 0)
			{
				if (topLeftTile().isSolidRight() || bottomLeftTile().isSolidRight())
				{
					// hit a wall to the left
					body.x = (leftEdge() + 1) * tileWidth;
					velocityX = 0;
					currentState.collideLeft();
				}
			}
		}
		
		/**
		 * Applies net velocity to y-position while checking for collisions.
		 * This should be used instead of directly setting body.y
		 */
		override protected function travelY():void
		{
			super.travelY();
			if (velocityY > 0)
			// check collision below
			{
				if (bottomLeftTile().isSolidUp() || bottomRightTile().isSolidUp())
				{
					// hit the floor
					body.y = bottomEdge() * tileHeight-body.height;
					velocityY = 0;
					currentState.collideBottom();
				}
			}
			// check collision above
			else if (velocityY < 0)
			{
				if (topLeftTile().isSolidDown() || topRightTile().isSolidDown())
				{
					// hit the ceiling
					body.y = bottomEdge() * tileHeight + 1;
					velocityY = 0;
					currentState.collideTop();
				}
			}
		}
		
		public function jump():void 
		{
			currentState.jump();
		}
		
		public function bodyCollides():Boolean
		{
			return (topLeftTile().isSolidUp() || topRightTile().isSolidUp() || bottomLeftTile().isSolidUp() || bottomRightTile().isSolidUp());
		}
		
		public function isOnGround():Boolean
		{
			return (currentState == groundState);
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
		
		internal function canJump():Boolean
		{
			return false;
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