package org.syncon.RosettaStone.vo
{
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.sensors.Accelerometer;
	import flash.utils.Timer;

	public class ShakeVO 
	{
		
		//private static const _SHAKE_WAIT = 500;
		// Add these two private variables to your class
		private var _accl : Accelerometer;
		private var _lastShake : Number = 0;
		private var timer : Timer = new Timer(2000, 1 ); 
		private var fxCallAtShake : Function ; 
		private var ui:Object;
		private var blocking:Boolean=false;
		public function init( ui : Object , fxCallAtShake : Function) : void{
			this.ui = ui ;
			this.fxCallAtShake = fxCallAtShake 
			// Put this where you initialize your class – it detects if accelerometer is supported on the device and adds the listener
			if (Accelerometer.isSupported)
			{
				_accl = new Accelerometer();
				_accl.addEventListener(AccelerometerEvent.UPDATE, onAccelerometer);
				_accl.setRequestedUpdateInterval(1000 )
			}
			

			
			timer.addEventListener(TimerEvent.TIMER, this.onResetTimer, false , 0 , true )
			this.ui.addEventListener(Event.REMOVED_FROM_STAGE, this.removeStageListeners, false, 0, true ) ; 
		}		
		private function removeStageListeners(e:Event=null):void
		{
			this.ui.stage.removeEventListener(Event.REMOVED_FROM_STAGE, this.removeStageListeners )
			timer.removeEventListener( TimerEvent.TIMER, this.onResetTimer ) ; 
			// Put this where you destroy your class – it detects if accelerometer is supported on the device and removes the listener
			if (Accelerometer.isSupported)
			{
				_accl.removeEventListener(AccelerometerEvent.UPDATE, onAccelerometer);
			}
		}
		
		private function onResetTimer(e:Event):void
		{
			this.blocking = false; 
		}		
		
		// Add this method to your class – it is the callback for the accelerometer
		public function onAccelerometer(e:AccelerometerEvent) : void
		{
			if ( blocking ) 
			{
				return;
			}
			//trace('accelerations', e.accelerationX, e.accelerationY, e.accelerationZ )
			if ( Math.abs( e.accelerationX ) >= 0.9 ||   Math.abs(e.accelerationY) >= 0.9 )// || e.accelerationZ >= .5)
			{
				fxCallAtShake(); 
				this.blocking = true; 
				this.timer.start();
			}
		}
		
		
		
		
		
	}
}