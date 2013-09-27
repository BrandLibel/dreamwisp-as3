package dreamwisp.state {
	
	import dreamwisp.core.Game;
	import dreamwisp.input.IInputReceptor;
	import dreamwisp.swift.geom.SwiftRectangle;
	import dreamwisp.visual.camera.Camera;
	import dreamwisp.visual.ContainerView;
	import dreamwisp.world.base.EntityManager;
	
	/**
	 * ...
	 * @author Brandon
	 */
	public interface IGameState extends IInputReceptor {
		
		function enter():void;
		function cleanup():void;
		
		function pause():void;
		function resume():void;
		
		function changeState(bridgeData:Object):void;
		
		function enableInput():void;
		function disableInput():void;
		
		function update():void;
		function render():void;
		
		function setGame(game:Game):void;
		
		function get view():ContainerView;	
		function set view(value:ContainerView):void;
		
		function get transition():TransitionManager;
		function set transition(value:TransitionManager):void;
		
		function get rect():SwiftRectangle;
		function set rect(value:SwiftRectangle):void;
		function get entityManager():EntityManager;
		function set entityManager(value:EntityManager):void;
		function get camera():Camera;
		function set camera(value:Camera):void;
	
	}
	
}