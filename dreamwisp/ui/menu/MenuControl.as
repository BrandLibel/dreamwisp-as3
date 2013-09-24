package dreamwisp.ui.menu {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.state.TransitionManager;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import project.menu.Menu;
		
	public final class MenuControl {
		
		private var layouts:Object = new Object();
				
		private var menus:Vector.<Menu> = new <Menu>[null];
		private var _menu:Menu;
		
		public var view:Sprite = new Sprite();		
		
		public final function MenuControl() {
			init();
		}
		
		private function init():void {
			layouts = Data.menuLayouts;
			for (var i:uint = 0; i < layouts.menus.length; i++) {
				//menus.push(new Menu(layouts[i]));
				menus.push(new Menu(layouts.menus[i]));
				view.addChild(menus[i + 1].view.container); // Initial visualization of menus
			}
		}
		
		public function goto(menuNum:uint):Menu {
			menu = menus[menuNum];
			menu.enter();
			
			// The active menu is set to be the top visible menu
			view.setChildIndex(menu.view.container, view.numChildren - 1);
			return menu;
		}
		
		public function find(menuNum:uint):Menu {
			menu = menus[menuNum];
			return menu;
		}
		
		public function exit():void {
			for (var i:uint = 1; i < menus.length; i++) {
				menus[i].exit();
			}
		}
		
		/// This is the reference to the active menu.
		public function get menu():Menu {
			return _menu;
		}
		public function set menu(value:Menu):void {
			_menu = value;
		}
		
	}
}