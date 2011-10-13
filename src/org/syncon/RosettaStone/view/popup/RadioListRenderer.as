package org.syncon.RosettaStone.view.popup
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TransformGestureEvent;
	import flash.text.TextField;
	
	import org.syncon.RosettaStone.view.mobile.itemrenderers.BaseRenderer;
	import org.syncon.RosettaStone.view.mobile.itemrenderers.utils.TextUtil;
	import org.syncon.RosettaStone.vo.AirVGroupVO;
	
	import spark.components.RadioButton;
	import spark.components.RadioButtonGroup;
	
	public class RadioListRenderer extends  BaseRenderer
	{
		//--------------------------------------------------------------------------
		//  Protected properties
		//--------------------------------------------------------------------------
		
		protected var txtTitle:TextField;
		protected var cb :   RadioButton; 
		
		protected var background:DisplayObject;
		protected var backgroundClass:Class;
		protected var separator:DisplayObject;
		
		protected var paddingLeft:int;
		protected var paddingRight:int;
		protected var paddingBottom:int;
		protected var paddingTop:int;
		protected var horizontalGap:int;
		protected var verticalGap:int;
		
		protected var maxHeightSize:Number;
		protected var autoSize:Boolean;
		//--------------------------------------------------------------------------
		//  Contructor
		//--------------------------------------------------------------------------
		
		
		
		public function RadioListRenderer()
		{
			percentWidth = 100;
		}
		
		//--------------------------------------------------------------------------
		//  Override Protected Methods
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			readStyles();
			
			setBackground();
			
			var separatorAsset:Class = getStyle( "separator" );
			if( separatorAsset )
			{
				separator = new separatorAsset();
				addChild( separator );
			}
			
			
			this.arrange =   new AirVGroupVO()
			this.arrange.paddingAll( 10 ) ;
			
			this.txtTitle  = TextUtil.createSimpleTextField( getStyle( "txtTitleStyle" ) , false, "none" );
			this.txtTitle.multiline = false;
			this.txtTitle.wordWrap = false; 
			this.arrange.useEmbeddedFont( this.txtTitle )
			addChild( this.txtTitle );
			
			cb = new RadioButton();
			cb.group = new RadioButtonGroup(); 
			cb.width = 48
			cb.height = 48 
			addChild( cb );
			cb.addEventListener(Event.CHANGE, this.onChanged, false, 0, true) ; 
			
			
			// if the data is not null, set the text
			if( data )
				setValues();
			
		}
		private function onChanged ( e : Event ) : void{
			this.data.selected = this.cb.selected; 
		}
		protected function setBackground():void
		{
			var backgroundAsset:Class = getStyle( "background" );
			if( backgroundAsset && backgroundClass != backgroundAsset )
			{
				if( background && contains( background ) )
					removeChild( background );
				
				backgroundClass = backgroundAsset;
				background = new backgroundAsset();
				addChildAt( background, 0 );
				if( layoutHeight && layoutWidth )
				{
					background.width = layoutWidth;
					background.height = layoutHeight;
				}
			}
		}
		
		//--------------------------------------------------------------------------
		public var arrange  : AirVGroupVO; 
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			
			this.txtTitle.x = paddingLeft
			this.txtTitle.y = paddingTop
			this.txtTitle.width = unscaledWidth - paddingLeft - paddingRight 
			
			this.arrange.left( this.cb, unscaledWidth ) ; 
			
			layoutHeight = this.txtTitle.y+this.txtTitle.textHeight+paddingBottom
			
			if ( separator != null ) 
			{
				separator.width = unscaledWidth;
				separator.y = layoutHeight - separator.height;
			}
		}
		
		protected function swipeHandler(event:TransformGestureEvent):void
		{
			// TODO Auto-generated method stub
			if (event.offsetY == 1) {
				trace("swiped down" ) 
			}
			else if (event.offsetY == -1) {
				trace( "swiped up") ;
			}
		}
		
		override public function getLayoutBoundsHeight(postLayoutTransform:Boolean=true):Number
		{
			return layoutHeight;
		}
		
		override public function set data( value:Object ):void
		{
			/*if( _data == value )
				return;*/
			
			_data = value;
			// if the elements has been created we set the values
			if( creationComplete )
				setValues();
		}
		override protected function setValues():void
		{
			var d :   SelectableItemVO = data as SelectableItemVO; 
			if ( d == null )
			{
				return;
			}
			/*	var arr:Array = String( data.author.name ).split("(");
			var user:String = String( data.author.name )*/
			/*if ( d.postedBy == null ) {
			trace('what'); 
			d.postedBy = ''; 
			}
			if ( d.postedAgo == null ) {
			trace('what'); 
			d.postedAgo = ''; 
			}			*/
			//	this.txtUsername.text = d.postedBy//arr[0];
			this.cb.selected  = d.selected
			this.txtTitle.text = d.name; /*+ '//domainOnly = /([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}/i//new RegExp("([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}", "g" ); ' + 
			
			
			'sdf df //domainOnly = /([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}/i//new RegExp("([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}", "g" ); ' + 
			'sdf df //domainOnly = /([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}/i//new RegExp("([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}", "g" ); ' + 
			'sdf df //domainOnly = /([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}/i//new RegExp("([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}", "g" ); ' + 
			
			'sdf dddd//domainOnly = /([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}/i//new RegExp("([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}", "g" ); '
			*/
			// String( arr[ 1 ] ).replace( ")", "" );
			//contentField.htmlText;// = data.content.value;
			/*	this.txtPoints.text = d.points + ' points'  + ' - ' + d.commentCount + ' comments '    ; 
			url =  d.url.replace('http://', '' ).slice(0, 16 ); 
			url = stripExtraneousUrlInformation( url ) ; 
			this.txtUrl.text =url*/
			//^(http://|https://)[A-Za-z0-9.-]+(?!.*\|\w*$)
			
			//http://gskinner.com/RegExr/
			
			//var domainOnly:RegExp =new RegExp("http(s?)://([\w]+\.){1}([\w]+\.?)+", "gi" ); 
			//	2	trace("directories = ", url.match(directoriesPattern));/
			///http(s?):\/\/([\w]+\.){1}([\w]+\.?)+/
			
			//domainOnly = /([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}/i//new RegExp("([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}", "g" ); 
			//var eee : String = domainOnly.exec( d.url ) ; 
			/*if ( domainOnly == null ) 
			domainOnly = /([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}/gi
			var urls : Array = d.url.match( domainOnly )
			if ( urls.length > 1 ) 
			{
			var url : String =urls[0]
			url = url.slice(0, 18 ); 
			url = stripExtraneousUrlInformation( url ) ; 
			this.txtUrl.text =url; 
			}
			if ( this.txtUrl.text == '' )
			this.txtUrl.text = ' ' ; 
			this.txtTimeAgo.text = d.postedAgo;//'4 hours' 
			*/
			/*if( data.link.length > 1)
			avatar.source = data.link[ 1 ].href;*/
		}
		
		private function stripExtraneousUrlInformation(url:String):String
		{
			if ( stripW == null ) 
				stripW = 	/^www./gi
			url = url.replace( stripW, '' ) ; 
			if ( stripEndingSlash == null ) 
				stripEndingSlash = new RegExp(	"/$", "ig" )
			url = url.replace( stripEndingSlash, '' ) ; 		
			//strip anything after a / 
			if ( url.indexOf( '/' ) != -1 ) 
			{
				var split : Array = url.split('/'); 
				url = split[0]; 
			}
			/*			stripEndingSlash = new RegExp(	"/$", "ig" )
			url = url.replace( stripEndingSlash, '' ) ; 	
			stripEndingSlash = new RegExp(	"\/$", "ig" )
			url = url.replace( stripEndingSlash, '' ) ; 			
			stripEndingSlash =/\/$/i*/
			url = url.replace( stripEndingSlash, '' ) ; 	
			return url;
		}
		
		static public var stripW : RegExp  ; 
		static public var domainOnly:RegExp ;
		static public var  stripEndingSlash : RegExp; 
		
		override protected function updateSkin():void
		{
			currentCSSState = ( selected ) ? "selected" : "up";
			setBackground();
		}
		
		protected function readStyles():void
		{
			paddingTop = getStyle( "paddingTop" );
			paddingLeft = getStyle( "paddingLeft" );
			paddingRight = getStyle( "paddingRight" );
			paddingBottom = getStyle( "paddingBottom" );
			horizontalGap = getStyle( "horizontalGap" );
		}
		/**
		 * Called when item render is by itself not in a list
		 * */
		public function updateSize(autoSize : Boolean, maxSize : Number = NaN) : void
		{
			this.autoSize = autoSize
			this.maxHeightSize = maxSize; 
			
			this.updateDisplayList( this.parent.width, this.height ); 
		}
	}
}
