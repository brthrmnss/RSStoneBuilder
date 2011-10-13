package org.syncon.RosettaStone.controller.IO
{
	
	import com.adobe.serialization.json.JSON;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LessonGroupVO;
	import org.syncon.RosettaStone.vo.LessonVO;
	import org.syncon.RosettaStone.vo.UnitVO;
	import org.syncon2.utils.file.FileAir;
	
	
	public class LoadUnitsCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:LoadUnitsCommandTriggerEvent;
		
		public var injections  : Array = ['model', RSModel] 
		
		override public function execute():void
		{
			if ( event.type == LoadUnitsCommandTriggerEvent.LOAD_UNITS ) 
			{
				if ( event.url == '' ) 
					event.url = "config.json"
				this.loadUnits()
			}				
		}
		
		private function loadUnits():void
		{
			NightStandConstants.FileLoader.readFile("units" ,event.url, this.importConfig ) 
		}		
		
		public function importConfig( input :  String ) : void
		{
			
			//this is only version that is working now 
			if ( this.event.loadFolder ) 
			{
				NightStandConstants.FileLoader.getSubDirectories("units", this.loadedSubDirectories) ;
				return 
			}
			
			if ( input == null )
			{
				this.loadConfigPart3( null ) ; 
				return
			}
			var inputObj :  Object = JSON.decode( input.toString() )
			var unit : UnitVO = new UnitVO(); 
			unit.importObj( inputObj ) ; 
			
			
			this.loadConfigPart3( [] ) ; 
		}
		
		public function loadedSubDirectories(directories:Array):void
		{
			var unitItems:Array= [];
			for each ( var url : String in directories ) 
			{
				var u : UnitVO = new UnitVO(); 
				
				unitItems.push(u)
				u.name = url; 
				u.baseFolder = 'units'  
				u.getSubDir()
				u.url = url; 
			}
			this.loadConfigPart3( unitItems ) ; 
		}
		
		public function loadConfigPart3( units  :  Array ) : void
		{
			/*if ( unit == null ) 
			{
			unit = new UnitVO(); 
			unit.url = event.url
			this.dispatch( new CreateDefaultDataTriggerEvent(
			CreateDefaultDataTriggerEvent.CREATE, unit ) ) ;
			//save this, ideally can send own url 
			this.dispatch( new SaveUnitCommandTriggerEvent(SaveUnitCommandTriggerEvent.SAVE_UNIT, unit) ) ; 
			}
			*/
			this.model.loadUnits( units ); 	
			if ( event.autoLoad && units.length > 0 ) 
			{
				var firstUnit : UnitVO = units[0]  as UnitVO
				//load b/c we have no assocaitaions
				this.dispatch( new  LoadUnitCommandTriggerEvent(
					LoadUnitCommandTriggerEvent.LOAD_UNIT,  firstUnit )); //firstUnit.getSubDir() ) ) ; 
			} 
			
		}
		
		
		
		
	}
}