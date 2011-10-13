package org.syncon.RosettaStone.view.edit
{
	import flash.net.FileReference;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.IO.CreateDefaultDataTriggerEvent;
	import org.syncon.RosettaStone.controller.IO.LoadLessonTriggerEvent;
	import org.syncon.RosettaStone.controller.IO.SaveLessonTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.vo.ItemRendererHelpers;
	import org.syncon.RosettaStone.vo.LessonSetVO;
	import org.syncon.RosettaStone.vo.LessonVO;
	
	public class LessonItemSetsMediator extends Mediator 
	{
		[Inject] public var ui : LessonItemSets;
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
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_SET_CHANGED, 
				this.onLessonSetChanged);	
			this.onLessonSetChanged( null ) 
			
			this.ui.addEventListener( LessonItemSets.DELETE_DATE, this.onDeleteDate ) 
			this.ui.addEventListener( LessonItemSets.EDIT_DATE, this.onEditDate ) 
			this.ui.addEventListener( LessonItemSets.REFRESH_DATES, this.onRefresh ) 				
			this.ui.addEventListener( LessonItemSets.ADD_DATE, this.onAddDate ) 
			this.ui.addEventListener( LessonItemSets.SAVE_FILE, this.onSave ) 		
		}
		
		/**
		 * Export when lesson changed, as we have just saved it
		 * */
		private function onLessonSetChanged(param0:Object):void
		{
			this.ui.list.selectedItem = this.model.currentLessonSet;
			var i : int = this.ui.list.dataProvider.getItemIndex( this.model.currentLessonSet ); 
			this.ui.list.selectedIndex = i ; 
			this.export()
		}
		
		private function onRefresh(e:CustomEvent):void
		{
			this.dispatch( new  LoadLessonTriggerEvent(
				LoadLessonTriggerEvent.LOAD_SOUNDS, this.currentLesson ));
		}	
		
		private function onChangedFileDate(e:RSModelEvent):void
		{
		}		
		
		public function onAddDate ( e : CustomEvent ) : void
		{
			var d :  LessonSetVO = new LessonSetVO()
			d.name = 'New'
			this.dispatch(  new CreateDefaultDataTriggerEvent(CreateDefaultDataTriggerEvent.CREATE, d) ) 
			this.model.currentLesson.sets.addItem( d ) ; 
			/*d.setDate = new Date()
			d.unsavedChanges = true; 
			this.model.dates.addItemAt( d, 0 ); 
			this.model.currentDate = d;*/
			//this.ui.btnSave.enabled = true; 
			this.model.currentLessonSet = d ; 
		}
		
		public var s : ItemRendererHelpers = new ItemRendererHelpers(null)
		private function onLessonChanged(e: RSModelEvent): void
		{
			var lesson : LessonVO = this.model.currentLesson
			s.listenForObj( lesson, LessonVO.UPDATED, this.onUpdatedLesson ) ; 	
			this.currentLesson = lesson; 
			if ( lesson != null ) 
			{
				var dp : ArrayCollection =lesson.sets 
			}
			else
				dp = new ArrayCollection(); 			
			this.ui.list.dataProvider = dp
			this.ui.list.selectedItem = null; 
			
			this.export()
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
			this.model.currentLessonSet = e.data as LessonSetVO;
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
			this.model.saveLesson(); 
			/*this.dispatch( new SaveLessonTriggerEvent(SaveLessonTriggerEvent.LOAD_SOUNDS, 
			this.model.currentLesson , this.model.currentLessonPlan.getSubDir() ) ) ; */
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
			if ( this.currentLesson == null ) 
				return; 
			if ( this.ui.preview != null ) 
			{
				this.ui.preview.export( this.currentLesson.export() ) 
			}
		}
		
		
	}
}