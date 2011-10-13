package   org.syncon.RosettaStone.controller
{
	
	import flash.events.Event;
	
	import org.syncon.RosettaStone.vo.LessonVO;
	
	public class AutomateEvent extends Event
	{
		public static const START_LESSON:String = 'startLesson';
		public static const NEXT_LESSON:String = 'NEXT_LESSON';
		
		public var lesson : LessonVO;
		public var confirmed : Boolean = false;
		public static var PAUSE_LESSON:String= 'PAUSE_LESSON';
		public static const RESUME_LESSON:String = 'RESUME_LESSON';
		/**
		 * Used to update settings on current leson, will copy from this.lesson; 
		 * */
		public static const UPDATE_SETTINGS:String = 'UPDATE_SETTINGS..';
		
		public function AutomateEvent(type:String   , lesson :  LessonVO, confirmed : Boolean = false ) 
		{	
			this.lesson = lesson
				this.confirmed = confirmed
			super(type, true);
		}
		
		
	}
}