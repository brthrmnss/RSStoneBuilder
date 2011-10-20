package org.syncon.RosettaStone.controller
{
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.TalkingClock.controller.LoadRSUnitIntoRSCommandTriggerEvent;
	
	/**
	 *
	 * */
	public class InitQuizBoardCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:InitQuizBoardCommandTriggerEvent;
		public var injections  : Array = ['model', RSModel] 
			
		override public function execute():void
		{
			if ( event.type == InitQuizBoardCommandTriggerEvent.INIT_QUIZBOARD ) 
			{
				this.model.dontShowNextLesson = true; 
				this.dispatch( new LoadRSUnitIntoRSCommandTriggerEvent(
					LoadRSUnitIntoRSCommandTriggerEvent.IMPORT  ) ) ;
				
			}
			
		}
		
		
		
		
		
	}
}