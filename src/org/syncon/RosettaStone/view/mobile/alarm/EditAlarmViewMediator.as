package  org.syncon.RosettaStone.view.mobile.alarm
{
	//import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.ConfigCommandTriggerEvent;
	import org.syncon.TalkingClock.controller.LoadWidgetCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.NavigateCommandTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.vo.AlarmVO;
	import org.syncon.TalkingClock.vo.IWidgetConfigVO;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.StyleConfigurator;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	import spark.formatters.DateTimeFormatter;
	
	public class  EditAlarmViewMediator extends Mediator
	{
		[Inject] public var ui:  EditAlarmView;
		[Inject] public var model :  RSModel;
		private var styler:StyleConfigurator=new  StyleConfigurator();
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
		private var alarm:AlarmVO;
		public function EditAlarmViewMediator()
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
			ev.addEv( EditAlarmView.EDIT_NAME, this.onEditName ) ; 
			ev.addEv( EditAlarmView.EDIT_REPEAT, this.onEditRepeat ) ; 
			
			ev.addEv( EditAlarmView.DONE, this.onDone ) ; 
			ev.addEv( EditAlarmView.DELETE, this.onDelete ) ; 
			
			
			ev.addEv( EditAlarmView.EDIT_SOUND, this.onEditSound ) ; 	
			ev.addEv( EditAlarmView.CHANGED_ENABLED, this.onChangeEnabled ) ; 
			ev.addEv( EditAlarmView.EDIT_TIME, this.onEditTime ) ; 				
			ev.addEv( FlexEvent.DATA_CHANGE, this.onDataChange )
			//eventMap.mapListener(eventDispatcher, NightStandModelEvent.WIDGET_CONFIG_CHANGED,
			//	this.onConfigChanged);	
			this.styler.init( this.ui, this.model.config  );
			/*if ( model.currentConfigSet ) 
			this.onConfigChanged(null)*/
			this.alarm = this.ui.data as AlarmVO; 
			this.onUpdateForm(); 
		}
		
		private function onDelete(e:Event):void
		{
			var index : int = this.model.alarmList.getItemIndex( this.alarm ) ; 
			this.model.alarmList.removeItemAt( index )//, 1 )
				this.onSave(); 
			this.dispatch(   NavigateCommandTriggerEvent.popView() ) ;
		}
		
		private function onDone(e:Event):void
		{
			this.alarm.new1 = false; //so it can actually function 
			this.onSave()
			this.dispatch(   NavigateCommandTriggerEvent.popView() ) ;
			
		}
		public function onUpdateForm() : void 
		{
			this.ui.cbEnabled.selected = this.alarm.enabled
			
			var e : Array = this.alarm.repeat.split(','  ) ; 
			var txt : String = ''; 
			var days : Array = [] 
			for each ( var str : String in e ) 
			{
				
				days.push( str.slice(0,3 )  )
			}
			txt = days.join(', ' ) ; 
			this.ui.txtRepeat.text = txt
			if ( e.length == 0 || this.alarm.repeat == '' || this.alarm.repeat == null  ) 
				this.ui.txtRepeat.text = 'Never Repeat' 
			
			this.ui.txtName.text = this.alarm.name; 
			
			if ( this.alarm.time == null ) 
			{
				this.ui.txtTime.text = 'Not Set';
			}
			else
			{
				var  dd :  DateTimeFormatter = new DateTimeFormatter()
				dd.dateTimePattern = "HH:mm"
				this.ui.txtTime.text = dd.format( this.alarm.time ) ; 
			}
			this.ui.txtSound.text = this.alarm.sound ; 
		}
		
		private function onChangeEnabled(e:CustomEvent):void
		{
			// TODO Auto Generated method stub
			this.alarm.enabled = e.data as Boolean; 
		}
		
		public function onDataChange ( e : FlexEvent )  : void
		{
			this.alarm = this.ui.data as AlarmVO; 
			
		}
		
		private function onEditName(e:Event):void
		{
			var event_ : ShowPopupEvent = new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupTextArea', ['Name', this.alarm.name, this.onChangedName,20], 'editText' )   		
			this.dispatch( event_ ) 			
		}		
		private function onChangedName(e  :   String ) : void
		{
			this.alarm.name = e; 
			this.onUpdateForm();
			return ; 
		}
		
		public static var Monday:String = 'Monday'; 
		public static var Tuesday:String = 'Tuesday'; 
		public static var Wednesday:String = 'Wednesday'; 
		public static var Thursday:String = 'Thursday'; 
		public static var Friday:String = 'Friday'; 
		public static var Saturday:String = 'Saturday'; 
		public static var Sunday:String = 'Sunday'; 
		
		private function onEditRepeat(e:Event):void
		{
			var options : Array = [Monday, Tuesday, Wednesday, Thursday,Friday ,Saturday , Sunday]
			//this.alarm.repeat = [ Tuesday, Wednesday , Sunday].join(','); 
			var event_ : ShowPopupEvent = new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupSelectableList', ['Repeat Settings', options, this.alarm.repeat.split(','), this.onSelectRepeat], 'selectFromList' )   		
			this.dispatch( event_ ) 			
		}				
		private function onSelectRepeat(e  :  Array ) : void
		{
			this.alarm.repeat = e.join(','); 
			this.onUpdateForm();
			return ; 
		}
		
		private function onEditSound(e:Event):void
		{
			var options : Array = this.model.alarms.toArray(); 
			var event_ : ShowPopupEvent = new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupRadioList', ['Sound', options, this.alarm.sound, this.onSelectSound, this.playSound, this.onClosePopup], 'selectFromList' )   		
			this.dispatch( event_ ) 			
		}		
		private function playSound(e  : String ) : void
		{
			this.model.playSound( this.model.getUrlAlarm( null, e ), 1 ) ; 
		}
		
		private function onSelectSound(e  : String ) : void
		{
			this.model.stopSound(); 
			this.alarm.sound = e; 
			this.onUpdateForm(); 
		}		
		
		private function onClosePopup(  ) : void
		{
			this.model.stopSound(); 
		}		
		
		
		private function onEditTime(e:Event):void
		{
			var options : Array = ['Robot', 'Drock'] ; 
			var event_ : ShowPopupEvent = new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupSetTime', ['Set Time', this.alarm.time, this.onSetTime], 'selectTime' )   		
			this.dispatch( event_ ) 
		}
		private function onSetTime( e: Date):void
		{
			this.alarm.time = e
			this.onUpdateForm();
		}
		
		
		public function onSave() : void
		{  
			this.dispatch( new ConfigCommandTriggerEvent(ConfigCommandTriggerEvent.SAVE_AND_LOAD_CONFIG ));  
		}
		
		
		
	}
}