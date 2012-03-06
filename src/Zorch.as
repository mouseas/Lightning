package {
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class Zorch {
		
		public var position:Point;
		
		public var prevPosition:Point;
		
		public var lineWidth:Number;
		
		public var strength:Number;
		
		public var dead:Boolean;
		
		public static var index:uint = 0;
		
		public static var zorches:Array = new Array();
		
		public static var exitPoint:Point;
		
		public static var drawLayer:Sprite = new Sprite();
		
		/**
		 * The bitmap data to draw to.
		 */
		public static var BMD:BitmapData;
		
		public static const LINE_WIDTH:Number = 1.0;
		
		public static const LINE_ALPHA:Number = 0.2;
		
		public static const LINE_COLOR:uint = 0xFFFFFFFF;
		
		public function Zorch(x:Number, y:Number) {
			position = new Point(x, y);
			prevPosition = new Point (0, 0);
			
			lineWidth = LINE_WIDTH;
			strength = Math.pow(LINE_WIDTH * 10, 2);
			
			dead = false;
			
			zorches.push(this);
		}
		
		public static function update():void {
			for (var i:uint = 0; i < 100; i++) {
				var z:Zorch = zorches[index];
				if (z != null && !z.dead) {
					var closest:Zorch;
					var closeDist:Number = Math.sqrt((Main.DISP_WIDTH * Main.DISP_WIDTH) + (Main.DISP_HEIGHT * Main.DISP_HEIGHT));
					var secondClosest:Zorch;
					var secCloseDist:Number = closeDist;
					for each (var otherZ:Zorch in zorches) {
						if (!otherZ.dead && otherZ != z) {
							var distance:Number = MathE.distance(z.position, otherZ.position);
							if (distance < closeDist) {
								closest = otherZ;
								closeDist = distance;
							} else if (distance < secCloseDist) {
								secondClosest = otherZ;
								secCloseDist = distance;
							}
						}
					}
					//trace(closest);
					if (closest != null && secondClosest != null) {
						if (Math.random() > 0.5) {
							mergeThree(z, closest, secondClosest);
						} else {
							mergeTwo(z, closest);
						}
					} else if (closest != null && secondClosest == null) {
						mergeTwo(z, closest);
					}
				}
				index++;
				if (index >= zorches.length) {
					index = 0;
					var newArray:Array = new Array();
					for each (z in zorches) {
						if (!z.dead) {
							newArray.push(z);
						}
					}
					zorches = newArray;
				}
			}
			BMD.draw(drawLayer);
			drawLayer.graphics.clear();
		}
		
		private static function mergeThree(z1:Zorch, z2:Zorch, z3:Zorch):void {
			// Calculate the electrons' merged values
			var newX:Number = (z1.position.x + z2.position.x + z3.position.x) / 3;
			var newY:Number = (z1.position.y + z2.position.y + z3.position.y) / 3;
			var newStr:Number = z1.strength + z2.strength + z3.strength;
			var newWidth:Number = Math.sqrt(newStr) / 10;
			if (newWidth > 1.5) { newWidth = 1.5; }
			// Draw lines from their positions to the merged position.
			z1.LineTo(newX, newY);
			z2.LineTo(newX, newY);
			z3.LineTo(newX, newY);
			// Kill all but the first Zorch
			z2.dead = true;
			z3.dead = true;
			// Assign the merged values to the first Zorch.
			z1.position.x = newX;
			z1.position.y = newY;
			z1.strength = newStr;
			z1.lineWidth = newWidth;
			// Pull the merge point towards the exit point.
			z1.pullTowardsExit();
		}
		
		private static function mergeTwo(z1:Zorch, z2:Zorch):void {
			// Calculate the electrons' merged values
			var newX:Number = (z1.position.x * 2 + z2.position.x * 2 ) / 4;
			var newY:Number = (z1.position.y * 2 + z2.position.y * 2 ) / 4;
			var newStr:Number = z1.strength + z2.strength;
			var newWidth:Number = Math.sqrt(newStr) / 10;
			if (newWidth > 1.5) { newWidth = 1.5; }
			// Draw lines from their position to the merged electrons' position.
			z1.LineTo(newX, newY);
			z2.LineTo(newX, newY);
			// kill the second electron, and assign the new values to the new electron.
			z2.dead = true;
			z1.position.x = newX;
			z1.position.y = newY;
			z1.strength = newStr;
			z1.lineWidth = newWidth;
			// Pull the merge point towards the exit point.
			z1.pullTowardsExit();
		}
		
		private function LineTo(x:Number, y:Number):void {
			drawLayer.graphics.moveTo(position.x, position.y);
			drawLayer.graphics.lineStyle(lineWidth, LINE_COLOR, LINE_ALPHA);
			drawLayer.graphics.lineTo(x, y);
		}
		
		private function pullTowardsExit():void {
			var distance:Number = MathE.distance(position, exitPoint);
			var angle:Number = MathE.angleBetweenPoints(position, exitPoint);
			angle += Math.random() * 0.3 - 0.15;
			/**var f:Number = ((strength * 1000) / (distance * distance));
			if (f > distance) {
				f = distance;
			}*/
			var f:Number = Math.min(distance, Math.random() * 30);
			var force:Point = new Point(Math.cos(angle) * f, Math.sin(angle) * f);
			LineTo(position.x + force.x, position.y + force.y);
			position.x += force.x;
			position.y += force.y;
		}
		
	}
	
}