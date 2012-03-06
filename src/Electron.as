package {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Electron {
		
		/**
		 * Position of the Electron at the current cycle.
		 */
		public var position:Point;
		
		/**
		 * Position of the Electron at the previous cycle.
		 */
		public var prevPosition:Point;
		
		/**
		 * Velocity of the Electron at the current cycle.
		 */
		public var velocity:Point;
		
		/**
		 * The force applied to the Electron during this cycle.
		 */
		public var force:Point;
		
		/**
		 * How much this Electron pushes or pulls other Electrons. 
		 */
		public var strength:Number = 1;
		
		/**
		 * Width of lines traced by this electron.
		 */
		public var lineWidth:Number;
		
		/**
		 * Alpha of lines traced by this electron.
		 */
		public var lineAlpha:Number;
		
		/**
		 * Color of lines traced by this electron.
		 */
		public var lineColor:uint;
		
		/**
		 * Boolean used to skip electrons that have been merged or left the screen.
		 */
		public var dead:Boolean;
		
		/**
		 * How much "time" passes between cycles. Used to help calculate velocity change and position change.
		 */
		public static var timeInterval:Number = 0.1;
		
		/**
		 * How many cycles to run in total.
		 */
		public static var numCycles:uint = 200;
		
		/**
		 * Which cycle processing is currently on.
		 */
		public static var currentCycle:uint = 0;
		
		/**
		 * Static array of all Electrons.
		 */
		public static var electrons:Array;
		
		/**
		 * The bitmap data to draw to.
		 */
		public static var BMD:BitmapData;
		
		/**
		 * The sprite object to add lines to. At the end of each cycle this is drawn to BMD.
		 */
		public static var drawLayer:Sprite;
		
		/**
		 * Standard width of a line.
		 */
		public static const LINE_WIDTH:Number = 1.0;
		
		/**
		 * Standard transparency of a line.
		 */
		public static const LINE_ALPHA:Number = 0.2;
		
		/**
		 * Standard color of a line.
		 */
		public static const LINE_COLOR:uint = 0xffffff;
		
		/**
		 * The standard color to use for lines.
		 */
		public static var lineColor:uint = 0xffffff;
		
		/**
		 * The standard width of each line.
		 */
		public static var lineWidth:Number = 1;
		
		/**
		 * The standard alpha of each line.
		 */
		public static var lineAlpha:Number = 0.2;
		
		/**
		 * Constructor function.
		 * @param	_x X position of the new Electron.
		 * @param	_y Y position of the new Electron.
		 */
		public function Electron(_x:Number, _y:Number):void {
			if (electrons == null) { electrons = new Array(); }
			if (drawLayer == null) { drawLayer = new Sprite(); }
			position = new Point(_x, _y);
			prevPosition = new Point(0, 0);
			velocity = new Point(0, 0);
			force = new Point(0, 0);
			
			dead = false;
			
			strength = 10;
			lineWidth = LINE_WIDTH;
			lineAlpha = LINE_ALPHA;
			lineColor = LINE_COLOR;
			
			electrons.push(this);
		}
		
		/**
		 * Each update cycle, calculate each point's force, then update velocity, then update position, then draw.
		 */
		public static function update(event:Event = null):void {
			if (electrons != null) {
				
				drawLayer.graphics.clear();
				
				for each (var e:Electron in electrons) {
					if (!e.dead) {
						e.updateForce();
						e.updateVelocity();
					}
				}
				for each (e in electrons) {
					if (!e.dead) {
						e.updatePosition();
						e.draw();
					}
				}
				
				BMD.draw(drawLayer);
				
			}
		}
		
		private function updateForce():void {
			force.x = 0;
			force.y = 0;
			for each (var e:Electron in electrons) {
				if (e != this && !e.dead) {
					var distance:Number = MathE.distance(this.position, e.position);
					if (distance > Math.sqrt(strength)) {
						var angle:Number = MathE.angleBetweenPoints(e.position, this.position);
						var f:Number = -((e.strength * this.strength) / (distance * distance));
						force.x += Math.cos(angle) * f;
						force.y += Math.sin(angle) * f;
					} else {
						mergePaths(this, e);
					}
				}
			}
		}
		
		private function updateVelocity():void {
			velocity.x += force.x * timeInterval;
			velocity.y += force.y * timeInterval;
		}
		
		private function updatePosition():void {
			if (position.x < 0 || position.y < 0 || position.x > Main.DISP_WIDTH || position.y > Main.DISP_HEIGHT) {
				dead = true;
			}
			prevPosition.x = position.x;
			prevPosition.y = position.y;
			position.x += velocity.x * timeInterval;
			position.y += velocity.y * timeInterval;
		}
		
		private function draw():void {
			if (BMD != null) {
				drawLayer.graphics.moveTo(prevPosition.x, prevPosition.y);
				drawLayer.graphics.lineStyle(lineWidth, lineColor, lineAlpha);
				drawLayer.graphics.lineTo(position.x, position.y);
			}
		}
		
		private static function mergePaths(e1:Electron, e2:Electron):void {
			// Calculate the electrons' merged values
			var newPos:Point = new Point((e1.position.x + e2.position.x) / 2, (e1.position.y + e2.position.y) / 2);
			var newVel:Point = new Point((e1.velocity.x + e2.velocity.x) / 2, (e1.velocity.y + e2.velocity.y) / 2);
			var newStr:Number = e1.strength + e2.strength;
			var newWidth:Number = Math.sqrt(newStr) / 10;
			var newAlpha:Number = Math.min(1, (e1.lineAlpha + e2.lineAlpha) / 2);
			// Draw lines from their position to the merged electrons' position.
			drawLayer.graphics.moveTo(e2.position.x, e2.position.y);
			drawLayer.graphics.lineStyle(e2.lineWidth, e2.lineColor, e2.lineAlpha);
			drawLayer.graphics.lineTo(newPos.x, newPos.y);
			drawLayer.graphics.moveTo(e1.position.x, e1.position.y);
			drawLayer.graphics.lineStyle(e1.lineWidth, e1.lineColor, e1.lineAlpha);
			drawLayer.graphics.lineTo(newPos.x, newPos.y);
			// kill the second electron, and assign the new values to the new electron.
			e2.dead = true;
			e1.position.x = newPos.x;
			e1.position.y = newPos.y;
			e1.velocity.x = newVel.x;
			e1.velocity.y = newVel.y;
			e1.strength = newStr;
			e1.lineWidth = newWidth;
			e1.lineAlpha = newAlpha; // Doesn't seem to be working...
		}
		
		
	}
}