package org.syncon.RosettaStone.view.mobile.alarm
{
	//import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.views.TalkTest;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.NightStandConfigVO;
	import org.syncon.RosettaStone.vo.StyleConfigurator;
	
	public class TalkTestMediator extends Mediator
	{
		[Inject] public var ui: TalkTest;
		[Inject] public var model : RSModel;
		private var styler:StyleConfigurator=new StyleConfigurator();
		private var ev : LazyEventHandler = new LazyEventHandler(); 
		public function TalkTestMediator()
		{
			
		}
		override public function onRemove():void
		{
			trace('mediator removed'); 
			ev.unmapAll(); 
			super.onRemove()
		}
		override public function onRegister():void
		{
			ev.init( this.ui ) ; 
			
			ev.addEv(TalkTest.SETUP, this. onSetup)
			
			this.styler.init( this.ui, this.model.config );
			//this.onUpdate() ;
			if ( ui.modeManual )
				return; 
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.CONFIG_UPDATED,
				this.onUpdateGlobalConfig);	
			eventMap.mapListener(eventDispatcher, RSModelEvent.VOICE_CHANGED,
				this.onVoiceChanged);			
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.MUTE_CHANGED,
				this.onMuteChanged );						
			
			
			this.onUpdateGlobalConfig(null)
			this.onVoiceChanged(null);
			this.onMuteChanged(); 
			//
		}
		/**
		 * Get Url Request
		 * */
		private function onSetup(e:Event):void
		{
			this.ui.fxGenerateUrlRequest = NightStandConstants.fxGenerateUrlReq 
		}		
		
		
		protected function onUpdateGlobalConfig(event:Event):void
		{
			var gConfig : NightStandConfigVO = this.model.config
			this.ui.updateSettings( this.model.config.enableVoice, gConfig.intervalMinutes, gConfig.intervalSeconds ) ;
			this.ui.TwenetFourHour = gConfig.format24Hours; 
		}
		
		protected function onVoiceChanged(event:Event):void
		{
			var gConfig : NightStandConfigVO = this.model.config
			if ( this.model.currentVoice != null ) 
				this.ui.loadVoice( this.model.currentVoice ) ; 
		}		
		//take secodnary preference
		protected function onMuteChanged(event:Event=null):void
		{
			var gConfig : NightStandConfigVO = this.model.config
			if ( gConfig.enableVoice == true ) 
			{
				this.ui.enabled = ! this.model.mute
			}
		}		
		
	}
}