package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
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
		 * The data for the displayed bitmap. The Electron class draws to this bitmap data.
		 */
		public var displayBMD:BitmapData;
		
		/**
		 * The bitmap used to display the bitmap data.
		 */
		public var displayBitmap:Bitmap;
		
		/**
		 * Drawing Layer. Used to draw all
		 */
		public var drawLayer:Sprite;
		
		/**
		 * Timer used for a full redraw, to save processing time + power.
		 */
		public var redrawTimer:uint;
		
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
			
			drawLayer = new Sprite();
			
			BrownianParticle.dispDrawLayer = drawLayer;
			new BrownianParticle(BrownianParticle.midpoint.x, BrownianParticle.midpoint.y, true);
			
			addChild(displayBitmap);
			addEventListener(Event.ENTER_FRAME, updateHandler);
		}
		
		public function updateHandler(e:Event = null):void {
			if (getTimer() - 1000 > redrawTimer) {
				redrawTimer = getTimer();
				BrownianParticle.cleanup();
			}
			//BrownianParticle.drawWalker(drawLayer);
			displayBMD.fillRect(new Rectangle(0, 0, DISP_WIDTH, DISP_HEIGHT), 0xff000000);
			displayBMD.draw(drawLayer);
			
			//Hand remaining time over to particle handler.
			BrownianParticle.frameHandler(e);
		}
		
		/**
		 * Generates a (large) string with the SVG (xml) data to reproduce a brownian tree in vector format. Useful for
		 * printing.
		 * @param	particles Array of particles to include. These should all be attached, and have a timestamp and color.
		 * @return String containing the relevant xml data.
		 */
		public function makeSVG(particles:Array):String {
			if (particles != null && particles.length > 0) {
				var xml:XML = <svg xmlns = "http://www.w3.org/2000/svg" version = "1.1" /> ;
				for each (var dot:BrownianParticle in particles) {
					xml.appendChild(dot.outputSVG());
				}
				return xml.toString();
			} else {
				return null;
			}
		}
	}
	
}