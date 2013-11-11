package dreamwisp.entity.hosts {
	
	import dreamwisp.entity.components.platformer.PlatformController;
	
	/**
	 * ...
	 * @author Brandon
	 */
	public interface IPlatformEntity extends IEntity {
		
		/*function get platformPhysics():PlatformPhysics;
		function set platformPhysics(value:PlatformPhysics):void;*/
		
		function get platformController():PlatformController;
		function set platformController(value:PlatformController):void;
		
	}
	
}