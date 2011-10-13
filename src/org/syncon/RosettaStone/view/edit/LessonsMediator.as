package org.syncon.RosettaStone.view.edit
{
	import flash.net.FileReference;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.IO.CreateDefaultDataTriggerEvent;
	import org.syncon.RosettaStone.controller.IO.LoadLessonTriggerEvent;
	import org.syncon.RosettaStone.controller.IO.SaveLessonPlanTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.vo.LessonVO;
	
	public class LessonsMediator extends Mediator 
	{
		[Inject] public var ui: Lessons;
		[Inject] public var model : RSModel;
		
		override public function onRegister():void
		{
			/*
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.CHANGED_DATE_XML_FILE_DATE, 
			this.onChangedFileDate);		
			*/
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_PLAN_CHANGED, 
				this.onLessonPlanChanged);	
			this.onLessonPlanChanged( null ) 
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_CHANGED, 
				this.onLessonChanged);	
			this.onLessonChanged( null ) 
			
			//this.ui.addEventListener( Lessons.DELETE_DATE, this.onDeleteDate ) 
			this.ui.addEventListener( LessonItemRenderer.DELETE, this.onDeleteDate ) 
			this.ui.addEventListener( Lessons.EDIT_DATE, this.onEditDate ) 
			this.ui.addEventListener( Lessons.REFRESH_DATES, this.onRefreshDates ) 				
			this.ui.addEventListener( Lessons.ADD_DATE, this.onAddDate ) 
			this.ui.addEventListener( Lessons.SAVE_FILE, this.onSave ) 		
		}
		
		
		/**
		 * Export when lesson changed, as we have just saved it
		 * */
		private function onLessonChanged(param0:Object):void
		{
			this.ui.list.selectedItem = this.model.currentLesson;
			this.export()
		}
		
		private function onRefreshDates(e:CustomEvent):void
		{
			if ( this.ui.btnSave.enabled ) 
			{
				
			}
			/*	var eee : LoadDatesXMLTriggerEvent
			this.dispatch( new LoadDatesXMLTriggerEvent( 
			LoadDatesXMLTriggerEvent.LOAD_DATES ) )*/
		}	
		
		private function onChangedFileDate(e:RSModelEvent):void
		{
			//this.ui.btnSave.enabled = true; 
		}		
		
		public function onAddDate ( e : CustomEvent ) : void
		{
			var d : LessonVO = new LessonVO()
			d.name = 'New'
			this.dispatch(  new CreateDefaultDataTriggerEvent(CreateDefaultDataTriggerEvent.CREATE, d) ) 
			this.model.currentLessonPlan.lessons.addItem( d ) ; 
			/*d.setDate = new Date()
			d.unsavedChanges = true; 
			this.model.dates.addItemAt( d, 0 ); 
			this.model.currentDate = d;*/
			
			//this.ui.btnSave.enabled = true; 
			this.model.currentLesson = d;  
		}
		
		
		private function onLessonPlanChanged(e: RSModelEvent): void
		{
			if ( this.model.currentLessonPlan == null ) 
			{
				this.ui.list.dataProvider =  new ArrayCollection()
				return; 
			}
			var dp : ArrayCollection =this.model.currentLessonPlan.lessons 
			this.ui.list.dataProvider = dp
				this.ui.list.selectedItem = null; 
			//this.ui.btnSave.enabled = false; 
			
			this.export(); 
			/*if ( dp.length > 0 ) 
			{
			var lesson : LessonVO = new LessonVO(); 
			dp.addItem( lesson ); 
			lesson.name = 'lesson 1'; 
			this.model.currentLesson = lesson; 
			this.ui.list.selectedItem =lesson ; 
			} */
			//this.ui.txtDistrict.text = ( this.model.currentDistrict+0).toString() + '/12'
		}		
		
		private function export():void
		{
			if ( this.model.currentLessonPlan == null ) 
				return; 
			if ( this.ui.preview != null ) 
			{
				
				this.ui.preview.export( this.model.currentLessonPlan.export() ) 
			}
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
			var lesson : LessonVO =  e.data as LessonVO;
			this.dispatch( new  LoadLessonTriggerEvent(LoadLessonTriggerEvent.LOAD_SOUNDS,
				lesson,  '', onLessonLoaded) ) ; 
			/*this.model.currentDate = e.data as DateXMLVO;*/
			this.model.currentLesson = null; 
		}
		
		public function onLessonLoaded(e:LessonVO) : void
		{
			this.model.currentLesson = e
		}
		
		
		public function onDeleteDate ( e : CustomEvent ) : void
		{
			var index : int = this.model.currentLessonPlan.lessons.getItemIndex( e.data )
			
			if ( index == -1 ) return; 
			
			this.model.currentLessonPlan.lessons.removeItemAt( index ) 
			if ( e.data == this.model.currentLesson ) 
			{
				if ( index > 0 ) 
					index--
				else 
					index = 0 
				this.model.currentLesson = this.model.currentLessonPlan.lessons.getItemAt( 0 ) as LessonVO ; 
			} 
			
		}		
		
		public function onSave( e : CustomEvent ) : void
		{
			this.export(); 
			this.dispatch( new SaveLessonPlanTriggerEvent(SaveLessonPlanTriggerEvent.LOAD_SOUNDS, this.model.currentLessonPlan ) ) ; 
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
		
	}
}