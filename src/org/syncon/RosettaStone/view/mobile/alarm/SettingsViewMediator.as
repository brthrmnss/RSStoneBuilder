package org.syncon.RosettaStone.view.mobile.alarm
{
	//import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.ConfigCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.InitMainContextCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.NavigateCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.ShowBottomNavBarCommandTriggerEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.view.parts.BackBtn;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.NightStandConfigVO;
	import org.syncon.RosettaStone.vo.StyleConfigurator;
	
	import spark.events.ViewNavigatorEvent;
	
	public class SettingsViewMediator extends Mediator
	{
		[Inject] public var ui: SettingsView;
		[Inject] public var model : RSModel;
		private var styler:StyleConfigurator=new StyleConfigurator();
		private var ev : LazyEventHandler = new LazyEventHandler(); 
		public function SettingsViewMediator()
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
			if ( this.model.showAds == false ) 
			{
				this.ui.scroller.setStyle('bottom', 0 ); 
			}			
			
			ev.init( this.ui ) ; 
			
			ev.addEv(SettingsView.GO_BACK, this.onGoBack)
			ev.addEv(SettingsView.CHANGED_FORM, this.onSettingsChanged)
			ev.addEv(SettingsView.RESTART_APP, this.onRestartApp)
			
			ev.addEv(ViewNavigatorEvent.VIEW_ACTIVATE, this.onActivate) 
			ev.addEv( BackBtn.GO_BACK_BTN, this.onGoBack ) ;
			
			this.styler.init( this.ui, this.model.config );
			this.onUpdate() ; 
			onActivate(null);
			
			this.ui.timeSelector.hideHours()
				//	this.ui.timeSelector.hideSeconds(); 
			this.ui.timeSelector.showPrompts()
			
		}
		
		protected function onRestartApp(event:Event):void
		{
			this.ui.parentApplication.persistNavigatorState= false 
			this.dispatch( new InitMainContextCommandTriggerEvent(
				InitMainContextCommandTriggerEvent.EXIT_APP ))
			//NativeApplication.nativeApplication.exit();
			this.ui.stage.addEventListener(Event.DEACTIVATE, deactivateHandler);
		}
		
		
		public function deactivateHandler(event:Event):void
		{
			this.dispatch( new InitMainContextCommandTriggerEvent(
				InitMainContextCommandTriggerEvent.EXIT_APP ))			
			this.ui.stage.removeEventListener(Event.DEACTIVATE, deactivateHandler);
			//NativeApplication.nativeApplication.exit();
			this.dispatch( new ShowBottomNavBarCommandTriggerEvent(
				ShowBottomNavBarCommandTriggerEvent.CLOSE) ) 
		}
		
		
		protected function onActivate(event:ViewNavigatorEvent):void
		{
			this.dispatch( new ShowBottomNavBarCommandTriggerEvent(
				ShowBottomNavBarCommandTriggerEvent.SHOW) ) 
			//trace('activate', this.ui ); 
			/*	this.ui.holder.alpha = 1; 
			this.ui.txtLoading.visible = false; 
			*/
			this.styler.changedCheck( this.model.config ) ; 
			this.onUpdate() ; 
		}
		
		private function onGoBack(e:Event):void
		{
			this.dispatch( NavigateCommandTriggerEvent.popView() ) 				
		}		
		
		private function onUpdate() :void
		{
			var config : NightStandConfigVO = this.model.config
			
			//this.ui.cb_HighSpeed.selected = config.hiSpeedMode ; 				
			/*	
			this.ui.slider_fontSize.value =config.fontSize ; 
			this.ui.cb_ReverseText.selected =	config.reverseText ; 
			*/
			this.ui.cb_format24Hours.selected = config.format24Hours ;
			/*
			this.ui.cb_ShowDate.selected = config.showDate 	
			
			this.ui.cb_ShowSeconds.selected = config.showSeconds ;
			this.ui.cb_ShowDay.selected = config.showDayOfWeek 	
			*/
			this.ui.timeSelector.setup('', 0,config.intervalMinutes, config.intervalSeconds ); 

			
			this.ui.cb_Enabled.selected = config.enableVoice; 
		}
		protected function onSettingsChanged(event:Event):void
		{
			var config : NightStandConfigVO = this.model.config
			/*	
			config.fontSize = this.ui.slider_fontSize.value; 
			config.reverseText = this.ui.cb_ReverseText.selected; 
			*/
			//config.hiSpeedMode = this.ui.cb_HighSpeed.selected; 
			config.enableVoice = this.ui.cb_Enabled.selected; 
			
			config.format24Hours = this.ui.cb_format24Hours.selected; 
			/*
			config.showDate = this.ui.cb_ShowDate.selected; 
			
			config.showSeconds = this.ui.cb_ShowSeconds.selected 
			config.showDayOfWeek 	= this.ui.cb_ShowDay.selected 
			*/
			config.intervalMinutes = this.ui.timeSelector.minutes
			config.intervalSeconds = this.ui.timeSelector.seconds
			this.dispatch( new ConfigCommandTriggerEvent(ConfigCommandTriggerEvent.SAVE_AND_LOAD_CONFIG) ); 
			this.model.configUpdated()
			this.styler.changedCheck( this.model.config )
		}
		
		
	}
}