package dreamwisp.undo 
{
	/**
	 * ...
	 * @author 
	 */
	public class MoveAction extends EditAction 
	{
		
		public function MoveAction(target:Object) 
		{
			super(target);
		}
		
		override public function undo():void 
		{
			for (var name:String in changes)
			{
				target[name] += -changes[name];
			}
		}
		
		override public function redo():void 
		{
			for (var name:String in changes)
			{
				target[name] += changes[name];
			}
		}
		
		override public function calculate(initState:Object, endState:Object):Boolean 
		{
			if (changes == null) changes = new Object();
			
			var hasAChange:Boolean = false;
			
			for (var name:String in endState)
			{
				changes[name] = endState[name] - initState[name];
				if (changes[name] != 0) hasAChange = true;
			}
			
			return hasAChange;
		}
		
	}

}