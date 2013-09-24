package dreamwisp.entity.components.platformer {
	
	/**
	 * Defines all kinds of movement that a platformer entity can make
	 * @author Brandon
	 */
	
	public interface IPlatformMovementState {
		
		function update():void;
		
		function enter():void;
		
		// universal platformer movement
		function moveLeft():void;
		function moveRight():void;
		function moveUp():void;
		function moveDown():void;
		function jump():void;
		function crouch():void;
		// collision handling
		function collideLeft():void;
		function collideRight():void;
		function collideTop():void;
		function collideBottom():void;
		
	}
	
}