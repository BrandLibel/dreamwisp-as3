package dreamwisp.undo 
{
	/**
	 * ...
	 * @author 
	 */
	public class ToggleAction extends EditAction 
	{
		
		public function ToggleAction(target:Object) 
		{
			super(target);
		}
		
		override public function undo():void 
		{
			for (var name:String in changes)
			{
				target[name] = !changes[name];
			}
		}
		
		override public function redo():void 
		{
			for (var name:String in changes)
			{
				target[name] = changes[name];
			}
		}
		
		override public function calculate(initState:Object, endState:Object):Boolean 
		{
			if (changes == null) changes = new Object();
			
			for (var name:String in endState)
			{
				changes[name] = endState[name];
			}
			
			return true;
		}
		
	}

}