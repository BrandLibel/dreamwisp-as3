package dreamwisp.entity.components.platformer
{
	import dreamwisp.entity.hosts.Entity;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class PlatformState
	{
		protected var platformPhysics:PlatformPhysics;
		protected var host:Entity;
		
		public function PlatformState(platformPhysics:PlatformPhysics, host:Entity)
		{
			this.platformPhysics = platformPhysics;
			this.host = host;
		}
		
		public function update():void
		{
		
		}
		
		public function enter():void
		{
		
		}
		
		public function moveLeft():void
		{
		
		}
		
		public function moveRight():void
		{
		
		}
		
		public function moveUp():void
		{
		
		}
		
		public function moveDown():void
		{
		
		}
		
		public function jump():void
		{
		
		}
		
		public function collideLeft():void
		{
		
		}
		
		public function collideRight():void
		{
		
		}
		
		public function collideTop():void
		{
		
		}
		
		public function collideBottom():void
		{
		
		}
	
	}

}