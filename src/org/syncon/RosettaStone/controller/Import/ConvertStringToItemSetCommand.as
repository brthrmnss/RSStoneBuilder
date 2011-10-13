package   org.syncon.RosettaStone.controller.Import
{
	
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.controller.Search.SearchDictionaryTriggerEvent;
	import org.syncon.RosettaStone.controller.Search.SearchImagesTriggerEvent;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon.RosettaStone.vo.LessonSetVO;
	import org.syncon.RosettaStone.vo.SearchResultVO;
	import org.syncon.RosettaStone.vo.SearchVO;
	import org.syncon2.utils.MakeVOs;
	import org.syncon2.utils.data.GoThroughEach;
	
	
	
	public class ConvertStringToItemSetCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:ConvertStringToItemSetCommandTriggerEvent;
		private var currentLessonSet: LessonSetVO;
		override public function execute():void
		{
			if ( event.type == ConvertStringToItemSetCommandTriggerEvent.CONVER_STRING ) 
			{
				var arr : Array = event.input.split(event.demarc); 
				var items : Array = MakeVOs.makeObjs( arr, LessonItemVO, 'name' ) ; 
				this.currentLessonSet = event.lessonSet; 
				this.automateItems(arr ) ; 
			}				
		}
		private function updateCurrentLessonSet(items:Array):void
		{
			if ( event.clearExisting ) 
				this.currentLessonSet.items.removeAll(); 
			this.currentLessonSet.items.disableAutoUpdate()
			this.currentLessonSet.items.addAll( new ArrayList( items ) ) 
			this.model.currentLessonSet = this.currentLessonSet; 
			this.model.copyAssetFolderToCurrentSetItems()
			this.currentLessonSet.items.enableAutoUpdate(); 
			//or just use a .refresh() 
			this.currentLessonSet.updated(); 
		}		
		
		public var g :   GoThroughEach = new GoThroughEach()
		private function automateItems(items:Array):void
		{
			newItems= []; 
			g.go( items, startSetup, this.onDoneAutomating,500 ) 
		}		
		
		public function onDoneAutomating() : void
		{
			this.updateCurrentLessonSet( newItems ) ; 	
			if ( this.event.save ) 
				this.model.saveLesson(); 
			if ( event.fxResult != null ) 
				event.fxResult(); 
		}
		public var newItems : Array = []; 
		private var currentLessonItem:LessonItemVO;
		public function startSetup(o :  String ) : void
		{
			var i : LessonItemVO = new LessonItemVO()
			i.name = o;
			this.currentLessonItem = i ; 
			this.newItems.push( i )
			
			this.faultedBefore = false; 
			//remove old items ...
			if ( i.pic != '' && i.pic != null  )  
			{
				NightStandConstants.FileLoader.deleteFile( i.folder , i.pic  ); 
			}
			if ( i.sound != '' && i.sound != null  ) 
			{
				NightStandConstants.FileLoader.deleteFile( i.folder ,  i.sound ); 
			}
			this.getItemPic(); 
		}
		
		private function getItemPic():void
		{
			this.dispatch( new SearchImagesTriggerEvent( 
				SearchImagesTriggerEvent.SEARCH_IMAGES, 
				this.currentLessonItem.name , this.onImagesReturned ) ) 
		}
		
		private function onImagesReturned(e:SearchResultVO):void
		{
			var s : SearchVO = e.results[0]
			NightStandConstants.FileLoader.downloadFileTo( s.url, this.model.lessonDir(), 
				this.currentLessonItem.name+'.***', this.onSavedImage, true  )
			return; 
		}
		
		public function onSavedImage(e:Object):void
		{
			trace('need the name', e ) ; 
			this.currentLessonItem.pic =  e.toString();
			this.currentLessonItem.update()
			//this.model.saveLesson()
			
			this.onGotPic()
		}
		
		
		private function onGotPic( ):void
		{
			this.getItemPronunciation()
		}
		public var goTrhgoutEAchWrodInName : GoThroughEach = new GoThroughEach()
		/**
		 * 
		 * Current word when goign through loop
		 * */
		private var currentWord:String;
		/**
		 * set to true on 2nd pass 
		 * */
		private var faultedBefore:Boolean;
		
		private function getItemPronunciation(itemOverride : Array = null ):void
		{
			var items : Array = [this.currentLessonItem.name] 
			if ( this.currentLessonItem.name.indexOf(' ' ) != -1 ) 
			{
				items = this.currentLessonItem.name.split(' '); 
			}
			if ( itemOverride != null ) 
				itemOverride = items; 
			this.goTrhgoutEAchWrodInName.go( items, this.onNext_WordSearchDictionary, this.onDoneSearchingWords ) 
			this.currentLessonItem.sound = ''; 
			this.currentLessonItem.pronunciation   = ''
		}
		private function onNext_WordSearchDictionary(word : String):void
		{
			this.currentWord = word; 
			if ( faultedBefore == false ) 
			{
				this.dispatch( new SearchDictionaryTriggerEvent(  
					SearchDictionaryTriggerEvent.SEARCH_DICTIONARY, word,  
					this.onDictReturned, this.onDictFault1  ) ) 
			}
			else
			{
				this.dispatch( new SearchDictionaryTriggerEvent(  
					SearchDictionaryTriggerEvent.SEARCH_DICTIONARY, word,  
					this.onDictReturned, this.onDictFault1 , true  ) ) 
			}
		}
		
		private function onDictReturned(e: SearchVO):void
		{
			this.setPronunciation( e); 
		}
		
		protected function setPronunciation(searchDicResult:SearchVO):void
		{
			if ( this.currentLessonItem.pronunciation != '' ) this.currentLessonItem.pronunciation += ' '
			this.currentLessonItem.pronunciation += searchDicResult.data;
			var url : String = unescape(searchDicResult.url)
			NightStandConstants.FileLoader.downloadFileTo(url, this.model.lessonDir(), 
				this.currentWord +'.***', this.onSavedSound, true  )
		}
		
		public function onSavedSound(filename:String):void
		{
			if ( this.currentLessonItem.sound != '' ) this.currentLessonItem.sound += ' '
			this.currentLessonItem.sound +=  filename;
			this.currentLessonItem.update()
			this.goTrhgoutEAchWrodInName.next() 
		}
		/**
		 * if fault, then try again wit htthe whold word ..
		 * */
		public function onDictFault1(e:Object = null ) : void
		{
			if ( this.faultedBefore ) 
			{
				this.goTrhgoutEAchWrodInName.end(); 	
				this.onDoneSearchingWords(); 
				return
			}
			
			this.faultedBefore = true; 
			this.goTrhgoutEAchWrodInName.end(); 
			this.getItemPronunciation( [this.currentLessonItem.name] )
		}
		
		public function onDoneSearchingWords():void
		{
			this.nextItem()
			
		}
		/*
		private function getItemPronunciation():void
		{
		if ( this.currentLessonItem.name.indexOf(' ' ) != -1 ) 
		{
		this.goTrhgoutEAchWrodInName
		}
		this.dispatch( new SearchDictionaryTriggerEvent(  
		SearchDictionaryTriggerEvent.SEARCH_DICTIONARY,  this.currentLessonItem.name,  
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
		this.currentLessonItem.name+'.***', this.onSavedSound, true  )
		}
		
		public function onSavedSound(filename:String):void
		{
		this.currentLessonItem.sound =  filename;
		this.currentLessonItem.update()
		this.nextItem()
		}
		
		*/
		private function nextItem( ):void
		{
			
			this.g.next(); 
		}
		
		
		
		
	}
}