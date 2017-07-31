package dreamwisp.undo 
{
	/**
	 * ...
	 * @author 
	 */
	public class UndoManager 
	{
		private var history:Vector.<EditAction> = new Vector.<EditAction>();
		private var future:Vector.<EditAction> = new Vector.<EditAction>();
		
		public function UndoManager() 
		{
			
		}
		
		public function log(action:EditAction):void 
		{
			history.push(action);
			future.splice(0, future.length);
		}
		
		public function canUndo():Boolean
		{
			return index > 0;
		}
		
		public function canRedo():Boolean
		{
			return index < history.length - 1;
		}
		
		public function undo():void 
		{
			if (canUndo()) 
			{ 
				var action:EditAction = history.pop();
				action.undo();
				future.push(action);
			}
		}
		
		public function redo():void 
		{
			if (canRedo()) 
			{ 
				var action:EditAction = future.pop();
				action.redo();
				history.push(action);
			}
		}
		
	}

}