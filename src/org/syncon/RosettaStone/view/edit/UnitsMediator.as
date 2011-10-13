package org.syncon.RosettaStone.view.edit
{
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.IO.CreateDefaultDataTriggerEvent;
	import org.syncon.RosettaStone.controller.IO.LoadLessonPlanCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.IO.SaveUnitCommandTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.vo.ItemRendererHelpers;
	import org.syncon.RosettaStone.vo.LessonGroupVO;
	import org.syncon.RosettaStone.vo.LessonSetVO;
	import org.syncon.RosettaStone.vo.UnitVO;
	
	public class UnitsMediator extends Mediator 
	{
		[Inject] public var ui : Units;
		[Inject] public var model : RSModel;
		private var currentUnit:UnitVO;
		
		override public function onRegister():void
		{
			/*
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.CHANGED_DATE_XML_FILE_DATE, 
			this.onChangedFileDate);		
			*/
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_UNIT_CHANGED, 
				this.onUnitChanged);	
			this.onUnitChanged( null ) 
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_PLAN_CHANGED, 
				this.onLessonPlanChanged);	
			this.onLessonPlanChanged( null ) 
			
			this.ui.addEventListener( Units.DELETE_DATE, this.onDeleteDate ) 
			this.ui.addEventListener( Units.EDIT_DATE, this.onEditDate ) 
			this.ui.addEventListener( Units.REFRESH_DATES, this.onRefreshDates ) 				
			this.ui.addEventListener( Units.ADD_DATE, this.onAddDate ) 
			this.ui.addEventListener( Units.SAVE_FILE, this.onSave ) 		
		}
		
		/**
		 * Export when lesson changed, as we have just saved it
		 * */
		private function onLessonPlanChanged(param0:Object):void
		{
			this.ui.list.selectedItem = this.model.currentLessonPlan
			this.export()
		}
		
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
			var d :  LessonGroupVO = new LessonGroupVO()
			d.name = 'New'
			this.dispatch(  new CreateDefaultDataTriggerEvent(CreateDefaultDataTriggerEvent.CREATE, d) ) 
			this.model.currentUnit.groups.addItem( d ) ; 
			/*d.setDate = new Date()
			d.unsavedChanges = true; 
			this.model.dates.addItemAt( d, 0 ); 
			this.model.currentDate = d;*/
			//this.ui.btnSave.enabled = true; 
			this.model.currentLessonPlan = d ; 
		}
		
		public var s : ItemRendererHelpers = new ItemRendererHelpers(null)
		private function onUnitChanged(e: RSModelEvent): void
		{
			var unit : UnitVO = this.model.currentUnit
			s.listenForObj( unit, UnitVO.UPDATED, this.onUpdatedLesson ) ; 	
			this.currentUnit = unit; 
			if ( unit != null ) 
			{
				var dp : ArrayCollection =unit.groups 
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
			this.model.currentLessonPlan = e.data as LessonGroupVO;
			//if ( this.model.currentLessonPlan.loaded == false )
			var group : LessonGroupVO =this.model.currentLessonPlan
			this.dispatch( new  LoadLessonPlanCommandTriggerEvent(
				LoadLessonPlanCommandTriggerEvent.LOAD_LESSON_PLAN, group  ) ) ; 
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
			
			this.dispatch( new SaveUnitCommandTriggerEvent(
				SaveUnitCommandTriggerEvent.SAVE_UNIT, this.model.currentUnit ) ) ; 
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
			if ( this.currentUnit == null ) 
				return; 
			if ( this.ui.preview != null ) 
			{
				this.ui.preview.export( this.currentUnit.export() ) 
			}
			
		}
		
		
	}
}