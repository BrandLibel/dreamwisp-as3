package dreamwisp.ui.menu {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.input.InputState;
	import dreamwisp.input.KeyMap;
	import dreamwisp.ui.menu.MenuButton;
	import dreamwisp.core.GameScreen;
	import dreamwisp.visual.AutoScrollGraphic;
	import dreamwisp.visual.BasicGraphicsFactory;
	import dreamwisp.visual.ContainerView;
	import dreamwisp.visual.IGraphicsFactory;
	import dreamwisp.visual.IGraphicsObject;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import org.osflash.signals.Signal;
	
	/**
	 * MenuBase is a data-driven, generic class and a GameState. 
	 * It constructs itself based on a 'Menu Layout' JSON object.
	 * For button functionality, a class 'Menu' must be created in 
	 * the project folder 
	 * @author Brandon
	 */
	
	// TODO: reduce MenuBase functionality so that it is only a system of buttons.
	//		 Separate unrelated functionality, such as displaying assets. 
	
	public class MenuScreen extends GameScreen {
		
		//public var view:MenuView;
		private var assets:Array = [];
		/// This is the int value representing the active button, for use in arrays.
		private var buttonNum:int = 1;
		/// This is the reference to the active button.
		private var button:MenuButton;
		/// The list of all buttons used in this menu.
		private var buttons:Vector.<MenuButton>;
		
		private var isLayoutHorizontal:Boolean = false;
				
		// Signals 
		public var buttonPressed:Signal;
		
		private var graphicsFactory:IGraphicsFactory;
		private var isDrawing:Boolean = false;
		private var drawHeadX:Number = 0;
		private var drawHeadY:Number = 0;
		
		/// Amount of game cycles between key input button selections.
		protected var MIN_CYCLES_BETWEEN_SEEKS:uint = 3;
		protected var CYCLES_FOR_INITIAL_PRESS:uint = 15;
		private var currentCyclesToWait:uint = 3;
		
		private var seekCounter:uint = 0;
		
		public function MenuScreen(layout:Object, graphicsFactory:IGraphicsFactory) {
			this.graphicsFactory = graphicsFactory;
			
			view = new ContainerView();
			//view.container.visible = false;
			if (layout.numOfButtons == 2) { 
				transitionTimeIn = 0;
				//transitionTimeOut = 0;
				//isConcurrent = true;
				isPopup = true;
			}
			build(layout);
			init();
			
			//view.container.graphics.lineStyle(16, 0x0087BD);
			//0xBBF8FB
			//0xB2FFFF (Celeste)
			//0x0087BD (Natural Color System)
			//drawTo(0, 0);
		}
		
		private function init():void {
			keyMap = new KeyMap();
			keyMap.bind( [Keyboard.SPACE, Keyboard.ENTER, Keyboard.Z, Keyboard.X], null, hitButton );
			keyMap.bind( [Keyboard.LEFT , Keyboard.UP], setInitialPressDelay, removeInitialPressDelay );
			keyMap.bind( [Keyboard.RIGHT , Keyboard.DOWN], setInitialPressDelay, removeInitialPressDelay );

			// defining signals
			buttonPressed = new Signal(String);
		}
				
		private function build(layout:Object):void {
			isLayoutHorizontal = layout.isHorizontal;
			// Adding assets
			if (layout.assets){
				for (var j:uint = 0; j < layout.assets.length; j++) {
					//assets.push(new Asset(layout.assets[j]));
					var asset:Object = layout.assets[j];
					if (!asset.hasOwnProperty("type") || !asset.hasOwnProperty("name")) continue;
					var graphicsObject:IGraphicsObject = graphicsFactory.getGraphicsObject(asset.type, asset.name, asset);
					assets.push(graphicsObject);
					view.addGraphicsObject(graphicsObject, ContainerView.LAYER_BOTTOM);
				}
			}
			// Adding buttons
			buttons = new Vector.<MenuButton>;
			var btn:MenuButton;
			var btnCodePreface:String = "M" + layout.menuNum + "B";
			for (var i:uint = 0; i <= layout.numOfButtons-1; i++) {
				var btnCode:String = btnCodePreface + (i+1);
				buttons.push(new MenuButton(btnCode));
				btn = buttons[i];
				btn.body.x = layout.xMargin + (layout.xSpace * (i));
				btn.body.y = layout.yMargin + (layout.ySpace * (i));
				//view.addDisplayObject( btn.view.movieClip, 1);
				view.addEntity(btn);
				//view.container.addChild(btn.view.movieClip);
				
				btn.update();
				btn.render(1); // immediate render after 
			}
			
			/// disabling all specified buttons 
			var disabledButtons:Array = layout.disabledButtons;
			if (disabledButtons) {
				for (var k:uint = 0; k < disabledButtons.length; k++) {
					btn = buttons[disabledButtons[k].button-1];
					btn.disable();
					/// giving them the property they listen for to be enabled
					//btn.watcher.watchFor(disabledButtons[k].dependency);
					btn.dataProperty = disabledButtons[k].dependency.name;
					//btn.enableUpon(Data.getText(disabledButtons[k].dependency));
					btn.update();
					btn.render(1);
				}
			}
		}
		
		override public function handleInput(inputState:InputState):void {
			super.handleInput(inputState);
			checkForButtonAt(inputState.mouseX, inputState.mouseY);
			if (inputState.wasMouseClicked()) {
				if (checkForButtonAt(inputState.mouseX, inputState.mouseY))
					hitButton();
			}
			
			if (seekCounter == 0) {
				if (keyMap.isDown(Keyboard.UP))
					seekPrevButton();
				if (keyMap.isDown(Keyboard.DOWN))
					seekNextButton();
			}
			
		}
		
		/// Runs all the visual animations of graphics.
		override public function update():void {
			if (paused) return;
			super.update();
			for each (var asset:IGraphicsObject in assets) asset.update();
			for each (var button:MenuButton in buttons) button.update();
			const stepDist:uint = 8;
			drawHeadX += stepDist;
			drawHeadY += stepDist;
			if (isDrawing) {
				view.container.graphics.lineTo(drawHeadX, drawHeadY);
				/*view.container.graphics.moveTo(drawHeadX - 8*2, drawHeadY - 8*2);
				view.container.graphics.lineStyle(8, 0xFFFFFF);
				view.container.graphics.lineTo(drawHeadX, drawHeadY);
				view.container.graphics.lineStyle(16, 0xBBF8FB);*/
			}
			if (seekCounter > 0)
				seekCounter--;
		}
		
		private function drawTo(targetX:Number, targetY:Number):void {
			isDrawing = true;
		}
		
		override public function render(interpolation:Number):void {
			if (paused) return;
			super.render(interpolation);
			for each (var asset:IGraphicsObject in assets) asset.render();
			for each (var button:MenuButton in buttons) button.render(interpolation);
			view.render(interpolation);
		}
		
		override public function enter():void {
			super.enter();
			/*takesInput = true;
			view.container.visible = true;
			view.container.alpha = 0;*/
			selectButton();
			/// check disabled buttons to see if they've become enabled
			for (var i:uint = 1; i < buttons.length; i++) {
				//buttons[i].watcher.check();
				if (buttons[i].isEnabled == false) buttons[i].check();
			}
		}
		
		private function setInitialPressDelay():void {
			currentCyclesToWait = CYCLES_FOR_INITIAL_PRESS;
		}
		
		private function removeInitialPressDelay():void {
			MonsterDebugger.trace(this, "zero");
			currentCyclesToWait = 0;
			seekCounter = 0;
		}
		
		private function resetSeekCounter():void {
			MonsterDebugger.trace(this, "setting seek counter");
			seekCounter = currentCyclesToWait;
			// if min cycl btw seeks > some amount, reset it to default
			if (currentCyclesToWait >= MIN_CYCLES_BETWEEN_SEEKS)
				currentCyclesToWait = MIN_CYCLES_BETWEEN_SEEKS;
		}
		
		private function seekNextButton():void {
			resetSeekCounter();
			var tempButtonNum:int = buttonNum;
			// currently on the last button? loop by going to the first
			if (tempButtonNum == buttons.length -1)
				tempButtonNum = 0;
			else
				tempButtonNum++;
			// visuals - unselect current, select new
			buttons[buttonNum].deselect();
			buttonNum = tempButtonNum;
			button = buttons[buttonNum];
			button.highlight();

			//selectButton(tempButtonNum);
		}
		
		private function seekPrevButton():void {
			resetSeekCounter();
			var tempButtonNum:int = buttonNum;
			// currently on the first button? loop by going to the last
			if (tempButtonNum == 0)
				tempButtonNum = buttons.length -1;
			else 
				tempButtonNum--;
			// visuals - unselect current, select new
			buttons[buttonNum].deselect();
			buttonNum = tempButtonNum;
			button = buttons[buttonNum];
			button.highlight();
			//selectButton(tempButtonNum);
		}
		
		private function scrollForward():void {
			selectButton(0, 1);
		}
		
		private function scrollBack():void {
			selectButton(0, -1);
		}
		
		private function checkForButtonAt(mouseX:int, mouseY:int):Boolean {
			for (var i:uint = 0; i < buttons.length; i++) {
				var btn:MenuButton = buttons[i];
				if (btn.body.touchesPoint(mouseX, mouseY)) {
					if (this.buttonNum != i)
						selectButton(i);
					return true;
				}
			}
			return false;
		}
		
		
		
		/**
		 * Makes the specified button the active button and visually highlights it.
		 * @param	buttonNum The int value of the button to select directly.
		 * @param	change The 
		 */
		private function selectButton(buttonNum:uint = 0, change:int = 0):void {
			// TODO: when at the last button in the list, going further should return and
				// select the first button.
			if (change == 0) {
				this.buttonNum = buttonNum;
			} else {
				this.buttonNum += change;
				if (this.buttonNum < 0) this.buttonNum = (buttons.length - 1);
				if (this.buttonNum > buttons.length - 1) this.buttonNum = 0;//buttons.length - 1;//1;
				while (buttons[this.buttonNum].isEnabled == false) this.buttonNum += change;
			}
			if (button) {
				if (button.name != buttons[this.buttonNum].name) this.button.deselect();
			}
			if (buttons[this.buttonNum].isEnabled == false){
				button = null;
			} else {
				button = buttons[this.buttonNum];
				button.highlight();
			}
		}
		
		private function hitButton():void {
			if (buttonPressed.numListeners == 0)
				throw new Error("The Menu's buttonPressed signal has no listeners! Add some!");
			buttonPressed.dispatch(button.name);
		}
		
	}

}