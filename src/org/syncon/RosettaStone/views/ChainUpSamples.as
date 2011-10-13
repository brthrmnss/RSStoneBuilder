package  org.syncon.RosettaStone.views {
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.utils.Timer;
	
	import mx.core.SoundAsset;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class ChainUpSamples  
	{
 
		
		
		
		public var song:SoundAsset;
		
		public var soundControl:SoundChannel;
		
		/*protected function onCheckAlarms(event:TimerEvent):void
		{
			this.dispatch( new CheckAlarmsCommandTriggerEvent( CheckAlarmsCommandTriggerEvent.CHECK_ALARMS ) ) ; 
		}*/
		public var sound : Sound; 
		private var currentIndex:int;
		private var songs: Array = []; ;
		public var prefix : String = '';
		public var suffix: String = ''; 
		static public var fxGenerateUrlRequest:Function;
		public function playSounds(a : Array, preabmle : String = '', suf : String = ''   ) : void
		{
			this.cleanUP()
			this.songs = a ; 
			this.prefix = preabmle; 
			this.suffix = suf ; 
			this.currentIndex = 0 ; 
			this.playNextSound()
		}
		
		private function cleanUP():void
		{
			// TODO Auto Generated method stub
			
		}			
		
		public function playSound(url : String , times : int = 0 ) : void
		{
			
			var soundReq:URLRequest = new URLRequest(url)//+'f');
			if ( fxGenerateUrlRequest != null ) 
				soundReq = fxGenerateUrlRequest(url ) 
			if ( sound != null ) 
			{this.stopSound()}
			if ( soundControl != null ) 
			{
				soundControl.removeEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
			}
			this.sound = new Sound(); 
			soundControl = new SoundChannel(); 
			// sound.addEventListener(Event.COMPLETE, completeHandler);
			 sound.addEventListener(IOErrorEvent.IO_ERROR, ioSoundErrorHandler); IOErrorEvent
			 /*
			sound.addEventListener(Event.ID3, id3Handler);
			sound.addEventListener(IOErrorEvent.IO_ERROR, ioSoundErrorHandler);
			sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);*/
			/* var context:SoundLoaderContext = new SoundLoaderContext(0, true);
			 Security.allowDomain("*");
			 Security.allowInsecureDomain("*");
			sound.load(soundReq, context); */
			 var trans:SoundTransform = new SoundTransform(0.6, -1);
			sound.load(soundReq);
			if ( times == 0 ) 
				times = int.MAX_VALUE
			soundControl = sound.play(0,1,trans);
			soundControl.addEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);

		}
		
		protected function onPlaybackComplete(event:Event):void
		{
			//trace('finisehd' )
			this.stopSound(); 
			this.currentIndex++
				this.playNextSound()
		}
		
		private function ioSoundErrorHandler(event:IOErrorEvent):void {
			//do nothing here
			trace( event.text )
			this.onPlaybackComplete(null);
			return;
		}
		protected function completeHandler(event:Event):void
		{
	
			
		}
		
		private function playNextSound():void
		{
			if ( this.currentIndex >= this.songs.length) 
			{
				//this.dispatch( new Event('done');
				this.stopSound(); 
				return; 
			}
			var current : String = this.songs[this.currentIndex]
			this.playSound( this.prefix+current+this.suffix ) ; // 'a.mp3' ); //current+this.suffix ) ; 
			return ;
		}
		
		public function stopSound():void{
			soundControl.stop();
			//mySound.removeEventListener(Event.COMPLETE,completeSound);
			sound = null;
		}
		
		
		
	}
}