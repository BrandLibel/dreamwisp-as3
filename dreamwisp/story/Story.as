package dreamwisp.story {
	
	public final class Story {
		
		/**
		 * These getters and setters access the public static vars in StoryVars
		 */
		public static function get hasDreamAmulet():Boolean {
			return StoryVars.hasDreamAmulet;
		}
		public static function set hasDreamAmulet(b:Boolean):void {
			StoryVars.hasDreamAmulet = b;
		}
		
		public static function startQuest(questName:String, questGoal:uint = -1):void {
			QuestList.addQuest(new Quest(questName, questGoal));
		}
		
		/** 
		 * Gives the specified quest reference so its functions can be called
		 * like this: Story.getQuest("ExampleQuest").complete()
		 */
		public static function getQuest(id:String):Object {
			if (QuestList.getQuest(id) == null) {
				throw new Error("That quest does not exist");
				return null;
			}
			return QuestList.getQuest(id);
		}
		
	}

}