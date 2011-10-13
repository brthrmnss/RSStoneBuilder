package  org.syncon.RosettaStone.controller.Import
{
	import flash.events.Event;
	
	import org.syncon.RosettaStone.vo.LessonSetVO;
	
	public class ConvertStringToItemSetCommandTriggerEvent extends Event
	{
		public static const CONVER_STRING:String = 'ConvertStringToItemSetCommandTriggerEvent-cs.';
		
		public var input : String;
		public var fxResult : Function;
		public var lessonSet:LessonSetVO;
		public var save:Boolean;
		public var demarc : String;
		/**
		 * flag, remove current lesson items
		 * */
		public var clearExisting:Boolean;
		
		public function ConvertStringToItemSetCommandTriggerEvent(type:String   , input : String, ls : LessonSetVO, 
																  fxR : Function, save : Boolean = true, demarc : String = ', ' , 
																  clearExisting : Boolean = true ) 
		{	
			this.input = input
			this.fxResult = fxR
			this.lessonSet = ls; 
			this.save = save; 
			this.demarc  = demarc; 
			this.clearExisting = clearExisting; 
			super(type, true);
		}
		
	}
}