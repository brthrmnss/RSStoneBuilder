package  org.syncon.RosettaStone.vo
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	[RemoteClass]
	public class LessonVO extends EventDispatcher  		
	{
		public var pic : String = ''; // Boolean = true; 
		public var name :  String = ''; // = true
		public var desc:String='';
		
		public var folder_name : String = ''; 
		
		/**
		 * used by curriculum item renderer
		 * */;
		[Transient] public var currentLesson  :  Boolean
		
		[Transient] public var sets : ArrayCollection = new ArrayCollection(); 
		
		static public const UPDATED : String = 'lessonupdated';
		static public const EXPORT_STRING_CHANGED : String = 'EXPORT_STRING_CHANGED';
		
		
		[Transient]  public var baseFolder : String = ''; 
		public var url : String = ''; 
		
		private var _test:Boolean=false;
		
		public function set test ( b : Boolean ) :  void
		{
			if ( b == _test ) 
				return; 
			this._test = b; 
			if ( b ) 
			{
				this.option_showPromptOnItemRender = false; 
				//this.option_promptIncludesText = false 
				this.option_oneShotAnswerAttemps = true ; 
				this.option_introduceItems = false; 
				this.option_PlaySoundWhenWrongOneClicked = false ; 
				this.option_MasteryMode = false; 
			}
		}
		
		public function get test() : Boolean{
			return this._test; 
		}
		
		/**
		 * flag indicates wheather to always show the prompt (great for non roman alphabets)
		 * */
		public var option_showPromptOnItemRender : Boolean = false; 
		/**
		 * hide the prompt text ...
		 * */
		public var option_showPromptText : Boolean = true; 
		public var option_introduceItems : Boolean = true 
		public var option_oneShotAnswerAttemps : Boolean = false //why would you want this ? or maybe counting how many times
		public var option_PlaySoundWhenWrongOneClicked : Boolean = false; 
		
		public var option_MasteryMode : Boolean = false; 
		
		public var prompts : ArrayCollection = new ArrayCollection()
		//public var prompts : Array = [] 
		/*public var promptSounds : Array = [] 
		public var promptImages : Array = [] 
		public var promptText : Array = [] */
		public var showPrompt:Boolean=true;
		public var activePromptText:String;
		public var activePromptImage:String;
		public var activePromptSound:String;	
		/**
		 * Flag, if loaded into model at least onces
		 * */
		public var loadedOnce:Boolean;
		
		public function getSubDir() : String 
		{
			var url_ : String = ''
			if ( baseFolder != null && this.baseFolder != '' ) 
				url_ = baseFolder; 
			if ( url != '' && url != null ) 
				url_ = baseFolder + '/' + url 
			/*if ( this.url.indexOf('/') == -1 ) 
			return url_
			var split : Array = this.url.split('/'); 
			//if no '.' complain
			var dir : String = split.slice( 0, split.length-2).join('/');
			dir += '/'*/
			return url_;
		}
		
		/**
		 * return either the name, or the folder name ...if set 
		 * */
		public function get getFolderName() : String 
		{
			var folder : String = this.folder_name; 
			if ( this.folder_name == ''  || this.folder_name == null ) 
				folder = this.name; 
			return folder;
		}
		
		
		public function updated() : void
		{
			this.dispatchEvent( new Event( UPDATED ) )		
		}
		
		public function get lastExport() : String
		{
			return this.lastExportPreview; 
		}
		private var lastExportPreview :String ; 
		public var retrievedContentsOnce:Boolean;
		public function previewExport() : void
		{
			var exportStr : String = this.export(); 
			if ( exportStr == lastExportPreview ) 
			{
				return ; 
			}
			this.lastExportPreview = exportStr
			
			this.dispatchEvent( new Event( EXPORT_STRING_CHANGED ) )		
		}
		
		
		/**
		 * Transfer definitions from lesson to item sets .. 
		 * do not adjust existing ones ...
		 * */
		public function clonePrompts(arr : Array ) : Array
		{
			var prompts : Array = [] ; 
			var dictCurrentPrompts : Dictionary = new Dictionary(true); 
			for  (   i   = 0 ; i < arr.length; i++ )
			{
				var p : PromptVO = arr[i] as  PromptVO 
				dictCurrentPrompts[p.parent_id] = p 
			} 
			var dictPrompts : Dictionary = this.makeDictOfPrompts(); 
			for  (  var i : int = 0 ; i < this.prompts.length; i++ )
			{
				var def : PromptDefinitionVO =this.prompts[i] as  PromptDefinitionVO 
				//should update 
				var existing : PromptVO = dictCurrentPrompts[def.id] 
				if ( existing == null ) 
				{
					existing = def.makeLiveVersion()
				}
				else
				{
					existing.name = def.name;
				}
				/*else
				def.update(existing)*/
				
				prompts.push(existing);
				
			}
			return prompts 
		}
		
		/**
		 * find unused filenames 
		 * remove unused prompts 
		 * look for required prompts that are empty 
		 * */
		/**
		 * get next id for naming 
		 * */
		public function getNextPromptDefId() : int
		{
			var maxId : int = 0 ; 
			for  (  var  i  : int = 0 ; i < this.prompts.length; i++ )
			{
				var def : PromptDefinitionVO =this.prompts[i] as  PromptDefinitionVO 
				if ( def.id >= maxId ) 
					maxId = def.id; 
			}
			maxId++
			return maxId
		}
		
		public function exportName():Object
		{
			var obj : Object = {}
			obj.name = this.name; 
			obj.desc = this.desc;
			obj.folder_name = this.folder_name; 
			return obj;
		}
		
		public function importName(obj:Object):void
		{
			this.name = obj.name; 
			this.desc = obj.desc; 
			this.folder_name = obj.folder_name; 
		}
		
		
		
		
		public function importObj(input:Object):void
		{
			this.name = input.name; 
			this.desc = input.desc; 
			this.test = input.test; 
			this.option_showPromptOnItemRender  = input.option_showPromptOnItemRender
			this.option_introduceItems  = input.option_introduceItems
			this.option_oneShotAnswerAttemps  = input.option_oneShotAnswerAttemps
			this.option_PlaySoundWhenWrongOneClicked  = input.option_PlaySoundWhenWrongOneClicked
			/*	
			this.promptImages = PromptVO.importArray(input.promptImages);  
			this.promptSounds = PromptVO.importArray(input.promptSounds);  
			this.promptText = PromptVO.importArray(input.promptText);  	
			*/
			//this.prompts = PromptVO.importArray(input.prompts);
			PromptDefinitionVO.importArray(input.prompts, this.prompts ); 
			var dictPromptDefs : Dictionary = this.makeDictOfPrompts(); 
			var setsInput : Array = input.sets; 
			var lessonsImport : Array = [] ; 
			this.sets.removeAll(); 
			for each ( var obj :  Object in setsInput ) 
			{
				var l :LessonSetVO = new LessonSetVO()
				
				l.importObj(obj);
				
				//copy prompt defitions to prompts on Lesson's Set's Item
				for each ( var item :LessonItemVO in l.items ) 
				{
					for each ( var prompt :  PromptVO in item.prompts ) 
					{
						var parentPromptDef : PromptDefinitionVO = dictPromptDefs[prompt.parent_id] 
						if (   parentPromptDef != null  )
						{
							prompt.def = parentPromptDef 
						}
					}
				}
				
				this.sets.addItem( l ) ; 
			}
			
			//this.lessons.addAll( new ArrayList() ) 
		}
		
		private function makeDictOfPrompts():Dictionary
		{
			var dict : Dictionary = new Dictionary(true); 
			for each ( var promptDef : PromptDefinitionVO in this.prompts ) 
			{
				dict[promptDef.id] = promptDef; 
			}
			// TODO Auto Generated method stub
			return dict;
		}
		
		public function export() : String
		{
			var output :   Object = {}; 
			output.name = this.name; 
			output.desc = this.desc; 
			output.test = this.test; 
			
			output.option_showPromptOnItemRender  = this.option_showPromptOnItemRender
			output.option_introduceItems  = this.option_introduceItems
			output.option_oneShotAnswerAttemps  = this.option_oneShotAnswerAttemps
			output.option_PlaySoundWhenWrongOneClicked  = this.option_PlaySoundWhenWrongOneClicked
			
			output.prompts = PromptDefinitionVO.exportArray(this.prompts.toArray()); 
			/*
			output.promptImages = PromptVO.exportArray(this.promptImages);  
			output.promptSounds = PromptVO.exportArray(this.promptSounds);  
			output.promptText = PromptVO.exportArray(this.promptText);  		
			*/
			//output.prompts = PromptVO.exportArray(this.prompts); 
			
			var setsExport : Array = [] ; 
			for each ( var l : LessonSetVO in this.sets.toArray() ) 
			{
				setsExport.push(l.export())
			}
			output.sets = setsExport; 
			return JSON.encode( output )
		}			
		
		
		
		public function get items () : Array
		{
			var items : Array = []; 
			for each (var l :LessonSetVO  in  this.sets  ) 
			{
				for each ( var item :LessonItemVO in l.items ) 
				{
					items.push( item ) 
				}
			}
			return  items
		}
		
		
		public function get selectedItems () : Array
		{
			var items : Array = []; 
			for each (var l :LessonSetVO  in  this.sets  ) 
			{
				for each ( var item :LessonItemVO in l.items ) 
				{
					if ( item.editSelected ) 
						items.push( item ) 
				}
			}
			return  items
		}
		
		
	}
}