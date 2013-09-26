package dreamwisp.world.base {
	
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.hosts.IEntityFactory;
	import dreamwisp.state.GameState;
	import dreamwisp.swift.geom.SwiftRectangle;
	import dreamwisp.visual.camera.Camera;
	import dreamwisp.visual.camera.ICamUser;
	import dreamwisp.visual.ContainerView;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.world.tile.TileScape;
	import project.entity.hosts.Player;
	
	/**
	 * This superclass contains basic functionality
	 * for all types of locations.
	 * @author Brandon Li 
	 */
	
	public class Location extends GameState implements ILocation {
			
		/// The index uint of the active sublocation in the list.
		private var activeLocation:uint;
		
		private var _parent:Location;
		private var _subLocation:Location;
		/// List of smaller Locations that form this Location.
		protected var subLocations:Array;
		//protected var entitys:Vector.<Entity>;
		
		//public var view:ContainerView;
				
		public var firstEntry:Boolean = true;
		
		private var _rect:SwiftRectangle;
		//protected var entityFactory:IEntityFactory;
		private var _entityManager:EntityManager;
		private var _player:Player;
		private var _camera:Camera;
		private var _tileScape:TileScape;
		
		public function Location() {
			
		}
		
		override public function update():void {
			if (paused) return;
			super.update();
			if (subLocation) subLocation.update();
			if (tileScape) tileScape.update();
			if (entityManager) entityManager.update();
			if (camera) camera.update();
			
			//if (entitys) for each (var entity:Entity in entitys) entity.update();
		}
		
		override public function render():void {
			if (paused) return;
			super.render();
			if (tileScape) tileScape.render();
			if (entityManager) entityManager.render();
			if (view) {
				
				// TODO: this block is temporary; it allows the ContainerView to be synced
				// 		 with the x and y values of the actual Location (necessary for proper placement
				//		 of Levels in Areas). 
				if (rect) {
					view.x = rect.x;
					view.y = rect.y;
				}
				
				view.render();
			}
			if (subLocation) subLocation.render();
			//if (entitys) for each (var entity:Entity in entitys) entity.render();
		}
		
		public function goto(location:Object, ...address):void {
			if (location) {
				 
			} else {
				address = (address.length == 1 && address[0] is Array) ? address[0] : address;
				/*for (var i:uint = 0; i < address.length; i++) {
					
				}*/
			}
		}
		
		public function transfer(entity:Entity, activateNewLocation:Boolean = false):void {
			
		}
		
		override public function enter():void {
			
			startup();
		}
		
		private function startup():void {
			// check Story for 
		}
		
		public function positionCamera(user:ICamUser = null, boundary:SwiftRectangle = null, focus:Body = null):void {
			if (camera) {
				camera.user = user;
				camera.setBounds(boundary);
				camera.focus = focus;
			}
		}
		
		public function get rect():SwiftRectangle { return _rect; }
		public function set rect(value:SwiftRectangle):void { _rect = value; }
		
		public function get entityManager():EntityManager { return _entityManager; }
		public function set entityManager(value:EntityManager):void { _entityManager = value; }
		
		public function get player():Player { return _player; }
		public function set player(value:Player):void { _player = value; }
		
		public function get camera():Camera { return _camera; }
		public function set camera(value:Camera):void { _camera = value; }
		
		public function get tileScape():TileScape { return _tileScape; }
		public function set tileScape(value:TileScape):void { _tileScape = value; }
		
		public function get subLocation():Location { return _subLocation; }
		public function set subLocation(value:Location):void { _subLocation = value; }
		
		public function get deepestLocation():Location {
			// if this is the deepest location
			if (!_subLocation) return this;
			// returns the deepest nested subLocation
			var lowerLocation:Location = _subLocation;
			// keep going down until a subLocation has no subLocation
			while (lowerLocation.subLocation) {
				lowerLocation = lowerLocation.subLocation;
			}
			return lowerLocation;
		}
		
		public function get highestLocation():Location {
			// if this is the highest location
			if (!_parent) return this;
			var higherLocation:Location = _parent;
			// keep going up until a parent has no parent
			while (higherLocation.parent) {
				higherLocation = higherLocation.parent;
			}
			return higherLocation;
		}
		
		public function get parent():Location { return _parent; }
		
		public function set parent(value:Location):void { _parent = value; }
		
	}

}