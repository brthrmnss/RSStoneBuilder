package org.syncon.RosettaStone.controller.IO
{
	
	import com.adobe.serialization.json.JSON;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon2.utils.file.FileAir;
	import org.syncon.RosettaStone.vo.LessonGroupVO;
	import org.syncon.RosettaStone.vo.LessonVO;
	import org.syncon.RosettaStone.vo.UnitVO;
	
	
	public class LoadUnitCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:LoadUnitCommandTriggerEvent;
		private var tempUnit:UnitVO;
		public var injections  : Array = ['model', RSModel] 
		override public function execute():void
		{
			if ( event.type == LoadUnitCommandTriggerEvent.LOAD_UNIT ) 
			{
				/*	if ( event.url == '' ) 
				event.url = "config.json"*/
				this.loadUnit()
			}				
		}
		
		
		private function loadUnit():void
		{
			if ( event.exactLocation != '' ) 
			{
				NightStandConstants.FileLoader.readFile("", event.exactLocation, this.onUnitLoaded )
				return; 
			}
			trace('LoadUnitCommand',  'not exact'); 
			var test : String = event.unit.getSubDir(); 
			NightStandConstants.FileLoader.readFile(event.unit.getSubDir(), "config.json", this.onUnitLoaded )
		}		
		
		public function onUnitLoaded( input :  String ) : void
		{
			if ( input == null )
			{
				this.loadConfigPart3( null ) ; 
				return
			}
			var inputObj :  Object = JSON.decode( input.toString() )
			var unit : UnitVO = new UnitVO(); 
			unit = event.unit; 
			unit.importObj( inputObj ) ; 
			unit.setSubBaseFolder( unit.getSubDir()) ; 
			/*		
			if ( this.event.autoLoad ) 
			{
			this.tempUnit = unit 
			
			NightStandConstants.FileLoader.getSubDirectories("units", this.loadedSubDirectories) ;
			
			return 
			}
			*/
			this.loadConfigPart3( unit ) ; 
		}
		
		/*		public function loadedSubDirectories(directories:Array):void
		{
		
		var unit : UnitVO = this.tempUnit; 
		unit.importDirectories( directories) 
		this.loadConfigPart3( unit ) ; 
		}*/
		
		public function loadConfigPart3( unit  : UnitVO ) : void
		{
			if ( unit == null ) 
			{
				if ( event.autoCreate == false ) 
				{
					if ( this.event.fxDone != null ) 
						this.event.fxDone(null); 
					return; 
				}
				unit =  event.unit
				//unit.url = event.exactLocation; ...make this up somewhere else ...
				this.dispatch( new CreateDefaultDataTriggerEvent(
					CreateDefaultDataTriggerEvent.CREATE, unit ) ) ;
				//save this, ideally can send own url 
				this.dispatch( new SaveUnitCommandTriggerEvent(SaveUnitCommandTriggerEvent.SAVE_UNIT, unit) ) ; 
			}
			
			this.model.currentUnit = unit; 
			
			//if auto load
			if ( unit.groups.length > 0  && event.autoLoad ) 
			{
				var firstLesson : LessonGroupVO = unit.groups.getItemAt(  0 )  as LessonGroupVO
				this.dispatch( new  LoadLessonPlanCommandTriggerEvent(
					LoadLessonPlanCommandTriggerEvent.LOAD_LESSON_PLAN, firstLesson  ) ) ; 
			}
			if ( this.event.fxDone != null ) 
				this.event.fxDone(unit); 
			return; 
		}
		
		
		
		
	}
}