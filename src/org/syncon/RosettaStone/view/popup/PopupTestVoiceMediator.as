package  org.syncon.RosettaStone.view.popup
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.AlarmVO;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.RotateVO;
	import org.syncon.RosettaStone.vo.SampleVO;
	import org.syncon.RosettaStone.vo.VoiceVO;
	
	public class PopupTestVoiceMediator extends Mediator
	{
		[Inject] public var ui: PopupTestVoice ;
		[Inject] public var model :  RSModel;
		private var ev : LazyEventHandler = new LazyEventHandler(); 
		private var rotate : RotateVO = new RotateVO()
		private var sample : SampleVO;
		private var modeVoice:Boolean;
		private var voice:VoiceVO;
		
		public function PopupTestVoiceMediator()
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
			this.ev.addEv(PopupTestVoice.PLAY, this.onPlay )
			this.ev.addEv(PopupTestVoice.DISMISS, this.onDismiss ) 
			this.ev.addEv( PopupTestVoice.SETUP, this.onSetup ) ; 
			this.ev.addEv( PopupTestVoice.SETUP_SAMPLE, this.onSetupSample ) ; 			
		}
		
		protected function onSetupSample(event:Event):void
		{
			this.modeVoice = false; 
			
			var sample_ : SampleVO = this.ui.args[0] as SampleVO
			
			this.sample = sample_
			if ( this.sample == null ) 
				return; 
			this.ui.header.label = 'Test Voice:' + sample.name; 
			if ( this.sample.name == '' || this.sample.name == null ) 
				this.ui.header.label = 'Sample'
			//this.ui.txtTime.text = alarm.curHhMM()
			
			this.playSound() ; 
		}
		
		
		protected function onSetup(event:Event):void
		{
			this.model.mute = true; 
			this.modeVoice = true; 
			var sample_ :  VoiceVO = this.ui.args[0] as VoiceVO
			
			this.voice = sample_
			if ( this.voice == null ) 
				return; 
			this.ui.header.label = voice.name; 
			if ( this.voice.name == '' || this.voice.name == null ) 
				this.ui.header.label = 'Voice'
			//this.ui.txtTime.text = alarm.curHhMM()
			this.ui.talker.loadVoice( this.voice )
			this.ui.talker.updateSettings(false, 0, 0 ) ; 
			this.playSound() ; 
		}		
		
		private function playSound() : void
		{
			if ( this.modeVoice )
			{
				
				this.ui.talker.say( this.ui.timeSelector.getDate()  ) ; 
			}
			else
			{
				if ( this.sample.url == '' || this.sample.url == null ) 
					return; 
				
				this.model.playSound(  this.sample.url  ) ;
			}
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
			//this.ui.listSavedSearches.dataProvider = e.data as ArrayCollection\
			this.model.mute = false; 
		}				
		
		public function cleanUp() : void
		{
			this.model.stopSound(); 
		}
		
	}
}