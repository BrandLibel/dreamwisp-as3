package dreamwisp.core.screens{	import dreamwisp.visual.GraphicsObject;		/**	 * LevelSelection is the item in a LevelSelectionScreen that users	 * interact with to enter different levels of the game.	 * @author Brandon	 */		public class LevelSelection	{		/// The level that is before this one; the parent level		protected var left:LevelSelection;		/// The level that is after this one; the child level		protected var right:LevelSelection;				protected var isLocked:Boolean;				private var _x:Number = 0;		private var _y:Number = 0;				private var graphicsObject:GraphicsObject;						public function LevelSelection(graphicsObject:GraphicsObject = null)		{			this.graphicsObject = graphicsObject;		}				public function getGraphicsObject():GraphicsObject 		{			return graphicsObject;		}				// some function select() that returns some data and exits the screen,		// data is used to decide which level to enter in the gameplay screen				/**		 * Makes this selectable, 100% opaque, enterable		 */		public function unlock():void		{			isLocked = false;		}				/**		 * Highlights the level visually, indicating the user has 'selected'		 * this level through a mouseover or navigation of keyboard.		 */		public function select():void		{					}				/**		 * Launches the GameplayScreen with this level, indicating the user has		 * hit an action button or clicked the mouse and wants to enter this.		 * @return Returns -1 if the level is locked.		 */		public function confirm():int		{			if (isLocked) return -1;			// return my levelCode/data			return -1;		}				/**		 * Marks this level as completed, unlocks the next level		 */		public function markComplete():void		{			right.unlock();		}				internal function get x():Number { return _x; }				internal function set x(value:Number):void { _x = value; }				internal function get y():Number { return _y; }				internal function set y(value:Number):void { _y = value; }			}}