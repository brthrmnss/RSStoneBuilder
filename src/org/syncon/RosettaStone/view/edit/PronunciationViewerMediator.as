package org.syncon.RosettaStone.view.edit
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon.RosettaStone.vo.SearchVO;
	
	public class PronunciationViewerMediator extends Mediator 
	{
		[Inject] public var ui : PronunciationViewer;
		[Inject] public var model : RSModel;
		private var currentLessonItem: LessonItemVO;
		private var modeAndroidFrieldny:Boolean=true;
		
		override public function onRegister():void
		{
			/*eventMap.mapListener(eventDispatcher, NightStandModelEvent.CURRENT_LESSON_ITEM_CHANGED, 
			this.onLessonItemChanged);	
			this.onLessonItemChanged( null ) 
			*/
			this.ui.addEventListener( PronunciationViewer.PRONOUNCE, this.onPlay);	 
			this.ui.addEventListener( PronunciationViewer.PLAY_ALL, this.onPlayAll);		
			this.ui.addEventListener( PronunciationViewer.PLAY_AL_REV, this.onPlayAll_Rev);	
			
		}
		
		protected function onPlayAll(event:CustomEvent):void
		{
			var fullPronunciation : Array = event.data as Array; 
			//properSyllables
			
			var songs : Array = []; 
			for each ( var o : SearchVO in fullPronunciation )
			{
				var url : String = this.getUrl( o.name ) ; 
				songs.push(url); 
			}
			this.model.chainUp( songs ) ; 
		}
		protected function onPlayAll_Rev(event:CustomEvent):void
		{
			var fullPronunciation : Array = event.data as Array; 
			var songs : Array = []; 
			for each ( var o : SearchVO in fullPronunciation )
			{
				var url : String = this.getUrl( o.name ) ; 
				songs.push(url); 
			}
			//songs = songs.reverse();
			var songs2 : Array = []; 
			for ( var i : int = 0; i < songs.length; i++ )
			{
				//url = songs[i] 
				songs2 = songs2.concat( songs.slice( songs.length -i-1, songs.length) ) 
				//songs2.push(url); 
				songs2.push( this.getUrl( 'silence' ) ) 
			}
			this.model.chainUp( songs2 ) ; 
		}
		
		protected function onPlay(event: CustomEvent):void
		{
			var searchItem : SearchVO = new SearchVO(); 
			var syllable : String = event.data.name.toString()
			var url : String = this.getUrl( syllable ) ; 
			this.model.playSound2( url ) ; 
		}
		protected function getUrl( syllable:  String):String
		{
			var dbg : Array = [ syllable.charCodeAt(0 ), this.ConvertToHexString( syllable )  ] 
			//replace for dictionary issues
			var replace : Array = ['ɔ', 'i'];
			var replacements  : Array = ['ɒ', 'i;']
			var index : int = replace.indexOf( syllable ) 
			if ( index != -1 ) 
				syllable = replacements[index]
			if ( modeAndroidFrieldny == false ) 
			{
				var url : String = 'assets/sounds/ipa/'+syllable+'.mp3';
			}
			if ( modeAndroidFrieldny )
			{
				if ( syllable != 'silence' ) 
				{
					//convert
					syllable =  this.ConvertToHexString( syllable ) 
					syllable = replacement2(syllable)
				}
				url = 'assets/sounds/ipa/converted/'+syllable+'.mp3';
			}
			return url; 
		}
		private function ConvertToHexString(s:String, skip: Array = null):String {
			var retString: String = "";
			var i:uint;
			var hexValue:String;
			
			for (var k:int=0; k < s.length; k++) {
				var char : String = s.charAt(k)
				
				
				var replace : Array = ["a;", "a\u028A", "a\u026A", "b", "d", "e", "e\u0259", "e\u026A", "f", "g", "h", "i;", "j", "k", "l", "m", "n", "p", "r", "s", "t", "u;", "v", "w", "z", "\u00E6", "\u00F0", "\u014B", "\u0254;", "\u0254\u026A", "\u0259", "\u0259\u028A", "\u0283", "\u028A", "\u0292", "\u0252", "\u025C;", "\u026A", "\u026A\u0259", "\u028C", "\u02A4", "\u02A7", "\u03B8"]
				var index : int = replace.indexOf( char ) 
				if ( index != -1 ) 
				{
					retString  += char
					continue; 
				}
				
				i = s.charCodeAt(k);
				//trace ("i:" + i.toString());
				hexValue = i.toString(16);
				
				switch (hexValue.length) {
					case 3:
						hexValue = "0" + hexValue;
						break;
					case 2:
						hexValue = "00" + hexValue;
						break;
					case 1:
						hexValue = "000" + hexValue;
						break;
				}
				trace ("ConvertToHexString:" + hexValue);
				retString  += '\\u'+ hexValue.toUpperCase();
				
			}
			return retString
		}
		
		public function replacement2(input :  String ) : String
		{
			var replace : Array = ["a;", "a\u028A", "a\u026A", "b", "d", "e", "e\u0259", "e\u026A", "f", "g", "h", "i;", "j", "k", "l", "m", "n", "p", "r", "s", "t", "u;", "v", "w", "z", "\u00E6", "\u00F0", "\u014B", "\u0254;", "\u0254\u026A", "\u0259", "\u0259\u028A", "\u0283", "\u028A", "\u0292", "\u0252", "\u025C;", "\u026A", "\u026A\u0259", "\u028C", "\u02A4", "\u02A7", "\u03B8"]
			var replacements  : Array = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43"]
			var syllable : String = input; 
			var index : int = replace.indexOf( input ) 
			if ( index != -1 ) 
				syllable = replacements[index]
			
			return syllable
		}
		
	}
}