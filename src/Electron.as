package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Electron {
		
		/**
		 * Position of the Electron at the current cycle.
		 */
		public var position:Point;
		
		/**
		 * The position of the Electron at the previous cycle. Draw() draws a line from prevPosition to position.
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
		 * Off-screen electrons are set to dead and then skipped.
		 */
		public var dead:Boolean = false;
		
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
		 * layer to which lines are added. This layer is drawn to the Main.displayBMD each cycle, then cleared.
		 */
		public static var drawLayer:Sprite;
		
		/**
		 * How much "time" passes between cycles. Used to help calculate velocity change and position change.
		 */
		public static var timeInterval:Number = 0.1;
		
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
			
			electrons.push(this);
		}
		
		/**
		 * Each update cycle, calculate each point's force, then update velocity, then update position, then draw.
		 */
		public static function update(e:Event = null):void {
			if (electrons != null && currentCycle < numCycles) {
				for each (var elec:Electron in electrons) {
					if (!elec.dead) {
						elec.updateForce();
						elec.updateVelocity();
					}
				}
				for each (elec in electrons) {
					if (!elec.dead) {
						elec.updatePosition();
						elec.draw();
					}
				}
				currentCycle++;
			}
		}
		
		private function updateForce():void {
			for each (var e:Electron in electrons) {
				if (e != this && !e.dead) {
					var distance:Number = MathE.distance(this.position, e.position);
					var angle:Number = MathE.angleBetweenPoints(this.position, e.position);
					var f:Number = (e.strength * this.strength) / (distance * distance);
					var vectX:Number = f * Math.cos(angle);
					var vectY:Number = f * Math.sin(angle);
					force.x += vectX;
					force.y += vectY;
				}
			}
		}
		
		private function updateVelocity():void {
			velocity.x += force.x * timeInterval;
			velocity.y += force.y * timeInterval;
		}
		
		private function updatePosition():void {
			prevPosition.x = position.x;
			prevPosition.y = position.y;
			position.x += velocity.x * timeInterval;
			position.y += velocity.y * timeInterval;
			// remove off-screen electrons
			if (position.x < 0 || position.y < 0 || position.x > Main.DISP_WIDTH || position.y > Main.DISP_HEIGHT) {
				dead = true;
			}
			// randomly split the electron
			if (Math.random() > 0.99) {
				var split:Electron  = new Electron(position.x + Math.random(), position.y + Math.random());
				split.velocity.x = velocity.x;
				split.velocity.y = velocity.y;
				position.x += Math.random();
				position.y += Math.random();
			}
		}
		
		private function draw():void {
			drawLayer.graphics.moveTo(prevPosition.x, prevPosition.y);
			drawLayer.graphics.lineStyle(lineWidth, lineColor, lineAlpha);
			drawLayer.graphics.lineTo(position.x, position.y);
		}
		
		
	}
}