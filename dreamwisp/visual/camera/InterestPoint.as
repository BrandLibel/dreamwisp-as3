package dreamwisp.visual.camera
{
	import dreamwisp.swift.geom.SwiftCircle;
	
	/**
	 * An InterestPoint directs the Camera to linger on certain areas.
	 * @author Brandon
	 */
	public class InterestPoint extends SwiftCircle
	{
		public var innerRadius:Number;
		/// Whether or not the camera shoudl take y position into account
		public var allowVertical:Boolean;
		/// Whether or not the camera shoudl take x position into account
		public var allowHorizontal:Boolean;
		
		public function InterestPoint(x:Number = 0, y:Number = 0, radius:Number = 0, innerRadius:Number = 0, allowVertical:Boolean = false, allowHorizontal:Boolean = true)
		{
			super(x, y, radius);
			this.innerRadius = innerRadius;
			this.allowVertical = allowVertical;
			this.allowHorizontal = allowHorizontal;
		}
	
	}

}