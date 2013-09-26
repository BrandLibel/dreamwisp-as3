package dreamwisp.world.base {
	
	import dreamwisp.swift.geom.SwiftRectangle;
	import dreamwisp.visual.camera.Camera;
	import dreamwisp.core.IUpdatable;
	import dreamwisp.state.IGameState;
	import dreamwisp.world.tile.TileScape;
	import project.entity.hosts.Player;
	
	/**
	 * This interface defines funcitons and properties of Locations.
	 * @author Brandon
	 */
	public interface ILocation extends IUpdatable {
		
		function goto(location:Object, ...address):void;
		function enter():void;
				
		function get rect():SwiftRectangle;
		function set rect(value:SwiftRectangle):void;
		function get entityManager():EntityManager;
		function set entityManager(value:EntityManager):void;
		function get player():Player;
		function set player(value:Player):void;
		function get camera():Camera;
		function set camera(value:Camera):void;
		function get tileScape():TileScape;
		function set tileScape(value:TileScape):void;
	}
	
}