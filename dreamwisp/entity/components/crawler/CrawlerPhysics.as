package dreamwisp.entity.components.crawler 
{
	import dreamwisp.entity.components.Physics;
	import dreamwisp.entity.components.TileBasedPhysics;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.world.tile.Tile;
	
	/**
	 * CrawlerPhysics handles top-down, tile-based 4 direction movement.
	 * It is grid-locked, in contrast to RoamerPhysics which is not.
	 * @author Brandon
	 */
	public class CrawlerPhysics extends TileBasedPhysics 
	{
		private var remainingX:int;
		private var remainingY:int;
		public function CrawlerPhysics(entity:Entity, maxSpeedX:Number, maxSpeedY:Number) 
		{
			super(entity, maxSpeedX, maxSpeedY);
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		override protected function travelX():void 
		{
			if (remainingX > 0)
			{
				super.travelX();
				remainingX -= velocityX;
			}
			
		}
		
		override protected function travelY():void 
		{
			if (remainingY > 0)
			{
				super.travelY();
				remainingX -= velocityX;
			}
			
		}
		
		override public function moveLeft():void 
		{
			if (!isMoving())
				moveTo(row(), col() - 1); 
		}
		
		override public function moveRight():void 
		{
			if (!isMoving())
				moveTo(row(), col() + 1); 
		}
		
		override public function moveUp():void 
		{
			if (!isMoving())
				moveTo(row() - 1, col()); 
		}
		
		override public function moveDown():void 
		{
			if (!isMoving())
				moveTo(row() + 1, col()); 
		}
		
		public function moveTo(row:int, col:int):void 
		{
			if (row < 0 || col < 0 || row > tileScape.gridHeight() - 1 || col > tileScape.gridWidth() - 1)
				return;
			if (tileScape.tileAt(row, col).isCompleteSolid())
				return;
			
			host.body.x = col * tileScape.tileWidth;
			host.body.y = row * tileScape.tileHeight;
		}
		
		public function col():int
		{
			return host.body.x / tileScape.tileWidth;
		}
		
		public function row():int
		{
			return host.body.y / tileScape.tileHeight;
		}
		
	}

}