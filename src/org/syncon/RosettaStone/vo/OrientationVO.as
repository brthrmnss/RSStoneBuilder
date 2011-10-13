package  org.syncon.RosettaStone.vo
{
	import flash.events.Event;

	public class OrientationVO  
	{
		
		public var multiplier :Number ; 
		//[ StageOrientation.DEFAULT, StageOrientation.UNKNOWN, StageOrientation.UPSIDE_DOWN]
		static public    var VERTICAL_DEVICE_STATES:Array;
		private var ui:Object;
		public function test() : void
		{
			
		}
		
		/**
		 * listen for added to stage, or setup now if possible 
		 * */
		public function setupStageListeners(e:Event=null, ui : Object = null , callAtEndFx_ : Function = null ):void
		{
			if ( ui != null ) 
					this.ui = ui ;
			if ( callAtEndFx_ != null ) 
			this.callAtEndFx = callAtEndFx_
			if ( this.ui.stage == null ) 
			{
				this.ui.addEventListener(Event.ADDED_TO_STAGE, this.setupStageListeners, false, 0, true ) ; 
				return
			}
			this.ui.removeEventListener(Event.ADDED_TO_STAGE, this.setupStageListeners )
			this.ui.addEventListener(Event.REMOVED_FROM_STAGE, this.removeStageListeners, false, 0, true ) ; 
			this.ui.stage.addEventListener('orientationChange', this.stageOrientationChange,false, 0, true ) ;
			stageOrientationChange(null)
		}
		
		private var  callAtEndFx : Function
		
		private function removeStageListeners(e:Event=null):void
		{
			this.ui.stage.removeEventListener(Event.REMOVED_FROM_STAGE, this.removeStageListeners )
			this.ui.stage.removeEventListener('orientationChange', this.stageOrientationChange  ) ; 
		}
		
		public  function stageOrientationChange(event:Event,tryLaterIfUnknown: Boolean=true):void {

			//trace("Device Orientation = " + ui.stage.deviceOrientation  ) ; 
			var deviceOrientation :  String = ui.stage['deviceOrientation']
			
			
			var normal :  Array = VERTICAL_DEVICE_STATES
			this.multiplier = this.ui.width/this.ui.height *.9
			/*
			//workaround for start rotation unknown, use deprec stage.oritiantaion 
			if ( deviceOrientation ==  StageOrientation.UNKNOWN && tryLaterIfUnknown == false )
			{
			deviceOrientation = ui.stage['orientation']
			var dbg : Array = [ui.stage.width, ui.stage.height] ;
			//we'll just assume it's not normal else it would've complained right? 
			//most don't support upside down 
			//multipler = this.ui.height/this.ui.width *.9
			multipler = this.ui.height /this.ui.width*.9
			}
			*/
			//this is strange, but if you are not in normal group ... you should be expanded, 
			//so flip if ration < 1
			if ( this.multiplier< 1 ) 
			{
				this.multiplier = this.ui.height /this.ui.width*.9
			}
			
		 	if ( normal.indexOf( deviceOrientation) != -1 ) 
				this.multiplier = 1 
			/*	if ( deviceOrientation ==  StageOrientation.UNKNOWN && tryLaterIfUnknown)
			{
			import flash.utils.setTimeout
			setTimeout( this.stageOrientationChange, 520, event, false  ) 
			}
			*/
			//onUpdateWidgetConfig(null)
			if ( this.callAtEndFx != null ) 
				this.callAtEndFx()
			return; 
		}
		
		
		
		
		
	}
}