package dreamwisp.world.base {
		
	/**
	 * ...
	 * @author Brandon
	 */
	public interface IArea extends ILocation {
		
		function get firstEntry():Boolean;
		function set firstEntry(value:Boolean):void;
		
		function get height():uint;
		function set height(value:uint):void;
		
		function get width():uint;
		function set width(value:uint):void;
		
	}
	
}