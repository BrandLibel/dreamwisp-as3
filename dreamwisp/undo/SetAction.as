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
		
		public function SetAction(target:Object) 
		{
			super(target);
		}
		
		override public function undo():void 
		{
			for (var name:String in initState)
			{
				target[name] = initState[name];
			}
		}
		
		override public function redo():void 
		{
			for (var name:String in endState)
			{
				target[name] = endState[name];
			}
		}
		
		override public function calculate(initState:Object, endState:Object):Boolean 
		{
			this.endState = endState;
			this.initState = initState;
			
			return true;
		}
		
	}

}