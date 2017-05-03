package dreamwisp.entity.hosts {
	
	import dreamwisp.input.IInputState;
	
	/**
	 * The IPlayer interface defines functionality for
	 * Entitys that can be take input and be controlled by a user.
	 * @author Brandon
	 */
	
	public interface IPlayerControllable extends IEntity {
		
		function handleInput(inputState:IInputState):void;
		
	}
	
}