package dreamwisp.input {
	import org.osflash.signals.Signal;
	
	/**
	 * Used by anything which can receive input
	 * @author Brandon
	 */
	public interface IInputReceptor {
		
		function hearMouseInput(type:String, mouseX:int, mouseY:int):void;
		function hearKeyInput(type:String, keyCode:uint):void;
		
		function get disabledInput():Signal;
		function set disabledInput(value:Signal):void;
		
		function get enabledInput():Signal;
		function set enabledInput(value:Signal):void;
		
	}
	
}