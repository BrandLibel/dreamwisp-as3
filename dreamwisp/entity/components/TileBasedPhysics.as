package dreamwisp.entity.components 
{
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.world.tile.TileScape;
	/**
	 * ...
	 * @author Brandon
	 */
	public class TileBasedPhysics extends Physics 
	{
		protected var tileScape:TileScape;
		protected var tileWidth:uint;
		protected var tileHeight:uint;
		
		public function TileBasedPhysics(entity:Entity, maxSpeedX:Number, maxSpeedY:Number) 
		{
			super(entity, maxSpeedX, maxSpeedY);
		}
		
		public function setTileScape(tileScape:TileScape):void 
		{
			this.tileScape = tileScape;
			tileWidth = tileScape.tileWidth;
			tileHeight = tileScape.tileHeight;
		}
		
	}

}