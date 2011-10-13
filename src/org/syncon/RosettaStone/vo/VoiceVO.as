package  org.syncon.RosettaStone.vo
{
	import mx.collections.ArrayCollection;
	
	import org.syncon.RosettaStone.model.NightStandConstants;
	
	[RemoteClass]
	public class VoiceVO  
	{
		public var hispeedMode : Boolean = true; 
		public var fontSize : Number = NaN; 
		public var pic : String = ''; // Boolean = true; 
		public var name :  String = ''; // = true
		public var type:String;
		private var _sounds : Array = [] ; 
		public var _chasers : Array = [] ; 
		public var _intruders : Array = [] ; 
		public var _specialTimes : Array = [] ; //just use alarms ?
		
		[Transient]
		public var sounds :  ArrayCollection = new ArrayCollection();  
		[Transient]
		public var chasers : ArrayCollection = new ArrayCollection();
		[Transient]
		public var intruders : ArrayCollection = new ArrayCollection();
		[Transient]
		public var specialTimes : ArrayCollection = new ArrayCollection();  
		public var path:String;
		
		public function load() : void
		{
			//look for file in path ... config.txt
			if ( NightStandConstants.flex ) 
			{
				var x : Array = [0, 1, 2, 3, 4 ]
				this.convertToSounds( x, _sounds ) ; 
				this.sounds = new ArrayCollection(this._sounds ) 
				
				x   = [0, 1, 2, 3, 4 ]
				this.convertToSounds( x, _intruders, 'intruders' ) 
				this.intruders = new ArrayCollection(this._intruders)
				
				x    = [0, 1, 2, 3, 4 ]
				this.convertToSounds( x, _chasers, 'chasers' ) 
				this.chasers = new ArrayCollection(this._chasers )
				
				x = [0, 1, 2, 3, 4 ]
				this.convertToSounds( x, _specialTimes , 'special'  ) 				
				this.specialTimes = new ArrayCollection(this._specialTimes) 	
			}
			
		}
		
		private function convertToSounds(x:Array, sounds_:Array, folder : String = ''):void
		{
			for ( var i : int = 0; i < x.length ; i++ )
			{
				var a :  SampleVO = new SampleVO (); 
				a.name = x[i] //+ ' gggggggggggggggggggggggg ' 
				//	a.fxNoParams = xx[i]
					if ( folder.length > 1 ) 
						folder +='/'
					a.url = this.path + '/' +folder+a.name+'.mp3'
				sounds_.push( a ); 
			}
			
		}		
		
		
	}
}