package dreamwisp.undo 
{
	/**
	 * ...
	 * @author 
	 */
	public class MoveAction extends EditAction 
	{
		
		public function MoveAction(target:Object, changes:Object) 
		{
			super(target, changes);
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
		
	}

}