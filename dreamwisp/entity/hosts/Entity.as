package dreamwisp.entity.hosts {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.components.Actor;
	import dreamwisp.entity.components.Animation;
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.components.Health;
	import dreamwisp.entity.components.Physics;
	import dreamwisp.entity.components.View;
	import dreamwisp.entity.components.Weapon;
	import dreamwisp.entity.hosts.IEntity;
	import dreamwisp.input.InputState;
	import dreamwisp.visual.lighting.LightSource;
	import dreamwisp.world.base.Location;
	import org.osflash.signals.Signal;
	
	/**
	 * Entitys are objects which populate GameStates (containers). 
	 */
	
	public class Entity implements IEntity {
		
		private var _name:String;
		public var actorID:uint;
		public var groupName:String;
		/// Name of the entitys it can target for combat
		public var targetName:String;
		
		private var _actor:Actor;
		private var _physics:Physics;
		private var _body:Body;
		private var _health:Health;
		private var _weapon:Weapon;
		private var _animation:Animation;
		private var _view:View;
		private var _lightSource:LightSource;
		
		private var _entityCreated:Signal;
		private var _destroyed:Signal;
		private var _leftBounds:Signal;
		private var _disabledInput:Signal;
		private var _enabledInput:Signal;
		
		private var _targets:Vector.<Entity>;
		private var _interactibles:Vector.<Entity>;
		private var _group:Vector.<Entity>;
		
		private var _state:String = "falling";
		private var _myLocation:Location;
		
		protected var isMobile:Boolean = true;
		
		//protected var takesInput:Boolean = false;
		
		
		public function Entity() {
			entityCreated = new Signal(Entity);
			destroyed = new Signal(Entity);
			leftBounds = new Signal(Entity);
			
			enabledInput = new Signal(Entity);
			disabledInput = new Signal(Entity);
		}
		
		/**
		 * Simple destruction of this Entity object.
		 * Involves removing Entity from its Location and Group, so that
		 * it might be created again.
		 */
		public function destroy():void {
			destroyed.dispatch(this);
			if (group) group.splice ( group.indexOf(this), 1 );
		}
		
		public function update():void {
			
			if (physics) physics.update();
			if (animation) animation.update();
			//if (hasLeftBounds()) leftBounds.dispatch(this);
		}
		
		public function render(interpolation:Number):void {
			if (view) view.render(interpolation);
			if (lightSource) lightSource.render();
		}
		
		/**
		 * Action to take when the Entity reaches an edge of the Location;
		 */ 
		
		/*public function onReachBounds():void {
			//TODO: override for each individual entity. Does it stop? Change direction? Move to new location? Die? Teleport?
		}*/
		
		public function immobilize():void {
			isMobile = false;
		}
		
		public function mobilize():void {
			isMobile = true;
		}
		
		// IEntity extends IRecptor, so all entitys get input listeners 
		
		/*public function enableInput():void {
			//takesInput = true;
			enabledInput.dispatch(this);
		}
		
		public function disableInput():void {
			//takesInput = false;
			disabledInput.dispatch(this);
		}*/
		
		/*public function hearMouseInput(type:String, mouseX:int, mouseY:int):void {
			
		}*/
		
		/*public function hearKeyInput(type:String, keyCode:uint):void {
			
		}*/
		
		protected function hasLeftBounds():Boolean {
			if (myLocation) {
				if ((body.globalX + body.width / 2) >= myLocation.rect.right) {
					return true;
				}
				if ((body.globalX + body.width / 2) <= myLocation.rect.left) {
					return true;
				}
				if ((body.globalY + body.height / 2) <= myLocation.rect.top) {
					return true;
				}
				if ((body.globalY + body.height / 2) >= myLocation.rect.bottom) {
					return true;
				}
			}
			return false;
		}
		
		public function get actor():Actor { return _actor; }
		
		public function set actor(value:Actor):void { _actor = value; }
						
		public function get physics():Physics { return _physics; }
		
		public function set physics(value:Physics):void { _physics = value; }
		
		public function get body():Body { return _body; }
		
		public function set body(value:Body):void { _body = value; }
		
		public function get health():Health { return _health; }
		
		public function set health(value:Health):void { _health = value; }
		
		public function get weapon():Weapon { return _weapon; }
		
		public function set weapon(value:Weapon):void { _weapon = value; }
		
		public function get animation():Animation { return _animation; }
		
		public function set animation(value:Animation):void { _animation = value; }
		
		public function get view():View { return _view; }
		
		public function set view(value:View):void { _view = value; }
		
		public function get entityCreated():Signal { return _entityCreated; }
		
		public function set entityCreated(value:Signal):void { _entityCreated = value; }
		
		public function get destroyed():Signal { return _destroyed; }
		
		public function set destroyed(value:Signal):void { _destroyed = value; }
		
		public function get state():String { return _state; }
		
		public function set state(value:String):void { _state = value; }
		
		public function get targets():Vector.<Entity> { return _targets; }
		
		public function set targets(value:Vector.<Entity>):void { _targets = value; }
		
		public function get group():Vector.<Entity> { return _group; }
		
		public function set group(value:Vector.<Entity>):void {
			// When setting the group of an entity, the entity
			// automatically removes itself from the old and adds
			// itself to the new
			if (_group) _group.splice ( _group.indexOf(this), 1 );
			_group = value;
			_group.push(this);
		}
		
		public function get myLocation():Location { return _myLocation; }
		
		public function set myLocation(value:Location):void {
			// entity has switched locations...
			_myLocation = value;
			/*leftBounds.removeAll();
			leftBounds.addOnce(myLocation.parent.transfer);*/
		}
		
		public function get leftBounds():Signal { return _leftBounds; }
		
		public function set leftBounds(value:Signal):void { _leftBounds = value; }
		
		public function get interactibles():Vector.<Entity> { return _interactibles; }
		
		public function set interactibles(value:Vector.<Entity>):void { _interactibles = value; }
		
		public function get disabledInput():Signal { return _disabledInput; }
		
		public function set disabledInput(value:Signal):void { _disabledInput = value; }
		
		public function get enabledInput():Signal { return _enabledInput; }
		
		public function set enabledInput(value:Signal):void { _enabledInput = value; }
		
		public function get lightSource():LightSource { return _lightSource; }
		
		public function set lightSource(value:LightSource):void { _lightSource = value; }
		
		public function get name():String {
			return _name;
		}
		
		public function set name(value:String):void {
			_name = value;
		}
		
		
	}

}