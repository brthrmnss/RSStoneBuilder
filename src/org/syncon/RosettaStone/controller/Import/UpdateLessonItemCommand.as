package org.syncon.RosettaStone.controller.Import
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
	import org.syncon.RosettaStone.vo.PromptVO;
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
		
		/**
		 * either updating a prompt or item itself 
		 * 
		 * user sometimes sends in a query to search for  and we want first one 
		 * or we have a specific ? vidoe url, video to rip audio url, 
		 * 
		 * pic:
		 * prompt: use prompt name, or query to search 
		 * no prompt: use item name or query to search
		 * 
		 * dictionary
		 * p: prompt name, or query for words 
		 * no: name or query 
		 * 
		 * movie
		 * p: name or query for search
		 * no, nqme or query 
		 * 
		 * audio ditto
		 * 
		 * */
		public function startSetup( ) : void
		{
			var i : LessonItemVO = this.event.item; 
			this.currentLessonItem = i ;
			var currentPrompt : PromptVO = i.currentPrompt; 
			
			if ( currentPrompt != null ) 
			{
				var promptData : String = currentPrompt.data; 
				var promptDataNotBlank : Boolean = ( promptData != '' && promptData != null ) 
				if ( currentPrompt.def.isPic ) 
				{
					if (promptDataNotBlank ) { NightStandConstants.FileLoader.deleteFile( i.folder ,promptData ); 	}
					this.getItemPic(); 
				}
				/*if ( currentPrompt.def.isSound ) 
				{
				if (promptDataNotBlank ) { NightStandConstants.FileLoader.deleteFile( i.folder ,promptData ); 	}
				this.getItemPronunciation(); //will will not operate on a prompt 
				}*/
				if ( currentPrompt.def.isSound ) 
				{
					if (promptDataNotBlank ) { NightStandConstants.FileLoader.deleteFile( i.folder ,promptData ); 	}
					this.getAudio();
				}
				if ( currentPrompt.def.isMovie ) 
				{
					if (promptDataNotBlank ) { NightStandConstants.FileLoader.deleteFile( i.folder ,promptData ); 	}
					this.getVideo();
				}
				return; 
			}
			else //for updating the items, not a prompt ..
			{
				if ( event.action == UpdateLessonItemCommandTriggerEvent.PIC  ) 
				{
					if ( i.pic != '' && i.pic != null ) 
					{
						NightStandConstants.FileLoader.deleteFile( i.folder , i.pic ); 
					}
					this.getItemPic(); 
				}
				if ( event.action == UpdateLessonItemCommandTriggerEvent.DICTIONARY ) 
				{
					//this is dictionary sound .... not a prompt 
					if ( i.sound != '' && i.sound != null ) 
					{
						NightStandConstants.FileLoader.deleteFile( i.folder , i.sound ); 
					}
					this.getItemPronunciation(); //will will not operate on a prompt 
					//need to handle the pronunciation
				}
				/*if ( event.action == UpdateLessonItemCommandTriggerEvent. ) 
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
				}*/
				
			}
			
		}
		
		private function getItemPic():void
		{
			var query : String =this.getQuery();  
			this.dispatch( new SearchImagesTriggerEvent( 
				SearchImagesTriggerEvent.SEARCH_IMAGES, 
				query , this.onImagesReturned ) ) 
		}
		
		private function onImagesReturned(e:SearchResultVO):void
		{
			var s : SearchVO = e.results[0]
			this.downloadImage( s.url )  ;
		}
		
		private function downloadImage(  url : String ) : void
		{
			var dbg : Array = [	NightStandConstants.FileLoader]
			NightStandConstants.FileLoader.downloadFileTo( url, this.model.lessonDir(), 
				this.currentLessonItem.name+'.***', this.onSavedImage, true )
			//return; 
		}
		
		public function onSavedImage(e:Object):void
		{
			updateItem('pic', e.toString() ) 
		}
		
		/**
		 * we prefer thename first ... then they can override with the query 
		 * */
		public function getQuery ()  : String
		{
			var query : String  = this.event.item.name; 
			if ( this.event.item.currentPrompt != null )
			{
				query = this.event.item.currentPrompt.name ; 
			}
			if ( this.event.query != null && this.event.query != '' ) 
			{
				query = event.query
			}
			if ( this.event.queryPost != ''  && this.event.queryPost != null ) 
			{
				query += ' '  + this.event.queryPost; 
			}
			return query; 
		}
		
		private function getItemPronunciation():void
		{
			//probably should call the command here  ... we ar enot updating the dictionary pronunciation
			var wordToSearchFor : String =this.getQuery();  
			
			this.dispatch( new SearchDictionaryTriggerEvent( 
				SearchDictionaryTriggerEvent.SEARCH_DICTIONARY, wordToSearchFor, 
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
		}
		
		
		private function getAudio():void
		{
			this.dispatch( new SearchYoutubeCommandTriggerEvent( 
				SearchYoutubeCommandTriggerEvent.SEARCH_YOUTUBE,
				this.getQuery() , this.onAudiosReturned ) ) 
		}
		
		private function onAudiosReturned(e:SearchResultVO ):void
		{
			var s : SearchVO = e.results[0]
			var url  : String = s.data; //'y'+s.url 
			this.downloadAudio( url ) 
		}
		public function downloadAudio( url : String ) : void
		{
			NightStandConstants.Server2.downloadVideoFileTo( url, this.model.lessonDir(), 
				this.getName(), this.onSavedAudio, true )
			return; 
		}
		
		public function onSavedAudio(e:Object):void
		{
			this.updateItem( 'other', e ) 
		}
		
		private function getVideo():void
		{
			this.dispatch( new SearchYoutubeCommandTriggerEvent( 
				SearchYoutubeCommandTriggerEvent.SEARCH_YOUTUBE,
				this.getQuery() , this.onVideosReturned ) ) 
		}
		
		private function onVideosReturned(e:SearchResultVO ):void
		{
			var s : SearchVO = e.results[0]
			var url  : String = s.data; //'y'+s.url 
			this.downloadVideo( url ) 
		}
		public function downloadVideo( url : String ) : void
		{
			NightStandConstants.Server2.downloadVideoFileTo( url, this.model.lessonDir(), 
				this.getName(), this.onSavedVideo, false )
			return; 
		}
		
		public function onSavedVideo(e:Object):void
		{
			this.updateItem( 'other', e ) 
		}
		
		
		////////////////////////////////////////////////////////////////////////////////
		//Utils
		public function updateItem( prop : String , val : Object ) : void
		{
			if ( this.currentLessonItem.currentPrompt == null ) 
				this.currentLessonItem[prop] = val.toString();
			else
				this.currentLessonItem.currentPrompt.data = val.toString();
			this.currentLessonItem.update()
			
			if ( this.event.fxResult != null ) 
				this.event.fxResult( this.event.item ) ; 
		}
		
		
		public function getName( ) : String
		{
			if ( this.currentLessonItem.currentPrompt == null ) 
				return this.currentLessonItem.name+'.***'
			else
				return this.currentLessonItem.currentPrompt.name + ' ' + this.currentLessonItem.name+'.***'
			
			
			return ''
		}
		
		
		
		
	}
}