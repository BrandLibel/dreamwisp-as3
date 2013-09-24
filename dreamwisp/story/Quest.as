package dreamwisp.story {
	
	internal class Quest {
		
		public var questName:String;
		private var goal:int;
		
		private var currentProgress:int;
		private var isComplete:Boolean;
		
		/// @param id can be set as id:* so, when searching through JSON for quest data, both the quest name and array index can be used
		public function Quest(id:String, qt:uint) {
			questName = id;
			goal = qt;
		}
		
		public function complete():void {
			currentProgress = goal;
			isComplete = true;
		}
		
		public function checkCompletion():Boolean {
			return isComplete;
		}
		
		public function updateProgress(change:int):void {
			currentProgress += change;
			if (change > 0) { /// 'Collect x until n acquired' type quests
				if (currentProgress >= goal) complete();
			} 
			if (change < 0) { /// 'Reduce x until n remaining' type quests
				if (currentProgress <= goal) complete();
			}
		}
		
	}

}