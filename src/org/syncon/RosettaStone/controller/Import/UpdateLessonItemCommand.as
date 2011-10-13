package   org.syncon.RosettaStone.controller.Import
{
	
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.controller.Search.SearchDictionaryTriggerEvent;
	import org.syncon.RosettaStone.controller.Search.SearchImagesTriggerEvent;
	import org.syncon.RosettaStone.controller.Search.SearchYoutubeCommandTriggerEvent;
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon.RosettaStone.vo.LessonSetVO;
	import org.syncon.RosettaStone.vo.SearchResultVO;
	import org.syncon.RosettaStone.vo.SearchVO;
	import org.syncon2.utils.MakeVOs;
	import org.syncon2.utils.data.GoThroughEach;
	
	
	
	public class UpdateLessonItemCommand extends Command
	{
		[Inject] public var model:RSModel;
		[Inject] public var event:UpdateLessonItemCommandTriggerEvent;
		private var currentLessonItem: LessonItemVO;
		override public function execute():void
		{
			if ( event.type == UpdateLessonItemCommandTriggerEvent.UPDATE_ITEM ) 
			{
				this.startSetup()
			}				
		}
		
		
		public function startSetup(  ) : void
		{
			var i : LessonItemVO = this.event.item; 
			/*	i.name = o;*/
			this.currentLessonItem = i ;
			
			if ( event.action == UpdateLessonItemCommandTriggerEvent.PIC ) 
			{
				
				if ( i.pic != '' && i.pic != null  )  
				{
					NightStandConstants.FileLoader.deleteFile( i.folder , i.pic  ); 
				}
				this.getItemPic(); 
			}
			if ( event.action == UpdateLessonItemCommandTriggerEvent.PIC ) 
			{
				if ( i.sound != '' && i.sound != null  ) 
				{
					NightStandConstants.FileLoader.deleteFile( i.folder ,  i.sound ); 
				}
				this.getItemPronunciation(); //will will not operate on a prompt 
			}
			if ( event.action == UpdateLessonItemCommandTriggerEvent.AUDIO ) 
			{
				if ( event.data == null )
				{
					//must store in 'other' for now 
					this.getAudio();
				}
				else
				{
					this.onAudiosReturned(null, this.event.data.toString() ) ; 
				}
			}
			if ( event.action == UpdateLessonItemCommandTriggerEvent.VIDEO ) 
			{
				if ( event.data == null )
				{
					//must store in 'other' for now 
					throw 'write function'; 
					this.getAudio();
				}
				else
				{
					this.onVideosReturned(null, this.event.data.toString() ) ; 
				}
			}
			
			
			
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
			
			//this.onGotPic()
		}
		
		/*	
		private function onGotPic( ):void
		{
		this.getItemPronunciation()
		}*/
		private function getItemPronunciation():void
		{
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
		}
		
		
		private function getAudio():void
		{
			this.dispatch( new SearchYoutubeCommandTriggerEvent( 
				SearchYoutubeCommandTriggerEvent.SEARCH_YOUTUBE,
				this.getQuery() , this.onAudiosReturned ) ) 
		}
		
		private function onAudiosReturned(e:SearchResultVO, url :  String = null ):void
		{
			if ( url == null ) 
			{
				var s : SearchVO = e.results[0]
				url   = s.data; //'y'+s.url 
			}
			NightStandConstants.Server2.downloadVideoFileTo( url, this.model.lessonDir(), 
			 this.getName(), this.onSavedAudio, true  )
			return; 
		}
		
		public function onSavedAudio(e:Object):void
		{
			//trace('need the name', e ) ; 
			this.updateItem( 'other', e ) 
			//this.currentLessonItem.pic =  e.toString();
			this.currentLessonItem.update()
			//this.model.saveLesson()
			
			//this.onGotPic()
		}
		
		
		private function onVideosReturned(e:SearchResultVO, url :  String = null ):void
		{
			if ( url == null ) 
			{
				var s : SearchVO = e.results[0]
				url   = s.data; //'y'+s.url 
			}
			NightStandConstants.Server2.downloadVideoFileTo( url, this.model.lessonDir(), 
			 this.getName(), this.onSavedVideo, false  )
			return; 
		}
		
		public function onSavedVideo(e:Object):void
		{
			//trace('need the name', e ) ; 
			this.updateItem( 'other', e ) 
			//this.currentLessonItem.pic =  e.toString();
			this.currentLessonItem.update()
			//this.model.saveLesson()
			
			//this.onGotPic()
		}
		
		
		public function getQuery(   ) :  String
		{
			var q : String = this.currentLessonItem.name; 
			if ( this.event.query != null  && this.event.query != '' ) 
				q = this.event.query; 
			
			if ( this.event.queryPost != null ) 
				q += ' ' + this.event.queryPost; 
			
			return q; 
		}
		
		public function updateItem( prop : String , val : Object ) : void
		{
			if ( this.currentLessonItem.currentPrompt == null ) 
				this.currentLessonItem[prop] = val.toString();
			else
				this.currentLessonItem.currentPrompt[prop] = val.toString();
			this.currentLessonItem.update()
			
			if ( this.event.fxResult != null ) 
				this.event.fxResult( this.event.item ) ; 
		}
		
		
		public function getName(   ) :  String
		{
			if ( this.currentLessonItem.currentPrompt == null ) 
				return this.currentLessonItem.name+'.***'
			else
				return this.currentLessonItem.currentPrompt.name   + ' ' + this.currentLessonItem.name+'.***'
		 
			
			return ''
		}
		
		
		
		
	}
}