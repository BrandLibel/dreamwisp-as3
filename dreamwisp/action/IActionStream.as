package dreamwisp.action {
	
	import dreamwisp.core.Game;
	
	/**
	 * Abstraction of 
	 * @author Brandon
	 */
	public interface IActionStream {
				
		function get game():Game;
		function set game(value:Game):void;
		
	}
	
}