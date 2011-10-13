package   org.syncon.RosettaStone.controller.IO
{
	
	import flash.events.Event;
	
	import org.syncon.RosettaStone.vo.LessonGroupVO;
	
	public class SaveLessonPlanTriggerEvent extends Event
	{
		public static const LOAD_SOUNDS:String = 'SaveLessonPlanTriggerEvent...';
		
		public var lessons : LessonGroupVO;
		
		public function SaveLessonPlanTriggerEvent(type:String   , lessons : LessonGroupVO) 
		{	
			this.lessons = lessons
			super(type, true);
		}
		
		
	}
}