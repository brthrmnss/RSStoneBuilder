package    org.syncon.RosettaStone.view.mobile.itemrenderers
{
	import flash.display.DisplayObject;
	import flash.events.TransformGestureEvent;
	import flash.text.TextField;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	import spark.components.Group;
	import spark.components.RichEditableText;
	import spark.components.Scroller;
	import spark.primitives.BitmapImage;
	import spark.primitives.Graphic;
	
	import org.syncon.RosettaStone.view.mobile.itemrenderers.utils.TextUtil;
	
	public class NewsRenderer extends BaseRenderer
	{
		//--------------------------------------------------------------------------
		//  Protected properties
		//--------------------------------------------------------------------------
		
		protected var txtUsername:TextField;
		protected var txtTitle:TextField;
		protected var txtPoints:TextField;
		protected var txtUrl:TextField;
		protected var txtTimeAgo:TextField;
		
		protected var avatar:BitmapImage;
		protected var avatarHolder:Graphic;
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
		private var txtScroller:  Scroller ;
		//--------------------------------------------------------------------------
		//  Contructor
		//--------------------------------------------------------------------------
		
		
		
		public function NewsRenderer()
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
			this.txtUsername  = TextUtil.createSimpleTextField( getStyle( "txtUsernameStyle" ) );
			addChild( this.txtUsername );
			this.txtPoints  = TextUtil.createSimpleTextField( getStyle( "txtPointsStyle" ) );
			addChild( this.txtPoints );
			this.txtUrl  = TextUtil.createSimpleTextField( getStyle( "txtUrlStyle" ),false, 'right' ) 
			addChild( this.txtUrl );
			this.txtTimeAgo  = TextUtil.createSimpleTextField( getStyle( "txtTimeAgoStyle" ),false, 'right' );
			addChild( this.txtTimeAgo );
			
			this.txtTitle  = TextUtil.createSimpleTextField( getStyle( "txtTitleStyle" ) , false, "none" );
			//this.txtTitle.selectable = true; 
			//this.txtTitle.wordWrap = true;
			this.txtTitle.multiline = true;
			this.txtTitle.wordWrap = true; 
			this.txtTitle.height = 24*2+20
			addChild( this.txtTitle );
			
			avatarHolder = new Graphic();
			avatar = new BitmapImage();
			avatar.fillMode = "clip";
			avatarHolder.width = 48;
			avatarHolder.height = 48;
			avatarHolder.addElement( avatar );
			addChild( avatarHolder );
			
			// if the data is not null, set the text
			if( data )
				setValues();
			
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
		
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			avatarHolder.x = paddingLeft;
			avatarHolder.y = paddingTop;
			avatarHolder.setLayoutBoundsSize( avatarHolder.getPreferredBoundsWidth(), avatarHolder.getPreferredBoundsHeight() );
			
			
			this.txtUsername.x = paddingLeft
			this.txtUsername.y = paddingTop;
			
			this.txtTitle.x = paddingLeft
			this.txtTitle.y = this.txtUsername.y + this.txtUsername.textHeight+5
			this.txtTitle.width = unscaledWidth - paddingLeft - paddingRight 
			
			if ( this.autoSize ) 
			{
				/*
				this.txtTitle.height = this.txtTitle.textHeight +5; 
				//this.txtContents.au
				if ( this.txtTitle.height > this.maxHeightSize )
				this.txtTitle.height = this.maxHeightSize; 
				*/
				/*if ( txtScroller == null ) 
				{
				txtScroller = new Scroller()
				txtScroller.y = this.txtTitle.y; 
				txtScroller.percentWidth = 100; 
				var g : Group = new Group()
				g.addElement( txtScroller ) 
				txtScroller.viewport =  new RichEditableText(); 
				//txtScroller.addElement( ui);// as IVisualElement ) ; 
				this.addChild( txtScroller) 
				}
				*/
				/*var ee  : TransformGestureEvent
				txtTitle.addEventListener(TransformGestureEvent.GESTURE_SWIPE,swipeHandler);
				this.addEventListener(TransformGestureEvent.GESTURE_SWIPE,swipeHandler);*/
				this.txtTitle.height = this.txtTitle.textHeight +5; 
				var parentGroup : Group = this.parent as Group
				parentGroup.maxHeight = this.maxHeightSize; 
			/*	txtTitle.height = this.txtTitle.height */
			/*	//this.txtContents.au
				if ( this.txtTitle.height > this.maxHeightSize )
					txtTitle.height = this.maxHeightSize; */
			}
			
			this.txtPoints.x = paddingLeft
			this.txtPoints.y =  this.txtTitle.y + this.txtTitle.height+5
			
			this.txtTimeAgo.x = paddingLeft
			this.txtTimeAgo.width = unscaledWidth - paddingLeft - paddingRight 
			this.txtTimeAgo.y =  paddingTop;				
			
			this.txtUrl.x = paddingLeft
			this.txtUrl.width =   unscaledWidth - paddingLeft - paddingRight 
			this.txtUrl.y =  this.txtPoints.y ;					
			
			/*nameField.x = this.txtUsername.x + userField.textWidth + horizontalGap;
			nameField.y = paddingTop + ( userField.textHeight - nameField.textHeight ) / 2;
			
			contentField.x = avatarHolder.x + avatarHolder.width + horizontalGap;
			contentField.y = paddingTop + userField.textHeight + verticalGap;
			contentField.width = unscaledWidth - paddingLeft - paddingRight - avatarHolder.getLayoutBoundsWidth() - horizontalGap;
			
			*/
			//layoutHeight = Math.max( contentField.y + paddingBottom + contentField.textHeight, avatarHolder.height + paddingBottom + paddingTop );
			layoutHeight = this.txtUrl.y+this.txtUrl.textHeight+paddingBottom
			if ( this.autoSize ) 
			{
				layoutHeight = this.txtPoints.y+this.txtPoints.textHeight+paddingBottom
				this.height = layoutHeight; 
				//update replies arrow ... 
				//this.setValues(); 
			}		
			//background.width = unscaledWidth;
			//background.height = layoutHeight;
			
			separator.width = unscaledWidth;
			separator.y = layoutHeight - separator.height;
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
		override protected function setValues():void
		{
			var d : NewsItem = data as NewsItem; 
			if ( d == null )
			{
				return;
			}
			/*	var arr:Array = String( data.author.name ).split("(");
			var user:String = String( data.author.name )*/
			if ( d.postedBy == null ) {
				trace('what'); 
				d.postedBy = ''; 
			}
			if ( d.postedAgo == null ) {
				trace('what'); 
				d.postedAgo = ''; 
			}			
			this.txtUsername.text = d.postedBy//arr[0];
			this.txtTitle.text = d.title /*+ '//domainOnly = /([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}/i//new RegExp("([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}", "g" ); ' + 
				  'sdf df //domainOnly = /([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}/i//new RegExp("([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}", "g" ); ' + 
				  'sdf df //domainOnly = /([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}/i//new RegExp("([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}", "g" ); ' + 
				  'sdf df //domainOnly = /([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}/i//new RegExp("([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}", "g" ); ' + 
				  
				  'sdf dddd//domainOnly = /([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}/i//new RegExp("([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}", "g" ); '
				*/
				// String( arr[ 1 ] ).replace( ")", "" );
			//contentField.htmlText;// = data.content.value;
			this.txtPoints.text = d.points + ' points'  + ' - ' + d.commentCount + ' comments '    ; 
			url =  d.url.replace('http://', '' ).slice(0, 16 ); 
			url = stripExtraneousUrlInformation( url ) ; 
			this.txtUrl.text =url
			//^(http://|https://)[A-Za-z0-9.-]+(?!.*\|\w*$)
			
			//http://gskinner.com/RegExr/
			
			//var domainOnly:RegExp =new RegExp("http(s?)://([\w]+\.){1}([\w]+\.?)+", "gi" ); 
			//	2	trace("directories = ", url.match(directoriesPattern));/
			///http(s?):\/\/([\w]+\.){1}([\w]+\.?)+/
			
			//domainOnly = /([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}/i//new RegExp("([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}", "g" ); 
			//var eee : String = domainOnly.exec( d.url ) ; 
			if ( domainOnly == null ) 
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