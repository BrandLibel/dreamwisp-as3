package dreamwisp.visual.particles 
{
	/**
	 * ...
	 * @author Brandon
	 */
	public class CircularParticleArray 
	{
		private var particles:Vector.<Particle>;
		private var start:uint;
		public var numActive:uint;
		
		public function CircularParticleArray(capacity:uint) 
		{
			particles = new Vector.<Particle>(capacity);
			for (var i:int = 0; i < capacity; i++) 
				particles[i] = new Particle();
		}
		
		public function getP(i:uint):Particle
		{
			return particles[(start + i) % particles.length];
		}
		
		public function setP(i:uint, particle:Particle):void
		{
			particles[(start + i) % particles.length] = particle;
		}
		
		public function capacity():uint
		{
			return particles.length;
		}
		
		public function getStart():uint
		{
			return start;
		}
		
		public function setStart(value:uint):void 
		{
			start = value % particles.length;
		}
		
	}

}