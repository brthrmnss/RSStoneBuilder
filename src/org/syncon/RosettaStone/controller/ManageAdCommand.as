package  org.syncon.RosettaStone.controller
{
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	
	/**
	 *
	 * */
	public class ManageAdCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:ManageAdCommandTriggerEvent;
		
		override public function execute():void
		{
			if ( event.type == ManageAdCommandTriggerEvent.IMPORT_AD ) 
			{
				NightStandConstants.ad = event.data;
				this.dispatch( new RSModelEvent (RSModelEvent.AD_CHANGED) ) 
			}
			if ( NightStandConstants.ad == null ) 
				return; 
			
			if ( event.type == ManageAdCommandTriggerEvent.AD_SHOW ) 
			{
				NightStandConstants.ad.hiddenState = false; 
				NightStandConstants.ad.showAd()
			}
			if ( event.type == ManageAdCommandTriggerEvent.AD_HIDE ) 
			{
				NightStandConstants.ad.hideAd()
			}


 
			
		}
		
		
		
		
		
	}
}