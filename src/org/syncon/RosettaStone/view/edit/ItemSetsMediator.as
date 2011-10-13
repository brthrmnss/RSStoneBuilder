package org.syncon.RosettaStone.view.edit
{
	import flash.net.FileReference;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon.RosettaStone.vo.LessonSetVO;
	
	public class ItemSetsMediator extends Mediator 
	{
		[Inject] public var ui :ItemSets;
		[Inject] public var model : RSModel;
		
		override public function onRegister():void
		{
			/*
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.CHANGED_DATE_XML_FILE_DATE, 
			this.onChangedFileDate);		
			*/
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_SET_CHANGED, 
				this.onCurrentSetChanged);	
			this.onCurrentSetChanged( null ) 
			
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_ITEM_CHANGED, 
				this.onLessonItemChanged);	
			this.onLessonItemChanged( null ) 				
			
			this.ui.addEventListener( ItemSets.DELETE_DATE, this.onDeleteDate ) 
			this.ui.addEventListener( ItemSets.EDIT_DATE, this.onEditDate ) 
			this.ui.addEventListener( ItemSets.REFRESH_DATES, this.onRefreshDates ) 				
			this.ui.addEventListener( ItemSets.ADD_DATE, this.onAddDate ) 
			this.ui.addEventListener( ItemSets.SAVE_FILE, this.onSave ) 		
		}
		
		
		/**
		 * */
		private function onLessonItemChanged(param0:Object):void
		{
			if ( this.ui.list.selectedItem == this.model.currentLessonItem ) 
				return; 
			this.ui.list.selectedItem =null 
			this.ui.list.selectedItem = this.model.currentLessonItem
		}
		
		
		private function onRefreshDates(e:CustomEvent):void
		{
		}	
		
		private function onChangedFileDate(e:RSModelEvent):void
		{
			this.ui.btnSave.enabled = true; 
		}		
		
		public function onAddDate ( e : CustomEvent ) : void
		{
			/*	var d : DateXMLVO = new DateXMLVO()
			d.setDate = new Date()
			d.unsavedChanges = true; 
			
			this.model.dates.addItemAt( d, 0 ); 
			
			this.model.currentDate = d;
			
			this.ui.btnSave.enabled = true; 
			
			this.ui.list.selectedItem = d; */
		}
		
		
		private function onCurrentSetChanged(e: RSModelEvent): void
		{
			var lessonSet : LessonSetVO = this.model.currentLessonSet
			if ( lessonSet != null ) 
			{
				var dp : ArrayCollection =lessonSet.items 
			}
			else
				dp = new ArrayCollection(); 
			
			this.ui.list.dataProvider = dp
			
			/*	if ( dp.length > 0 ) 
			{
			var set : LessonSetVO = new LessonSetVO(); 
			dp.addItem( set ); 
			set.name = 'set 1'; 
			this.model.currentLessonSet = set; 
			this.ui.list.selectedItem =set ; 
			} */
		}		
		
		private function onChangedDistrict ( e : CustomEvent ) : void
		{
			this.model.currentLessonItem = e.data as LessonItemVO;
		}
		
		public function onEditDate ( e : CustomEvent ) : void
		{
			/*this.model.currentDate = e.data as DateXMLVO;*/
			this.model.currentLessonItem = e.data as LessonItemVO;
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
			//http://www.mikechambers.com/blog/2008/08/20/reading-and-writing-local-files-in-flash-player-10/
			//var ee : FileReference
			var myFileReference: FileReference = new FileReference();
			//myFileReference.save("i just put some string data here lol", "filename.txt");
			
			myFileReference.save( this.xmlFileContents(), "beige_book_dates.xml");
			
			/*	var myFileReference2: FileReference = new FileReference();
			myFileReference2.save( this.xmlFileContents(), "beige_book_datess.xml");			*/
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