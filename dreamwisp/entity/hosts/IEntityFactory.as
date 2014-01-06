package dreamwisp.entity.hosts {
	
	/**
	 * ...
	 * @author Brandon
	 */
	public interface IEntityFactory {
		
		function createEntity(name:String):Entity;
		function createEntity2(id:uint):Entity;
		
	}
	
}