package org.syncon.RosettaStone.views.clocks.components {
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Linear;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	[Bindable]
	public class Clock extends SkinnableComponent {
		public var secAngle:Number = 0.0;
		public var minAngle:Number = 0.0;
		public var hourAngle:Number = 0.0;
		public var isRunning:Boolean = false;
		
		private var _tween:GTween;
		private var _timer:Timer;
		
		
		public var offsetHours : int  = 0 ; 
		
		
		
		public function Clock() {
			super();
			_tween = new GTween(this, 2, {'secAngle':secAngle, 'minAngle':minAngle, 'hourAngle':hourAngle}, {'ease':Linear.easeNone});
			tickHandler(null);
			
			_timer = new Timer(2000,0);
			_timer.addEventListener(TimerEvent.TIMER, tickHandler);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
		}
		
		private var  _label : String = '';
		
		[SkinPart(required="false")]
		public var localeLabel:Label;
		[SkinPart(required="false")]
		public var labelHolder: Group;	
		
		private var _dialDiamter:Number;
		
		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			_label = value;
			if ( this.localeLabel != null ) 
			{
				this.labelHolder.visible = true; 
				this.localeLabel.text = _label;
			}
		}
		
		public function set dialDiamter(value: Number):void
		{
			_dialDiamter = value;
			if ( skin != null ) 
				skin['dialDiamter'] = value; 
		}		
		
		override protected function partAdded(partName:String, instance:Object):void {
			super.partAdded(partName, instance)
			switch (instance){
				case localeLabel:
					this.localeLabel.text =  this._label 
					//playPauseButton.addEventListener(MouseEvent.CLICK, playSound)
					//playPauseButton.selected = isPlaying;
					break;
				
			}
			//skin['dialDiamter'] = value; 
		}
		override protected function partRemoved(partName:String, instance:Object):void {
			super.partRemoved(partName, instance)
			switch (instance){
				case localeLabel:
					//playPauseButton.removeEventListener(MouseEvent.CLICK, playSound)
					break;
				
			}
		}
		
		
		public function startClock():void {
			tickHandler(null);
			
			isRunning = true;
			_timer.reset();
			_timer.start();
		}
		
		public function stopClock():void {
			_timer.stop();
			isRunning = false;
		}

		private function tickHandler(e:TimerEvent):void {
			var t:Date = new Date();
			t.setTime( t.getTime() + offsetHours*60*60*1000  )  
			var h:Number = t.getHours();
			var m:Number = t.getMinutes() + h * 60;
			var s:Number = t.getSeconds() + m * 60;
			var ms:Number = t.getMilliseconds();
			
			//multiply by 6 to get basic sec angle, then add up to
			//5.994 degrees (999 * 0.006) to account for milliseconds
			_tween.proxy.secAngle = -90 + s * 6 + ms * 0.006;
			
			//multiply by 6 to get basic min angle, then add up to
			//5.9 degrees (59 * 0.1) to account for seconds
			_tween.proxy.minAngle = -90 + s * 0.1;
			
			//multiply by 30 to get basic hour angle, then add up to
			//29.5 degrees (59 * 0.5) to account for minutes, and up to
			//0.4916666667 degrees (59 * 1/120) to account for seconds
			_tween.proxy.hourAngle = -90 + (s / 120);
		}
		
		public function updateTime(e:TimerEvent=null):void {
			var t:Date = new Date();
			t.setTime( t.getTime() + offsetHours*60*60*1000  )  
			var h:Number = t.getHours();
			var m:Number = t.getMinutes() + h * 60;
			var s:Number = t.getSeconds() + m * 60;
			var ms:Number = t.getMilliseconds();
			
			//multiply by 6 to get basic sec angle, then add up to
			//5.994 degrees (999 * 0.006) to account for milliseconds
			_tween.proxy.secAngle = -90 + s * 6 + ms * 0.006;
			
			//multiply by 6 to get basic min angle, then add up to
			//5.9 degrees (59 * 0.1) to account for seconds
			_tween.proxy.minAngle = -90 + s * 0.1;
			
			//multiply by 30 to get basic hour angle, then add up to
			//29.5 degrees (59 * 0.5) to account for minutes, and up to
			//0.4916666667 degrees (59 * 1/120) to account for seconds
			_tween.proxy.hourAngle = -90 + (s / 120);
		}
		public function updateTime2(e:TimerEvent=null):void {
			var t:Date = new Date();
			t.setTime( t.getTime() + offsetHours*60*60*1000  )  
			var h:Number = t.getHours();
			var m:Number = t.getMinutes() + h * 60;
			var s:Number = t.getSeconds() + m * 60;
			var ms:Number = t.getMilliseconds();
			
			//multiply by 6 to get basic sec angle, then add up to
			//5.994 degrees (999 * 0.006) to account for milliseconds
			secAngle = -90 + s * 6 + ms * 0.006;
			
			//multiply by 6 to get basic min angle, then add up to
			//5.9 degrees (59 * 0.1) to account for seconds
			minAngle = -90 + s * 0.1;
			
			//multiply by 30 to get basic hour angle, then add up to
			//29.5 degrees (59 * 0.5) to account for minutes, and up to
			//0.4916666667 degrees (59 * 1/120) to account for seconds
			hourAngle = -90 + (s / 120);
		}
		private function completeHandler(e:TimerEvent):void {
			isRunning = false;
		}
	}
}