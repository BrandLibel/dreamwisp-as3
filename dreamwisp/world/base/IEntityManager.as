package dreamwisp.world.base {
	
	import dreamwisp.entity.hosts.Entity;
	
	/**
	 * ...
	 * @author Brandon
	 */
	public interface IEntityManager {
		
		function update():void;
		
		function render():void;
		
		function spawnEntity(actionData:Object):Entity;
		
		function addEntity(entity:Entity):Entity;
		
		function onEntityDestroyed(entity:Entity):void;
		
	}
	
}