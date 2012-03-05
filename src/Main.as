package 
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * Short generative art project simulating an electric discharge into a glass block.
	 * @author Martin Carney
	 */
	public class Main extends Sprite 
	{
		
		/**
		 * The bitmap data the lightning burst will be drawn on.
		 */
		public var displayBMD:BitmapData;
		
		/**
		 * The bitmap used to display the bitmap data.
		 */
		public var displayBitmap:Bitmap;
		
		/**
		 * The sprite each line will be added to, and the bitmap data will be drawn from.
		 */
		public var drawLayer:Sprite;
		
		public static const DISP_WIDTH:uint = 800;
		public static const DISP_HEIGHT:uint = 600;
		
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// Create the various objects...
			displayBMD = new BitmapData(DISP_WIDTH, DISP_HEIGHT, true, 0xff000000);
			displayBitmap = new Bitmap(displayBMD);
			drawLayer = new Sprite();
			
			for (var i:int = 0; i < 100; i++) {
				new Electron (300 + Math.random() * 5, 300 + Math.random() * 5);
			}
			addChild(displayBitmap);
			addEventListener(Event.ENTER_FRAME, update);
			
		}
		
		private function drawToBitmapData(event:Event = null):void {
			// Draw the drawLayer's contents to the bitmap.
			displayBMD.draw(Electron.drawLayer);
			// Then clear the drawLayer.
			Electron.drawLayer.graphics.clear();
		}
		
		private function update(e:Event):void {
			Electron.update();
			var elec:Electron = Electron.electrons[0];
			//trace ("Force:" + elec.force + " Pos:" + elec.position + " Vel:" + elec.velocity)
			drawToBitmapData();
		}
		
	}
	
}