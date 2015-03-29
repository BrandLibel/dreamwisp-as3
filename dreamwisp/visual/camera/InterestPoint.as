package dreamwisp.visual.camera
{
	import dreamwisp.swift.geom.SwiftCircle;
	
	/**
	 * A camera interest point is a circle with a second (inner) radius.
	 * @author Brandon
	 */
	public class InterestPoint extends SwiftCircle
	{
		public var innerRadius:Number;
		public function InterestPoint(x:Number = 0, y:Number = 0, radius:Number = 0, innerRadius:Number = 0)
		{
			super(x, y, radius);
			this.innerRadius = innerRadius;
		}
	
	}

}