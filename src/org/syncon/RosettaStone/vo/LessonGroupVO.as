package  org.syncon.RosettaStone.vo
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	import org.syncon.RosettaStone.model.NightStandConstants;
	
	[RemoteClass]
	public class LessonGroupVO  extends EventDispatcher
	{
		static public var UPDATED : String = 'LessonGroupVO_UPdated';
		public function update() : void
		{
			this.dispatchEvent( new Event( UPDATED ) ) ; 
		}
		
		public var name :  String = ''; // = true
		public var desc:String;
		
		/**
		 * 
		 * either load a direct path 
		 * or lazy load from a file folder with the name config.json 
		 * 
		 * baseFolder is the path to the current lesson gropu (adove), and url should be the local folder to load, so 
		 * when loading usualy you take the base_dir + '/'  + folder_name 
		 * */
		
		
  private var _baseFolder : String = ''; 

		[Transient]
		/**
		 * set when loading in items the first time 
		 * */
		public function get baseFolder():String
		{
			return _baseFolder;
		}

		/**
		 * @private
		 */
		public function set baseFolder(value:String):void
		{
			_baseFolder = value;
		}

		//public var path : String = '';
		/**
		 * really the folder name ... will rename this later
		 * */
		public var url : String = ''; 
		public function getSubDir() : String 
		{
			var url_ : String = ''
			if ( baseFolder != null && this.baseFolder != '' ) 
				url_ = baseFolder; 
			if ( url != '' && url != null ) 
				url_ = baseFolder + '/' + url 
		/*	if ( url_.indexOf('/') == -1 ) */
			return url_
			/*var split : Array = this.url.split('/'); 
			//if no '.' complain
			var dir : String = split.slice( 0, split.length-2).join('/');
			dir += '/'
			return dir;*/
		}
		//public var lessons : Array = new Array()
		[Transient] public var lessons :  ArrayCollection = new ArrayCollection(); 
		
		
		
		public function exportName():Object
		{
			var obj : Object = {}
			obj.name = this.name; 
			obj.desc = this.desc;
			//obj.url = url;//this.folder_name; 
			return obj;
		}
		
		public function importName(obj:Object):void
		{
			this.name = obj.name; 
			this.desc = obj.desc; 
			if ( obj.url == null )
				this.url = this.name; 
			//this.url = obj.url; 
		}
		
		
		public function importObj(input:Object,secondLoading : Boolean = true):void
		{
			this.name = input.name; 
			this.desc = input.desc; 
			if ( secondLoading == false ) 
				this.url = input.url; 
			//this.filename = input.filename; 			
			var lessonsImport : Array = input.lessons 
			this.lessons.removeAll(); 
			for each ( var obj :  Object in lessonsImport ) 
			{
				var l : LessonVO = new LessonVO()
				l.importName(obj);
				this.lessons.addItem( l ) ; 
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
			for each ( var l : LessonVO in this.lessons.toArray() ) 
			{
				lessonsExport.push(l.exportName())
			}
			output.lessons = lessonsExport; 
			return JSON.encode( output )
		}
		
		
		
		
		public function setBaseFolder(url:String):void
		{
			//this.baseFolder = url ; 
			//var subdir : String = this.getSubDir()
			for each ( var l : LessonVO in this.lessons.toArray() ) 
			{
				l.baseFolder = url; // url+'/'+; 
			}
		}
		
	}
}