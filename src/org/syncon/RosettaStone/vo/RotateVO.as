package  org.syncon.RosettaStone.vo
{
	import flash.events.Event;
	//import flash.events.StageOrientationEvent;

	public class RotateVO
	{
		private var fx :  Function
		private var ui:Object;
 
		/**
		 * listen for added to stage, or setup now if possible 
		 * */
		public function setupStageListeners(  ui : Object = null , callAtEndFx_ : Function = null ):void
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
			if ( this.callAtEndFx != null ) 
				this.callAtEndFx()
			return; 
		}
		
		
		
		
		
	}
}