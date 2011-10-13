package  org.syncon.RosettaStone.view.ellips
{
	import flash.events.Event;
	
	import mvc.controller.SwitchScreensTriggerEvent;
	
	import mx.collections.ArrayCollection;
	import mx.core.IFactory;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.AutomateEvent;
	import org.syncon.RosettaStone.controller.IO.LoadLessonTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.*;
	import org.syncon.TalkingClock.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSMobileModel;
	
	
	public class PackageCurriculumViewMediator extends Mediator
	{
		[Inject] public var ui: PackageCurriculumView;
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
			if ( this.model.showAds == false ) 
			{
				this.ui.list.setStyle('bottom', 0 ); 
			}			
			ev.init( this.ui ) ; 
			
			this.styler = new StyleConfigurator(); 
			//this.styler.init( this.ui, this.model.config, this.updateStyles ); 
			/*
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.CURRENT_UNIT_CHANGED, 
			this.onUnitChanged);	
			this.onUnitChanged( null ) 
			*/
			/*eventMap.mapListener(eventDispatcher, NightStandModelEvent.CURRENT_LESSON_CHANGED, 
			this.onUnitChanged);	
			*/
			//whenever this is displayed
			this.ev.addEv( 'showing', this.onUnitChanged ) ; 
			onUnitChanged(); 
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_PLAN_CHANGED, 
				this.onLessonPlanChanged);	
			this.onLessonPlanChanged( null ) 
			
			this.ev.addEv( GroupSelectView.LIST_CHANGED, this.onListChanged ) 
			this.ev.addEv( GroupSelectView.GO_BACK, this.onGoBack ) 
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.LOADED_LAST_LESSON, 
				this.onLoadedLastLesson);	
			this.onLoadedLastLesson( null ) 				
		}
		
		protected function onResume(event:Event):void
		{
			/*this.dispatch( new NavigateCommandTriggerEvent( 
			NavigateCommandTriggerEvent.PUSH, PlayerView ) ) */
		}
		
		
		public function updateStyles(init:Boolean=false) : void
		{
			var updateAnyway : Boolean = false
			if ( this.styler.bgChanged || init ) 
			{
				/*
				var css : CSSStyleDeclaration = this.ui.styleManager.getStyleDeclaration('org.syncon.odb.view.mobile.ODBRenderer')
				css.setStyle( 'backgroundColor', this.model.config.reverseText ? 0: 0xFFFFFF ) 
				var css2 : CSSStyleDeclaration = this.ui.styleManager.getStyleDeclaration('.txtTitleStyle')
				css2.setStyle( 'color', this.model.config.reverseText == false ? 0: 0xFFFFFF ) 
				updateAnyway = true; 
				*/
			}
			if ( this.styler.fontChanged || updateAnyway ) // != this.model.config.fontSize ) 
			{
				//refresh list itemRenderers
				var oldItemRenderer : Object = this.ui.list.itemRenderer
				this.ui.list.itemRenderer = null ; 
				this.ui.list.itemRenderer = oldItemRenderer as IFactory ;
				
				NightStandConstants.PlatformGlobals.setListSelectedIndex( this.ui.list, 0 ); 
				//this.ui.list.scroller.verticalScrollBar.value = 0; 
			}
		}
		
		private function onTryAgain(e:Event):void
		{
		}		
		
		private function onGoBack(e:Event=null):void
		{
			/*this.dispatch( SwitchScreensTriggerEvent.GoBack() )
			this.dispatch( SwitchScreensTriggerEvent.GoTo( SwitchScreensTriggerEvent.PLAYER_VIEW2 ) ) ; */
			this.modelMobile.goToPlayer(1) 
			this.dispatch( new AutomateEvent(AutomateEvent.RESUME_LESSON, null ) ) ; 
		}		
		
		private function onUnitChanged(e:  Object = null ): void
		{
			var unit : UnitVO = this.model.currentUnit
			
			this.currentUnit = unit; 
			if ( unit != null ) 
			{
				this.ui.header.label = 'Curriculum ' + unit.name 
				var dp : ArrayCollection =unit.groups 
				dp = new ArrayCollection(); 		
				
				for each ( var group : LessonGroupVO in this.currentUnit.groups ) 
				{
					dp.addItem( group ) 
					for each ( var lesson :  LessonVO in group.lessons ) 
					{
						dp.addItem( lesson ) ; 
						if ( this.model.currentLesson == lesson ) 
							lesson.currentLesson = true
						else
							lesson.currentLesson = false; 
					}
				}
			}
			else
			{
				dp = new ArrayCollection(); 
			}
			this.ui.list.dataProvider = null
			this.ui.list.dataProvider = dp
			this.ui.list.selectedItem = null; 
		}	
		/**
		 * Export when lesson changed, as we have just saved it
		 * */
		private function onLessonPlanChanged(param0:Object):void
		{
			//this.ui.list.selectedItem = this.model.currentLessonPlan
		}
		protected function onListChanged(e:CustomEvent):void
		{
			if ( e.data is LessonVO ) 
			{
				var lesson : LessonVO =e.data as LessonVO;
				if ( lesson == this.model.currentLesson ) 
				{
					this.onGoBack(); 
					return; 
				}
				this.model.currentLesson = lesson
				
				this.dispatch( new  LoadLessonTriggerEvent(
					LoadLessonTriggerEvent.LOAD_SOUNDS, lesson, '',  this.onLessonLoaded, '', false, false  ) )
			}
			else
			{
				return; 
				/*this.model.currentLessonPlan = e.data as LessonGroupVO;
				var group : LessonGroupVO =this.model.currentLessonPlan
				this.dispatch( new  LoadLessonPlanCommandTriggerEvent(
				LoadLessonPlanCommandTriggerEvent.LOAD_LESSON_PLAN, group,'', this.onLoadedGroup  ) ) ; 
				*/
				
				//this.ui.list.selectedItem = null;
			}
		}
		private function onLessonLoaded(lu: LessonVO):void
		{
			this.model.currentLesson = lu; 
			this.modelMobile.goToPlayer(1) 
			this.dispatch( new AutomateEvent(AutomateEvent.START_LESSON,  lu  ) ) ; 
			return;
		}		
		
		private function onLoadedGroup(e:Object):void
		{
			//this.dispatch( NavigateCommandTriggerEvent.pushView( LessonSelectView )  ) 				
			this.dispatch( SwitchScreensTriggerEvent.GoTo( SwitchScreensTriggerEvent.SELECT_LESSON ) ) ; 
		}
		
		private function onLoadedLastLesson(param0:Object):void
		{
			//this.ui.btnResume.visible =  this.model.loadedLastLesson
		}
		
		
	}
}