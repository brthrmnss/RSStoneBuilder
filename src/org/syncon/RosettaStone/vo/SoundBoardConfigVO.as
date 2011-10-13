package org.syncon.RosettaStone.vo
{
	import flash.utils.Dictionary;
	
	
	[RemoteClass]
	public class SoundBoardConfigVO 
	{
		public var sounds : Array = [] ;
		public var name : String = ''; 
		public var package_name : String = ''; 
		public var subtitle : String = ''; 
		public var image : String = ''; 
		public var color : uint; 
		public var colorSet : Boolean = false; 
		public var version : String = ''; 
		public var human_version :  String = ''; 
		public var date : String = ''; 
		public var filters : Array = [] ;		
		public var tags : Array = [] ; 
		public function importObj ( p : Object, prepend : String = '' ) : void
		{
			this.name = p.name; 
			this.subtitle= p.subtitle; 
			this.package_name = p.package_name; 
			this.image = prepend+ p.image; 
			this.sounds = p.sounds; 
			var tagDict:Dictionary = new Dictionary(true)
			var pattern:RegExp = new RegExp("\r", 'gi' ) 
			var convertedSounds :   Array = []; 
			for each ( var o  : Object in this.sounds ) 
			{
				
				/*			for each ( var o:Object in  r.sounds  ) 
				{
				var exageratePostings:int=1;
				for ( var i : int = 0 ; i < exageratePostings ; i++ )
				{*/
				var s : SoundVO = new SoundVO()
				s.name = o.name
				s.name = s.name.replace(".mp3", '' ) 
				pattern= new RegExp("_", ' ' ) 
				s.name = s.name.replace(pattern, '' )
				 pattern = new RegExp("\\", 'gi' ) 
				o.url = o.url.replace( pattern, '/' ); 
				pattern = new RegExp('\\\\', 'gi' ) 
				o.url = o.url.replace( pattern, '/' ); 
				s.url = prepend+o.url; 
				
				
				//s.tag = o.tag; 
				convertedSounds.push( s )
				/*				}
				}*/
				
				var tagName :  String = o.tag; 
				if ( tagName != null )
				{
					
					var tag : TagVO = tagDict[tagName.toLowerCase()] 
					if ( tag == null )
					{ 
						tag = new TagVO()
						//tagName = this.capitalize( tagName ) ; 
						tag.name = tagName;
						
						this.tags.push( tag ) ; 
						tagDict[tagName.toLowerCase()] = tag; 
					}
					
					tag.sounds.push( s ) ; 
					
				}
			}
			
			
			var tag_order : String  = p.tag_order
			if ( tag_order != null ) 
			{
				var newTagOrder : Array = [] ; 
				var tagDict2 :Dictionary = tagDict//should clone ...
				var tagOrder : Array = tag_order.split(','); 
				for each ( var  tagOName : String in tagOrder ) 
				{
					var tagFound : TagVO = tagDict2[tagOName.toLocaleLowerCase()]
						if ( tagFound != null ) 
						{
							delete tagDict2[tagOName.toLocaleLowerCase()]
							//replace names ... for uppercase formatting 
							tagFound.name = tagOName; 
							newTagOrder.push( tagFound )
						}
				}
				
				for each ( tag in tagDict2 ) 
				{
						newTagOrder.push( tag )
				}
				
				this.tags = newTagOrder; 
			}
			
		/*	for each ( tag in tagDict2 ) 
			{
				newTagOrder.push( tag )
			}*/
			
			this.sounds = convertedSounds; 
			this.version = p.version 
			this.human_version = p.human_version; 
			this.filters = p.filters; //['name', 'look for']
			this.date = p.date; 
			if ( p.color != null )
			{
				this.colorSet = true;
				p.color = p.color.replace('#', '' ); 
				
				this.color = uint('0x'+p.color)
			}
		}
		
		private function capitalize(str:String):String
		{
			// TODO Auto Generated method stub
			str = str.charAt(0).toUpperCase() + str.slice(1, str.length ) 
			return str;
		}
	}
}