package skins {
	
	import spark.skins.mobile.ButtonSkin;

	public class BoomButtonSkin extends ButtonSkin {
		
		[Bindable]
		[Embed(source="../assets/images/btn-boom.png")]
		private var boomImage:Class;

		public function BoomButtonSkin() {
			super();
			width = 280;
			height = 64;
		}
		
		override protected function getBorderClassForCurrentState():Class {
			labelDisplay.setStyle("color", 0xFFFFFF);
			return boomImage;
		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void {
		}
	}
}