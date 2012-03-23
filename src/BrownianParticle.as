package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class BrownianParticle {
		
		private var _position:Point;
		
		public function get position():Point { return new Point(_position.x, _position.y); }
		
		/**
		 * X position of the particle.
		 */
		public function get x():Number { return _position.x; }
		public function set x(num:Number):void { _position.x = num; }
		
		/**
		 * Y position of the particle.
		 */
		public function get y():Number { return _position.y; }
		public function set y(num:Number):void { _position.y = num; }
		
		/**
		 * Whether the particle has attached itself to other particles.
		 * Actually, whether the particle is allowed to move. The seed particle(s) should have this set to true.
		 */
		public var attached:Boolean;
		
		/**
		 * Multiplier for x and y position when drawing for display.
		 */
		public static var zoomFactor:Number = 2.0;
		
		/**
		 * Array containing all attached (static) particles.
		 */
		public static var attachedParticles:Array = new Array();
		
		/**
		 * Array containing all walking particles, used to process their movement.
		 */
		public static var walkingParticle:BrownianParticle;
		
		/**
		 * How far from the midpoint the furthest attached particle is. Used to calculate launch and kill radii.
		 */
		public static var radius:Number = 0;
		
		/**
		 * The radius at which to launch new particles. This is radius + 1.
		 */
		public static var launchRadius:Number = 1;
		
		/**
		 * The radius beyond which particles die if they travel.
		 */
		public static var killRadius:Number = 5;
		
		/**
		 * The center of the brownian tree. Periodically recentered to the bounding box of all the attached particles.
		 */
		public static var midpoint:Point = new Point(Main.DISP_WIDTH / (2 * zoomFactor), Main.DISP_HEIGHT / (2 * zoomFactor));
		
		/**
		 * Reference to a drawLayer for adding new particles as they attach
		 */
		public static var dispDrawLayer:Sprite;
		
		/**
		 * Constructor
		 * @param	_x X position of the new particle
		 * @param	_y Y Position of the new particle
		 * @param	_attached Whether to make the new particle pre-attached. Usually used just for the seed particle.
		 */
		public function BrownianParticle(_x:Number, _y:Number, _attached:Boolean = false):void {
			_position = new Point(_x, _y);
			attached = false;
			
			if (_attached) {
				attach();
			} else {
				walkingParticle = this;
			}
			
		}
		
		public static function launch():void {
			var p:Point = MathE.pointFromAngle(midpoint, Math.random() * 2 * Math.PI, launchRadius);
			walkingParticle = new BrownianParticle(p.x, p.y);
		}
		
		private function walk():void {
			var angle:Number = Math.random() * 2 * Math.PI;
			var distance:Number = (Math.random() + Math.random()) * 2;
			
			var p:Point = MathE.pointFromAngle(_position, angle, distance);
			x = p.x;
			y = p.y;
			
			// Reusing distance now for distance from center.
			distance = getDistance();
			if (distance > killRadius) {
				launch();
			}
		}
		
		private function collide():void {
			var dist:Number = getDistance();
			if (dist < launchRadius + 1) {
				for each (var particle:BrownianParticle in attachedParticles) {
					if (MathE.distance(_position, particle.position) < 1.5) {
						attach();
						break;
					}
				}
			} else {
				//skip collision calculation; there are no particles out here to collide with.
			}
			
		}
		
		public function attach():void {
			attached = true;
			attachedParticles.push(this);
			if (dispDrawLayer != null) {
				draw(dispDrawLayer, 0xFFFFFF);
			}
			var dist:Number = getDistance();
			if (dist > radius) {
				radius = dist;
				launchRadius = dist + 1;
				killRadius = launchRadius + 25;
			}
		}
		
		public function kill():void {
			if (attachedParticles.indexOf(this) >= 0) {
				trace ("ERROR: Trying to kill an attached particle!");
			} else {
				launch();
			}
		}
		
		private function getDistance():Number {
			return MathE.distance(midpoint, _position);
		}
		
		public function draw(drawLayer:Sprite, color:uint = 0xFFFFFF):void {
			if (drawLayer != null) {
				drawLayer.graphics.beginFill(color);
				drawLayer.graphics.drawCircle(x * zoomFactor, y * zoomFactor, zoomFactor / 2);
				drawLayer.graphics.endFill();
			}
		}
		
		public static function drawWalker(drawLayer:Sprite):void {
			if (drawLayer != null && walkingParticle != null) {
				walkingParticle.draw(drawLayer, 0xFF0000);
			}
		}
		
		/**
		 * Draws all the particles to the input Sprite. WARNING: Clears the sprite's graphics before drawing.
		 * @param	drawLayer
		 */
		public static function drawAll(drawLayer:Sprite):void {
			if (drawLayer != null) {
				drawLayer.graphics.clear();
				for each (var p:BrownianParticle in attachedParticles) {
					p.draw(drawLayer);
				}
			}
		}
		
		/**
		 * Generates an XML object containing an SVG reproduction of the particle.
		 * @return
		 */
		public function outputSVG():XML {
			var result:XML = <circle cx={x} cy={y} r={0.5} stroke="none" fill="red" />;
			return result;
		}
		
		/**
		 * Process a frame's-worth of particle motion. This keeps the framerate high
		 * @param	event
		 */
		public static function frameHandler(event:Event):void {
			var startTime:uint = getTimer();
			var numSteps:uint = 0;
			while (getTimer() - startTime < (1000 / 35) - 1) {
				if (walkingParticle == null || walkingParticle.attached) {
					launch();
				} else {
					walkingParticle.walk();
					walkingParticle.collide();
				}
				numSteps ++;
			}
			//trace(numSteps);
		}
		
	}
	
}