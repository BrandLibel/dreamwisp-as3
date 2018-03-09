package dreamwisp.core.screens 
{
	import dreamwisp.core.Game;
	import dreamwisp.core.GameScreen;
	import dreamwisp.input.IInputState;
	import dreamwisp.visual.ContainerView;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Brandon
	 */
	public class MenuScreen extends GameScreen 
	{
		protected var container:DisplayObjectContainer;
		protected var buttons:Vector.<MenuButton>;
		protected var selectedButton:MenuButton;
		
		public var buttonPressed:Signal;
		
		public function MenuScreen(game:Game, container:DisplayObjectContainer) 
		{
			super(game);
			this.container = container;
			buttons = new Vector.<MenuButton>();
			detectButtons();
			
			buttonPressed = new Signal(MenuButton);
			buttonPressed.add(handleButtonPress);
			
			view = new ContainerView();
			view.addDisplayObject(container);
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
		 * 
		 * @param	parent Defaults to the MenuScreen container if not specified
		 * @param	btnArray Defaults to the member variable 'buttons' if not specified
		 * @param	startingIndex The number of the first button in the provided parent
		 * @return
		 */
		protected function detectButtons(parent:DisplayObjectContainer = null, btnArray:Vector.<MenuButton> = null, startingIndex:uint = 1):Vector.<MenuButton> 
		{
			if (parent == null) parent = container;
			
			var btnNum:uint = startingIndex;
			var button:MenuButton;
			while (parent.getChildByName("B" + btnNum) != null)
			{
				const btnCode:String = "B" + btnNum; 
				const graphic:DisplayObject = parent.getChildByName(btnCode);
				
				button = makeButton(graphic, btnCode, btnNum);
				addDetectedButton(button, btnArray);
				
				btnNum++;
			}
			
			return btnArray;
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
		
		protected function addDetectedButton(button:MenuButton, btnArray:Vector.<MenuButton> = null):void 
		{
			if (btnArray == null) btnArray = buttons;
			btnArray.push(button);
		}
		
		override public function handleInput(inputState:IInputState):void 
		{
			super.handleInput(inputState);
			
			const mX:int = inputState.mouseX;
			const mY:int = inputState.mouseY;
			var button:MenuButton = null;
			var btn:MenuButton;
			
			// Removed the check for isMoving since it prevents clicking a button
			// after the first time without moving.
			if (!inputState.isTouch() /*&& inputState.isMouseMoving()*/)
			{
				for each (btn in buttons) 
				{
					if (btn.hitTestPoint(mX, mY))
					{
						button = btn;
						if (inputState.isMousePressed() || inputState.wasMouseClicked())
						{
							break;
						}
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
		
		/**
		 * Returns a button with the specified btnCode
		 * @param	btnCode a string in "B" + N format, where N is a integer >= 1
		 */
		public function getButton(btnCode:String):MenuButton
		{
			return buttons[uint(btnCode.substr(1)) - 1];
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
		
		public function get mc():MovieClip { return container as MovieClip; }
		
	}

}