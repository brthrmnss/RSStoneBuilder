package org.syncon.RosettaStone.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	
	[RemoteClass]
	public class LessonItemVO extends EventDispatcher
	{
		public var name : String = ''; // = true
		public var desc:String = ''
		public var pic:String = ''
		public var sound:String = ''
		
		public function get sourceImg () : String
		{
			if ( this.pic == '' ) 
				return ''; 
			return this.folder+'/'+this.pic; 
		}
		
		public function get sourceSound () : String
		{
			if ( this.sound == '' ) 
				return ''; 
			if ( this.folder == '/...' ) //this is what it would be if ti was empty .... 
				return this.sound; 
			//convertSoundToSourceSound( this.sound ) ; 
			return this.folder+'/'+this.sound; 
		}		
		
		public function getSoundSources(onThis : String = null) : Array
		{
			var split : Array = this.sound.split(' ' ) ; 
			
			if ( onThis != null ) 
				split  = onThis.split(' ' ) ; 
			
			var arr : Array = [] ; 
			//wat happens to 1 sound? 
			for each ( var sound_ : String in split ) 
			{
				sound_ = this.convertSoundToSourceSound( sound_ ) 
				arr.push( sound_ ) 
			}
			return arr; 
		}
		
		/**
		 * essentially append path 
		 * */
		public function convertSoundToSourceSound(inputSound: String )   : String
		{
			if ( inputSound == '' ) 
				return ''; 
			if ( this.folder == '/...' ) //this is what it would be if ti was empty .... 
				return inputSound; 
			
			return this.folder+'/'+inputSound
		}
		
		static public var UPDATED : String = 'lessonitemupdated';
		static public const TEXT_DISPLAY_VISIBILITY_CHANGED : String = 'PROMPT_VISIBILITY_CHANGED'; 
		static public const DISPLAY_IMAGE_CHANGED : String = 'PROMPT_IMAGE_CHANGED'; 
		static public const DISPLAY_TEXT_CHANGED : String = 'PROMPT_TEXT_CHANGED'; 
		static public const CURRENT_PROMPT_CHANGED : String = 'PROMPT_TEXT_CHANGED'; 
		
		private var _folder:String ='';
		
		[Transient]
		/**
		 * used to load images from subfolder ... do not save ... model 
		 * fills it in when loaded 
		 */
		public function get folder():String
		{
			return _folder;
		}
		
		/**
		 * @private
		 */
		public function set folder(value:String):void
		{
			_folder = value;
		}
		
		public var pronunciation:String='';
		public var itemRenderer:Object;
		public function update() : void
		{
			this.dispatchEvent( new Event( UPDATED ) ) ; 
		}
		public function importObj(input:Object):void
		{
			this.name = input.name; 
			this.desc = input.desc; 
			this.pic = input.pic; 
			this.sound = input.sound; 		
			this.pronunciation = input.pronunciation; 	
			this.image_attribution = input.image_attribution
			this.image_author = input.image_author
			
			PromptVO.importArray(input.prompts, this.prompts ); 
			/*this.promptImages = PromptVO.importArray(input.promptImages); 
			this.promptSounds = PromptVO.importArray(input.promptSounds); 
			this.promptText = PromptVO.importArray(input.promptText); */			
		}
		
		public function export() : Object
		{
			var output : Object = {}; 
			output.name = this.name; 
			output.desc = this.desc; 
			output.pic = this.pic; 
			output.sound = this.sound; 		 
			output.pronunciation = this.pronunciation; 	
			output.prompts = PromptVO.exportArray(this.prompts.toArray(), true); 
			output.image_attribution = this.image_attribution
			output.image_author = this.image_author
			/*	output.promptImages = PromptVO.exportArray(this.promptImages); 
			output.promptSounds = PromptVO.exportArray(this.promptSounds); 
			output.promptText = PromptVO.exportArray(this.promptText); 		*/		
			return output
		}			
		
		
		public function promptShow():void
		{
			this.showPrompt = true; 
			this.dispatchEvent( new Event( TEXT_DISPLAY_VISIBILITY_CHANGED ) ) ; 
		}
		
		public function promptHide():void
		{
			this.showPrompt = false; 
			this.dispatchEvent( new Event( TEXT_DISPLAY_VISIBILITY_CHANGED ) ) ; 
		}
		
		
		/***
		 * append gets you the image ulr, false get you just the image
		 * */
		public function getPromptData( promptName : String = null, appendFolder : Boolean =true ):String 
		{
			if ( promptName == null && this.currentPrompt != null ) 
				promptName = this.currentPrompt.name					
			var txt : String = this.getPrompt( promptName  ) 
			if ( txt == '' ||txt == null ) 
				return ''; 
			if ( appendFolder ) 
				return this.folder+'/'+txt; 
			return txt
		}
		
		
		/**
		 * goes through all prompts to find a match 
		 * */
		private function getPrompt(promptName:String ): String
		{
			var found : PromptVO; 
			for ( var i : int = 0 ; i < this.prompts.length; i++ )
			{
				if ( found != null ) 
					continue; 
				var l : PromptVO = prompts[i] as PromptVO
				if ( l.name == promptName )
					found = l 
			}
			if ( found == null ) 
				return null; 
			return found.data
		}
		
		
		/**
		 * goes through all prompts to find a match 
		 * */
		public function setPromptDefinition(promptDef:PromptDefinitionVO, notify:Boolean = true, fxRegerenate : Function = null): void
		{
			if ( promptDef != null ) 
			{
				var found : PromptVO; 
				for ( var i : int = 0 ; i < this.prompts.length; i++ )
				{
					if ( found != null ) 
						continue; 
					var l : PromptVO = prompts[i] as PromptVO
					if ( l.parent_id == promptDef.id )
						found = l 
				}
				if ( found == null )
				{
					if ( fxRegerenate != null ) 
					{
						trace('reginerating', 'setPromptDefinition' ) 
						//it is clonePrompts
						this.prompts =new ArrayCollection( fxRegerenate( this.prompts.toArray() ) ) 
						for ( i = 0 ; i < this.prompts.length; i++ )
						{
							if ( found != null ) 
								continue; 
							l = prompts[i] as PromptVO
							if ( l.parent_id == promptDef.id )
								found = l 
						}
					}
				}
				if ( found == null )
				{
					trace('LessonItemVO', 'setPromptDefinition' , 'could not find prompt' ) 
					throw 'how?'
				}
				else
				{
					this.currentPrompt = found; 
				}
			}
			else
			{
				this.currentPrompt = null; 
			}
			if ( notify) 
				this.dispatchEvent( new Event( LessonItemVO.CURRENT_PROMPT_CHANGED ) ) ; 
		}
		
		
		public var prompts : ArrayCollection = new ArrayCollection()
		/*	public var promptImages : Array = [] 
		public var promptText : Array = [] */
		public var showPrompt:Boolean=true;
		
		/**
		 * more of an editor thing
		 * ...y not on the model? 
		 * */
		[Transient] public var currentPrompt : PromptVO; 
		[Transient] public var itemRendererEdit: Object;
		public var image_author:String;
		public var image_attribution:String;
		public var editSelected:Boolean;
		
		/***
		 * return text to display , updates item renderers
		 * */
		public function getDisplayImage() : String
		{
			return ''
		}
		
		/***
		 * return text to display 
		 * */
		public function getDisplayText() : String
		{
			return ''
		}		
	}
}