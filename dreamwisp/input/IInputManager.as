package dreamwisp.input {
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Brandon
	 */
	public interface IInputManager extends IInputReceptor {
		
		function addInputReceptor(receptor:IInputReceptor):void;
		function removeInputReceptor(receptor:IInputReceptor):void;
		
	}
	
}