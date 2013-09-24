package dreamwisp.data {
	
	/**
	 * ...
	 * @author Brandon
	 */
	public interface IField {
		
		
		/// Changes the name of the field
		function rename():void;
		
		/// Clears the value of the field
		function reset():void;
		
		/// Destroys both the name and value of the field
		function wipe():void;
		
	}
	
}