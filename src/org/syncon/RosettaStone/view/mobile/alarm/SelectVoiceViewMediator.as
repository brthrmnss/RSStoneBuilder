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
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.view.parts.BackBtn;
	import org.syncon.TalkingClock.view.subview.AnalogLCD.AnalogLCDView;
	import org.syncon.TalkingClock.view.subview.DigitalLED.ClockView;
	import org.syncon.TalkingClock.vo.IWidgetConfigVO;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.MenuItemVO;
	import org.syncon.RosettaStone.vo.MenuItemsVO;
	import org.syncon.RosettaStone.vo.NightStandConfigVO;
	import org.syncon.RosettaStone.vo.StyleConfigurator;
	import org.syncon.RosettaStone.vo.VoiceVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	import org.syncon2.utils.mobile.view.ItemRenderer.Bridge.FlexItemRendererBridgeVO;
	import org.syncon2.utils.mobile.view.ItemRenderer.Bridge.FlexMobileItemRendererBridge;
	
	import spark.events.ViewNavigatorEvent;
	
	public class SelectVoiceViewMediator extends Mediator
	{
		[Inject] public var ui: SelectVoiceView;
		[Inject] public var model : RSModel;
		private var styler:StyleConfigurator=new StyleConfigurator();
		private var ev : LazyEventHandler = new LazyEventHandler(); 
		private var itemRend : FlexItemRendererBridgeVO = new FlexItemRendererBridgeVO(); 
		private var testAlarmsOnStartup:Boolean=false;
		public function SelectVoiceViewMediator()
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
			ev.addEv( SelectVoiceView.GO_BACK, this.onGoBack )
			ev.addEv( SelectVoiceView.LIST_CHANGED, this.onListChanged )	
			ev.addEv( SelectVoiceView.ADD_ALARM, this.onAddNew )			
			ev.addEv( SelectVoiceView.TEST, this.onTestVoice )			
			ev.addEv( BackBtn.GO_BACK_BTN, this.onGoBack ) ; 	
			ev.addEv( VoicesRenderer.GET_PIC, this.onGetPic ) ; 		
			
			this.styler.init( this.ui, this.model.config );
			if ( model.currentConfigSet ) 
				this.onConfigChanged(null)
			var items : ArrayList = new ArrayList(); 
			if ( this.testAlarmsOnStartup ) 
			{
				var x : Array = ['Chav', 'settings', 'record voice', 'test', 'help']
				var xx : Array = [this.onSelectVoice, this.onSettings, this.onRecordVoice, this.onTest, this.onHelp]
				for ( var i : int = 0; i < x.length ; i++ )
				{
					var a :  VoiceVO = new VoiceVO (); 
					a.name = x[i] //+ ' gggggggggggggggggggggggg ' 
						a.path = 'voices/chav'
				//	a.fxNoParams = xx[i]
					items.addItem( a )
				}
				this.ui.list.dataProvider = items
			}
			else
			{
				//this.model.config.alarmList = new ArrayList(this.model.config.alarms ) 
				//this.ui.list.dataProvider = items
				
				//this.model.config.voiceList = new ArrayList(this.model.config.configs ) 
				this.ui.list.dataProvider = this.model.voiceList
			}
			itemRend.init( this.model.flex , this.ui, this.ui.list ) ; 
			
			this.onVoiceChanged(); 
			eventMap.mapListener(eventDispatcher, RSModelEvent.VOICE_CHANGED,
				this.onVoiceChanged);			
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
		
		private function onGetPic(e:CustomEvent):void
		{
			// TODO Auto Generated method stub
			if ( NightStandConstants.fxGenerateUrlReq != null ) 
			{
				var alarm : VoiceVO = e.data as VoiceVO; 
				e.data = NightStandConstants.fxGenerateUrlReq(alarm.path+ '/' +  alarm.pic)
			}
		}
		
		private function onVoiceChanged(e:Event=null):void
		{
			this.ui.txtCurrentSelection.text = 'Current Selection: ' +   this.model.currentVoice.name; 
		}
		
		private function onTestVoice(e:CustomEvent):void
		{
			var event_ : ShowPopupEvent = new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupTestVoice', [e.data], 'open3_Voice_NoShow' )   		
			this.dispatch( event_ ) 			
			return;
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
			//trace('change heard'); 
			var item : VoiceVO = event.data as  VoiceVO;
			this.model.currentVoice = item; 
			this.model.saveConfig(); 
			//this.dispatch( NavigateCommandTriggerEvent.pushView( EditVoiceView ,item ) ) 	
		//	item.automate(); 
			//this.dispatch( NavigateCommandTriggerEvent.pushView( EditSelectVoiceView ,alarm ) ) 		
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
			this.dispatch( NavigateCommandTriggerEvent.popView() ); 
		}	
		private function onSettings(e:Event=null):void
		{
			this.dispatch( NavigateCommandTriggerEvent.popView() ); 
		}	
		private function onRecordVoice(e:Event=null):void
		{
			this.dispatch( NavigateCommandTriggerEvent.popView() ); 
		}	
		private function onTest(e:Event=null):void
		{
			this.dispatch( NavigateCommandTriggerEvent.popView() ); 
		}	
		private function onHelp(e:Event=null):void
		{
			this.dispatch( NavigateCommandTriggerEvent.popView() ); 
		}			
		
		
		private function onAddNew(e:Event):void
		{
		/*	var alarm : AlarmVO = new AlarmVO(); 
			alarm.new1 = true; 
			alarm.enabled = true; 
			alarm.sound = this.model.alarms.getItemAt(0 ).toString(); 
			///this.dispatch( NavigateCommandTriggerEvent.pushView( EditSelectVoiceView ,alarm ) ) 	
			this.model.alarmList.addItem( alarm ) ; */
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