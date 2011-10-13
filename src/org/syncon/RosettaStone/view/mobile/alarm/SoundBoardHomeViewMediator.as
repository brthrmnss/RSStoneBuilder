package org.syncon.RosettaStone.view.mobile.alarm
{
	//import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.collections.ArrayList;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.utils.ColorUtil;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.InitMainContextCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.LoadPortCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.ManageAdCommandTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.vo.AlarmVO;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.MenuItemVO;
	import org.syncon.RosettaStone.vo.MenuItemsVO;
	import org.syncon.RosettaStone.vo.SoundVO;
	import org.syncon.RosettaStone.vo.StyleConfigurator;
	import org.syncon.RosettaStone.vo.TagVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	import org.syncon.popups.controller.default_commands.ShowAlertMessageTriggerEvent;
	import org.syncon2.utils.mobile.AndroidExtensions;
	import org.syncon2.utils.mobile.view.ItemRenderer.Bridge.FlexItemRendererBridgeVO;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.supportClasses.StyleableTextField;
	
	public class SoundBoardHomeViewMediator extends Mediator
	{
		[Inject] public var ui: SoundBoardHomeView;
		[Inject] public var model : RSModel;
		private var styler:StyleConfigurator=new StyleConfigurator();
		private var ev : LazyEventHandler = new LazyEventHandler(); 
		private var itemRend : FlexItemRendererBridgeVO = new FlexItemRendererBridgeVO(); 
		private var testAlarmsOnStartup:Boolean=true;
		
		private var dictBtnToSound :  Dictionary = new Dictionary(true)
		private var timer: Timer = new Timer(1500, 1 );
		
		public	var menu : MenuItemsVO = new MenuItemsVO(); 
		
		public function SoundBoardHomeViewMediator()
		{
			
		}
		override public function onRemove():void
		{
			ev.unmapAll(); 
			this.timer.removeEventListener(TimerEvent.TIMER, this.downForTimerTime )
			super.onRemove()
		}
		override public function onRegister():void
		{
			if ( this.model.showAds == false ) 
			{
				//this.ui.scroller.setStyle('bottom', 0 ); 
			}			
			ev.init( this.ui ) ; 
			eventMap.mapListener(eventDispatcher, RSModelEvent.CONFIG_CHANGED,
				this.onConfigChanged);	
			eventMap.mapListener(eventDispatcher, RSModelEvent.SOUNDS_CHANGED,
				this.onSoundsChanged);	
			ev.addEv( SoundBoardHomeView.GO_BACK, this.onGoBack )
			ev.addEv( SoundBoardHomeView.LIST_CHANGED, this.onListChanged )	
			ev.addEv( SoundBoardHomeView.ADD_ALARM, this.onAddNew )			
			ev.addEv( SoundBoardHomeView.RELAYOUT, this.onSoundsChanged )			
			ev.addEv( SoundBoardHomeView.INQUIRE, this.onInquire )			
			ev.addEv( SB_SoundRenderer.BTN_UP, this.onBtnUp )			
			ev.addEv( SB_SoundRenderer.BTN_DOWN, this.onBtnDown )			
			
			ev.addEv( SoundBoardHomeView.CHANGE_BUTTON, this.onChangeButton )		
			
			ev.addEv( SoundBoardHomeView.LOAD_PORT, this.onLoadPort ); 
			ev.addEv(  PropertyChangeEvent.PROPERTY_CHANGE, this.onScrollList )
			this.ui.list.dataGroup.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, this.onScrollList ) ; 
			//this.hostComponent.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, handleScroll);
			
			this.timer.addEventListener(TimerEvent.TIMER, this.downForTimerTime, false, 0, true ) ; 
			//this.styler.init( this.ui, this.model.config );
			if ( model.currentConfigSet ) 
				this.onConfigChanged(null)
			
			this.onSoundsChanged(null)
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
			
			this.menu.initSimple( [  PLAY_ALL, STOP_ALL_SOUNDS, 
				REPORT_PROBLEM, RATE, MORE,SET_RINGTONE,
				SHARE,	QUIT ], this.ui, this.onClickMenu ) ; 
			//itemRend.init( this.model.flex , this.ui, this.ui.list ) ; 
			
			//this.model.config.alarmList = new ArrayList(this.model.config.alarms ) 
			//this.ui.list.dataProvider = items
			/*
			if ( this.model.flex ) 
			{
			this.oldClass = this.ui.list.itemRenderer
			this.ev.addEv( FlexMobileItemRendererBridge.SETUP, this.onSetupIR ) ; 
			var clas : ClassFactory = new ClassFactory(FlexMobileItemRendererBridge )
			this.ui.list.itemRenderer = clas
			}
			*/
			this.ui.addEventListener( "viewMenuClose", this.onMenuClosed ) ; 
			this.ui.addEventListener( "viewMenuOpen", this.onMenuOpened ) ; 
			this.ui.addEventListener(FlexEvent.MENU_KEY_PRESSED, this.onMenuKeyPressed ); 
		}
		
		private function onLoadPort(e:Event):void
		{
			
			this.dispatch( new LoadPortCommandTriggerEvent(
				LoadPortCommandTriggerEvent.LOAD_PORT ) ) ; 	
		}		
		
		private function onInquire(e:Event):void
		{
			this.dispatch( new ShowAlertMessageTriggerEvent(
				ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP, 
				Capabilities.isDebugger + ' '  + 
				this.model.config.date + ' ' + this.model.config.version, 'About'  )  ) 
		}
		
		public static var STOP_ALL_SOUNDS:String = 'Stop All Sounds'; 
		public static var SET_RINGTONE:String = 'Set Ringtone'; 		
		
		public static var REPORT_PROBLEM:String = 'Report a problem'; 
		public static var RATE:String = 'Rate'; 
		public static var MORE: String = 'More Applications' 
		public static var ABOUT:String = 'About'; 
		public static var PLAY_ALL:String = 'Play All';
		public static var SHARE :  String = 'Share'
		public static var QUIT:String = 'Quit'; 
		
		protected function onMenuOpened(event:Event):void
		{
			trace('open');
			this.dispatch( new ManageAdCommandTriggerEvent(
				ManageAdCommandTriggerEvent.AD_HIDE ) ) ; 
		}
		
		protected function onMenuClosed(event:Event):void
		{
			trace('close');
			this.dispatch( new ManageAdCommandTriggerEvent(
				ManageAdCommandTriggerEvent.AD_SHOW ) ) ; 
		}
		
		protected function onMenuKeyPressed(event:FlexEvent):void
		{
			var dbg : Array = [this.ui.navigator.activeView]
			// trace(); 
			/*		var v : ViewNavigatorApplication = this.ui.parentApplication; 
			v.viewMenuOpen*/
		}
		
		private function onClickMenu(o : Object):void
		{
			// TODO Auto Generated method stub
			switch(o)
			{
				case STOP_ALL_SOUNDS:
				{
					this.model.stopSound()
					break;
				}
				case REPORT_PROBLEM:
				{
					this.reportProblem()
					break;
				}
				case RATE:
				{
					var a  : AndroidExtensions = new AndroidExtensions(); 
					a.rateApp(this.model.config.package_name); 
					break;
				}
				case MORE:
				{
					//"synco+systems"+alarm
					a  = new AndroidExtensions(); 
					//a.goToStore('', 'SynCo+Systems' ); 
					a.goToStore( '"SynCo Systems"' ); 
					break;
				}
				case PLAY_ALL:
				{
					this.onPlayAll(); 
					break;
				}
				case SHARE:
				{
					//var appname : String = "air.org.syncon.ODBViewer"
					a  = new AndroidExtensions(); 
					a.shareApp(   "Sound Board", "Check out this app "+"http://market.android.com/details?id="+this.model.config.package_name,
						"Tell a friend about "+this.model.config.name + ' '  +  this.model.config.subtitle); //com.example.yourpackagename" ); 
					break;
				}					
				case ABOUT:
				{
					this.dispatch( new  InitMainContextCommandTriggerEvent(InitMainContextCommandTriggerEvent.EXIT_APP) ) 
					break;
				}
				case SET_RINGTONE:
				{  ShowAlertMessageTriggerEvent
					this.dispatch( new ShowAlertMessageTriggerEvent(
						ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP, 
						"Press on a sound and hold for a second to bring up the ringtone changer.", 'Help'  )  ) 
					break;
				}
					
				case QUIT:
				{
					//a.goToStore( '' ,'SynCo Systems' ); 
					this.dispatch( new  InitMainContextCommandTriggerEvent(InitMainContextCommandTriggerEvent.EXIT_APP) ) 
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		private function onPlayAll():void
		{
			//this.lastSelectedIndex
			var start : int = 0//
			//this.ui.list.lastVisibleIndex
			var whoThere : Vector.<int>  = this.ui.list.dataGroup.getItemIndicesInView()
			var first : int = whoThere[0]
			this.lastIndex = start 
			this.playNextSound(); 
		}
		
		private function playNextSound(next:Object=null):void
		{
			if ( this.model.config.tags.length == 0 ) 
			{
				if ( this.lastIndex >= this.model.config.sounds.length )
					return; 
				this.ui.list.ensureIndexIsVisible( this.lastIndex ); 
				this.ui.list.selectedIndex = this.lastIndex; 
				var sound : SoundVO =  this.model.config.sounds[this.lastIndex] ; 
				
				this.model.playSound(sound, this.playNextSound )
				this.lastIndex	++
			}
			else
			{
				if ( this.lastIndex >= this.currentTag.sounds.length )
					return; 
				this.ui.list.ensureIndexIsVisible( this.lastIndex ); 
				this.ui.list.selectedIndex = this.lastIndex; 
				sound   =  this.currentTag.sounds[this.lastIndex] ; 
				
				this.model.playSound(sound, this.playNextSound )
				this.lastIndex	++				
			}
		}		
		
		
		
		private function reportProblem():void
		{
			var urlString:String = "mailto:";
			urlString += 'info.sync.con@gmail.com'
			urlString += "?subject="
			urlString += 'Problem With "' + this.model.config.name + '"'
			navigateToURL(new URLRequest(urlString));
		}
		
		
		private function onChangeButton(e:CustomEvent):void
		{
			var tag : TagVO = e.data as TagVO;
			this.currentTag = tag; 
			this.ui.list.dataProvider = new ArrayList( tag.sounds ) ; 
		}
		
		/**
		 * if using tags , lift the bottom up some 
		 * */
		private function onSoundsChanged(param0:Object):void
		{
			this.ui.scroller2.includeInLayout = false
				this.ui.scroller2.visible = false; 
				//this.ui.button.height = 0; 
			this.ui.list.dataProvider = new ArrayList( this.model.sounds.toArray() ) ; 
			if ( this.model.config.tags.length > 0 ) 
			{
				// TODO Auto Generated method stub
				var tags : Array = this.model.config.tags; 
				var allTag : TagVO = new TagVO()
				allTag.name = 'All'
				allTag.sounds = this.model.sounds.toArray() 
				this.currentTag = allTag; 
				tags.unshift( allTag ) 
				this.ui.button.dataProvider = new ArrayList( this.model.config.tags ) ; 
				this.ui.button.selectedIndex = 0 ; 
				this.ui.scroller2.includeInLayout = true; 
				this.ui.scroller2.visible = true; 
				//this.ui.button.height = NaN; 
				this.ui.scroller.bottom = 70+this.ui.scroller2.height 
				this.ui.holderList.bottom = 70+this.ui.scroller2.height 
			}
			return; 
			var g : Group 	 = this.ui.holder
			for ( var i : int = 0 ; i  < g.numElements; i++ ) 
			{
				btn = g.getElementAt( i ) as Button; 
				btn.removeEventListener( MouseEvent.CLICK, this.onSoundClicked )
			}
			g.removeAllElements(); 
			dictBtnToSound  = new Dictionary(true)
			for each ( var sound :  SoundVO in this.model.config.sounds ) 
			{
				var btn : Button = new Button() ; 
				//btn.percentWidth = 30
				btn.width = this.ui.parentApplication.width * .3
				
				g.addElement( btn ) ; 
				btn.label = sound.name
				if ( testNameSize ) 
				{
					if ( Math.random() < 0.25 ) 
						btn.label += sound.name + ' ' + sound.name  ; 
					if ( Math.random() < 0.5 ) 
						btn.label += sound.name + ' ' + sound.name  ; 
					if ( Math.random() < 0.5 ) 
						btn.label += sound.name + ' ' + sound.name  ;
				}
				//btn.data = sound; 
				sound.name = btn.label; 
				this.dictBtnToSound[btn] = sound; 
				btn.addEventListener(MouseEvent.CLICK,  this.onSoundClicked, false, 0, true ) ; 
				btn.addEventListener(MouseEvent.MOUSE_DOWN,  this.onBtnDown, false, 0, true ) ; 
				btn.addEventListener(MouseEvent.MOUSE_UP,  this.onBtnUp, false, 0, true ) ; 
				btn.addEventListener(FlexEvent.CREATION_COMPLETE, this.onCreationCompleteBtn, false, 0, true ) 
			}
		}
		
		protected function onCreationCompleteBtn(event:FlexEvent):void
		{
			var dbg : Array = [ event.currentTarget.labelDisplay ] 
			var btn : Button = event.currentTarget as Button; 
			var lbl : StyleableTextField = event.currentTarget.labelDisplay; 
			var lbls : StyleableTextField= new StyleableTextField()
			var btnLblShadow : StyleableTextField = btn.skin['labelDisplayShadow']
			
			
			var lblTxt : String = lbl.text; 
			lbls.text  = lblTxt
			var tf : TextFormat = lbl.defaultTextFormat
			var s : SoundVO = this.dictBtnToSound[event.currentTarget] as SoundVO
			lbls.defaultTextFormat = tf; 
			lbls.text  = s.name
			//	trace( lbl.textWidth, s.name, lbls.textWidth  ) ; 
			if ( lbls.textWidth > btn.width-40)
			{
				btn.label = s.name; 
				btn.setStyle('fontAlign', 'center');
				var newSize : Number =  Number(tf.size) *  (btn.width-40)/lbls.textWidth
				newSize = Math.floor( newSize )  ;
				var minSize : Number = 10; 
				newSize = Math.max(newSize, minSize ) ; 
				trace(  s.name, lbls.textWidth, newSize  ) ; 
				btn.setStyle('fontSize', newSize ) ; 
				lbl.text = s.name; 
				
				tf = lbl.defaultTextFormat; 
				//tf.
				lbl.multiline = true; 
				lbl.wordWrap = true 
				//btnLblShadow.defaultTextFormat = tf
				btnLblShadow.multiline = true; 
				btnLblShadow.wordWrap = true 
				//tf.align = 'center' 
				//tf.size = Number(tf.size) *  lbl.textWidth/btn.width
				//	lbl.defaultTextFormat = tf
			}
			//lbl.autoSize = TextFieldAutoSize.CENTER
			//		lbl.embedFonts = true; 
			
			return; 
		}
		/*
		//for buttons
		protected function onBtnUp(event:MouseEvent):void
		{
		this.timer.stop(); 
		} 
		
		protected function onBtnDown(event:MouseEvent):void 
		{
		this.menuSound = this.dictBtnToSound[event.currentTarget] as SoundVO
		//this.timerStartOn = event.currentTarget
		this.timer.start()
		}
		
		*/
		protected function onBtnUp(event: CustomEvent):void
		{
			this.timer.stop(); 
		} 
		
		protected function onBtnDown(event:CustomEvent):void 
		{
			this.menuSound =  event.data  as SoundVO
			//this.timerStartOn = event.currentTarget
			this.timer.start()
		}
		
		
		
		protected function onScrollList(event: Event):void 
		{
			//trace('scrolled'); 
			this.timer.stop()
		}
		
		
		public static var Ringtone:String = 'Set as Ringtone'; 
		public static var Notification:String = 'Set as Notification'; 
		public static var Alarm:String = 'Set as Alarm'; 
		public static var CancelAction:String = 'Cancel'; 
		public static var Friday:String = 'Friday'; 
		public static var Saturday:String = 'Saturday'; 
		public static var Sunday:String = 'Sunday'; 
		private var menuSound:SoundVO;
		private var testNameSize:Boolean=false;
		private var lastIndex:int;
		private var currentTag:TagVO;
		public function downForTimerTime(e:TimerEvent ) : void
		{
			/*var date : Date = new Date(); 
			var time : Number =date.getTime() - this.oldTime.getTime() ; 
			time = time/ 1000*/
			/*trace('show menu'); 
			var event_ : ShowPopupEvent = new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
			'PopupSelectOptions', [this.model.currentVoice], 'open3_Voice' )   		
			this.dispatch( event_ ) 		
			*/
			//this.menuSound = this.dictBtnToSound[event.currentTarget] as SoundVO
			var options : Array = [Ringtone, Notification, Alarm, CancelAction]
			var selected : Array = []; 
			var selectedString :String = selected.join(',')
			//this.alarm.repeat = [ Tuesday, Wednesday , Sunday].join(','); 
			var event_ : ShowPopupEvent = new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupSelectOptions', ['Options', options, this.onSelectAction], 'selectFromList' )   		
			this.dispatch( event_ ) 	
			
		}
		private function onSelectAction(e  :   String ) : void
		{
			var a : AndroidExtensions = new AndroidExtensions(); 
			if ( e == Ringtone ) 
			{
				a.setRingtone( this.menuSound.url ) ; 
				trace('setting ring tone', this.menuSound.url);//
				return; 
			}
			if ( e == Notification ) 
			{
				a.setNotification( this.menuSound.url ) ; 
				return; 
			}
			if ( e == Alarm ) 
			{
				a.setAlarm( this.menuSound.url ) ; 
				return; 
			}
			if ( e == CancelAction ) 
			{
				return; 
			}			
			
			/*	this.alarm.repeat = e.join(','); 
			this.onUpdateForm();*/
			return ; 
		}
		
		
		private function onSoundClicked(e :  MouseEvent ) : void
		{
			var sound : SoundVO = this.dictBtnToSound[e.currentTarget] as SoundVO
			this.model.playSound( sound ) ; 
			//
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
			this.ui['list'].selectedIndex = -1; 
			trace('change heard'); 
			var sound :  SoundVO = event.data as SoundVO;
			
			this.model.playSound( sound ) ; 
		}
		private function onGoBack(e:Event):void
		{
			//this.dispatch( NavigateCommandTriggerEvent.popView() ); 
		}		
		
		private function onSelectVoice(e:Event=null):void
		{
			//this.dispatch( NavigateCommandTriggerEvent.pushView( SelectVoiceView ) ); 
		}	
		private function onSettings(e:Event=null):void
		{
			//this.dispatch( NavigateCommandTriggerEvent.pushView( SettingsView ) ); 
		}	
		private function onRecordVoice(e:Event=null):void
		{
			//this.dispatch( NavigateCommandTriggerEvent.popView() ); 
		}	
		private function onTest(e:Event=null):void
		{
			var event_ : ShowPopupEvent = new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupTestVoice', [this.model.currentVoice], 'open3_Voice' )   		
			this.dispatch( event_ ) 			
		}	
		private function onHelp(e:Event=null):void
		{
			//this.dispatch( NavigateCommandTriggerEvent.pushView( HelpView ) ); 
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
			if ( this.model.config.colorSet )
			{
				//this.ui.colorHeader.color = this.model.config.color;
				this.ui.colorHeader1.color =ColorUtil.adjustBrightness( this.model.config.color, 15 )
				this.ui.colorHeader2.color = ColorUtil.adjustBrightness( this.model.config.color, -5 )
				//this.ui.button.setStyle('chromeColor', this.model.config.color ) 
			}
			this.ui.txtTitle.text = this.model.config.name; 
			this.ui.txtSubTitle.text = this.model.config.subtitle; 
			//consolidate this ... do this on sound config convert ....
			var resized : Array = this.model.config.image.split('/')  
			resized[resized.length-1] = 'r-'+resized[resized.length-1]; 
			var resizeImage : String = resized.join('/'); 
			this.ui.image.source=  resizeImage; //this.model.config.image 	; 
			return; 
			
		}		
		
		
		
	}
}