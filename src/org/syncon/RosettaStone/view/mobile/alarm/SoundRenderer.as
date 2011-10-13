package  org.syncon.RosettaStone.view.mobile.alarm
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.view.mobile.itemrenderers.BaseRenderer;
	import org.syncon.RosettaStone.view.mobile.itemrenderers.utils.TextUtil;
	import org.syncon.RosettaStone.vo.AirVGroupVO;
	import org.syncon.RosettaStone.vo.SampleVO;
	
	import spark.components.CheckBox;
	import spark.components.Group;
	import spark.components.RadioButton;
	import spark.components.RadioButtonGroup;
	import spark.components.RichEditableText;
	import spark.components.Scroller;
	import spark.formatters.DateTimeFormatter;
	import spark.primitives.BitmapImage;
	import spark.primitives.Graphic;
	
	public class SoundRenderer extends  BaseRenderer
	{
		//--------------------------------------------------------------------------
		//  Protected properties
		//--------------------------------------------------------------------------
		
		protected var txtName:TextField;
		protected var txtDesc:TextField;
		//protected var txtRepeat:TextField;		
		//protected var cb :     CheckBox;  
		
		protected var avatar:BitmapImage;
		protected var avatarHolder:Graphic;
		
		protected var picPlayBtn:BitmapImage;
		protected var holderPlayBtn:Graphic;		
		
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
		
		
		public function SoundRenderer()
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
			
			
			this.fontSize = 24; 
			this.txtName  = TextUtil.createSimpleTextField( getStyle( "txtNameStyle" ) , false, "none" );
			this.arrange.oneline( this.txtName )
			this.arrange.fontSize( this.txtName, this.fontSize   )
			this.arrange.useEmbeddedFont( this.txtName )
			var format  : TextFormat = this.txtName.defaultTextFormat; 
			format.letterSpacing  = -this.fontSize*.06
			this.txtName.defaultTextFormat = format; 
			addChild( this.txtName );
			
			
			this.txtDesc  = TextUtil.createSimpleTextField( getStyle( "txtNameStyle" ) , false, "none" );
			this.arrange.oneline( this.txtDesc )
			this.arrange.fontSize( this.txtDesc, this.arrange.getFontSize(this.txtName)*.6  )
			this.arrange.useEmbeddedFont( this.txtDesc )
			addChild( this.txtDesc );
			/*
			this.avatarHolder = this.arrange.newGraphic(this); 
			this.avatar = this.arrange.newBitmap(this.avatarHolder, 100, 100, false,'assets/images/'+'christophe_coenraets_bio.jpg.adimg.mw.160.png'  )
			
			*/
				
			this.holderBtnRec = this.arrange.newGraphic(this); 
			this.picBtnRec = this.arrange.newBitmap(this.holderBtnRec, 64, 64, false,'assets/buttons/'+'Recorder-green-64.png'  )
			//this.arrange.addBtnClickHandler(); 
			this.holderBtnRec.buttonMode = true; 
			this.holderBtnRec.useHandCursor  = true; 
			this.holderBtnRec.addEventListener(MouseEvent.CLICK, this.onClickRec, false, 0, true ) ;		
				
			this.holderPlayBtn = this.arrange.newGraphic(this); 
			this.picPlayBtn = this.arrange.newBitmap(this.holderPlayBtn, 64, 64, false,'assets/buttons/'+'Play-Disabled-icon.png'  )
			
			this.holderPlayBtn.buttonMode = true; 
			this.holderPlayBtn.useHandCursor  = true; 
			this.holderPlayBtn.addEventListener(MouseEvent.CLICK, this.onClickPlay, false, 0, true ) ; 
			/*
			this.txtRepeat  = TextUtil.createSimpleTextField( getStyle( "txtNameStyle" ) , false, "none" );
			this.arrange.oneline( this.txtRepeat )
			this.arrange.fontSize( this.txtRepeat, 24  )
			this.arrange.useEmbeddedFont( this.txtRepeat )
			addChild( this.txtRepeat );		*/	
			/* 
			cb = new CheckBox  ();
			cb.width = 48
			cb.height = 48 
			addChild( cb );
			cb.addEventListener(Event.CHANGE, this.onChanged, false, 0, true) ; 
			*/
			
			// if the data is not null, set the text
			if( data )
				setValues();
			
		}
		private function onClickRec ( e : Event ) : void{
			//this.data.enabled = this.cb.selected; 
			this.dispatchEvent( new CustomEvent( SoundRenderer.REC_SOUND, this.data, true ) ) ; 
		}
		private function onClickPlay ( e : Event ) : void{
			//this.data.enabled = this.cb.selected; 
			this.dispatchEvent( new CustomEvent(  SoundRenderer.PLAY_SOUND , this.data, true ) ) ; 
		}		
		/*private function onChanged ( e : Event ) : void{
		this.data.enabled = this.cb.selected; 
		this.dispatchEvent( new CustomEvent( 'changeAlarm', this.data, true ) ) ; 
		}*/
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
		private var fontSize:Number;
		private var holderBtnRec:Graphic;
		private var picBtnRec:BitmapImage;
		public static var PLAY_SOUND:String='playSound';
		public static var REC_SOUND:String='recSound';		
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			this.arrange.paddingAll(10 ) ; 
			//this.arrange.setup( [ this.txtTime, this.txtRepeat ],70 , 10) ; 
			this.arrange.setup( [ this.txtName, txtDesc  ] )//,120 , 10) ; 
			var h : Number = this.arrange.arrange(); 
			
			this.arrange.setWidthTo(  unscaledWidth, [ this.txtName, this.txtDesc ] );
			
			//this.arrange.setup( [ this.avatarHolder   ] ) ; 
			this.arrange.paddingAll(10 ) ; 
			//this.arrange.arrange( [ this.avatarHolder   ]); 
			
			
			//this.txtTitle.x = paddingLeft
			//this.txtTitle.y = paddingTop
			//this.txtTitle.width = unscaledWidth - paddingLeft - paddingRight 
			// this.arrange.right( this.txtName, unscaledWidth ) ; 
			
			layoutHeight =h//+50
			//layoutHeight = this.fontSize; 
		//	layoutHeight  = 120
			
			this.arrange.right(  this.holderPlayBtn  ,unscaledWidth); 
			this.holderBtnRec.x = unscaledWidth - 10 - 64-10-64
				
			this.arrange.verticalCenter( this.holderPlayBtn, layoutHeight ) 
			this.arrange.verticalCenter( this.holderBtnRec, layoutHeight ) 
			//this.arrange.verticalCenter( this.cb, layoutHeight ) 
			//this.arrange.verticalCenter( this.txtName, layoutHeight ) 
			//this.arrange.leftt( this.cb ); //set padding  
			if ( separator != null ) 
			{
				separator.width = unscaledWidth;
				separator.y = layoutHeight - separator.height;
			}
			/*
			graphics.beginFill(0xFF, 1 );
			graphics.lineStyle();
			graphics.drawRect(0, 0, unscaledWidth, layoutHeight);
			graphics.endFill();
			*/
			this.arrange.drawHrLite( this.graphics,10, unscaledWidth-20,  this.layoutHeight ) ; 
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
			var alarm :    SampleVO = data as  SampleVO; 
			if ( alarm == null )
			{
				return;
			}
			this.txtName.text = alarm.name; 
			this.txtDesc.text = ' blb asdfa  ' 
			
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
