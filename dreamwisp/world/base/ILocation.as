package dreamwisp.world.base {
	
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.entity.hosts.IEntity;
	import dreamwisp.entity.hosts.IPlayer;
	import dreamwisp.swift.geom.SwiftRectangle;
	import dreamwisp.visual.camera.Camera;
	import dreamwisp.core.IUpdatable;
	import dreamwisp.world.tile.TileScape;
	
	/**
	 * This interface defines funcitons and properties of Locations.
	 * @author Brandon
	 */
	public interface ILocation extends IUpdatable {
		
		function goto(location:Object, ...address):void;
		function enter():void;
		
		function transfer(entity:Entity):void;
		
		function get player():IPlayer;
		function set player(value:IPlayer):void;
		
		function get tileScape():TileScape;
		function set tileScape(value:TileScape):void;
	}
	
}