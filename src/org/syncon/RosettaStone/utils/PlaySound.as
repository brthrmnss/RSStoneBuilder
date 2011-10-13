package  org.syncon.RosettaStone.utils
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import mx.core.SoundAsset;
	import flash.net.URLVariables;
	
	public  class   PlaySound  
	{
		public var song:SoundAsset;
		
		public var soundControl:SoundChannel;
		public var sound : Sound; 
		
		public function playSound2(url : String , times : int = 1 , urlReq : URLRequest = null) : void
		{
			
			var soundReq:URLRequest = new URLRequest(url);
			if ( urlReq != null ) 
				soundReq =  urlReq
			if ( sound != null ) 
			{this.stopSound()}
			this.sound = new Sound(); 
			soundControl = new SoundChannel(); 
			//sound.addEventListener(Event.COMPLETE, completeSound);
			/*sound.addEventListener(Event.COMPLETE, completeHandler);
			sound.addEventListener(Event.ID3, id3Handler);
			sound.addEventListener(IOErrorEvent.IO_ERROR, ioSoundErrorHandler);
			sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);*/
			sound.addEventListener(IOErrorEvent.IO_ERROR, ioSoundErrorHandler);
			sound.load(soundReq); 
			if ( times == 0 ) 
				times = int.MAX_VALUE
			soundControl = sound.play(0,times);
			soundControl.addEventListener(Event.SOUND_COMPLETE, this.onSoundComplete ) ; 
		}
		
		protected function onSoundComplete(event:Event):void
		{
			/*	if ( fxCallAfterSoundCompletePlaying != null ) 
			fxCallAfterSoundCompletePlaying(event); */
		}
		
		private function ioSoundErrorHandler(event:IOErrorEvent):void {
			//do nothing here
			trace( event.text )
			return;
		}
		public function stopSound():void{
			if ( sound != null ) 
			{
				soundControl.stop();
				soundControl.removeEventListener(Event.COMPLETE,onSoundComplete);
			}
			sound = null;
		}
		
		static public var  serverBase : String = 'http://localhost:7126/'
		public static function getProxy(url:String):URLRequest
		{
			var req:URLRequest = new URLRequest(serverBase+"play_sound");
			//req.method = URLRequestMethod.POST;
			
			var postData:URLVariables = new URLVariables();
			postData.url =url
			req.data = postData;
			
			return req;
		}
	}
}