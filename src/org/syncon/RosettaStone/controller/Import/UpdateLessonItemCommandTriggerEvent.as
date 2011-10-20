package  org.syncon.RosettaStone.controller.Import
{
	import flash.events.Event;
	
	import mx.messaging.AbstractConsumer;
	
	import org.syncon.RosettaStone.vo.LessonItemVO;
	
	public class UpdateLessonItemCommandTriggerEvent extends Event
	{
		public static const UPDATE_ITEM:String = 'UpdateLessonItemCommandTriggerEvent-UPDATE_ITEM.';
		
		public static const AUDIO:String = 'AUDIO-UPDATE_ITEM.';
		public static const DICTIONARY:String = 'DICTIONARY-UPDATE_ITEM.';
		public static const PRONUNCIATION:String = 'PRONUNCIATION-UPDATE_ITEM.';
		public static const VIDEO:String = 'VIDEO-UPDATE_ITEM.';
		
		public static const PIC:String = 'PIC-UPDATE_ITEM.';
		
		
		
		
		
		
		public var input : String;
		public var fxResult : Function;
		public var item:LessonItemVO;
		public var save:Boolean;
		/*
		only req'd when not sendinga prompt ... prompts have no choice
		*/
		public var action:String;
		/**
		 * overide prompt name 
		 * */
		public var query : String ; 
		/**
		 * overide prompt name 
		 * */
		public var queryPost : String ; 
		public var data:Object;
		public function UpdateLessonItemCommandTriggerEvent(type:String   , input : String, ls : LessonItemVO, 
																  fxR : Function, action : String, save : Boolean = true , query : String = null , 
																  queryPost : String = null) 
		{	
			this.input = input
			this.fxResult = fxR
			this.item = ls; 
			this.save = save; 
			this.action = action; 
			
			this.query = query; 
			this.queryPost = queryPost; 
			
			super(type, true);
		}
		
		/**
		 * No searching, just set proper property 
		 * */
		static public function UpdateLessonTo(   lI : LessonItemVO, data : Object, 
															fxR : Function, action : String, save : Boolean = true  ) : 
													UpdateLessonItemCommandTriggerEvent
		{	
			var e : UpdateLessonItemCommandTriggerEvent = new UpdateLessonItemCommandTriggerEvent(
				UpdateLessonItemCommandTriggerEvent.UPDATE_ITEM, null, lI, fxR, action, save ) ; 
			e.data = data; 
			return e 
		}
		
		
	}
}