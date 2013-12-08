package dreamwisp.action {
	
	/**
	 * ...
	 * @author Brandon
	 */
	public interface IActionReceptor {
		
		function update(interpolation:Number):void;
		
		function queueAction(action:Object):void;
		function executeAction(action:Object):void;
		
		/**
		 * If the action can be executed right now, do it. 
		 * Otherwise, queue it to be executed on the next tick.
		 * @param	action
		 */ 
		function attemptAction(action:Object):void;
		
		/**
		 * If the action exists in the queue, remove it.
		 * @param	action
		 */
		function abortAction(action:Object):void;
		
	}
	
}