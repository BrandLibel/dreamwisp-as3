package dreamwisp.undo 
{
	/**
	 * ...
	 * @author 
	 */
	public class EditAction 
	{
		protected var target:Object;
		protected var changes:Object;
		
		public function EditAction(target:Object, changes:Object = null) 
		{
			this.changes = changes;
			this.target = target;
		}
		
		public function undo():void
		{
			throw new Error("This needs to be overriden with a real method!");
		}
		
		public function redo():void 
		{
			throw new Error("This needs to be overriden with a real method!");
		}
		
		/**
		 * Determines the changes between a start and end state.
		 * @param	initState
		 * @param	endState
		 * @return True if there is a difference between start/end, false if difference is 0
		 */
		public function calculate(initState:Object, endState:Object):Boolean 
		{
			throw new Error("This needs to be overriden with a real method!");
		}
		
	}

}