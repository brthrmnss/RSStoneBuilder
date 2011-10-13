package  org.syncon.RosettaStone.controller
{
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.NightStand.vo.OdbVO;
	
	/**
	 *
	 * */
	public class ShowBottomNavBarCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:ShowBottomNavBarCommandTriggerEvent;
		private var odb:OdbVO;
		
		override public function execute():void
		{
			if ( event.type == ShowBottomNavBarCommandTriggerEvent.SHOW ) 
			{
				this.dispatch( new GetRSSCommandTriggerEvent( GetRSSCommandTriggerEvent.LOAD,
					'http://odb.org/podcast/', fxRSSResult, fxRSSFault ))
			}	
		}
		
		private function fxRSSResult(o:   Array=null):void
		{
			this.dispatch( new ConvertRSSToODBVOCommandTriggerEvent(
						ConvertRSSToODBVOCommandTriggerEvent.CONVERT,
				o, fxConvertedOdb ))
		}
		
		private function fxRSSFault(err:    Object=null):void
		{
			trace( 'failed to load RSS' ) 
			this.model.onFailLoadList()
		}
		
		private function fxConvertedOdb(o:      Array=null):void
		{
				this.model.setOdbs(o)
				this.dispatch( new GetODBVOCommandTriggerEvent(
					GetODBVOCommandTriggerEvent.GET,
					o[0] as OdbVO, fxGetODB , fxGetODBFault ))
				this.odb = o[0] as OdbVO
				return; 
		}
		
		private function fxGetODB(e:OdbVO ):void
		{
			this.dispatch( new  GetBibleCommandTriggerEvent(GetBibleCommandTriggerEvent.GET_BIBLE, e.scriptureVO , fxGetBiblePassage, fxGetBiblePassageFault) ) 
			return;
		}		
		

		private function fxGetODBFault(e:Object ):void
		{
			return;
		}		
		
		
		private function fxGetBiblePassage(e: String ):void
		{
			odb.scriptureContent = e;
			this.model.loadOdb(odb); 
			trace(); 
		}
		
		private function fxGetBiblePassageFault(e:Object ):void
		{
			trace(); 
		}
		
		
		
	}
}