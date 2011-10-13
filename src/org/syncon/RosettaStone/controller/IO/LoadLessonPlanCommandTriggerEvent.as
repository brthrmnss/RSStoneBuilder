package org.syncon.RosettaStone.controller.IO
{
	
	import flash.events.Event;
	
	import org.syncon.RosettaStone.vo.LessonGroupVO;
	
	public class LoadLessonPlanCommandTriggerEvent extends Event
	{
		public static const LOAD_LESSON_PLAN:String = 'LoadLessonPlanTriggerEvent...';
		public var group :LessonGroupVO;
		
		public var exactLocation : String;
		public var fxDone : Function ; 
		public var autoCreate : Boolean; 
		public var autoLoad : Boolean;
		public function LoadLessonPlanCommandTriggerEvent(type:String , group : LessonGroupVO , exactLocdation : String='', 
														  fxDone:Function=null, autoLoad : Boolean  =true,  autoCreate : Boolean  =true)//,filename : String='') 
		{	
			this.group = group
			this.exactLocation = exactLocdation; 
			this.fxDone = fxDone 
			this.autoLoad = autoLoad 
			this.autoCreate = autoCreate; 
			super(type, true);
		}
		
		
	}
}