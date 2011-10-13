package org.syncon.RosettaStone.controller
{
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.AlarmVO;
	import org.syncon.RosettaStone.vo.NightStandConfigVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	import spark.formatters.DateTimeFormatter;
	
	/**
	 * Goes through all alarms on model and verifies 
	 * 
	 * */
	public class CheckAlarmsCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:CheckAlarmsCommandTriggerEvent;
		/**
		 * Testing only, will display name of triggered alarm 
		 * */
		public var traceOnly : Boolean = false 
		override public function execute():void
		{
			if ( event.type == CheckAlarmsCommandTriggerEvent.CHECK_ALARMS ) 
			{
				this.checkAlarms()
			}				
			
		}
		static public var  dd :  DateTimeFormatter;
		
		public function checkAlarms(overrideCurrentTime:Date=null) : void
		{
			var debug : Boolean = false; 
			//var config : NightStandConfigVO = this.model.config ;
			var currentTime : Date = new Date()
			if ( overrideCurrentTime != null ) 
				currentTime.setTime( overrideCurrentTime.getTime() ); 
			
			if ( dd == null )
			{
				dd= new DateTimeFormatter()
				dd.dateTimePattern = "EEEE"
				
			}
			var dayOfWeek : String = dd.format( currentTime ) ; 
			
			for each ( var o : AlarmVO in this.model.alarmList.toArray() ) 
			{
				if ( o.enabled == false ) 
					continue; 
				if ( o.new1 ) 
					continue; 
				var time : Date = o.time; 
				var time2 : Date = o.time_SnoozeAlarm;
				//if ( o.triggered
				if ( time2 == null ) 
					time2 = time; 
				//trace(time.getHours(), currentTime.getHours(), ';', time.getMinutes() , currentTime.getMinutes() );
				//time.getDay()
				
				
				if ( o.time_SnoozeAlarm != null ) 
				{
					
					same= false; 
					surpress = false 
					same = o.compareTimes( o.time_SnoozeAlarm, currentTime ) ; 
					if ( debug ) trace('snooze not null ....', same ) ; 
					if ( same ) 
					{
						o.time_SnoozeAlarm = null; 
						this.showAlarm( o ) ; 
					}
					return; 
				}
				
				
				var same : Boolean = o.compareTimes( o.time, currentTime, o.repeat ) ; 
				if ( o.lastAlarmActivation != null ) 
				{
					var surpress : Boolean = o.compareTimes( o.lastAlarmActivation, currentTime, '', true  ) ; 
				}
				if ( surpress == true ) 
				{
					return;  
				}
				if ( surpress == false && same == true ) 
				{
					o.lastAlarmActivation = new Date()
						
					o.lastAlarmActivation.setTime(  o.time.getTime()   ) ; 
					this.showAlarm( o ) ; 
				}
				 
			}
		}
		
		public function showAlarm ( o : AlarmVO ) : void
		{
			if ( this.traceOnly ) 
			{ 
				trace('showAlarm', o.name ) ; 
				return
			}
			var event_ : ShowPopupEvent = new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupAlarm', [o], 'editText' ) 		
			this.dispatch( event_ ) 
		}
		
		public static var Monday:String = 'Monday'; 
		public static var Tuesday:String = 'Tuesday'; 
		public static var Wednesday:String = 'Wednesday'; 
		public static var Thursday:String = 'Thursday'; 
		public static var Friday:String = 'Friday'; 
		public static var Saturday:String = 'Saturday'; 
		public static var Sunday:String = 'Sunday'; 
		
		static public function test() : void
		{
			var arr : Array = []; 
			var recursDays : Array = 
				[
					[Monday, Wednesday], 
					[], 
					[Sunday], 
					[Friday]
				]
			var time : Date = new Date()
			time.setHours( 12, 0,0 , 0 ); 
			var alarms : Array = []; 
			for each ( var days : Array  in recursDays ) 
			{
				var a : AlarmVO = new AlarmVO()
				a.name = 'alarm '+( alarms.length+1);
				a.time = time; 
				a.repeat = days.join(',');
				a.enabled = true; 
				a.new1 = false; 
				alarms.push( a  ) 
			}
			
			var cmd : CheckAlarmsCommand = new CheckAlarmsCommand();
			cmd.traceOnly = true; 
			var model : RSModel = new RSModel()
			model.loadAlarms(  alarms )  
			cmd.model = model; 
			for ( var i : int = 0 ; i <14; i++) 
			{
				//time.setTime( time.getTime() + (24*60*60*1000) )
				trace( 'day', time ) ; 
				cmd.checkAlarms( new Date( time.getTime() ) )
				time.setTime( time.getTime() + (24*60*60*1000) )
			}
			trace('test complete');
			return; 
		}
		
		
	}
}