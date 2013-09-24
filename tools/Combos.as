package tools {
	
	public final class Combos {
		
		private static var instance:Combos = new Combos();
		private var comboList:Array = new Array();
		private var currentCombo:Array = new Array();
		private var comboCount:uint = 0;
		
		public final function Combos() {
			if (instance){
				throw new Error ("Do not create an instance of this class; this is static.");
			}
			comboList[0] = [];
			comboList[1] = [37, 37, 90];
			comboList[2] = [39, 39, 90];
			comboList[3] = [40, 40, 90];
		}
		
		public static function getInstance():Combos {
			return instance;
		}
		
		public final function comboEnterFrame():void {
			if (comboCount > 1){
				comboCount--;
			}
			if (comboCount == 1){
				currentCombo = [];
				comboCount = 0;
			}
		}
		
		public final function addToCombo(key:uint):void {
			comboCount = 16;
			currentCombo.push(key);
		}
		
		public final function testForCombo():uint {
			if (currentCombo.length > 3 && currentCombo[currentCombo.length-1] == 90){
				currentCombo.reverse();
				currentCombo.splice(3);
				currentCombo.reverse();
			}
			if (currentCombo.length == 3){
				for (var c:uint = 1; c < comboList.length; c++){
					if ( Utilities.isArrayEqual(currentCombo, comboList[c]) == true ){
						comboCount = 0;
						return c;
					}
				}
			}
			return 0;
		}
		
	}
	
}