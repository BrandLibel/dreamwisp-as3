package dreamwisp.input {
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Brandon
	 */
	public interface IInputManager {
		
		function addInputReceptor(receptor:IReceptor):void;
		function removeInputReceptor(receptor:IReceptor):void;
		
		function hearMouseInput(type:String, mouseX:int, mouseY:int):void;
		function hearKeyInput(type:String, keyCode:uint):void;
		
		function get enabledInput():Signal;
		function set enabledInput(value:Signal):void;
		
		function get disabledInput():Signal;
		function set disabledInput(value:Signal):void;
		
	}
	
}