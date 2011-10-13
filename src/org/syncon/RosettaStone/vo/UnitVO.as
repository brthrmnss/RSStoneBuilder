package  org.syncon.RosettaStone.vo
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	
	[RemoteClass]
	public class UnitVO extends EventDispatcher 
	{
		public var name :  String = ''; // = true
		public var desc:String;
		
		static public var UPDATED : String = 'UnitVOmupdated';
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
		[Transient] public var groups : ArrayCollection = new ArrayCollection(); 
		
		
		public function importObj(input:Object,secondLoading : Boolean = true):void
		{
			this.name = input.name; 
			this.desc = input.desc; 
			if ( input.hasOwnProperty('baseFolder') ) //i'm sure second loading would work too
				this.baseFolder = input.baseFolder; 
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
			// output.baseFolder = this.baseFolder; //10-11-10: this caused lading errors, //10:-12/11, should be 'units'
			//no ... removed a 3rd time, units are moveable and autoloaded ... this is controled by LoadUnitsComand
			//full clarifcation, only when loading the config should this be saved ... i will add it on the save commands
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
		
		public function setSubBaseFolder(url:String):void
		{
			//this.baseFolder = url ; 
			for each ( var l : LessonGroupVO in this.groups.toArray() ) 
			{
				l.baseFolder = url; 
			}
		}
		
	}
}