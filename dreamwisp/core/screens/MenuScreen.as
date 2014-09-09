package dreamwisp.core.screens 
{
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.core.Game;
	import dreamwisp.core.GameScreen;
	import dreamwisp.input.InputState;
	import dreamwisp.input.KeyMap;
	import dreamwisp.visual.ContainerView;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Brandon
	 */
	public class MenuScreen extends GameScreen 
	{
		protected var mc:MovieClip;
		private var buttons:Vector.<MenuButton>;
		protected var selectedButton:MenuButton;
		
		public var buttonPressed:Signal;
		
		public function MenuScreen(game:Game, mc:MovieClip) 
		{
			super(game);
			this.mc = mc;
			detectButtons();
			
			buttonPressed = new Signal(String);
			buttonPressed.add(handleButtonPress);
			
			view = new ContainerView();
			view.addDisplayObject(mc);
		}
		
		override public function update():void 
		{
			super.update();
			for each (var menuButton:MenuButton in buttons) 
				menuButton.update();
		}
		
		protected function scrollPrev():void 
		{
			const id:int = currentID() - 1;
			
			var mod:int = (id % buttons.length);
			if (mod < 0)
				mod += buttons.length;
			selectID( mod );
		}
		
		protected function scrollNext():void 
		{
			selectID( (currentID() + 1) % buttons.length );
		}
		
		/**
		 * Adds all buttons of the MenuScreen MovieClip into the buttons vector.
		 * Override when using different button naming scheme or special behavior.
		 */
		protected function detectButtons():void 
		{
			buttons = new Vector.<MenuButton>();
			var btnNum:uint = 1;
			while (mc.getChildByName("B" + btnNum) != null)
			{
				const btnCode:String = "B" + btnNum; 
				const child:DisplayObject = mc.getChildByName(btnCode);
				if (child is SimpleButton)
					buttons.push(new MenuButton(child, btnCode)); 
				else if (child is MovieClip)
					buttons.push(new MenuButtonMC(child, btnCode));
				btnNum++;
			}
		}
		
		override public function handleInput(inputState:InputState):void 
		{
			super.handleInput(inputState);
			
			const mX:int = inputState.mouseX;
			const mY:int = inputState.mouseY;
			var button:MenuButton = null;
			
			if (inputState.isMouseMoving() || inputState.isMousePressed || inputState.wasMouseClicked())
			{
				for each (var btn:MenuButton in buttons) 
				{
					if (btn.hitTestPoint(mX, mY))
					{
						button = btn;
						break;
					}
					// deselect button on mouse out
					else if (selectedButton != null)
						deselect();
				}
				if (button != null)
				{
					select(button);
					if (inputState.wasMouseClicked())
						confirm();
				}
			}
		}
		
		protected function select(button:MenuButton):void 
		{
			if (selectedButton != null)
				selectedButton.deselect();
			selectedButton = button;
			button.select();;
		}
		
		/**
		 * Deselects the current button. Called when mouse is away from any button.
		 */
		protected function deselect():void 
		{
			selectedButton.deselect();
			selectedButton = null;
		}
		
		protected function selectID(btnID:uint):void 
		{
			select(buttons[btnID]);
		}
		
		protected function confirm():void 
		{
			const btnCode:String = selectedButton.btnCode;
			buttonPressed.dispatch(btnCode);
		}
		
		protected function handleButtonPress(btnCode:String):void 
		{
			throw new Error("Must override abstract method handleButtonPress and ignore super call");
		}
		
		private function currentID():uint 
		{
			return buttons.indexOf( selectedButton );
		}
		
	}

}