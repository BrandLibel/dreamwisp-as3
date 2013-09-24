package dreamwisp.ui.menu {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.input.KeyMap;
	import dreamwisp.ui.menu.MenuButton;
	import dreamwisp.state.GameState;
	import dreamwisp.state.TransitionManager;
	import dreamwisp.visual.ContainerView;
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
	
	public class Menu extends GameState {
		
		//public var view:MenuView;
		private var assets:Array = [];
		/// This is the int value representing the active button, for use in arrays.
		private var buttonNum:int = 1;
		/// This is the reference to the active button.
		private var button:MenuButton;
		/// The list of all buttons used in this menu.
		private var buttons:Vector.<MenuButton>;
		
		private var orientation:String;
		
		private var keyMap:KeyMap;
		
		// Signals 
		public var buttonPressed:Signal;
		
		public function Menu(layout:Object) {
			//MonsterDebugger.trace(this, layout);
			view = new MenuView();
			build(layout);
			init();
		}
		
		private function init():void {
			keyMap = new KeyMap();
			keyMap.bind( [Keyboard.SPACE, Keyboard.ENTER, Keyboard.Z, Keyboard.X], null, hitButton );
			keyMap.bind( ((orientation == Data.text.ORIENT_HORIZONTAL) ? Keyboard.LEFT : Keyboard.UP), scrollBack );
			keyMap.bind( ((orientation == Data.text.ORIENT_HORIZONTAL) ? Keyboard.RIGHT : Keyboard.DOWN), scrollForward );
			//keyMap.clear(Keyboard.SPACE);
			
			// GameState
			transition = new TransitionManager(view);
			
			heardKeyInput.add(keyMap.receiveKeyInput);
			
			// defining signals
			buttonPressed = new Signal(String);
		}
		
		private function noAction():void {
			MonsterDebugger.trace(this, "nothing");
		}
		
		private function scrollForward():void {
			selectButton(0, 1);
		}
		
		private function scrollBack():void {
			selectButton(0, -1);
		}
		
		/*private function confirmButton():void {
			// override this
		}*/
		
		private function build(layout:Object):void {
			this.orientation = layout.orientation;
			/// Adding assets
			if (layout.assets){
				for (var j:uint = 0; j < layout.assets.length; j++) {
					assets.push(new Asset(layout.assets[j]));
					var assetMC:MovieClip = assets[j].movieClip;
					//view.addGraphic(assetMC, assetMC.x, assetMC.y, MenuView.LAYER_ASSETS); 
					view.addDisplayObject(assetMC, ContainerView.LAYER_BOTTOM, assetMC.x, assetMC.y);
				}
			}
			/// Adding buttons
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
				btn.render(); // immediate render after 
			}
			
			/// disabling all specified buttons 
			var disabledButtons:Array = layout.disabledButtons;
			if (disabledButtons) {
				for (var k:uint = 0; k < disabledButtons.length; k++) {
					btn = buttons[disabledButtons[k].button-1];
					btn.disable();
					/// giving them the property they listen for to be enabled
					btn.watcher.watchFor(disabledButtons[k].dependency);
					btn.dataProperty = disabledButtons[k].dependency.name;
					//btn.enableUpon(Data.getText(disabledButtons[k].dependency));
					btn.update();
					btn.render();
				}
			}
		}
		
		override public function hearMouseInput(type:String, mouseX:int, mouseY:int):void {
			if (paused || !takesInput) return;
			checkForButtonAt(mouseX, mouseY);
			if (type == MouseEvent.CLICK) {
				if (checkForButtonAt(mouseX, mouseY)) hitButton();//button.hit();
			}
		}
		
		private function checkForButtonAt(mouseX:int, mouseY:int):Boolean {
			for (var i:uint = 0; i < buttons.length; i++) {
				var btn:MenuButton = buttons[i]
				if (mouseX >= btn.body.x && mouseX <= btn.body.x + btn.body.width) {
					if (mouseY >= btn.body.y && mouseY <= btn.body.y + btn.body.height) {
						if (this.buttonNum != i) {
							selectButton(i);
						}
						return true;
					}
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
		
		/// Runs all the visual animations of graphics.
		override public function update():void {
			if (paused) return;
			super.update();
			for each (var asset:Asset in assets) asset.update();
			for each (var button:MenuButton in buttons) button.update();
		}
		
		override public function render():void {
			if (paused) return;
			super.render();
			for each (var asset:Asset in assets) asset.render();
			for each (var button:MenuButton in buttons) button.render();
			view.render();
		}
		
		override public function enter():void {
			takesInput = true;
			view.container.visible = true;
			view.container.alpha = 0;
			selectButton();
			/// check disabled buttons to see if they've become enabled
			for (var i:uint = 1; i < buttons.length; i++) {
				buttons[i].watcher.check();
				if (buttons[i].isEnabled == false) buttons[i].check();
			}
		}
		
		public function exit():void {
			view.container.visible = false;
		}
		
		private function hitButton():void {
			//button.hit();
			if (buttonPressed.numListeners == 0) {
				throw new Error("The Menu's buttonPressed signal has no listeners! Add some!");
			}
			buttonPressed.dispatch(button.name);
		}
		
	}

}



// MENU code


//package project.menu {
	//
	//import dreamwisp.menu.MenuBase;
	//import flash.events.MouseEvent;
	//
	///**
	 //* ...
	 //* @author Brandon
	 //*/
	//public class Menu extends MenuBase {
		//
		//public function Menu(layout:Object) {
			//super(layout, confirmButton);
		//}
		//
		//private function confirmButton():void {
			//hitButton(button.name);
		//}
		//
		//override protected function hitButton(buttonCode:String):void {
			//super.hitButton(buttonCode);
			//var bridgeData:Object;
			//
			//switch (buttonCode) {
				//case "M1B1": // New Game button, brings up overwrite game prompt 
					//
					// two transition objects, defined here, passed to transition.exit and transition.entry for the bridged game states
					///*bridgeData = {
						//myExitTransition: { type: "alpha", startVal: 1, targetVal: 0, speed: 0.05 },
						//newState: game.menus[2],
						//transition: { type: "alpha", startVal: 0, targetVal: 1, speed: 0.05 }
					//}
					//startStateChange(bridgeData);*/
					//
					//changeState(
						//{
							//myExitTransition: { type: "alpha", startVal: 1, targetVal: 0, speed: 0.05 },
							//newState: game.menus[2],
							//transition: { type: "alpha", startVal: 0, targetVal: 1, speed: 0.05 }
						//}
					//);
					//
					//break;
				//case "M1B2": // Load game button
					//game.loadGame();
					//break;
				//case "M1B3": // Options button
					//break;
				//case "M2B1": // Overwrite game prompt to start new game
					//
					///*bridgeData = {
						//myExitTransition: { type: "alpha", startVal: 1, targetVal: 0, speed: 0.05 },
						//action: game.newGame,
						//transition: { type: "alpha", startVal: 0, targetVal: 1, speed: 0.05 }
					//}
					//startStateChange(bridgeData);*/
					//
					//changeState(
						//{
							//myExitTransition: { type: "alpha", startVal: 1, targetVal: 0, speed: 0.05 },
							//action: game.newGame
						//}
					//);
					//
					//break;
				//case "M2B2":
					//Data.save("test lolol");
					//
					///*bridgeData = {
						//myExitTransition: { type: "alpha", startVal: 1, targetVal: 0, speed: 0.05 },
						//newState: game.menus[1],
						//transition: { type: "alpha", startVal: 0, targetVal: 1, speed: 0.05 }
					//}
					//startStateChange(bridgeData);*/
					//changeState(
						//{
							//myExitTransition: { type: "alpha", startVal: 1, targetVal: 0, speed: 0.05 },
							//newState: game.menus[1],
							//transition: { type: "alpha", startVal: 0, targetVal: 1, speed: 0.05 }
						//}
					//);
					//break;
				// PAUSE MENU
				//case "M3B1":
					//break;
				//case "M3B2":
					//break;
			//}
		//}	
		//
	//}
//
//}