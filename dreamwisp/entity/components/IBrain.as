package dreamwisp.entity.components {
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public interface IBrain {
		
		function think():void;
		function act():void;
		function perform(action:Function):void;
		function prepare(action:Function):void;
		
	}
	
}