package  org.syncon.RosettaStone.view.ellips
{
	import flash.events.Event;
	
	import mvc.controller.SwitchScreensTriggerEvent;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.AutomateEvent;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.*;
	import org.syncon.RosettaStone.model.RSMobileModel;
	
	
	public class GettingStartedViewMediator extends Mediator
	{
		[Inject] public var ui: GettingStartedView;
		[Inject] public var model : RSModel;
		[Inject] public var modelMobile : RSMobileModel;		
		
		public var injections  : Array = ['model', RSModel,'modelMobile', RSMobileModel]  
		
		private var currentUnit:UnitVO;
		
		private var styler:StyleConfigurator;
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
 
		override public function onRemove():void
		{
			ev.unmapAll(); 
			super.onRemove()
		}
		override public function onRegister():void
		{
			
			ev.init( this.ui ) ; 
			
			this.styler = new StyleConfigurator(); 
			this.ev.addEv( GettingStartedView.OK, this.onOK ) 
			this.ev.addEv( GettingStartedView.RESUME, this.onResume ) 
			eventMap.mapListener(eventDispatcher, RSModelEvent.LOADED_LAST_LESSON, 
				this.onLoadedLastLesson);	
			this.onLoadedLastLesson( null ) 				
			this.ev.addEv( GettingStartedView.SELECT_LESSON, this.onSelectLesson ) 
			
			//this.ev.addEv( GettingStartedView.DEBUG, this.onDebug ) 
			eventMap.mapListener(eventDispatcher, RSModelEvent.DEBUG_MODE_CHANGED, 
				this.onDebugModeChanged);	
			this.onDebugModeChanged( null ) 		
				
		}
		
		private function onOK(e:Event):void
		{
			// TODO Auto Generated method stub
			this.dispatch( SwitchScreensTriggerEvent.GoBack() )
		}
		
		private function onDebug(e:Event):void
		{
			this.model.debugMode = ! this.model.debugMode; 
		}
		
		public function  onDebugModeChanged (e:Event) : void
		{
			this.ui.debug.visible = this.model.debugMode; 
		}
		
		protected function onResume(event:Event):void
		{
			/*
			this.dispatch( SwitchScreensTriggerEvent.GoBack() )
			var e :  SwitchScreensTriggerEvent =SwitchScreensTriggerEvent.GoTo(
				SwitchScreensTriggerEvent.PLAYER_VIEW ) 
			this.dispatch( e ) */
			//this.model.currentLesson = this.model.
			this.modelMobile.goToPlayer( 1 ) ; 
			this.dispatch( new AutomateEvent(AutomateEvent.RESUME_LESSON, null ) ) ; 
			//who loads this ?  
		} 
		
		
		
		private function onSelectLesson(param0:Object):void
		{
			this.dispatch( SwitchScreensTriggerEvent.GoBack() )
			//return
			var e :  SwitchScreensTriggerEvent =SwitchScreensTriggerEvent.GoTo(
				SwitchScreensTriggerEvent.SELECT_PACKAGE ) 
			this.dispatch( e ) 
		}
		
		private function onLoadedLastLesson(param0:Object):void
		{
			//this.ui.btnResume.visible =  this.model.loadedLastLesson
		}
		
		
	}
}