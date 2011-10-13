package org.syncon.RosettaStone.controller.IO
{
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModel;
	
	
	public class SaveLessonPlanCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:SaveLessonPlanTriggerEvent;
		public var injections  : Array = ['model', RSModel] 
		override public function execute():void
		{
			if ( event.type == SaveLessonPlanTriggerEvent.LOAD_SOUNDS ) 
			{
				this.saveLessonPlan()
			}				
			//this.findPortFile(); 
		}
		
		
		private function saveLessonPlan():void
		{
			var output : String = event.lessons.export()
			var url : String =  event.lessons.getSubDir()
			if ( url != '' ) 
			{
			}
			
			url += '/'+'config.json'
			NightStandConstants.FileLoader.writeFile( output, "" ,url, this.saved ) 
		}
		
		public function saved( c : Object ) : void
		{
			
		}
		
		
	}
}