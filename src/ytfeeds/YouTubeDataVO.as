/**
* YouTubeDataVO v0.1 Coded by dehash.com June 2008
*/
package ytfeeds {
	
	[Bindable]
	public class YouTubeDataVO {

		public var title:String = "";
		public var thumb:String = "";
		public var urlID:String = "";
		

		public function YouTubeDataVO( _title:String, _thumb:String, _urlID:String ) {
			this.title = _title;
			this.thumb = _thumb;
			this.urlID= _urlID;
		} 
	}
}
