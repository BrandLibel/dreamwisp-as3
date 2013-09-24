package dreamwisp.visual {
	
	/**
	 * The IVideo interface defines basic functionality of all
	 * videos and video-player functionality. 
	 * @author Brandon
	 */
	public interface IVideo {
		
		function rewind():void;
		function pause():void;
		function play():void;
		function fastForward():void;
		function skip():void;
		function update():void;
		
	}
	
}