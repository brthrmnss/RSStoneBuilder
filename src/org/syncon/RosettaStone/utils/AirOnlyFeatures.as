package  org.syncon.RosettaStone.utils
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.StageDisplayState;
	
	public  class   AirOnlyFeatures 	 implements  IAirOnlyFeatures
	{
		static public var stage : Object; 
		public function goIntoFullscreenMode() : void
		{
			//stage.displayState = StageDisplayState.FULL_SCREEN;
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
		
		public function leaveFullscreenMode() : void
		{
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		public function disableKeyLock () : void
		{
			var ee :  StageDisplayState
			//prevent screen dimming
			//Persmissions xml file has to have android.permission.WAKE_LOCK 
			//android.permission.DISABLE_KEYGUARD enabled!
			NativeApplication.nativeApplication.systemIdleMode = 
				SystemIdleMode.KEEP_AWAKE;
			

		}
		public function enableKeyLock() : void
		{
			//prevent screen dimming
			//Persmissions xml file has to have android.permission.WAKE_LOCK 
			//android.permission.DISABLE_KEYGUARD enabled!
			NativeApplication.nativeApplication.systemIdleMode = 
				SystemIdleMode.NORMAL
		}
		
		public function exitApp() : void
		{
			 NativeApplication.nativeApplication.exit();
		}
		
	}
}