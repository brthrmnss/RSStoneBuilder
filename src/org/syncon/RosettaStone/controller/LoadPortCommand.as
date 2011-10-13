package org.syncon.RosettaStone.controller
{
	
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.Capabilities;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.SoundBoardConfigVO;
	import org.syncon.RosettaStone.vo.SoundVO;
	import org.syncon2.utils.mobile.AndroidExtensions;
	
	
	public class LoadPortCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:LoadPortCommandTriggerEvent;
		private var timer:Timer;
		
		override public function execute():void
		{
			if ( event.type == LoadPortCommandTriggerEvent.LOAD_PORT ) 
			{
				this.timer = new Timer(1000,3); 
				this.timer.addEventListener(TimerEvent.TIMER, this.findPortFile ) ; 
				this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onTimerComplete  ) ; 
				this.findPortFile();
			}				
			
		}
		
		protected function onTimerComplete(event:TimerEvent):void
		{
			trace('could nto find file'); 
			if ( NightStandConstants.debug == false )
			this.model.alert('Could not find a port ' + File.applicationStorageDirectory.nativePath, 'Port' ) 		
			this.timer.removeEventListener(TimerEvent.TIMER, this.findPortFile ) ; 
			this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onTimerComplete  ) ; 
		}
		
		private function findPortFile(e:Event=null):void
		{
			 var ff : File = File.applicationStorageDirectory;
			 
				ff = ff.resolvePath( 'port.txt' )
				if ( ff.exists == false ) 
				{
					if ( this.timer.running == false ) {
					this.timer.start();}
						return; 
				}
				this.timer.stop(); 
				
				
				var obj:Object;
				var fileStream:FileStream = new FileStream();
				fileStream.open(ff, FileMode.READ);
				var   v : Object = fileStream.bytesAvailable
				obj = fileStream.readUTFBytes(fileStream.bytesAvailable ); 
				
				fileStream.close();
			
				if ( obj == null ) 
				{
					obj == 'null ...' 
				}
				this.model.port = Number( obj ) ;
				trace('recieved port number', this.model.port ) ; 
				AndroidExtensions.port = this.model.port; 
				//this.model.alert(obj.toString() + ' v:'  + v.toString() , 'Port' ) 				 
				this.timer.removeEventListener(TimerEvent.TIMER, this.findPortFile ) ; 
				this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onTimerComplete  ) ;
				ff.deleteFile()
		}
	 
		
	}
}