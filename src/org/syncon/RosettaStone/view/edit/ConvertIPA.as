package org.syncon.RosettaStone.view.edit
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.RosettaStone.vo.LessonItemVO;
	import org.syncon.RosettaStone.vo.SearchVO;
	
	public class ConvertIPA 
	{
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
				//convert
				syllable =  this.ConvertToHexString( syllable ) 
				syllable = replacement2(syllable)
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
		
		
		
		public function asdf () : void
		{
			['b',	'd',	'j',	'f',	'g',	'h',	'k',	'l',	'm',	'n',	'ng',	'p',	'r',	's',	'sh',	't',	'ch',	'th',	'th',	'v',	'w',	'hw',	'y',	'z',	'zh',	'',	'a',	'ey',	'ah',	'air',	'aw',	'',	'e',	'ee',	'eer',	'er',	'',	'i',	'ahy',	'',	'o',	'oh',	'oo',	'oo',	'oi',	'ou',	'uh',	'uh',]
			['boy, baby, rob ',	'do, ladder, bed ',	'jump, budget, age ',	'food, offer, safe ',	'get, bigger, dog ',	'happy, ahead ',	'can, speaker, stick ',	'let, follow, still ',	'make, summer, time ',	'no, dinner, thin ',	'singer, think, long ',	'put, apple, cup ',	'run, marry, far, store ',	'sit, city, passing, face ',	'she, station, push ',	'top, better, cat ',	'church, watching, nature, witch ',	'thirsty, nothing, math ',	'this, mother, breathe ',	'very, seven, love ',	'wear, away ',	'where, somewhat ',	'yes, onion ',	'zoo, easy, buzz ',	'measure, television, beige ',	'',	'apple, can, hat ',	'aid, hate, day ',	'arm, father, aha ',	'air, careful, wear ',	'all, or, talk, lost, saw ',	'',	'ever, head, get ',	'eat, see, need ',	'ear, hero, beer ',	'teacher, afterward, murderer ',	'',	'it, big, finishes ',	'I, ice, hide, deny ',	'',	'odd, hot, waffle ',	'owe, road, below ',	'ooze, food, soup, sue ',	'good, book, put ',	'oil, choice, toy ',	'out, loud, how ',	'up, mother, mud ',	'about, animal, problem, circus ',]
			['b',	'd',	'dʒ',	'f',	'g',	'h',	'k',	'l',	'm',	'n',	'ŋ',	'p',	'r',	's',	'ʃ',	't',	'tʃ',	'θ',	'ð',	'v',	'w',	'ʰw',	'y',	'z',	'ʒ',	'',	'æ',	'eɪ',	'ɑ',	'ɛər',	'ɔ',	'aʊər',	'ɛ',	'i',	'ɪər',	'ər',	'ɜr',	'ɪ',	'aɪ',	'aɪər',	'ɒ',	'oʊ',	'u',	'ʊ',	'ɔɪ',	'aʊ',	'ʌ',	'ə',]
			['boy, baby, rob ',	'do, ladder, bed ',	'jump, budget, age ',	'food, offer, safe ',	'get, bigger, dog ',	'happy, ahead ',	'can, speaker, stick ',	'let, follow, still ',	'make, summer, time ',	'no, dinner, thin ',	'singer, think, long ',	'put, apple, cup ',	'run, marry, far, store ',	'sit, city, passing, face ',	'she, station, push ',	'top, better, cat ',	'church, watching, nature, witch ',	'thirsty, nothing, math ',	'this, mother, breathe ',	'very, seven, love ',	'wear, away ',	'where, somewhat ',	'yes, onion ',	'zoo, easy, buzz ',	'measure, television, beige ',	'',	'apple, can, hat ',	'aid, hate, day ',	'arm, father, aha ',	'air, careful, wear ',	'all, or, talk, lost, saw ',	'hour ',	'ever, head, get ',	'eat, see, need ',	'ear, hero, beer ',	'teacher, afterward, murderer ',	'early, bird, stirring ',	'it, big, finishes ',	'I, ice, hide, deny ',	'fire, tired ',	'odd, hot, waffle ',	'owe, road, below ',	'ooze, food, soup, sue ',	'good, book, put ',	'oil, choice, toy ',	'out, loud, how ',	'up, mother, mud ',	'about, animal, problem, circus ',]
			['b',	'd',	'dʒ',	'f',	'g',	'h',	'k',	'l',	'm',	'n',	'ŋ',	'p',	'r',	's',	'ʃ',	't',	'tʃ',	'θ',	'ð',	'v',	'w',	'ʰw',	'y',	'z',	'ʒ',	'',	'æ',	'eɪ',	'a;',	'eə',	'ɒ',	'"',	'e',	'i;',	'ɪə',	'ɜ;',	'"',	'ɪ',	'aɪ',	'"',	'ɒ',	'əʊ',	'u;',	'ʊ',	'ɔɪ',	'aʊ',	'ʌ',	'ə',]
		 			

		}
		
	}
}