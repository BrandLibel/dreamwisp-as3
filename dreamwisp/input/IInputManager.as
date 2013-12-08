package dreamwisp.input {
	
	import org.osflash.signals.Signal;
	
	/**
	 * IInputManager defines functionality for handling multiple InputReceptors.
	 * Extends IInputReceptor because the manager may also need to receive input data
	 * from an outside source.
	 * @author Brandon
	 */
	
	public interface IInputManager extends IInputReceptor {
		
		function impossibleAction():void;
		
		function addInputReceptor(receptor:IInputReceptor):void;
		function removeInputReceptor(receptor:IInputReceptor):void;
		
		function get heardMouseInput():Signal;
		function set heardMouseInput(value:Signal):void;
		function get heardKeyInput():Signal;
		function set heardKeyInput(value:Signal):void;
		
	}
	
}