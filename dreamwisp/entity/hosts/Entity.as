package dreamwisp.entity.hosts
{
	import dreamwisp.core.GameScreen;
	import dreamwisp.entity.components.Actor;
	import dreamwisp.entity.components.Animation;
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.components.Health;
	import dreamwisp.entity.components.Physics;
	import dreamwisp.entity.components.View;
	import dreamwisp.entity.components.Weapon;
	import dreamwisp.visual.lighting.LightSource;
	import dreamwisp.world.base.EntityManager;
	import dreamwisp.world.base.Location;
	import flash.utils.getDefinitionByName;
	import org.osflash.signals.Signal;
	import tools.Belt;
	
	
	/**
	 * Entitys are objects which populate GameStates (containers). 
	 */
	
	public class Entity implements IEntity
	{
		private var _name:String;
		public var actorID:uint;
		
		private var _actor:Actor;
		private var _body:Body;
		private var _health:Health;
		private var _weapon:Weapon;
		private var _animation:Animation;
		private var _view:View;
		private var _lightSource:LightSource;
		public var _physics:Physics;
		
		private var _entityCreated:Signal;
		private var _destroyed:Signal;
		private var _leftBounds:Signal;
		private var _disabledInput:Signal;
		private var _enabledInput:Signal;
		
		private var _myLocation:Location;
		private var _entityManager:EntityManager;
		private var _myScreen:GameScreen;
		
		protected var isMobile:Boolean = true;		
				
		public function Entity(prototypeData:Object = null, prototypeID:uint = 0) 
		{
			entityCreated = new Signal(Entity);
			destroyed = new Signal(Entity);
			leftBounds = new Signal(Entity);
			
			enabledInput = new Signal(Entity);
			disabledInput = new Signal(Entity);
			
			if (!prototypeData)
				return;
			// Any prototype data not handled here should be intercepted in the subclass constructor
			var hosts:Array = prototypeData.hosts;
			var components:Object = prototypeData.components;
			var myData:Object = hosts[prototypeID];
			if (myData.name)
			{
				name = myData.name;
			}
			if (myData.body != null)
			{
				var bodyData:Object = components["body"][myData.body];
				body = new Body(this, bodyData.width, bodyData.height);
			}
			if (myData.health != null)
			{
				health = new Health(this, myData.health);
			}
			if (myData.physics != null)
			{
				var physicsData:Object = components["physics"][myData.physics];
				var physicsClass:Class = getDefinitionByName(physicsData.classLink) as Class;
				physics = new physicsClass(this, physicsData.maxWalkSpeed,
					physicsData.walkAcceleration, physicsData.jumpPower);
			}
			if (myData.view != null)
			{
				view = new View(this);
				var strings:Array = myData.view.split("_");
				if (strings[0] == "mc")
					view.movieClip = Belt.addClassFromLibrary( strings[1], Belt.CLASS_MOVIECLIP );
				//else
					// "ss" - access spritesheet statically 
			}
		}
		
		/**
		 * Simple destruction of this Entity object.
		 */
		public function destroy():void {
			destroyed.dispatch(this);
		}
		
		public function update():void {
			
			//if (physics) physics.update();
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
		
		public function get entityManager():EntityManager { return _entityManager; }
		
		public function set entityManager(value:EntityManager):void { _entityManager = value; }
		
		public function get myLocation():Location { return _myLocation; }
		
		public function set myLocation(value:Location):void {
			// entity has switched locations...
			_myLocation = value;
		}
		
		public function get leftBounds():Signal { return _leftBounds; }
		
		public function set leftBounds(value:Signal):void { _leftBounds = value; }
		
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
		
		public function get myScreen():GameScreen { return _myScreen; }
		
		public function set myScreen(value:GameScreen):void { _myScreen = value; }
		
		
	}

}