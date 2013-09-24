package dreamwisp.entity.hosts {
	
	/**
	 * ...
	 * @author Brandon
	 */
	public interface IInteractible {
		
		/**
		 * 
		 * @param	entity The entity which is using the interactible object.
		 */
		function interact(entity:Entity = null):void;
		
	}
	
}