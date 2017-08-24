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
		
		/// There can be only one.
		private var initState:Object;
		
		public function UndoManager() 
		{
			
		}
		
		public function log(action:EditAction):void 
		{
			history.push(action);
			future.splice(0, future.length);
		}
		
		public function start(initState:Object):void 
		{
			this.initState = initState;
		}
		
		public function finalize(action:EditAction, endState:Object):void 
		{
			if (!initState) return;
			
			if (action.calculate(initState, endState))
			{
				log(action);
			}
			
			initState = null;
		}
		
		public function canUndo():Boolean
		{
			return history.length > 0;
		}
		
		public function canRedo():Boolean
		{
			return future.length > 0;
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