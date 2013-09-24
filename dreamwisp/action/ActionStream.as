package dreamwisp.action {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.core.Game;
	import dreamwisp.entity.hosts.Entity;
	import org.osflash.signals.Signal;
	
	/**
	 * The ActionStream is an event manager class that is based on AS3 signals.
	 */
	public class ActionStream {
		
		private static var _instance:ActionStream = new ActionStream();
		private var _game:Game;
		
		public var entityCreated:Signal = new Signal(Entity);
		public var entityDestroyed:Signal = new Signal(Entity);
		public var buttonPressed:Signal = new Signal(String);
		public var leverFlipped:Signal = new Signal(String, Boolean);
		public var locationEntered:Signal = new Signal(String);
		
		public function ActionStream() {
			if (_instance) {
				throw new Error(
					"ActionStream is a Singleton class; call getInstance() instead of the constructor");
			}
		}
		
		public static function getInstance():ActionStream {
			return _instance;
		}
		
		public static function execute(action:Object):void {
			/*if (action.type == Data.text.ACTION_SPAWN_ENTITY) {
				entityManager.spawnEntity(action);
			} else if (action.type == Data.text.ACTION_DESTROY_ENTITY) {
				entityManager.destroyEntity(action);
			} else if (action.type == Data.text.ACTION_START_CHAT) {
							
			} else if (action.type == Data.ACTION_SCRIPT_CAMERA) {
				highestLocation.camera.followPath(action.data);
			}*/
		}
		
		public function findSignal(name:String):Signal {
			/*if (!this.hasOwnProperty(name)) {
				throw new Error("Signal " + name + " is not defined in ActionStream class.");
			}*/
			if (this[name] is Signal) {
				return this[name];
			} else {
				throw new Error("Signal " + name + " is not defined in ActionStream class.");
			}
			
			return null;
		}
		
	}

}