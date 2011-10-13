package org.syncon.RosettaStone.view.edit
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.controller.Import.ConvertStringToLessonCommandTriggerEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.model.RSModelEvent;
	import org.syncon.RosettaStone.vo.LessonVO;
	
	public class QuickInputLessonMediator extends Mediator 
	{
		[Inject] public var ui : QuickInputLesson;
		[Inject] public var model : RSModel;
		private var currentLesson: LessonVO;
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, RSModelEvent.CURRENT_LESSON_CHANGED, 
				this.onLessonChanged);	
			this.onLessonChanged( null ) 
			
			this.ui.addEventListener( QuickInput.INPUT_CHANGED, 
				this.onInputChanged);	
		}
		
		private function onInputChanged(e: Event): void
		{
			this.excelParse(); 
			var txt : String = this.ui.txtInput.text; 
			/*
			this.dispatch( new ConvertStringToLessonCommandTriggerEvent( 
				ConvertStringToLessonCommandTriggerEvent.CONVER_STRING, txt, this.currentLesson, 
				this.newItemsCreated, true) ) 
				*/
			//this.automateItems(arr ) ; 
			return; 
			
		}
		
		private function excelParse():void
		{
			var newline: RegExp = /\n/;			
			var returncarriage: RegExp = /\r/;
			var tab : RegExp = /\t/;
			
			var str:String   = this.ui.txtInput.text; 
			//str = this.ui.rawInputString
			
			var errors : Array = [];
			
			var result:Array = str.split( returncarriage )
			if ( str.indexOf('\r') == -1 ) 
				result = str.split( newline )			
			var results : Array = [] ; 
			for each ( var line : String in result ) 
			{
				if ( line == '' ) 
					continue; 
				var lines:Array = line.split( '\t' )			
				results.push( lines.join(', ')  ) 
				/*tabMode  = false 
				if ( tab.test( line  ) ) 
				{
				tabMode = true
				}
				
				if ( tabMode ) 
				{
				if ( line == fields.join('\t')  ) 
				continue; 
				var clothingItemString:String = line
				var result2:Array = clothingItemString.split( '\t' )					
				}
				else
				{
				if ( line == fields.join(',') )  //all commands between the field names
				continue; 
				//what if they don't copy them all ...? 
				clothingItemString = line
				result2 = clothingItemString.split( ',' )					
				}
				
				//var fields : Array = 'pic_url,name,description,type,other tags,colors,cost,rating,store url'.split(',')
				
				//make an object
				var o :  Object = new Object()	
				for ( var i : int =0 ; i < fields.length; i++ )
				{
				o[fields[i]] = result2[i] 
				}
				
				
				var clothingItem : EntryVO = this.processEntry( o )
				this.dp.addItem( clothingItem )				
				*/
				
			}
			
			this.dispatch( new ConvertStringToLessonCommandTriggerEvent( 
				ConvertStringToLessonCommandTriggerEvent.CONVER_STRING, null, this.currentLesson, 
				this.newItemsCreated, true, '', results) ) 
				
			
			return; 
		}
		public function newItemsCreated() : void
		{
			trace('lesson sets created'); 
			//this.updateCurrentLessonSet( newItems ) ; 	
			/*if ( this.ui.chkSaveAfter.selected ) 
			this.model.saveLesson(); */
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
		
		
		
		
		
		private function onLessonChanged(e: RSModelEvent): void
		{
			currentLesson = this.model.currentLesson; 
		}		
		
	}
}