package dreamwisp.world.base {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.core.Game;
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.hosts.IEntityFactory;
	import dreamwisp.entity.hosts.IPlayerControllable;
	import dreamwisp.core.GameScreen;
	import dreamwisp.input.InputState;
	import dreamwisp.swift.geom.SwiftRectangle;
	import dreamwisp.visual.ContainerView;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.world.tile.TileScape;
	
	/**
	 * This superclass contains basic functionality
	 * for all types of locations.
	 * @author Brandon Li 
	 */
	
	public class Location extends GameScreen {
			
		/// The index uint of the active sublocation in the list.
		private var activeLocation:uint;
		
		private var _parent:Location;
		private var _subLocation:Location;
		/// List of smaller Locations that form this Location.
		protected var subLocations:Array;
		
		public var firstEntry:Boolean = true;
		
		private var _player:IPlayerControllable;
		private var _tileScape:TileScape;
		
		public function Location(game:Game = null) {
			super(game);
		}
		
		override public function update():void {
			if (paused) return;
			
			if (subLocation) subLocation.update();
			if (tileScape) tileScape.update();
			super.update();
		}
		
		override public function render(interpolation:Number):void {
			if (paused) return;
			if (tileScape) tileScape.render();
			
			if (subLocation) subLocation.render(interpolation);
			super.render(interpolation);
			
		}
		
		public function moveTo(location:Object, ...address):void {
			if (location) {
				 
			} else {
				address = (address.length == 1 && address[0] is Array) ? address[0] : address;
			}
		}
		
		public function transfer(entity:Entity):void {
			
		}
		
		override public function enter():void {
			super.enter();
			startup();
		}
		
		private function startup():void {
			
		}
		
		public function get player():IPlayerControllable { return _player; }
		public function set player(value:IPlayerControllable):void { _player = value; }
		
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