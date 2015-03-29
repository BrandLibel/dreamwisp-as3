package dreamwisp.swift.geom
{
	
	/**
	 * A circle is a point with a radius.
	 * @author Brandon
	 */
	public class SwiftCircle extends SwiftPoint
	{
		public var radius:Number;
		
		public function SwiftCircle(x:Number = 0, y:Number = 0, radius:Number = 0)
		{
			super(x, y);
			this.radius = radius;
		}
	
	}

}