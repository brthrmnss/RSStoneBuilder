package  org.syncon.RosettaStone.vo
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	
	[RemoteClass]
	public class LessonResultVO extends EventDispatcher 
	{
		public var name :  String = ''; // = true
		public var desc:String;
		
		static public var UPDATED : String = 'LessonResultVO_updated';
		public function update() : void
		{
			this.dispatchEvent( new Event( UPDATED ) ) ; 
		}
		//public var path : String = '';
		/**
		 * Points to path of file. unlike lessons, which are relative to this 
		 * do not set the folder, just the full path to file
		 * can be root based or defaults to subdir 
		 * */
		/**
		 * you odn't have to use this ... 
		 * */
		public var baseFolder : String = ''; 
		/**
		 * this should be called folder, the config is always config.json
		 * */
		public var url : String = ''; 
		/*public function get dir() : String
		{
		
		}*/
		public function getSubDir() : String 
		{
			var url_ : String = ''; 
			if ( baseFolder != '' && baseFolder != null )
				url_ = this.baseFolder + '/'
			url_ += this.url;
			if ( url_ == '' )
				return ''; 
			
			return url_ ;//
			
		}
		//public var lessons : Array = new Array()
		public var groups : ArrayCollection = new ArrayCollection(); 
		
		
		public function importObj(input:Object,secondLoading : Boolean = true):void
		{
			this.name = input.name; 
			this.desc = input.desc; 
			if ( secondLoading == false ) 
				this.url = input.url; 
			//this.filename = input.filename; 			
			var lessonsImport : Array = input.groups 
			this.groups.removeAll(); 
			for each ( var obj :  Object in lessonsImport ) 
			{
				var l : LessonGroupVO = new LessonGroupVO()
				l.importName(obj);
				this.groups.addItem( l ) ; 
			}
			
			//this.lessons.addAll( new ArrayCollection() ) 
		}
		
		public function export() : String
		{
			var output :   Object = {}; 
			output.name = this.name; 
			output.desc = this.desc; 
			output.url = this.url; 
			//output.filename = this.filename; 			
			var lessonsExport : Array = [] ; 
			for each ( var l : LessonGroupVO in this.groups.toArray() ) 
			{
				lessonsExport.push(l.exportName())
			}
			output.groups = lessonsExport; 
			return JSON.encode( output )
		}
		
		
		public function importDirectories(input: Array):void
		{
			this.groups.removeAll(); 
			for each ( var folder :   String in input ) 
			{
				var l : LessonGroupVO = new LessonGroupVO()
				l.name = folder; 
				l.url = folder; 
				this.groups.addItem( l ) ; 
			}
		}
		
		
		public function percentCorrect() : Number
		{
			return this.correctCount/this.trialCount; 
		}
		
		public var correctCount : int = 0 ; 
		public var trialCount : int = 0 ; 
		/**
		 * T/F if result has been set once
		 * */
		private var resultRecieved:Boolean;
		public var wrongs : Array = []; 
		
		
		public function newItem( ):void
		{
			this.trialCount++
				this.resultRecieved = false; 
		}
		
		public function currentCorrect(url:String=''):void
		{
			if ( this.resultRecieved == true ) 
				return; 
			
			this.resultRecieved = true; 
			this.correctCount++
		}
		
		
		public function currentWrong(url:Object=null):void
		{
			if ( this.resultRecieved == true ) 
				return; 
			
			this.resultRecieved = true; 
			this.wrongs.push(url)
		}
		
	}
}