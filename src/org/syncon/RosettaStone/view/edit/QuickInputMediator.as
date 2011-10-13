package org.syncon.RosettaStone.view.edit
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.Import.ConvertStringToItemSetCommandTriggerEvent;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon.RosettaStone.vo.LessonSetVO;
	import org.syncon2.utils.MakeVOs;
	
	public class QuickInputMediator extends Mediator 
	{
		[Inject] public var ui : QuickInput;
		[Inject] public var model : RSModel;
		private var currentLessonSet: LessonSetVO;
		private var automate:Boolean=true;
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_SET_CHANGED, 
				this.onLessonSetChanged);	
			this.onLessonSetChanged( null ) 
			
			this.ui.addEventListener( QuickInput.INPUT_CHANGED, 
				this.onInputChanged);	
		}
		
		private function onInputChanged(e: Event): void
		{
			
			var txt : String = this.ui.txtInput.text; 
			arr = txt.split(' '); 
			if ( txt.indexOf( ',' ) == -1 ) 
			{
				var arr : Array = txt.split(' ');
				txt = arr.join(', '); 
			}
			
			
			
			var items : Array = MakeVOs.makeObjs( arr, LessonItemVO, 'name' ) ; 
			if ( automate ) 
			{
				
				this.dispatch( new ConvertStringToItemSetCommandTriggerEvent( 
					ConvertStringToItemSetCommandTriggerEvent.CONVER_STRING, txt, this.currentLessonSet, 
					this.newItemsCreated, true, ', ', this.ui.chkClear.selected ) ) 
				//this.automateItems(arr ) ; 
				return; 
			}
			//var arr : Array = txt.split(' '); 
			this.updateCurrentLessonSet(items); 
		}
		
		private function updateCurrentLessonSet(items:Array):void
		{
			if ( ui.chkClear.selected == true ) 
				this.currentLessonSet.items.removeAll(); 
			this.currentLessonSet.items.addAll( new ArrayCollection( items ) )
			this.model.copyAssetFolderToCurrentSetItems()
			this.model.currentLessonSet = this.currentLessonSet; 
			this.currentLessonSet.updated(); 
		}		
		
		public function newItemsCreated() : void
		{
			//this.updateCurrentLessonSet( newItems ) ; 	
			if ( this.ui.chkSaveAfter.selected ) 
				this.model.saveLesson(); 
		}
		
		
		/*
		public var g : GoThroughEach = new GoThroughEach()
		private function automateItems(items:Array):void
		{
		newItems= []; 
		g.go( items, startSetup, this.onDoneAutomating ) 
		}		
		
		public function onDoneAutomating() : void
		{
		this.updateCurrentLessonSet( newItems ) ; 	
		if ( this.ui.chkSaveAfter.selected ) 
		this.model.saveLesson(); 
		}
		public var newItems : Array = []; 
		private var currentLessonItem:LessonItemVO;
		public function startSetup(o : String ) : void
		{
		var i : LessonItemVO = new LessonItemVO()
		i.name = o;
		this.currentLessonItem = i ; 
		this.newItems.push( i )
		if ( i.pic != '' && i.pic != null ) 
		{
		NightStandConstants.FileLoader.deleteFile( i.folder , i.pic ); 
		}
		if ( i.sound != '' && i.sound != null ) 
		{
		NightStandConstants.FileLoader.deleteFile( i.folder , i.sound ); 
		}
		this.getItemPic(); 
		}
		
		private function getItemPic():void
		{
		this.dispatch( new SearchImagesTriggerEvent( 
		SearchImagesTriggerEvent.SEARCH_IMAGES, 
		this.currentLessonItem.name , this.onImagesReturned ) ) 
		}
		
		private function onImagesReturned(e: Array):void
		{
		var s : SearchVO = e[0]
		NightStandConstants.FileLoader.downloadFileTo( s.url, this.model.lessonDir(), 
		this.currentLessonItem.name+'.***', this.onSavedImage, true )
		return; 
		}
		
		public function onSavedImage(e:Object):void
		{
		trace('need the name', e ) ; 
		this.currentLessonItem.pic = e.toString();
		this.currentLessonItem.update()
		//this.model.saveLesson()
		
		this.onGotPic()
		}
		
		
		private function onGotPic( ):void
		{
		this.getItemPronunciation()
		}
		private function getItemPronunciation():void
		{
		this.dispatch( new SearchDictionaryTriggerEvent( 
		SearchDictionaryTriggerEvent.SEARCH_DICTIONARY, this.currentLessonItem.name, 
		this.onDictReturned ) ) 
		}
		
		private function onDictReturned(e: SearchVO):void
		{
		this.setPronunciation( e); 
		}
		
		protected function setPronunciation(searchDicResult:SearchVO):void
		{
		this.currentLessonItem.pronunciation = searchDicResult.data;
		var url : String = unescape(searchDicResult.url)
		NightStandConstants.FileLoader.downloadFileTo(url, this.model.lessonDir(), 
		this.currentLessonItem.name+'.***', this.onSavedSound, true )
		}
		
		public function onSavedSound(filename:String):void
		{
		this.currentLessonItem.sound = filename;
		this.currentLessonItem.update()
		this.nextItem()
		}
		
		
		private function nextItem( ):void
		{
		
		this.g.next(); 
		}
		*/
		
		
		
		
		
		private function onLessonSetChanged(e: RSModelEvent): void
		{
			currentLessonSet = this.model.currentLessonSet; 
		}		
		
	}
}