package org.syncon.RosettaStone.view.edit
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.IO.LoadLessonPlanCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.IO.SaveUnitCommandTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.ItemRendererHelpers;
	import org.syncon.RosettaStone.vo.LessonGroupVO;
	import org.syncon.RosettaStone.vo.LessonVO;
	import org.syncon.RosettaStone.vo.PromptDefinitionVO;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	
	public class LessonPromptsMediator extends Mediator 
	{
		[Inject] public var ui : LessonPrompts;
		[Inject] public var model : RSModel;
		private var currentLesson:LessonVO;
		
		override public function onRegister():void
		{
			/*
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.CHANGED_DATE_XML_FILE_DATE, 
			this.onChangedFileDate);		
			*/
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_CHANGED, 
				this.onLessonChanged);	
			this.onLessonChanged( null ) 
			/*
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.CURRENT_LESSON_PLAN_CHANGED, 
			this.onLessonPlanChanged);	
			this.onLessonPlanChanged( null ) 
			*/
			this.ui.addEventListener( LessonPrompts.DELETE_DATE, this.onDeleteDate ) 
			this.ui.addEventListener( LessonPrompts.EDIT_DATE, this.onEditDate ) 
			this.ui.addEventListener( LessonPrompts.REFRESH_DATES, this.onRefreshDates ) 				
			this.ui.addEventListener( LessonPrompts.ADD_DATE, this.onAddDate ) 
			this.ui.addEventListener( LessonPrompts.SAVE_FILE, this.onSave ) 
			
			this.ui.addEventListener( LessonPrompts.UPDATE, this.onUpdate ) 				
			
		}
		
		/**
		 * Export when lesson changed, as we have just saved it
		 * */
		/*private function onLessonPlanChanged(param0:Object):void
		{
		this.ui.list.selectedItem = this.model.currentLessonPlan
		this.export()
		}
		*/
		private function onRefreshDates(e:CustomEvent):void
		{
			/*	var eee : LoadDatesXMLTriggerEvent
			this.dispatch( new LoadDatesXMLTriggerEvent( 
			LoadDatesXMLTriggerEvent.LOAD_DATES ) )*/
		}	
		
		private function onChangedFileDate(e:RSModelEvent):void
		{
		}		
		
		public function onAddDate ( e : CustomEvent ) : void
		{
			var d :  PromptDefinitionVO = new PromptDefinitionVO()
			d.name = 'New'
			this.model.currentLesson.addPrompt( d ) ; 
			
			//this.dispatch(  new CreateDefaultDataTriggerEvent(CreateDefaultDataTriggerEvent.CREATE, d) ) 
			
			/*d.setDate = new Date()
			d.unsavedChanges = true; 
			this.model.dates.addItemAt( d, 0 ); 
			this.model.currentDate = d;*/
			//this.ui.btnSave.enabled = true; 
			
			//this.model.currentLessonSet = d ; 
			
			
		}
		
		public var s : ItemRendererHelpers = new ItemRendererHelpers(null)
		private function onLessonChanged(e: RSModelEvent): void
		{
			var lesson : LessonVO = this.model.currentLesson
			s.listenForObj( lesson, LessonVO.UPDATED, this.onUpdatedLesson ) ; 	
			this.currentLesson = lesson; 
			if ( lesson != null ) 
			{
				var dp : ArrayCollection =lesson.getPrompts() 
			}
			else
				dp = new ArrayCollection(); 			
			this.ui.list.dataProvider = dp
			this.ui.list.selectedItem = null; 
			
			//this.export()
		}		
		
		private function onUpdatedLesson(e:Object=null):void
		{
			
			this.export(); 
		}
		
		private function onChangedDistrict ( e : CustomEvent ) : void
		{
			/*	var newCurrentDistrict : int = this.model.currentDistrict + e.data as int
			if ( newCurrentDistrict < 1 )
			newCurrentDistrict = 12; 
			if ( newCurrentDistrict > 12 )
			newCurrentDistrict = 1; 			
			this.model.currentDistrict = newCurrentDistrict*/
		}
		
		public function onEditDate ( e : CustomEvent ) : void
		{
			/*this.model.currentDate = e.data as DateXMLVO;*/
			this.model.currentPromptDefinition = e.data as PromptDefinitionVO;
			for each ( var item : LessonItemVO in this.currentLesson.items ) 
			{
				item.setPromptDefinition( this.model.currentPromptDefinition, true, this.model.currentLesson.clonePrompts  )
				item.currentPrompt 
			}
			
			
			//if ( this.model.currentLessonPlan.loaded == false )
			/*var group : LessonGroupVO =this.model.currentLessonPlan
			this.dispatch( new  LoadLessonPlanCommandTriggerEvent(
			LoadLessonPlanCommandTriggerEvent.LOAD_LESSON_PLAN, group  ) ) ; */
		}
		
		
		public function onDeleteDate ( e : CustomEvent ) : void
		{
			/*	var index : int = this.model.dates.getItemIndex( e.data )
			if ( index != -1 ) this.model.dates.removeItemAt( index ) 
			if ( e.data == this.model.currentDate ) 
			{
			this.model.currentDate = null; 
			}*/
		}		
		
		public function onSave( e : CustomEvent ) : void
		{
			//this.model.saveLesson(); 
			/*this.dispatch( new SaveLessonTriggerEvent(SaveLessonTriggerEvent.LOAD_SOUNDS, 
			this.model.currentLesson , this.model.currentLessonPlan.getSubDir() ) ) ; */
			this.export(); 
			this.model.saveLesson(); 
		}	
		
		public function xmlFileContents () : String
		{
			var str : String = ''; 
			/*var xml : XML = new XML( '<config />')
			
			
			//this.model.dates.source.sortOn( 'date' ) 
			
			for each ( var dis : DateXMLVO in this.model.dates ) 
			{
			var fileNode : XML = new XML('<file />' )
			fileNode.@date = dis.dateString
			fileNode.@file = dis.filename; 
			xml.appendChild( fileNode ) 	
			}
			var str : String = xml.toXMLString()*/
			return str; 
		}
		
		
		private function export():void
		{
			/*if ( this.currentUnit == null ) 
			return; 
			if ( this.ui.preview != null ) 
			{
			this.ui.preview.export( this.currentUnit.export() ) 
			}*/
			if ( this.currentLesson == null ) 
				return; 
			if ( this.ui.preview != null ) 
			{
				this.ui.preview.export( this.currentLesson.export() ) 
			}
			//should prorbably set vlaue of lesson and update it as so 
		}
		
		public function onUpdate(e:Event):void
		{
			this.export(); 
			this.dispatch( new RSModelEvent(RSModelEvent.LESSON_PROMPTS_CHANGED) ) ; 
		}
		
	}
}