package dreamwisp.entity.hosts {
	
	/**
	 * ...
	 * @author Brandon
	 */
	public interface IInteractible extends IEntity {
		
		/**
		 * 
		 * @param	entity The entity which is using the interactible object.
		 */
		function interact(entity:Entity = null):void;
		
		function touch(entity:Entity):void;
	}
	
}