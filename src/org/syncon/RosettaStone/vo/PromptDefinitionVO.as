package  org.syncon.RosettaStone.vo
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 
	 * this is a second class to swe can lmit the amount of versoity 
	 * */
	[RemoteClass]
	public class PromptDefinitionVO  extends EventDispatcher
	{
		
		static public const PIC : String = 'PIC'
		static public const MOVIE : String = 'MOVIE'
		static public const SOUND : String = 'SOUND'
		static public const TEXT : String = 'TEXT'
			
		public function get  isPic () : Boolean
		{
			if ( this.type == PIC ) return true; 
			return false; 
		}
		
		public function makePic () : void
		{
			 this.type  = PIC 
		}
		
		public function get  isSound () : Boolean
		{
			if ( this.type == SOUND ) return true; 
			return false; 
		}
		
		public function makeSound () : void
		{
			this.type  = SOUND 
		}
		
		public function get  isMovie () : Boolean
		{
			if ( this.type == MOVIE ) return true; 
			return false; 
		}
		
		public function makeMovie () : void
		{
			this.type  = MOVIE 
		}
		
		public function get  isText () : Boolean
		{
			if ( this.type == TEXT ) return true; 
			return false; 
		}
		
		public function makeText () : void
		{
			this.type  = TEXT 
		}
		
			
		static public const UPDATED : String = 'updatedPromptVO'
		public function updated() : void
		{
			this.dispatchEvent( new Event( UPDATED  ) ) 
		}
		
		public var name :  String = ''; // = true
		public var desc:String = ''
		public var type : String = TEXT;
		/**
		 * transfer to Prompt 
		 * */
		public var id : int = 0 ; 
		
		public var required : Boolean = false; 
		/*
		public var prompt : String; 
		public var image : String; 
		public var sound : String; 
		public var other : String; 
		*/
		public function importObj(input:Object):void
		{
			this.name = input.name; 
			this.desc = input.desc; 
			this.id = input.id; 
			/*
			this.prompt = input.prompt; 
			this.image = input.image; 
			this.sound = input.sound; 
			this.other = input.other; 
			*/
			this.type = input.type; 
			this.required = input.required; 
		}
		
		public function export() :  Object
		{ 
			var output :   Object = {}; 
			output.name = this.name; 
			output.desc = this.desc; 
			output.id = this.id; 
			/*
			output.prompt = this.prompt; 
			output.image = this.image; 
			output.sound = this.sound; 
			output.other = this.other; 
			*/
			output.type = this.type; 
			output.required = this.required; 
			return  output 
		}			
		
		
		static public  function importArray(input:Array, arrc : ArrayCollection = null ): Array
		{
			
			if ( arrc != null )
			{
				arrc.removeAll(); 
			}
			var items : Array = [] 
			if ( input == null ) 
				return []; 
			for  ( var i : int = 0 ; i < input.length; i++ )
			{
				var obj : Object = input[i]
				var l : PromptDefinitionVO = new PromptDefinitionVO()
				l.importObj(obj);
				items.push( l ) ; 
				if ( arrc != null )
				{
					arrc.addItem( l ) 
				}
				
			}
			return items;
		}
		static public function exportArray(outputItems:Array): Array
		{
			if ( outputItems == null ) 
				return []; 
			var items : Array = [] 
			for  ( var i : int = 0 ; i < outputItems.length; i++ )
			{
				var p : PromptDefinitionVO =  outputItems[i] as  PromptDefinitionVO 
				items.push( p.export()) ; 
			}
			return items;
		}
		
		
		
		
		
		public function makeLiveVersion():PromptVO
		{
			var p : PromptVO = new PromptVO()
			p.name = this.name; 
			//p.desc = this.desc; 
			p.def = this; 
			p.parent_id = this.id; 
			// TODO Auto Generated method stub
			return p;
		}
	}
}