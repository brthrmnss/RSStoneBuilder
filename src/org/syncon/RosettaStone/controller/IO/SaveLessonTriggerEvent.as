package org.syncon.RosettaStone.controller.IO
{
	import flash.events.Event;
	
	import org.syncon.RosettaStone.vo.LessonGroupVO;
	import org.syncon.RosettaStone.vo.LessonVO;
 
	public class SaveLessonTriggerEvent extends Event
	{
		public static const SAVE_LESSON:String = 'SaveLessonTriggerEvent...';
		public var lesson : LessonVO;
		public var subdir :  String;
		
		public function SaveLessonTriggerEvent(type:String , lesson : LessonVO, subdir : String = '') 
		{	
			this.lesson = lesson
				this.subdir = subdir; 
			super(type, true);
		}
		
	 
	}
}