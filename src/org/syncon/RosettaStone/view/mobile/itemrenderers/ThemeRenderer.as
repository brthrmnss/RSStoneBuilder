package   org.syncon.RosettaStone.view.mobile.itemrenderers
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.TransformGestureEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.styles.CSSStyleDeclaration;
	
	import org.syncon.RosettaStone.model.NightStandConstants;
	import org.syncon.RosettaStone.utils.FilterHelpers;
	import org.syncon.RosettaStone.view.mobile.itemrenderers.utils.TextUtil;
	import org.syncon.RosettaStone.vo.ThemeVO;
	
	import spark.components.Group;
	import spark.components.RichEditableText;
	import spark.components.Scroller;
	import spark.core.SpriteVisualElement;
	import spark.primitives.BitmapImage;
	import spark.primitives.Graphic;
	
	public class ThemeRenderer extends BaseRenderer
	{
		//--------------------------------------------------------------------------
		//  Protected properties
		//--------------------------------------------------------------------------
		
		protected var txtTitle:TextField;
		protected var txtTitleShadow:TextField;
		
		protected var txtPoints:TextField;
		
		protected var background:DisplayObject;
		protected var backgroundClass:Class;
		protected var separator:DisplayObject;
		
		protected var avatar:BitmapImage;
		protected var avatarHolder:Graphic;
		
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
		private var backgroundColor:*;
		private var backgroundAlpha : Number; 
		
		
		public function ThemeRenderer()
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
			
			//setBackground();
			/*
			var separatorAsset:Class = getStyle( "separator" );
			if( separatorAsset )
			{
			separator = new separatorAsset();
			addChild( separator );
			}
			*/
			
			var css : CSSStyleDeclaration =this.styleManager.getStyleDeclaration('global')
			var fontSize : Number = css.getStyle('fontSize'); 
			
			
			this.txtPoints  = TextUtil.createSimpleTextField( getStyle( "txtPointsStyle" ) );
			addChild( this.txtPoints );
			
			
			this.useEmbeddedFont( txtPoints, fontSize  ); 
			
			this.txtTitle  = TextUtil.createSimpleTextField( getStyle( "txtTitleStyle" ) , false, "none" );
			this.useEmbeddedFont( this.txtTitle, Math.ceil(fontSize *1.25)  ); 
			
			this.txtTitleShadow  = TextUtil.createSimpleTextField( getStyle( "txtTitleStyle" ) , false, "none" );
			this.useEmbeddedFont( this.txtTitleShadow, Math.ceil(fontSize *1.25)  ); 
			var format : TextFormat = txtTitleShadow.defaultTextFormat ; 
			format.color = 0xd2d2d2
			this.txtTitleShadow.defaultTextFormat = format
			
			addChild( this.txtTitleShadow );
			//this.txtTitle.selectable = true; 
			//this.txtTitle.wordWrap = true;
			this.txtTitle.multiline = true;
			this.txtTitle.wordWrap = true; 
			this.txtTitle.height = 24*2+20
			addChild( this.txtTitle );
			
			this.txtTitleShadow.multiline = true;
			this.txtTitleShadow.wordWrap = true; 
			this.txtTitleShadow.height = 24*2+20
			
			avatarHolder = new Graphic();
			avatar = new BitmapImage();
			avatar.fillMode = "clip";
			avatar.fillMode = "scale";
			avatar.addEventListener(Event.COMPLETE, this.onLoaded, false, 0, true ) ; 
			/*avatarHolder.width = 48;
			avatarHolder.height = 48;*/
			avatarHolder.addElement( avatar );
			addChild( avatarHolder );
			
			var sp:SpriteVisualElement = new SpriteVisualElement();
			var g : Graphics = sp.graphics
			g.beginFill(0x00ff00,1);
			var radius  : Number  =  8
			g.drawRoundRectComplex(0,0,180,180, radius, radius, radius , radius ) ; 
			g.endFill();
			avatarHolder.mask = sp
			//addChild( ); 
			// if the data is not null, set the text
			if( data )
				setValues();
			
		}
		
		protected function onLoaded(event:Event):void
		{
			var t : BitmapImage = event.target as BitmapImage; 
			/*avatar.height = t.height; 
			avatar.width = t.width; */
			avatarHolder.width = t.bitmapData.width; 
			avatarHolder.height = t.bitmapData.height; 
			avatarHolder.setLayoutBoundsSize( t.bitmapData.width, t.bitmapData.height  )
			//FilterHelpers.addDropShadow( this.avatarHolder, 0xDDDDDD, 45, 3 ); 
			return; 
		}
		
		private function useEmbeddedFont(txt:TextField, fontSize:Number=NaN):void
		{
			var format : TextFormat = txt.defaultTextFormat; 
			format.font = "myFontFamily"  	
			if( isNaN(fontSize ) == false  ) 
				format.size  = fontSize
			txt.defaultTextFormat = format ; 
			txt.embedFonts=true
			
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
			//avatarHolder.setLayoutBoundsSize( avatarHolder.getPreferredBoundsWidth(), avatarHolder.getPreferredBoundsHeight() );
			
			this.txtTitle.x = paddingLeft
			this.txtTitle.y = this.paddingTop
			this.txtTitle.width = unscaledWidth - paddingLeft - paddingRight 
			
			this.txtTitle.x = 10//+10
			//this.txtTitle.y = this.paddingTop
			this.txtTitle.y = 200
			this.txtTitle.width = unscaledWidth - paddingLeft - paddingRight 
			
			this.txtTitleShadow.x =this.txtTitle.x +1-.5
			this.txtTitleShadow.y = this.txtTitle.y +1.-.5
			this.txtTitleShadow.width = this.txtTitle.width
			
			
			
			var ee : NightStandConstants
			if ( NightStandConstants.flex == false ) 
			{
				this.txtTitle.height = this.txtTitle.textHeight +5; 
			}
			this.txtPoints.x = paddingLeft
			this.txtPoints.y =  this.txtTitle.y + this.txtTitle.height+5
			
			layoutHeight =unscaledHeight;// this.txtPoints.y+this.txtPoints.textHeight+paddingBottom
			if ( separator != null ) 
			{
				separator.width = unscaledWidth;
				separator.y = layoutHeight - separator.height;
			}
			else
			{
				var isLastItem : Boolean = false; 
				var bottomSeparatorColor:uint=0xc2c2c2;
				var bottomSeparatorAlpha:Number=1;
				graphics.beginFill(bottomSeparatorColor, bottomSeparatorAlpha);
				graphics.drawRect(0, unscaledHeight - (isLastItem ? 0 : 1), unscaledWidth, 1);
				graphics.endFill();
				
			}
			if ( background != null ) 
			{
				background.width = unscaledWidth;
				background.height = layoutHeight;
			}
			else
			{
				var drawBackground : Boolean = true; 
				//var backgroundColor: uint = 0xFFFFFF
				//backgroundColor = 0xFF0000
				graphics.beginFill(backgroundColor, backgroundAlpha );
				graphics.lineStyle();
				graphics.drawRect(0, 0, unscaledWidth, layoutHeight);
				graphics.endFill();
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
		override protected function setValues():void
		{
			var d : ThemeVO = data as   ThemeVO; 
			if ( d == null )
			{
				return;
			}
			this.txtTitle.text = d.name
			this.txtTitleShadow.text = d.name
			//this.txtPoints.text = 'test'
			avatar.source = d.pic; 
		}
		
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
			backgroundColor = getStyle( "backgroundColor" );
			backgroundAlpha = getStyle( "backgroundAlpha" );
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