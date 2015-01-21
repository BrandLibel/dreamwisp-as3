package dreamwisp.ui 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * SpeechBubble with basic Sprite vector graphics that are code-generated.
	 * The bubble graphic changes size depending on the amount of text.
	 * @author Brandon
	 */
	public class SpeechBubbleFit extends SpeechBubble 
	{
		private var sprite:Sprite;
		private var yOffset:Number;
		private var padding:Number;
		
		/**
		 * 
		 * @param	textField 
		 * @param	maxWidth maximum allowed width of the text field
		 * @param	yOffset vertical distance of bottom from starting position
		 * @param	padding pixels between the text and the border
		 * @param	typeSpeed
		 */
		public function SpeechBubbleFit(textField:TextField, maxWidth:Number, yOffset:Number, padding:Number, typeSpeed:uint=0) 
		{
			super(null, 0); // this super call gets ignored since init() is overrided and empty
			sprite = new Sprite();
			sprite.addChild(textField);
			super.graphic = sprite;
			
			this.yOffset = yOffset;
			this.padding = padding;
			
			textField.x = padding / 2;
			textField.y = padding / 2;
			textField.width = maxWidth;
			textField.wordWrap = true;
			textField.multiline = true;
			textField.selectable = false;
			
			dialogueTextField = textField;
			dialogueWriter = new TypeWriter(dialogueTextField, typeSpeed);
		}
		
		override protected function init(graphic:DisplayObjectContainer, typeSpeed:uint = 1):void 
		{
			// intentionally left  blank
		}
		
		override public function render(interpolation:Number):void 
		{
			super.render(interpolation);
			sprite.graphics.clear();
			sprite.graphics.lineStyle(lineThickness, lineColor, lineAlpha);
			sprite.graphics.beginFill(fillColor, fillAlpha);
			sprite.graphics.drawRect(0, 0, dialogueTextField.textWidth + padding, dialogueTextField.textHeight + padding * 2);
			sprite.graphics.endFill();
			
			dialogueTextField.height = dialogueTextField.textHeight + dialogueTextField.getTextFormat().size;
			
			if (yOffset == 0) return;
			var bottomEdge:Number = y - yOffset;
			sprite.y = bottomEdge - dialogueTextField.textHeight;
		}
		
		private var fillColor:uint = 0xFFFFFF;
		private var fillAlpha:Number = 1;
		private var lineThickness:Number = 1;
		private var lineColor:uint = 0;
		private var lineAlpha:Number = 1;
		
		public function setStyle(fillColor:uint = 0xFFFFFF, fillAlpha:Number = 1, lineThickness:Number = 1, lineColor:uint = 0, lineAlpha:Number = 1):void 
		{
			this.fillColor = fillColor;
			this.fillAlpha = fillAlpha;
			this.lineThickness = lineThickness;
			this.lineColor = lineColor;
			this.lineAlpha = lineAlpha;
		}
		
	}

}