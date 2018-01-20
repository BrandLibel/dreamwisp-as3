package dreamwisp.undo 
{
	/**
	 * ...
	 * @author 
	 */
	public class SetAction extends EditAction 
	{
		private var initState:Object;
		private var endState:Object;
		private var afterAction:Function;
		
		public function SetAction(target:Object, afterAction:Function = null) 
		{
			super(target);
			this.afterAction = afterAction;
		}
		
		override public function undo():void 
		{
			for (var name:String in initState)
			{
				target[name] = initState[name];
			}
			if (afterAction) afterAction.call();
		}
		
		override public function redo():void 
		{
			for (var name:String in endState)
			{
				target[name] = endState[name];
			}
			if (afterAction) afterAction.call();
		}
		
		override public function calculate(initState:Object, endState:Object):Boolean 
		{
			this.endState = endState;
			this.initState = initState;
			
			return true;
		}
		
	}

}