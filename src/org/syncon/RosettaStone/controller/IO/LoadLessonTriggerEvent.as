package org.syncon.RosettaStone.controller.IO
{
	import flash.events.Event;
	
	import org.syncon.RosettaStone.vo.LessonGroupVO;
	import org.syncon.RosettaStone.vo.LessonVO;
	
	public class LoadLessonTriggerEvent extends Event
	{
		public static const LOAD_SOUNDS:String = 'LoadLessonTriggerEvent...';
		
		public var lesson : LessonVO;
		public var exactUrl : String;
		/**
		 * hwere is main config folder relative to root, this will have to be a subdir
		 * */
		public var subdir : String;
		public var fxDone : Function; 
		
		public var autoCreate : Boolean; 
		public var autoLoad : Boolean;
		public var updateModel:Boolean=true;
		
		public function LoadLessonTriggerEvent(type:String , lesson : LessonVO, 
											   subdir :   String = '' , fxDone : Function=null, exactLocation : String = '',
											   autoLoad : Boolean  =true,autoCreate : Boolean  =true) 
		{	
			this.exactUrl = exactLocation
			this.lesson = lesson;
			this.subdir = subdir;
			this.fxDone = fxDone; 
			this.autoLoad = autoLoad 
			this.autoCreate = autoCreate; 
			super(type, true);
		}
		
	}
}