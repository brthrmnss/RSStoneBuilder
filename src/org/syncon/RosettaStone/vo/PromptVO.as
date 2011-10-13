package  org.syncon.RosettaStone.vo
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	
	[RemoteClass]
	public class PromptVO  extends EventDispatcher
	{
		
		static public const UPDATED : String = 'updatedPromptVO'
		public function updated() : void
		{
			this.dispatchEvent( new Event( UPDATED  ) ) 
		}
		
		/**
		 * included for debbuging purposes 
		 * */
		public var name :  String = ''; // = true
		//public var desc:String = ''
		public var def : PromptDefinitionVO; 
		/*
		public var required_prompt : Boolean = false; 
		public var required_image : Boolean = false; 
		public var required_sound : Boolean = false; 
		public var required_other : Boolean = false;
		*/
		public var prompt : String; 
		public var image : String; 
		public var sound : String; 
		public var other : String; 
		public var parent_id:int;
		//public var image_copyright:Object;
		
		public var image_author:String;
		public var image_attribution:String;
		
		public function importObj(input:Object):void
		{
			this.name = input.name; 
			this.parent_id = input.parent_id; 
			
			this.prompt = input.prompt; 
			this.image = input.image; 
			this.sound = input.sound; 
			this.other = input.other; 
			
			this.image_attribution = input.image_attribution
			this.image_author = input.image_author
			/*this.required_prompt = input.required_prompt; 
			this.required_image = input.required_image; 
			this.required_sound = input.required_sound; 
			this.required_other = input.required_other; */
		}
		
		public function export() : Object
		{ 
			var output :   Object = {}; 
			output.name = this.name; 
			output.parent_id = this.parent_id; 
			
			output.prompt = this.prompt; 
			output.image = this.image; 
			output.sound = this.sound; 
			output.other = this.other; 
			
			output.image_attribution = this.image_attribution
			output.image_author = this.image_author
				
			/*output.required_prompt = this.required_prompt; 
			output.required_image = this.required_image; 
			output.required_sound = this.required_sound; 
			output.required_other = this.required_other; 		*/	
			
			return   output 
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
				var l : PromptVO = new PromptVO()
				l.importObj(obj);
				items.push( l ) ; 
				if ( arrc != null )
				{
					arrc.addItem( l ) 
				}
				
			}
			return items;
		}
		static public function exportArray(outputItems:Array, skipEmpty : Boolean): Array
		{
			if ( outputItems == null ) 
				return []; 
			var items : Array = [] 
			for  ( var i : int = 0 ; i < outputItems.length; i++ )
			{
				var p : PromptVO =  outputItems[i] as  PromptVO
				if ( p.image == null || p.image == '' ) 
				{
					if ( p.prompt == null || p.prompt == '' ) 
					{
						if ( p.sound == null || p.sound == '' ) 
						{
							if ( p.other == null || p.other == '' ) 
							{
								continue 
							}
						}
					}
				}
				items.push( p.export()) ; 
			}
			return items;
		}
		
		
		
		
		
	}
}