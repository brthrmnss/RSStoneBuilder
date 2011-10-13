package org.syncon.RosettaStone.view.edit
{
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.IO.CreateDefaultDataTriggerEvent;
	import org.syncon.RosettaStone.controller.IO.LoadUnitCommandTriggerEvent;
	import org.syncon.RosettaStone.controller.IO.LoadUnitsCommandTriggerEvent;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.vo.ItemRendererHelpers;
	import org.syncon.RosettaStone.vo.LessonSetVO;
	import org.syncon.RosettaStone.vo.UnitVO;
	
	public class PackagesMediator extends Mediator 
	{
		[Inject] public var ui : Packages;
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
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.UNITS_CHANGED, 
				this.onUnitsChanged);	
			this.onUnitsChanged( null ) 
			
			this.ui.addEventListener( Packages.DELETE_DATE, this.onDeleteDate ) 
			this.ui.addEventListener( Packages.EDIT_DATE, this.onEditDate ) 
			this.ui.addEventListener( Packages.REFRESH_DATES, this.onRefreshDates ) 				
			this.ui.addEventListener( Packages.CREATE_ITEM, this.onAddDate ) 
			this.ui.addEventListener( Packages.SAVE_FILE, this.onSave ) 		
		}
		
		
		private function onRefreshDates(e:CustomEvent):void
		{
			/*	var eee : LoadDatesXMLTriggerEvent
			this.dispatch( new LoadDatesXMLTriggerEvent( 
			LoadDatesXMLTriggerEvent.LOAD_DATES ) )*/
			this.dispatch( new LoadUnitsCommandTriggerEvent(LoadUnitsCommandTriggerEvent.LOAD_UNITS, '', false ) )
		}	
		
		private function onChangedFileDate(e:RSModelEvent):void
		{
		}		
		
		public function onAddDate ( e : CustomEvent ) : void
		{
			var d :  UnitVO = new UnitVO()
			d.name = 'New'
			//this.dispatch(  new CreateDefaultDataTriggerEvent(CreateDefaultDataTriggerEvent.CREATE, d) ) 
			//this.model.currentLesson.sets.addItem( d ) ; 
			/*d.setDate = new Date()
			d.unsavedChanges = true; 
			this.model.dates.addItemAt( d, 0 ); 
			this.model.currentDate = d;*/
			//this.ui.btnSave.enabled = true; 
				this.model.listUnits.addItem( d)
			this.model.currentUnit = d ; 
			 
		}
		
		public var s : ItemRendererHelpers = new ItemRendererHelpers(null)
		private function onUnitsChanged(e: RSModelEvent): void
		{
			//var unit : UnitVO = this.model.currentUnit
			/*s.listenForObj( unit, UnitVO.UPDATED, this.onUpdatedLesson ) ; 	
			this.currentUnit = unit; 
			if ( unit != null ) 
			{*/
			var dp : ArrayCollection = new ArrayCollection( this.model.listUnits.toArray() ) ; 
			dp = this.model.listUnits; 
			/*	}
			else
			dp = new ArrayCollection(); 			*/
			this.ui.list.dataProvider = dp
			this.ui.list.selectedItem = null; 
			
			this.export()
		}		
		/**
		 * Export when lesson changed, as we have just saved it
		 * */
		private function onUnitChanged(param0:Object):void
		{
			var unit : UnitVO = this.model.currentUnit
			this.ui.list.selectedItem = unit
			this.currentUnit = unit; 
			this.export()
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
			var unit : UnitVO =  e.data as UnitVO;
			/*this.model.currentDate = e.data as DateXMLVO;*/
			this.model.currentUnit =unit
			this.dispatch( new  LoadUnitCommandTriggerEvent(
				LoadUnitCommandTriggerEvent.LOAD_UNIT, unit   ) ) ; 
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