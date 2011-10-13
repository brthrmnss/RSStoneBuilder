package  org.syncon.RosettaStone.view.mobile.alarm
{
	//import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayList;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.ConfigCommandTriggerEvent;
	import org.syncon.TalkingClock.controller.LoadWidgetCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.NavigateCommandTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.TalkingClock.view.subview.AnalogLCD.AnalogLCDView;
	import org.syncon.TalkingClock.view.subview.DigitalLED.ClockView;
	import org.syncon.RosettaStone.vo.AlarmVO;
	import org.syncon.TalkingClock.vo.IWidgetConfigVO;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.NightStandConfigVO;
	import org.syncon.RosettaStone.vo.StyleConfigurator;
	import org.syncon2.utils.mobile.view.ItemRenderer.Bridge.FlexItemRendererBridgeVO;
	import org.syncon2.utils.mobile.view.ItemRenderer.Bridge.FlexMobileItemRendererBridge;
	
	import spark.events.ViewNavigatorEvent;
	
	public class  AlarmViewMediator extends Mediator
	{
		[Inject] public var ui: AlarmView;
		[Inject] public var model :  RSModel;
		private var styler:StyleConfigurator=new  StyleConfigurator();
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
		private var itemRend : FlexItemRendererBridgeVO = new FlexItemRendererBridgeVO(); 
		private var testAlarmsOnStartup:Boolean=true;
		public function AlarmViewMediator()
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
			ev.addEv( AlarmView.GO_BACK,  this.onGoBack )
			ev.addEv( AlarmView.LIST_CHANGED,  this.onListChanged )	
			ev.addEv( AlarmView.ADD_ALARM,  this.onAddNew )			
			
			this.styler.init( this.ui, this.model.config  );
			if ( model.currentConfigSet ) 
				this.onConfigChanged(null)
			
			if ( this.testAlarmsOnStartup ) 
			{
				if ( this.model.alarmList.length == 0 ) 
				{
					for ( var i : int = 0; i < 10 ; i++ )
					{
						var a : AlarmVO =  new  AlarmVO()
						a.name = 'asdf'
						//a.enabled = true; 
						a.time.setTime( a.time.getTime() + 60*1000/30 ) ; 
						a.sound = this.model.alarms.getItemAt( 0 ).toString(); 
						this.model.alarmList.addItem(a) 
						
					}
				}
			}
			
			itemRend.init(  this.model.flex , this.ui, this.ui.list  ) ; 
			
			//this.model.config.alarmList  = new ArrayList(this.model.config.alarms ) 
			this.ui.list.dataProvider =  this.model.alarmList  
			/*
			if ( this.model.flex ) 
			{
				this.oldClass = this.ui.list.itemRenderer
				this.ev.addEv( FlexMobileItemRendererBridge.SETUP, this.onSetupIR ) ; 
				var clas : ClassFactory = new ClassFactory(FlexMobileItemRendererBridge )
				this.ui.list.itemRenderer = clas
			}
			*/
		}
/*		private var oldClass :  IFactory; 
		public function onSetupIR(e:CustomEvent ) : void
		{
			e.stopImmediatePropagation(); 
			e.data = oldClass ; 
		}
		*/
		protected function onListChanged(event:CustomEvent):void
		{
			
			//this.ui.list.selectedItem = null 
			this.ui.list.selectedIndex = -1; 
			trace('change heard'); 
			var alarm :    AlarmVO = event.data as  AlarmVO;
			
			this.dispatch(   NavigateCommandTriggerEvent.pushView( EditAlarmView ,alarm )     ) 		
			/*	this.loadOdb  = odb
			this.ui.txtLoading.visible = false; 
			//this.showLoadingForLater()
			this.ui.txtLoading.addEventListener(FlexEvent.SHOW, this.onShowLabel, false, 0, true ); 
			this.ui.txtLoading.visible = true; 
			this.ui.list.alpha = 0.2
			/*this.ui.callLater( this.ui.navigator.pushView, [DevotionView, odb] )*/
			/*this.ui.navigator.pushView( DevotionView, odb  ); */
			
		}
		private function onGoBack(e:Event):void
		{
			this.dispatch(   NavigateCommandTriggerEvent.popView()   );  
		}		
		
		private function onAddNew(e:Event):void
		{
			var alarm :  AlarmVO = new AlarmVO(); 
			alarm.new1 = true; 
			alarm.enabled = true; 
			alarm.sound = this.model.alarms.getItemAt(0 ).toString(); 
			this.dispatch(   NavigateCommandTriggerEvent.pushView( EditAlarmView ,alarm )     ) 	
			this.model.alarmList.addItem( alarm ) ; 
		}				
		private function onConfigChanged(e:Event):void
		{
			return; 
			if ( this.ui.visible == false ) 
				return; 
			this.dispatch(   NavigateCommandTriggerEvent.popView()   );  
			
			if ( this.model.config.helpShown == false ) 
			{
				//this.dispatch(   NavigateCommandTriggerEvent.pushView( HelpView )     ) 		
				return; 
			}
			var widgetConfig : IWidgetConfigVO = this.model.currentConfig
			this.dispatch( new LoadWidgetCommandTriggerEvent(LoadWidgetCommandTriggerEvent.LOAD_WIDGET, 
				widgetConfig ) ) 
			
		}		
		
		
		
	}
}