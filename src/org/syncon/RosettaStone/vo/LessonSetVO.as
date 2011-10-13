package  org.syncon.RosettaStone.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;

	[RemoteClass]
	public class LessonSetVO  extends EventDispatcher
	{
		[Bindable] public var name :  String = ''; // = true
		public var desc:String='';
		
		static public var UPDATED : String = 'lessonsetupdated';
		public var items : ArrayCollection = new ArrayCollection(); 
		public function updated():void
		{
			this.dispatchEvent( new Event(UPDATED) ) 
		}
		
		
		public function importObj(input:Object):void
		{
			this.name = input.name; 
			this.desc = input.desc; 
			var inputItems : Array = input.items; 
			var lessonsImport : Array = [] ; 
			this.items.removeAll(); 
			for each ( var obj :  Object in inputItems ) 
			{
				var l :LessonItemVO = new LessonItemVO()
				l.importObj(obj);
				this.items.addItem( l ) ; 
			}
			
			//this.lessons.addAll( new ArrayCollection() ) 
		}
		
		public function export() : Object
		{
			var output :   Object = {}; 
			output.name = this.name; 
			output.desc = this.desc; 
			var exportItems : Array = [] ; 
			for each ( var l : LessonItemVO in this.items.toArray() ) 
			{
				exportItems.push(l.export())
			}
			output.items = exportItems; 
			return output
		}			
		
		public function getRandom( seen : Array = null) : LessonItemVO
		{
			if ( seen == null ) seen = [] 
				
			var output :   LessonItemVO;// = {}; 
		 
			var unseen : Array = []
			for each ( var o : Object in this.items.toArray() ) 
			{
				if ( seen.indexOf(o) == -1 ) 
				{
					unseen.push( o ) 
				}
			}
			if ( unseen.length == 0 ) 
				return null; //or should let it fai
			var max : Number = unseen.length-1
			var index : Number = getRandoml(0, max)
			output = unseen[index] 
			return output
		}			
		
		public static function getRandoml(min_num:Number,max_num:Number):Number
		{
			return min_num + Math.floor(Math.random() * (max_num + 1 - min_num));
		}
		
	}
}