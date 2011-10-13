package org.syncon.RosettaStone.view.mobile
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.NavigateCommandTriggerEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.*;
	
	import spark.events.ViewNavigatorEvent;
	
	public class PlayerViewMediator extends Mediator
	{
		[Inject] public var ui: PlayerView;
		[Inject] public var model : RSModel;
		
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
			//this.styler.init( this.ui, this.model.config, this.updateStyles ); 
			this.ev.addEv( PlayerView.GO_BACK, this.onGoBack ) 
			this.ev.addEv( PlayerView.HOME, this.onHome ) 
			this.ev.addEv( PlayerView.INFO, this.onInfo ) 
		}
		
		private function onInfo(e:Event):void
		{
			this.model.alert( 'Lesson: ' + this.model.currentLesson.name + '\n' + 
				'Lesson Group: ' + this.model.currentLessonPlan.name  + '\n'+
				'Unit: ' + this.model.currentUnit.name  + '\n', 'You are Viewing' )
		}
		
		protected function onActivate2(event:ViewNavigatorEvent):void
		{
			//trace('activate', this.ui ); 
			/*this.ui.list.alpha = 1; 
			this.ui.txtLoading.visible = false; */
			//this.styler.changedCheck( this.model.config ) ; 
		}
		public function updateStyles(init:Boolean=false) : void
		{
		}
		
		private function onTryAgain(e:Event):void
		{
		}		
		
		private function onGoBack(e:Event):void
		{
			this.dispatch( NavigateCommandTriggerEvent.popView() ) 	
		}		
		private function onHome(e:Event):void
		{
			this.dispatch( NavigateCommandTriggerEvent.pushView( PackageSelectView )  ) 	
		}		
		
	}
}