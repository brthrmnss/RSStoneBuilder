package org.syncon.RosettaStone.controller.IO
{
	
	import com.adobe.serialization.json.JSON;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon2.utils.file.FileAir;
	import org.syncon.RosettaStone.vo.LessonGroupVO;
	import org.syncon.RosettaStone.vo.LessonVO;
	
	
	public class LoadLessonPlanCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:LoadLessonPlanCommandTriggerEvent;
		public var injections  : Array = ['model', RSModel] 
		override public function execute():void
		{
			if ( event.type == LoadLessonPlanCommandTriggerEvent.LOAD_LESSON_PLAN ) 
			{
				if ( event.group.url == '' ) 
					event.group.url = "config.json"
				this.loadConfig()
			}				
		}
		
		
		
		private function loadConfig():void
		{
			if ( event.exactLocation != '' ) 
			{
				NightStandConstants.FileLoader.readFile("", event.exactLocation, this.importConfig )
				return; 
			}
			var test : String = event.group.getSubDir(); 
			NightStandConstants.FileLoader.readFile(event.group.getSubDir(),'config.json',  this.importConfig )
		}		
		
		public function importConfig( input :  String ) : void
		{
			if ( input == null )
			{
				this.loadConfigPart3( null ) ; 
				return
			}
			var inputObj :  Object = JSON.decode( input.toString() )
			var lessonG : LessonGroupVO = new LessonGroupVO(); 
			lessonG = event.group
			lessonG.importObj( inputObj ) ; 
			lessonG.setBaseFolder( event.group.getSubDir() ) ; 
			this.loadConfigPart3( lessonG ) ; 
		}
		public function loadConfigPart3( group  : LessonGroupVO ) : void
		{
			if ( group == null ) 
			{
				if ( event.autoCreate == false ) 
				{
					if ( this.event.fxDone != null ) 
						this.event.fxDone(null); 
					return; 
				}
				//config = new LessonGroupVO(); 
				//config.url = event.group.url
				group = event.group; 
				this.dispatch( new CreateDefaultDataTriggerEvent(
					CreateDefaultDataTriggerEvent.CREATE, group ) ) ;
				//save this, ideally can send own url 
				this.dispatch( new SaveLessonPlanTriggerEvent(SaveLessonPlanTriggerEvent.LOAD_SOUNDS, group) ) ; 
			}
			this.model.currentLessonPlan = group; 
			
			//weird b/c resultx function returns same thing nomatter what 
			//if auto load
			if ( group.lessons.length > 0 && this.event.autoLoad ) 
			{
				var lessonBaseDir : String = ''; 
				lessonBaseDir =group.getSubDir()
				var firstLesson : LessonVO = group.lessons.getItemAt(  0 )  as LessonVO
				lessonBaseDir = firstLesson.getSubDir(); 
				this.dispatch( new  LoadLessonTriggerEvent(LoadLessonTriggerEvent.LOAD_SOUNDS, firstLesson ,'', this.event.fxDone ));//, lessonBaseDir )) ; 
				
			}
			
			if ( this.event.fxDone != null ) 
				this.event.fxDone(group); 
		}
		
		
		
		
	}
}