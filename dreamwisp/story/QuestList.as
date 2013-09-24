package dreamwisp.story {
	
	internal class QuestList {
		
		private static var list:Array = [];
		private static var numberOfQuests:uint = 0;
		
		public static function addQuest(quest:Object):void {
			list.push(quest);
			updateNumber();
		}
		
		private static function updateNumber():void {
			numberOfQuests = list.length;
		}
		
		public static function getQuest(id:String):Object {
			for (var i:uint = 0; i < list.length; i++) {
				if (list[i].questName == id) {
					return list[i];
				}
			}
			return null;
		}
		
	}

}