package  org.syncon.RosettaStone.view.mobile.alarm
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TransformGestureEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.view.mobile.itemrenderers.BaseRenderer;
	import org.syncon.RosettaStone.view.mobile.itemrenderers.utils.TextUtil;
	import org.syncon.RosettaStone.vo.AirVGroupVO;
	import org.syncon.RosettaStone.vo.MenuItemVO;
	
	import spark.components.CheckBox;
	
	public class MainMenuRenderer extends  BaseRenderer
	{
		//--------------------------------------------------------------------------
		//  Protected properties
		//--------------------------------------------------------------------------
		
		protected var txtName:TextField;
		protected var txtTime:TextField;
		protected var txtRepeat:TextField;		
		protected var cb :     CheckBox;  
		
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
		
		
		
		public function MainMenuRenderer()
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
			
			this.txtTime  = TextUtil.createSimpleTextField( getStyle( "txtMainMenuStyle" ) , false, "none" );
			this.arrange.oneline( this.txtTime )
			this.arrange.fontSize( this.txtTime, 24  )
			this.arrange.useEmbeddedFont( this.txtTime )
			this.baseColor =  uint(txtTime.defaultTextFormat.color ) 
			addChild( this.txtTime );
			
			this.fontSize = 64; 
			this.txtName  = TextUtil.createSimpleTextField( getStyle( "txtMainMenuStyle" ) , false, "none" );
			this.arrange.oneline( this.txtName )
			this.arrange.fontSize( this.txtName, this.fontSize   )
			this.arrange.useEmbeddedFont( this.txtName )
			var format  : TextFormat = this.txtName.defaultTextFormat; 
			format.letterSpacing  = -this.fontSize*.06
			this.txtName.defaultTextFormat = format; 
			
			addChild( this.txtName );
			
			this.txtRepeat  = TextUtil.createSimpleTextField( getStyle( "txtMainMenuStyle" ) , false, "none" );
			this.arrange.oneline( this.txtRepeat )
			this.arrange.fontSize( this.txtRepeat, 24  )
			this.arrange.useEmbeddedFont( this.txtRepeat )
			addChild( this.txtRepeat );			
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
		private function onChanged ( e : Event ) : void{
			this.data.enabled = this.cb.selected; 
			this.dispatchEvent( new CustomEvent( 'changeAlarm', this.data, true ) ) ; 
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
			if ( this.selected != this.lastDrawnSelection ) 
				this.lastDrawnSelection = this.selected; 
			//var graphics = this.graphics; 
			if ( this.selected  ) 
			{
				graphics.clear(); 
				graphics.beginFill(0xF06A0B, 1 );
				graphics.lineStyle();
				//graphics.drawRect(0, 10, this.layoutWidth, layoutHeight);
				graphics.drawRoundRectComplex(-10, 5, this.layoutWidth, layoutHeight-2, 9, 9, 9, 9);
				graphics.endFill();
				this.arrange.color( this.txtName, 0xFFFFFF ) 
				this.setValues();
			}
			else
			{
				if ( this.arrange != null )  
					this.arrange.color( this.txtName,  this.baseColor  ) 
				graphics.clear(); 
				this.setValues();
			}
			
		}
		
		//--------------------------------------------------------------------------
		public var arrange  : AirVGroupVO; 
		private var fontSize:Number;
		private var lastDrawnSelection:Boolean;
		private var baseColor: uint;
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			this.arrange.paddingAll( 0 ) ; 
			//this.arrange.setup( [ this.txtTime, this.txtRepeat ],70 , 10) ; 
			this.arrange.setup( [ this.txtName  ],0 , 0) ; 
			var h : Number = this.arrange.arrange(); 
			
			this.arrange.setWidthTo(  unscaledWidth, [ this.txtName, this.txtRepeat ] );
			
			//this.txtTitle.x = paddingLeft
			//this.txtTitle.y = paddingTop
			//this.txtTitle.width = unscaledWidth - paddingLeft - paddingRight 
			// this.arrange.right( this.txtName, unscaledWidth ) ; 
			
			layoutHeight =h//+50
			layoutHeight = this.fontSize; 
			//this.arrange.verticalCenter( this.cb, layoutHeight ) 
			this.arrange.verticalCenter( this.txtName, layoutHeight ) 
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
			var alarm :    MenuItemVO = data as MenuItemVO; 
			if ( alarm == null )
			{
				return;
			}
			this.txtName.text = alarm.name; 
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
