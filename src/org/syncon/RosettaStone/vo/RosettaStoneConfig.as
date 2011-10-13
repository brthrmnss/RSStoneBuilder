package  org.syncon.RosettaStone.vo
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	
	[RemoteClass]
	public class RosettaStoneConfig extends EventDispatcher 
	{
		public var name :  String = ''; // = true
		public var desc:String;
		
		public var gettingStartedSeen : Boolean = false; 
		public var lastVersionUsed : String = ''; 
		
		public var package_name :  String = ''; 
		
		static public var UPDATED : String = 'RosettaStoneConfigVOmupdated';
		public function update() : void
		{
			this.dispatchEvent( new Event( UPDATED ) ) ; 
		}
		
		
		public var volume : Number; 
		//public var currentUser : UserVO
		//public var users : ArrayCollection = new ArrayCollection()
		//public var groups : ArrayList = new ArrayList(); 
		/*	
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
		
		*/
		
		public var currentUnit:UnitVO;
		public var currentLessonGroup:LessonGroupVO;
		public var currentLesson:LessonVO;
		
		/**
		 * it did not like take the whoel thing too many levle of recursion? 
		 * storeSubInformation - for units, store groups, for groups, store lessons 
		 * this information should not be necessary .... so we drop it 
		 * */
		public function export(storeSubInformation : Boolean = false ) :  String
		{
			var config : Object = {} 
			config.name = this.name; 
			config.desc= this.desc; 
			config.gettingStartedSeen = this.gettingStartedSeen; 
			config.lastVersionUsed = this.lastVersionUsed; 
			
			if ( this.currentUnit != null ) 
			{
				trace('unit' ) 
				config.currentUnit =  JSON.decode( this.currentUnit.export()  )  
					//important as units can be moved, this is only stored in config
				config.currentUnit.baseFolder = this.currentUnit.baseFolder; 
				if ( storeSubInformation == false ) config.currentUnit.groups = [] 
			}
			if ( this.currentLessonGroup != null ) 
			{
				trace('group' ) 
				config.currentLessonGroup =JSON.decode( this.currentLessonGroup.export()  )  ; 
				if ( storeSubInformation == false ) config.currentLessonGroup.lessons = [] 
			}
			if ( this.currentLesson  != null ) 
			{
				trace('lesson' ) 
				config.currentLesson =JSON.decode( this.currentLesson.export() ); 
				if ( storeSubInformation == false ) config.currentLesson.sets = [] 
			}
			trace('config' ) 
			var str : String = JSON.encode( config ) ; 
			trace('return' ) 
			return   str 
		}
		
		public function importObj(input:Object):void
		{
			this.name = input.name; 
			this.desc = input.desc; 
			this.gettingStartedSeen = input.gettingStartedSeen; 
			this.lastVersionUsed = input.lastVersionUsed; 
			if ( input.hasOwnProperty('currentUnit') && input.currentUnit != null ) 
			{
				var unit :  UnitVO = new UnitVO()
				unit.importObj( input.currentUnit,false ) 
				this.currentUnit = unit; 
			}
			
			if ( input.hasOwnProperty('currentLessonGroup') && input.currentLessonGroup != null ) 
			{
				var lg :  LessonGroupVO = new LessonGroupVO()
				lg.importObj( input.currentLessonGroup, false ) 
				this.currentLessonGroup = lg; 
			}
			
			if ( input.hasOwnProperty('currentLesson') && input.currentLesson != null ) 
			{
				var l :  LessonVO = new LessonVO()
				l.importObj( input.currentLesson ) 
				this.currentLesson = l; 
			}			
		}
	}
}