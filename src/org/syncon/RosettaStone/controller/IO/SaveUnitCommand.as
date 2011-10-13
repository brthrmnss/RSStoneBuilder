package org.syncon.RosettaStone.controller.IO
{
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModel;
	
	
	public class SaveUnitCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:SaveUnitCommandTriggerEvent;
		
		override public function execute():void
		{
			if ( event.type == SaveUnitCommandTriggerEvent.SAVE_UNIT ) 
			{
				this.saveUnit()
			}				
			//this.findPortFile(); 
		}
		
		
		private function saveUnit():void
		{
			var output : String = event.unit.export()
				if ( event.unit.baseFolder  == ''  ) 
				{
					event.unit.baseFolder = 'units'; 
					event.unit.url = event.unit.name; //clean up bad names 
				}
			//NightStandConstants.FileLoader.writeFile( output, "" , event.unit.url, this.saved ) 
			NightStandConstants.FileLoader.writeFile( output,  event.unit.getSubDir(),  "config.json", this.saved ) 
		}
		
		public function saved( c : Object ) : void
		{
			
		}
		
		
	}
}