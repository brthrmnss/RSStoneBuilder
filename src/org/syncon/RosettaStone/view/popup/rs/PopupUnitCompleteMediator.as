package  	org.syncon.RosettaStone.view.popup.rs 
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.AutomateEvent;
	import org.syncon.RosettaStone.controller.NavigateCommandTriggerEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.Places;
	import org.syncon.RosettaStone.vo.LazyEventHandler;
	
	public class  PopupUnitCompleteMediator extends Mediator
	{
		[Inject] public var ui:PopupUnitComplete;
		[Inject] public var model : RSModel;
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
		public function PopupUnitCompleteMediator()
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
			this.ev.addEv(PopupUnitComplete.CANCEL, this.onCancel )
			this.ev.addEv( PopupUnitComplete.SETUP, this.onSetup ) ; 
			
			this.ev.addEv(PopupUnitComplete.REPEAT, this.onRepeat )
			this.ev.addEv( PopupUnitComplete.NEXT_LESSON, this.onNext ) ; 
			this.ev.addEv(PopupUnitComplete.GO_HOME, this.noHome )
		}
		
		
		protected function onRepeat(event:Event=null):void
		{
			this.dispatch( new AutomateEvent(AutomateEvent.START_LESSON, this.model.currentLesson ))
			this.ui.hide(); 
		}
		
		protected function onNext(event:Event=null):void
		{
			this.dispatch( new AutomateEvent(AutomateEvent.NEXT_LESSON, this.model.currentLesson )) 
			//this.dispatchEvent( new Event( NEXT_LESSON ) )  
			this.ui.hide(); 
		}
		
		protected function noHome(event:Event=null):void
		{
			this.dispatch( new NavigateCommandTriggerEvent(NavigateCommandTriggerEvent.PUSH, 
				Places.HOME	) ) ; 
			this.ui.hide(); 
		}		
		
		
		protected function onSetup(event:Event):void
		{
			this.ui.txtLessonName.text = this.model.currentUnit.name; 
			
		}
		
		
		private function onCancel(e:Event) : void
		{
			this.ui.hide();
		}				
		
		
	}
}