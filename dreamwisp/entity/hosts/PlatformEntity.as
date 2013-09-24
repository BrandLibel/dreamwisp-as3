package dreamwisp.entity.hosts {
	
	import dreamwisp.entity.components.PlatformController;
	
	/**
	 * ...
	 * @author Brandon
	 */
	 
	public class PlatformEntity extends Entity implements IPlatformEntity {
		
		private var _platformController:PlatformController;
		
		public function PlatformEntity() {
			
		}
		
		override public function update():void {
			super.update();
			if (platformPhysics) platformPhysics.update();
		}
		
		/* INTERFACE dreamwisp.entity.hosts.IPlatformEntity */
		
		public function get platformController():PlatformController {
			return _platformController;
		}
		
		public function set platformController(value:PlatformController):void {
			_platformController = value;
		}
		
	}

}