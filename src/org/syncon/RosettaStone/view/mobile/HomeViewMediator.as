package  org.syncon.RosettaStone.view.mobile
{
	//import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.ConfigCommandTriggerEvent;
	import org.syncon.TalkingClock.controller.LoadWidgetCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.NavigateCommandTriggerEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.TalkingClock.view.subview.AnalogLCD.AnalogLCDView;
	import org.syncon.TalkingClock.view.subview.DigitalLED.ClockView;
	import org.syncon.TalkingClock.vo.IWidgetConfigVO;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.NightStandConfigVO;
	import org.syncon.RosettaStone.vo.StyleConfigurator;
	
	import spark.events.ViewNavigatorEvent;
	
	public class  HomeViewMediator extends Mediator
	{
		[Inject] public var ui: HomeView;
		[Inject] public var model :  RSModel;
		private var styler:StyleConfigurator=new  StyleConfigurator();
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
		public function HomeViewMediator()
		{
			
		}
		override public function onRemove():void
		{
			ev.unmapAll(); 
			super.onRemove()
		}
		override public function onRegister():void
		{
			if ( this.model.showAds == false ) 
			{
				//this.ui.scroller.setStyle('bottom', 0 ); 
			}			
			ev.init( this.ui ) ; 
			eventMap.mapListener(eventDispatcher, RSModelEvent.WIDGET_CONFIG_CHANGED,
				this.onConfigChanged);	
			this.styler.init( this.ui, this.model.config  );
			if ( model.currentConfigSet ) 
				this.onConfigChanged(null)
		}
		
		
		
		private function onConfigChanged(e:Event):void
		{
			if ( this.ui.visible == false ) 
				return; 
			this.dispatch(   NavigateCommandTriggerEvent.popView()   );  
			
			if ( this.model.config.helpShown == false ) 
			{
				this.dispatch(   NavigateCommandTriggerEvent.pushView( HelpView )     ) 		
				return; 
			}
			var widgetConfig : IWidgetConfigVO = this.model.currentConfig
			this.dispatch( new LoadWidgetCommandTriggerEvent(LoadWidgetCommandTriggerEvent.LOAD_WIDGET, 
				widgetConfig ) ) 
			
		}		
		
		
		
	}
}