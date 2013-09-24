package dreamwisp.state {
	
	import dreamwisp.core.Game;
	import dreamwisp.input.IReceptor;
	import dreamwisp.visual.ContainerView;
	
	/**
	 * ...
	 * @author Brandon
	 */
	public interface IGameState extends IReceptor {
		
		function enter():void;
		function cleanup():void;
		
		function pause():void;
		function resume():void;
		
		function changeState(bridgeData:Object):void;
		
		function enableInput():void;
		function disableInput():void;
		
		function update():void;
		function render():void;
		
		function setGame(game:Game):void;
		
		function get view():ContainerView;	
		function set view(value:ContainerView):void;
		
		function get transition():TransitionManager;
		function set transition(value:TransitionManager):void;
	
	}
	
}