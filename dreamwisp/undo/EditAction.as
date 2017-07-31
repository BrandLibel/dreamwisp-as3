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
		
		public function calculate(initState:Object, endState:Object):void 
		{
			throw new Error("This needs to be overriden with a real method!");
		}
		
	}

}