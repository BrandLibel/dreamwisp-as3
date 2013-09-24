package dreamwisp.ui.hud {
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	// create individual HUD modules implementing this interface to handle various kinds of displays
	// such as number, percent, 
	 
	public interface IHUDModule {
		
		function write(data:*):void;
		
		
	}
	
}