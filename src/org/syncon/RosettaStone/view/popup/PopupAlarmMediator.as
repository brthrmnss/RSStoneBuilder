package  org.syncon.RosettaStone.view.popup
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.vo.AlarmVO;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.RotateVO;
	import org.syncon.RosettaStone.model.RSModel;
	
	public class PopupAlarmMediator extends Mediator
	{
		[Inject] public var ui: PopupAlarm;
		[Inject] public var model :  RSModel;
		private var ev : LazyEventHandler = new LazyEventHandler(); 
		private var rotate : RotateVO = new RotateVO()
		private var alarm:AlarmVO;
		
		public function PopupAlarmMediator()
		{
		} 
		override public function onRemove():void
		{
			ev.unmapAll(); 
			super.onRemove()
		}
		override public function onRegister():void
		{
			ev.init( this.ui ) ; //unmap is unnecesary ... 
			this.ev.addEv(PopupAlarm.SNOOZE, this.onSnooze )
			this.ev.addEv(PopupAlarm.DISMISS, this.onDismiss )
			this.ev.addEv( PopupAlarm.SETUP, this.onSetup ) ; 
		}
		
		protected function onSetup(event:Event):void
		{
			var alarm_ : AlarmVO = this.ui.args[0] as AlarmVO
			this.alarm = alarm_
			this.ui.header.label = alarm.name; 
			if ( this.alarm.name == '' || this.alarm.name == null ) 
				this.ui.header.label = 'Alarm'
			this.ui.txtTime.text = alarm.curHhMM()
				
			this.playSound() ; 
		}
		
		private function playSound() : void
		{
			if ( this.alarm.sound == '' || this.alarm.sound == null ) 
				return; 
			
			this.model.playSound( this.model.getUrlAlarm( this.alarm) ) ; 
		}
		
		private function onSnooze(e:Event) : void
		{
			var snoozeTime : Date = new Date()
			snoozeTime.setTime( snoozeTime.getTime()  + 10/10*60*1000 ) 
			this.alarm.time_SnoozeAlarm =snoozeTime
			this.ui.hide();
			this.cleanUp(); 
		}		
		
		
		private function onDismiss(e:Event) : void
		{
			this.alarm.time_SnoozeAlarm =null;
			this.ui.hide();
			this.cleanUp(); 
			//this.ui.listSavedSearches.dataProvider = e.data as ArrayCollection
		}				
		
		public function cleanUp() : void
		{
			this.model.stopSound(); 
		}
		
	}
}