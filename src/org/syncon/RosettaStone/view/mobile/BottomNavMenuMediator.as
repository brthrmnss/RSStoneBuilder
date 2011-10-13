package org.syncon.RosettaStone.view.mobile
{
	//import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.NavigateCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.ShowBottomNavBarCommandTriggerEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.view.mobile.alarm.AlarmView;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.StyleConfigurator;
	
	public class BottomNavMenuMediator extends Mediator
	{
		[Inject] public var ui: BottomNavMenu;
		[Inject] public var model : RSModel;
		private var styler:StyleConfigurator=new StyleConfigurator();
		private var ev : LazyEventHandler = new LazyEventHandler(); 
		
		public function BottomNavMenuMediator()
		{
			
		}
		override public function onRemove():void
		{
			ev.unmapAll(); 
			super.onRemove()
		}
		
		override public function onRegister():void
		{
			ev.init( this.ui ) ; 
			
			eventMap.mapListener(eventDispatcher, ShowBottomNavBarCommandTriggerEvent.SHOW,
				this.onShow);	
			eventMap.mapListener(eventDispatcher, ShowBottomNavBarCommandTriggerEvent.CLOSE,
				this.onHide);				
			ev.addEv(BottomNavMenu.SETTINGS, this.onSettings)
			ev.addEv(BottomNavMenu.THEME, this.onTheme)
			ev.addEv(BottomNavMenu.INFO, this.onInfo)
			ev.addEv(BottomNavMenu.HELP, this.onHelp)			
			ev.addEv(BottomNavMenu.ALARMS, this.onAlarms )			
		}
		
		private function onShow(e:Event):void
		{
			this.ui.visible = true; 
		}		
		
		private function onHide(e:Event):void
		{
			this.ui.visible = false; 
		}
		
		private function onSettings(e:Event):void
		{
			this.dispatch( NavigateCommandTriggerEvent.pushView( SettingsView) ) 	
		}		
		
		private function onTheme(e:Event):void
		{
			this.dispatch( NavigateCommandTriggerEvent.pushView( SelectThemeView) ) 	
		}		
		
		private function onInfo(e:Event):void
		{
			this.dispatch( NavigateCommandTriggerEvent.pushView( InfoView ) ) 	
		}		
		
		private function onHelp(e:Event):void
		{
			this.dispatch( NavigateCommandTriggerEvent.pushView( HelpView ) ) 	
		}		
		
		private function onAlarms(e:Event):void
		{
			this.dispatch( NavigateCommandTriggerEvent.pushView( AlarmView ) ) 	
		}		
		
	}
}