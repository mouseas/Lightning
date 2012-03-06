package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * Short generative art project simulating an electric discharge into a glass block.
	 * @author Martin Carney
	 */
	public class Main extends Sprite 
	{
		/**
		 * Height of the screen, as well as the bitmap.
		 */
		public static const DISP_WIDTH:uint = 800;
		
		/**
		 * Width of the screen.
		 */
		public static const DISP_HEIGHT:uint = 600;
		
		/**
		 * The bitmap displayed on screen.
		 */
		public var displayBitmap:Bitmap;
		
		/**
		 * The data for the displayed bitmap. The Electron class draws to this bitmap data.
		 */
		public var displayBMD:BitmapData;
		
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
			
			displayBMD = new BitmapData(DISP_WIDTH, DISP_HEIGHT, true, 0xff000000);
			displayBitmap = new Bitmap(displayBMD);
			Zorch.BMD = displayBMD;
			
			Zorch.exitPoint = new Point(Math.random() * DISP_WIDTH, Math.random() * DISP_HEIGHT);
			
			for (var i:int = 0; i < 5000; i++) {
				new Zorch(Math.random() * DISP_WIDTH, Math.random() * DISP_HEIGHT);
			}
			
			trace (Zorch.zorches.length);
			
			addChild(displayBitmap);
			//addChild(Electron.drawLayer);
			addEventListener(Event.ENTER_FRAME, updateHandler);
		}
		
		public function updateHandler(e:Event = null):void {
			Zorch.update();
		}
		
	}
	
}