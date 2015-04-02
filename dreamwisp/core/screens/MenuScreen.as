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
		protected var buttons:Vector.<MenuButton>;
		protected var selectedButton:MenuButton;
		
		public var buttonPressed:Signal;
		
		public function MenuScreen(game:Game, mc:MovieClip) 
		{
			super(game);
			this.mc = mc;
			detectButtons();
			
			buttonPressed = new Signal(MenuButton);
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
			var button:MenuButton;
			while (mc.getChildByName("B" + btnNum) != null)
			{
				const btnCode:String = "B" + btnNum; 
				const graphic:DisplayObject = mc.getChildByName(btnCode);
				
				button = makeButton(graphic, btnCode, btnNum);
				addDetectedButton(button);
				
				btnNum++;
			}
		}
		
		protected function makeButton(graphic:DisplayObject, btnCode:String, btnNum:uint):MenuButton 
		{
			var button:MenuButton;
			if (graphic is SimpleButton)
				button = new MenuButton(graphic, btnCode, btnNum);
			else if (graphic is MovieClip)
				button = new MenuButtonMC(graphic, btnCode, btnNum);
			return button;
		}
		
		protected function addDetectedButton(button:MenuButton):void 
		{
			buttons.push(button);
		}
		
		override public function handleInput(inputState:InputState):void 
		{
			super.handleInput(inputState);
			
			const mX:int = inputState.mouseX;
			const mY:int = inputState.mouseY;
			var button:MenuButton = null;
			var btn:MenuButton;
			
			if (!inputState.isTouch() && inputState.isMouseMoving())
			{
				for each (btn in buttons) 
				{
					if (btn.hitTestPoint(mX, mY))
					{
						button = btn;
						if (inputState.isMousePressed() || inputState.wasMouseClicked()) break;
						select(button);
						break;
					}
				}
				// deselect button on mouse out
				if (button == null && selectedButton != null)
					deselect();
			}
			
			if (inputState.isTouch() && inputState.isMousePressed())
			{
				for each (btn in buttons)
				{
					if (btn.hitTestPoint(mX, mY))
					{
						button = btn;
						select(button);
						break;
					}
				}
				if (button == null && selectedButton != null)
					deselect();
			}
			
			if (inputState.wasMouseClicked())
			{
				if (selectedButton != null && selectedButton.hitTestPoint(mX, mY))
				{
					confirm();
				}
			}
		}
		
		protected function select(button:MenuButton):void 
		{
			if (selectedButton != null)
				selectedButton.deselect();
			selectedButton = button;
			button.select();
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
			buttonPressed.dispatch(selectedButton);
		}
		
		protected function handleButtonPress(button:MenuButton):void 
		{
			throw new Error("Must override abstract method handleButtonPress and ignore super call");
		}
		
		private function currentID():uint 
		{
			return buttons.indexOf( selectedButton );
		}
		
	}

}