package  org.syncon.RosettaStone.controller.Import
{
	import flash.events.Event;
	
	import org.syncon.RosettaStone.vo.LessonVO;
	
	public class ConvertStringToLessonCommandTriggerEvent extends Event
	{
		public static const CONVER_STRING:String = 'ConvertStringToLessonCommandTriggerEventddd-cs.';
		
		public var input : String;
		public var fxResult : Function;
		public var lesson:LessonVO;
		public var save:Boolean;
		public var demarc : String;
		public var arr : Array = null ; 
		
		public function ConvertStringToLessonCommandTriggerEvent(type:String   , input : String, ls : LessonVO, 
																 fxR : Function, save : Boolean = true, demarc : String = '; ', 
		arr : Array = null) 
		{	
			this.input = input
			this.fxResult = fxR
			this.lesson = ls; 
			this.save = save; 
			this.demarc  = demarc; 
			this.arr = arr; 
			super(type, true);
		}
		
	}
}