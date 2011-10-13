package org.syncon.RosettaStone.vo
{
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import spark.components.Label;
	import spark.core.SpriteVisualElement;
	import spark.primitives.BitmapImage;
	import spark.primitives.Graphic;
	
	public class AirVGroupVO 
	{
		
		public function setup(arr:Array, padLeft : Number=NaN, padTop : Number=NaN, gap : int = 5 ):void
		{
			this.items = arr; 
			this.gap = gap; 
			if ( ! isNaN( padLeft ) ) 
				this.paddingLeft = padLeft; 
			if ( ! isNaN( padLeft ) ) 
				this.paddingTop = padTop; 
		}
		
		public function paddingAll(pad : Number ) : void
		{
			this.paddingLeft = this.paddingRight = this.paddingTop= this.paddingBottm = pad; 
		}
		
		public function arrange(tempItems : Array = null ) : Number 
		{
			var y : Number = this.paddingTop
			var x : Number = this.paddingLeft; 
			var firstTime : Boolean = true; 
			var arrangeItems : Array = this.items; 
			if ( tempItems != null ) 
				arrangeItems = tempItems; 
			for each ( var o : Object in arrangeItems  ) 
			{
				if ( firstTime ) {
					firstTime = false;
					//continue; 
				}else
				{
					y+= this.gap
				}
				o.y = y ; 
				if ( o.hasOwnProperty('textHeight' ) )
					y += o.textHeight 
				else
					y += o.height; 
				
				o.x = x; 
				/*if (! isNaN( setWidth ) ) 
				o.width = setWidth
				*/
				
				
			}
			
			return y+this.paddingBottm
		}
		
		//change padding as necessary 
		public function setWidthTo( width: Number, items : Array ) : void 
		{
			for each ( var o : Object in this.items ) 
			{
				o.width = width-this.paddingLeft-this.paddingRight
			}
		}
		
		public var setWidth : Number
		public var items:Array;
		public var gap:int;
		public var paddingTop:Number=0;
		public var paddingLeft:Number=0;
		public var paddingRight : Number = 0 
		/*
		palce item on left 
		*/
		private var paddingBottm:Number=0;
		public function right( o : Object , unscaledWidth :Number ) : void
		{
			//o.setStyle('right', 10 ) 
			o.x = unscaledWidth -o.width - paddingRight
		}
		public function left( o : Object , unscaledWidth :Number ) : void
		{
			//o.setStyle('left', 10 ) 
			o.x = unscaledWidth -o.width - paddingRight
		}
		public function verticalCenter( o : Object , unscaledHeight :Number ) : void
		{
			if ( o is TextField ) 
				o.height = o.textHeight; 
			o.y = unscaledHeight/2 -o.height/2 
		} 
		
		public function useEmbeddedFont(txt:TextField, fontSize:Number=NaN):void
		{
			var format : TextFormat = txt.defaultTextFormat; 
			format.font = "myFontFamily2" 	
			if( isNaN(fontSize ) == false ) 
				format.size = fontSize
			txt.defaultTextFormat = format ; 
			txt.embedFonts=true
		}
		
		public function fontSize(txt:TextField, fontSize:Number ):void
		{
			var format : TextFormat = txt.defaultTextFormat; 
			if( isNaN(fontSize ) == false ) 
				format.size = fontSize
			txt.defaultTextFormat = format ; 
		}
		
		public function color(txt:TextField, color:uint ):void
		{
			var format : TextFormat = txt.defaultTextFormat; 
				format.color = color
			txt.defaultTextFormat = format ; 
		}
		
		public function getFontSize(txt:TextField ):Number
		{
			var format : TextFormat = txt.defaultTextFormat; 
			return	Number(format.size);
		}
		
		
		
		public function oneline(txt:TextField ):void
		{
			txt.multiline = false;
			txt.wordWrap = false; 
		}
		
		
		//graphcis ... we assumem there is only 1 image ... 
		//add image s
		public function newGraphic(renderer : Object ):Graphic
		{
			var g : Graphic = new Graphic()
			renderer.addChild(g);
			return g ; 
		}
		
		
		
		public function setSource(avatarHolder_ : Graphic, avatar :  BitmapImage, w : Number, h : Number, addEventListner : Boolean = false , source : Object = null):BitmapImage
		{
			var avatar:BitmapImage = new BitmapImage();
			avatar.fillMode = "clip";
			avatar.fillMode = "scale";
			if ( addEventListner ) 
			{
				this.avatarHolder = avatarHolder_; 
				avatar.addEventListener(Event.COMPLETE, this.onLoaded, false, 0, true ) ; 
			}
			avatarHolder_.width = w
			avatarHolder_.height = h 
			avatarHolder_.addElement( avatar );
			if ( source != null ) 
				avatar.source = source; 
			return avatar; 
			//addChild( avatarHolder )
		}
		
		public function newBitmap(avatarHolder_ : Graphic,w : Number, h : Number, addEventListner : Boolean = false , source :String = null):BitmapImage
		{
			var avatar:BitmapImage = new BitmapImage();
			avatar.fillMode = "clip";
			avatar.fillMode = "scale";
			if ( addEventListner ) 
			{
				this.avatarHolder = avatarHolder_; 
				avatar.addEventListener(Event.COMPLETE, this.onLoaded, false, 0, true ) ; 
			}
			avatarHolder_.width = w
			avatarHolder_.height = h 
			avatarHolder_.addElement( avatar );
			if ( source != null ) 
				avatar.source = source; 
			return avatar; 
			//addChild( avatarHolder )
		}
		protected function onLoaded(event:Event):void
		{
			var t : BitmapImage = event.target as BitmapImage; 
			/*avatar.height = t.height; 
			avatar.width = t.width; */
			avatarHolder.width = t.bitmapData.width; 
			avatarHolder.height = t.bitmapData.height; 
			avatarHolder.setLayoutBoundsSize( t.bitmapData.width, t.bitmapData.height )
			//FilterHelpers.addDropShadow( this.avatarHolder, 0xDDDDDD, 45, 3 ); 
			return; 
		}		
		//protected var avatar:BitmapImage;
		protected var avatarHolder:Graphic;
		
		public function addMask(w:Number, h : Number, radius : Number, avatarHolder : Graphic):void
		{
			var sp:SpriteVisualElement = new SpriteVisualElement();
			var g : Graphics = sp.graphics
			g.beginFill(0x00ff00,1);
			g.drawRoundRectComplex(0,0,w,h, radius, radius, radius , radius ) ; 
			g.endFill();
			avatarHolder.mask = sp
		}	

		
		public function drawHrLite(g : Graphics, x : Number, w : Number,  y : Number ):void
		{
			//g.beginFill(0xFF, 1 );
			g.lineStyle(1,0xD0D0D0 ) 
			g.moveTo( x, y )
			g.lineTo( x+w, y ) ; 
			g.lineStyle(1,0xEAEAEA  ) 
			g.moveTo( x, y+1 )
			g.lineTo( x+w, y+1 ) ; 
			
			//g.endFill();
		}	
		
		public function drawHrLine(g : Graphics, color : uint,  x : Number, w : Number,  y : Number ):void
		{
			g.lineStyle(1,color ) 
			g.moveTo( x, y )
			g.lineTo( x+w, y ) ; 
		}			
		
		public static function em(txtTitle:Label, ems:Number):void
		{
			var fontSize : Number = Number( txtTitle.getStyle('fontSize' ) )
			fontSize *= ems 
			txtTitle.setStyle('fontSize', fontSize ) ; 
				
		}
	}
}