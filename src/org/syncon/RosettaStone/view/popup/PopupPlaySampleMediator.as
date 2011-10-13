package  org.syncon.RosettaStone.view.popup
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.AlarmVO;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.RotateVO;
	import org.syncon.RosettaStone.vo.SampleVO;
	
	public class PopupPlaySampleMediator extends Mediator
	{
		[Inject] public var ui: PopupPlaySample;
		[Inject] public var model :  RSModel;
		private var ev : LazyEventHandler = new LazyEventHandler(); 
		private var rotate : RotateVO = new RotateVO()
		private var sample : SampleVO;
		
		public function PopupPlaySampleMediator()
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
			 this.ev.addEv(PopupPlaySample.PLAY, this.onPlay )
			this.ev.addEv(PopupPlaySample.DISMISS, this.onDismiss ) 
			this.ev.addEv( PopupPlaySample.SETUP, this.onSetup ) ; 
		}
		
		protected function onSetup(event:Event):void
		{
			var sample_ : SampleVO = this.ui.args[0] as SampleVO
			this.sample = sample_
			this.ui.header.label = sample.name; 
			if ( this.sample.name == '' || this.sample.name == null ) 
				this.ui.header.label = 'Sample'
			//this.ui.txtTime.text = alarm.curHhMM()
				
			this.playSound() ; 
		}
		
		private function playSound() : void
		{
			if ( this.sample.url == '' || this.sample.url == null ) 
				return; 
			
			this.model.playSound(  this.sample.url  ) ; 
		}
 
		private function onPlay(e:Event) : void
		{
			//var snoozeTime : Date = new Date()
			//snoozeTime.setTime( snoozeTime.getTime()  + 10/10*60*1000 ) 
			//this.alarm.time_SnoozeAlarm =snoozeTime
			//this.ui.hide();
			//this.cleanUp(); 
			this.playSound(); 
		}		
		
		
		private function onDismiss(e:Event) : void
		{
			//this.alarm.time_SnoozeAlarm =null;
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