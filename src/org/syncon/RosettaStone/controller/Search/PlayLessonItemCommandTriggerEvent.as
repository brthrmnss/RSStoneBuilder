package   org.syncon.RosettaStone.controller.Search
{
	
	import flash.events.Event;
	
	import org.syncon.RosettaStone.vo.LessonItemVO;
	
	public class PlayLessonItemCommandTriggerEvent extends Event
	{
		public static const PLAY_LESSON_ITEM:String = 'PLAY_LESSON_ITEM.j';
		
		public var item : LessonItemVO;
		public var fxResult : Function;
		public var fxFault : Function; 
		public var url:String;
		public function PlayLessonItemCommandTriggerEvent(type:String   , item :  LessonItemVO , 
														  fxR : Function=null, fxF : Function = null, 
														  soundUrl : String = null ) 
		{	
			this.item = item
			this.fxResult = fxR
			this.fxFault = fxF; 
			this.url = soundUrl ; 
			super(type, true);
		}
		
		static public function Play( item :  LessonItemVO , fxR : Function=null, fxF : Function = null) : PlayLessonItemCommandTriggerEvent
		{	
			var e : PlayLessonItemCommandTriggerEvent = 
				new PlayLessonItemCommandTriggerEvent (PLAY_LESSON_ITEM, item);
			e.item = item
			e.fxResult = fxR
			e.fxFault = fxF; 
			return e; 
		}
		
		
	}
}