package dreamwisp.entity.hosts {
	
	import dreamwisp.entity.components.Actor;
	import dreamwisp.entity.components.Animation;
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.components.Health;
	import dreamwisp.entity.components.Physics;
	import dreamwisp.entity.components.View;
	import dreamwisp.entity.components.Weapon;
	import dreamwisp.input.InputState;
	import dreamwisp.visual.lighting.LightSource;
	import dreamwisp.world.base.Location;
	import org.osflash.signals.Signal;
	
	
	
	public interface IEntity {
		// Actions
		function destroy():void;
		function update():void;
		function render(interpolation:Number):void;
		//function enableInput():void;
		//function disableInput():void;
		
		function get state():String;
		function set state(value:String):void;
		
		// Components
		function get actor():Actor;
        function set actor(value:Actor):void;
        function get physics():Physics;
        function set physics(value:Physics):void
		function get body():Body;
        function set body(value:Body):void;
        function get health():Health
        function set health(value:Health):void
        function get weapon():Weapon;
        function set weapon(value:Weapon):void;
		function get animation():Animation;
		function set animation(value:Animation):void;
        function get view():View;
        function set view(value:View):void;
		function get lightSource():LightSource;
		function set lightSource(value:LightSource):void;
		
		// Signals
		function get entityCreated():Signal;
		function set entityCreated(value:Signal):void;
		function get destroyed():Signal;
		function set destroyed(value:Signal):void;
		function get leftBounds():Signal;
		function set leftBounds(value:Signal):void;
		
		// Dependencies
		function get targets():Vector.<Entity>;
		function set targets(value:Vector.<Entity>):void;
		function get group():Vector.<Entity>;
		function set group(value:Vector.<Entity>):void;
		function get myLocation():Location;
		function set myLocation(value:Location):void;
		
		
	}
	
}