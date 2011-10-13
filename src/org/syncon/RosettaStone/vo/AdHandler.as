package  org.syncon.RosettaStone.vo
{
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.ManageAdCommandTriggerEvent;
	import org.syncon.RosettaStone.model.RSModelEvent;
	
	import spark.events.ViewNavigatorEvent;
	
	/**
	 * */
	public class AdHandler 
	{
		public var target : Object; 
		public var ui : Object; 
		private var fxDispatch : Function; 
		public function init( tar :  Mediator, eventMap : Object, fxDispatch : Function  ) : void
		{
			this.target = tar; 
			this.ui = this.target.ui; 
			this.fxDispatch = fxDispatch; 
			ui.addEventListener(ViewNavigatorEvent.VIEW_ACTIVATE, onActivate, false, 0, true ) ; 
			ui.addEventListener(ViewNavigatorEvent.VIEW_DEACTIVATE, onDeactivate, false, 0, true ) ;
			 eventMap.mapListener(this.target.eventDispatcher, RSModelEvent.AD_CHANGED,
				this.onLoadedAd );	
		}
		public function onLoadedAd(e:Event):void
		{
			this.onActivate(null);
		}
		public function onActivate(e:Event):void
		{
			fxDispatch( new ManageAdCommandTriggerEvent(ManageAdCommandTriggerEvent.AD_SHOW) ) ; 
		}
		
		public function onDeactivate(e:Event ) : void
		{
			fxDispatch( new ManageAdCommandTriggerEvent(ManageAdCommandTriggerEvent.AD_HIDE) ) ; 
		}
		 
		public function unmap(   ) : void
		{
			ui.removeEventListener(ViewNavigatorEvent.VIEW_ACTIVATE, onActivate );//, false, 0, true ) ; 
			ui.removeEventListener(ViewNavigatorEvent.VIEW_DEACTIVATE, onDeactivate);//, false, 0, true ) ; 
		}
		
		
		 
		
	}
}