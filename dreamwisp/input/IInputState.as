package dreamwisp.input
{
	public interface IInputState
	{
		function isTouch():Boolean;
		function isMouseMoving():Boolean;
		function wasMouseClicked():Boolean;
		function isMousePressed():Boolean;
		function lastKeyReleased():int;
		function wasKeyReleased(keyCode:uint):Boolean;
		function wasKeyPressed(keyCode:uint):Boolean;
		function isKeyDown(keyCode:uint):Boolean;
		function reset():void;
		function get mouseX():int;
		function set mouseX(value:int):void;
		function get mouseY():int;
		function set mouseY(value:int):void;
	}

}