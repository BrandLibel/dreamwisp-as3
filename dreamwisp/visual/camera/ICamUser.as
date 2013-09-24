package dreamwisp.visual.camera {
	
	import flash.geom.Point;
	
	/**
	 * The ICamUser interace defines the functionality of a view
	 * that has a scrollRect which depends on the camera.
	 */
	public interface ICamUser {
		
		/// Sets scroll rect according to the camera position.
		function followCamera(camX:Number, camY:Number):void;
		
	}
	
}