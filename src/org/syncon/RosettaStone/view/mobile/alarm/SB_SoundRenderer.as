package org.syncon.RosettaStone.view.mobile.alarm
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TransformGestureEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	import org.syncon.RosettaStone.model.CustomEvent;
	import org.syncon.RosettaStone.view.mobile.itemrenderers.BaseRenderer;
	import org.syncon.RosettaStone.view.mobile.itemrenderers.utils.TextUtil;
	import org.syncon.RosettaStone.vo.AirVGroupVO;
	import org.syncon.RosettaStone.vo.AlarmVO;
	import org.syncon.RosettaStone.vo.SoundVO;
	
	import spark.components.CheckBox;
	import spark.components.Group;
	import spark.components.List;
	import spark.components.RichEditableText;
	import spark.components.Scroller;
	import spark.layouts.TileLayout;
	import spark.primitives.BitmapImage;
	import spark.primitives.Graphic;
	import flash.events.MouseEvent;
	
	public class SB_SoundRenderer extends  BaseRenderer
	{
		//--------------------------------------------------------------------------
		//  Protected properties
		//--------------------------------------------------------------------------
		
		protected var txtTitle:TextField;
		protected var txtMeasure:TextField;
		
		//protected var cb :  CheckBox; 
		
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
		
		private var backgroundColor:*;
		private var backgroundAlpha : Number; 
		//--------------------------------------------------------------------------
		//  Contructor
		//--------------------------------------------------------------------------
		
		public static var BTN_UP:String = 'Set as btn up'; 
		public static var BTN_DOWN:String = 'Set as btn down'; 
		
		public function SB_SoundRenderer()
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
			
			
			
			var separatorAsset:Class = getStyle( "separator" );
			if( separatorAsset )
			{
				separator = new separatorAsset();
				addChild( separator );
			}
			
			
			this.arrange =   new AirVGroupVO()
			this.arrange.paddingAll( 10 ) ;
			
			this.txtTitle  = TextUtil.createSimpleTextField( getStyle( "txtTitleStyle" ) , false, "none" );
			this.txtTitle.multiline = true;
			this.txtTitle.wordWrap = true; 
			this.arrange.useEmbeddedFont( this.txtTitle )
			var tf :  TextFormat = this.txtTitle.defaultTextFormat; 
			tf.align = 'center'
			this.txtTitle.autoSize =  TextFieldAutoSize.CENTER;
			this.txtTitle.defaultTextFormat = tf ; 
			addChild( this.txtTitle );
			
			this.txtMeasure  = TextUtil.createSimpleTextField( getStyle( "txtTitleStyle" ) , false, "none" );
			this.txtMeasure.multiline = true;
			this.txtMeasure.wordWrap = true; 
			this.arrange.useEmbeddedFont( this.txtMeasure )
			
			/*
			cb = new CheckBox();
			cb.width = 48
			cb.height = 48 
			addChild( cb );
			cb.addEventListener(Event.CHANGE, this.onChanged, false, 0, true) ; 
			*/
			this.addEventListener(MouseEvent.MOUSE_DOWN,  this.onBtnDown, false, 0, true ) ; 
			this.addEventListener(MouseEvent.MOUSE_UP,  this.onBtnUp, false, 0, true ) ; 
			
			// if the data is not null, set the text
			if( data )
				setValues();
			setBackground();
		}
		
		
		protected function onBtnUp(event:MouseEvent):void
		{
			this.dispatchEvent( new CustomEvent( BTN_UP, this.data )  ) ; 
		} 
		
		protected function onBtnDown(event:MouseEvent):void 
		{
			this.dispatchEvent( new CustomEvent( BTN_DOWN, this.data )  ) ; 
		}
		
		private function onChanged ( e : Event ) : void{
			//this.data.selected = this.cb.selected; 
		}
		protected function setBackground():void
		{
			if ( isNaN( this.layoutHeight ))
			return; 
			var list  : List = (this.parent.parent.parent.parent.parent as List)
			var tileLayout :  Object = list.layout
			var w : Number = tileLayout.columnWidth; 
			var h : Number = tileLayout.rowHeight; 
			if ( this.selected != this.lastDrawnSelection ) 
				this.lastDrawnSelection = this.selected; 
			//var graphics = this.graphics; 
			if ( this.selected  ) 
			{
				graphics.clear(); 
				/*graphics.beginFill(0xF06A0B, 1 );
				graphics.lineStyle();
				//graphics.drawRect(0, 10, this.layoutWidth, layoutHeight);
				graphics.drawRoundRectComplex(-10, 5, this.layoutWidth, layoutHeight-2, 9, 9, 9, 9);
				graphics.endFill();*/
				
				graphics.beginFill(backgroundColor, backgroundAlpha *.5);
				graphics.lineStyle(1, 0 ); 
				graphics.drawRect(0, 0,  w,h);
				graphics.endFill();
			}
			else
			{
				graphics.clear();
				graphics.beginFill(backgroundColor, backgroundAlpha*1 );
				graphics.lineStyle(1,backgroundColor,1)
				graphics.drawRect(0, 0, w,h);
				graphics.endFill();
			}
		}
		
		//--------------------------------------------------------------------------
		public var arrange  : AirVGroupVO; 
		private var lastDrawnSelection:Boolean;
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			
			this.txtTitle.x = paddingLeft
			this.txtTitle.y = paddingTop
			this.txtTitle.width = unscaledWidth - paddingLeft - paddingRight 
			
			//		this.arrange.left( this.cb, unscaledWidth ) ; 
			
			layoutHeight = this.txtTitle.y+this.txtTitle.textHeight+paddingBottom
			
			if ( separator != null ) 
			{
				separator.width = unscaledWidth;
				separator.y = layoutHeight - separator.height;
			}
			if ( background != null ) 
			{
				background.width = unscaledWidth;
				background.height = layoutHeight;
			}
			else
			{
				var list  : List = (this.parent.parent.parent.parent.parent as List)
				var tileLayout :  Object = list.layout
				var w : Number = tileLayout.columnWidth; 
				var h : Number = tileLayout.rowHeight; 
				backgroundColor = 0xeaeaea
				var drawBackground : Boolean = true; 
				//var backgroundColor: uint = 0xFFFFFF
				//backgroundColor = 0xFF0000
				graphics.beginFill(backgroundColor, backgroundAlpha );
				graphics.lineStyle();
				graphics.drawRect(0, 0, w, h);
				graphics.endFill();
			}
			this.height = layoutHeight; 
			//if ( unscaledHeight == 0 ) 
			//	this.updateDisplayList(0, layoutHeight ); 
			//this.arrange.drawHrLine( this.graphics,0xEAEAEA, 0, unscaledWidth, layoutHeight -1) 
		}
		
 
		override protected function setValues():void
		{
			var d :    SoundVO = data as SoundVO; 
			if ( d == null )
			{
				return;
			}
 
			
			this.txtTitle.text = d.name;
			
			var list  : List = (this.parent.parent.parent.parent.parent as List)
			var tileLayout :  Object = list.layout
			var w : Number = tileLayout.columnWidth; 
			var h : Number = tileLayout.rowHeight; 
			this.txtTitle.width = w-10
			/*if ( this.txtTitle.textWidth >w-40)
			{
			this.measuredWidth; this.layoutWidth
			//this.parent.parentDocument
			var tf : TextFormat = txtTitle.defaultTextFormat
			var newSize : Number =  Number(tf.size) *  (w-40)/txtTitle.textWidth
			newSize = Math.floor( newSize )  ;
			var minSize : Number = 10; 
			newSize = Math.max(newSize, minSize ) ;
			tf.size = newSize; 
			txtTitle.defaultTextFormat = tf; 
			}
			*/
			/*	
			this.txtMeasure.text = d.name; 
			
			var h : Number = tileLayout.rowHeight; 
			if ( this.txtMeasure.textHeight > h - 20 )
			{
			var tf : TextFormat = txtMeasure.defaultTextFormat
			var newSize : Number =  Number(tf.size) *  (h - 20 )/txtMeasure.textHeight
			newSize = Math.floor( newSize )  ;
			var minSize : Number = 10; 
			newSize = Math.max(newSize, minSize ) ;
			tf.size = newSize; 
			txtTitle.defaultTextFormat = tf; 
			txtTitle.text = this.txtTitle.text; 
			
			}
			*/
	 
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