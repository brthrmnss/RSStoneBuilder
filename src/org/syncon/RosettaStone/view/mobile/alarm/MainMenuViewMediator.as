package org.syncon.RosettaStone.view.mobile.alarm
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
	import org.syncon.RosettaStone.vo.MenuItemVO;
	import org.syncon.RosettaStone.vo.MenuItemsVO;
	import org.syncon.RosettaStone.vo.NightStandConfigVO;
	import org.syncon.RosettaStone.vo.StyleConfigurator;
	import org.syncon.popups.controller.ShowPopupEvent;
	import org.syncon2.utils.mobile.view.ItemRenderer.Bridge.FlexItemRendererBridgeVO;
	import org.syncon2.utils.mobile.view.ItemRenderer.Bridge.FlexMobileItemRendererBridge;
	
	import spark.events.ViewNavigatorEvent;
	
	public class MainMenuViewMediator extends Mediator
	{
		[Inject] public var ui: MainMenuView;
		[Inject] public var model : RSModel;
		private var styler:StyleConfigurator=new StyleConfigurator();
		private var ev : LazyEventHandler = new LazyEventHandler(); 
		private var itemRend : FlexItemRendererBridgeVO = new FlexItemRendererBridgeVO(); 
		private var testAlarmsOnStartup:Boolean=true;
		public function MainMenuViewMediator()
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
			ev.addEv( MainMenuView.GO_BACK, this.onGoBack )
			ev.addEv( MainMenuView.LIST_CHANGED, this.onListChanged )	
			ev.addEv( MainMenuView.ADD_ALARM, this.onAddNew )			
			
			this.styler.init( this.ui, this.model.config );
			if ( model.currentConfigSet ) 
				this.onConfigChanged(null)
			var items : ArrayList = new ArrayList(); 
			if ( this.testAlarmsOnStartup ) 
			{
				var x : Array = ['select voice', 'settings', 'record voice', 'test', 'help']
				var xx : Array = [this.onSelectVoice, this.onSettings, this.onRecordVoice, this.onTest, this.onHelp]
				for ( var i : int = 0; i < x.length ; i++ )
				{
					var a : MenuItemVO = new MenuItemVO (); 
					a.name = x[i]
					a.fxNoParams = xx[i]
					items.addItem( a )
				}
			}
			
			itemRend.init( this.model.flex , this.ui, this.ui.list ) ; 
			
			//this.model.config.alarmList = new ArrayList(this.model.config.alarms ) 
			this.ui.list.dataProvider = items
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
		/*		private var oldClass : IFactory; 
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
			var item : MenuItemVO = event.data as MenuItemVO;
			item.automate(); 
			//this.dispatch( NavigateCommandTriggerEvent.pushView( EditMainMenuView ,alarm ) ) 		
			/*	this.loadOdb = odb
			this.ui.txtLoading.visible = false; 
			//this.showLoadingForLater()
			this.ui.txtLoading.addEventListener(FlexEvent.SHOW, this.onShowLabel, false, 0, true ); 
			this.ui.txtLoading.visible = true; 
			this.ui.list.alpha = 0.2
			/*this.ui.callLater( this.ui.navigator.pushView, [DevotionView, odb] )*/
			/*this.ui.navigator.pushView( DevotionView, odb ); */
			
		}
		private function onGoBack(e:Event):void
		{
			this.dispatch( NavigateCommandTriggerEvent.popView() ); 
		}		
		
		private function onSelectVoice(e:Event=null):void
		{
			this.dispatch( NavigateCommandTriggerEvent.pushView( SelectVoiceView ) ); 
		}	
		private function onSettings(e:Event=null):void
		{
			this.dispatch( NavigateCommandTriggerEvent.pushView( SettingsView ) ); 
		}	
		private function onRecordVoice(e:Event=null):void
		{
			this.dispatch( NavigateCommandTriggerEvent.popView() ); 
		}	
		private function onTest(e:Event=null):void
		{
			var event_ : ShowPopupEvent = new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupTestVoice', [this.model.currentVoice], 'open3_Voice' )   		
			this.dispatch( event_ ) 			
		}	
		private function onHelp(e:Event=null):void
		{
			this.dispatch( NavigateCommandTriggerEvent.pushView( HelpView ) ); 
		}			
		
		
		private function onAddNew(e:Event):void
		{
			var alarm : AlarmVO = new AlarmVO(); 
			alarm.new1 = true; 
			alarm.enabled = true; 
			alarm.sound = this.model.alarms.getItemAt(0 ).toString(); 
			///this.dispatch( NavigateCommandTriggerEvent.pushView( EditMainMenuView ,alarm ) ) 	
			this.model.alarmList.addItem( alarm ) ; 
		}				
		private function onConfigChanged(e:Event):void
		{
			return; 
			if ( this.ui.visible == false ) 
				return; 
			this.dispatch( NavigateCommandTriggerEvent.popView() ); 
			
			if ( this.model.config.helpShown == false ) 
			{
				//this.dispatch( NavigateCommandTriggerEvent.pushView( HelpView ) ) 		
				return; 
			}
			var widgetConfig : IWidgetConfigVO = this.model.currentConfig
			this.dispatch( new LoadWidgetCommandTriggerEvent(LoadWidgetCommandTriggerEvent.LOAD_WIDGET, 
				widgetConfig ) ) 
			
		}		
		
		
		
	}
}