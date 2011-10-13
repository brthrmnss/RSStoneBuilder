package  	org.syncon.RosettaStone.view.popup.rs 
{
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.AutomateEvent;
	import org.syncon.RosettaStone.controller.NavigateCommandTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.Places;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	import org.syncon.RosettaStone.vo.OrientationVO;
	import org.syncon.RosettaStone.vo.RotateVO;
	
	public class  PopupLessonCompleteMediator extends Mediator
	{
		[Inject] public var ui:PopupLessonComplete;
		[Inject] public var model : RSModel;
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
		private var rotate : RotateVO = new RotateVO()
		public function PopupLessonCompleteMediator()
		{
		} 
		override public function onRemove():void
		{
			ev.unmapAll(); 
			super.onRemove()
		}
		override public function onRegister():void
		{
			ev.init( this.ui ) ; 
			this.ev.addEv(PopupLessonComplete.CANCEL, this.onCancel )
			this.ev.addEv( PopupLessonComplete.SETUP, this.onSetup ) ; 
			
			this.ev.addEv(PopupLessonComplete.REPEAT, this.onRepeat )
			this.ev.addEv( PopupLessonComplete.NEXT_LESSON, this.onNext ) ; 
			this.ev.addEv(PopupLessonComplete.GO_HOME, this.noHome )
		}
		
		
		protected function onRepeat(event:Event=null):void
		{
			this.ui.hide(); 
			this.dispatch( new AutomateEvent(AutomateEvent.START_LESSON, this.ui.lesson )) 
		}
		
		protected function onNext(event:Event=null):void
		{
			this.ui.hide(); 
			this.dispatch( new AutomateEvent(AutomateEvent.NEXT_LESSON, this.ui.lesson )) 
			//this.dispatchEvent( new Event( NEXT_LESSON ) )  
			
		}
		
		protected function noHome(event:Event=null):void
		{
			this.ui.hide(); 
			this.dispatch( new NavigateCommandTriggerEvent(NavigateCommandTriggerEvent.PUSH, 
				Places.HOME	) ) ; 
		}		
		
		
		protected function onSetup(event:Event):void
		{
			this.ui.txtLessonName.text = this.model.currentLesson.name; 
		}
		
		
		
		
		private function onCancel(e:Event) : void
		{
			this.ui.hide();
		}				
		
		
	}
}