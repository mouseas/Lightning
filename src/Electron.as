package {
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Electron {
		
		/**
		 * Position of the Electron at the current cycle.
		 */
		public var position:Point;
		
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
		public var strength:Number;
		
		/**
		 * How much "time" passes between cycles. Used to help calculate velocity change and position change.
		 */
		public static var timeInterval:Number;
		
		/**
		 * How many cycles to run in total.
		 */
		public static var numCycles:uint = 15;
		
		/**
		 * Which cycle processing is currently on.
		 */
		public static var currentCycle:uint = 0;
		
		/**
		 * Static array of all Electrons.
		 */
		public static var electrons:Array;
		
		
		
		/**
		 * Constructor function.
		 * @param	_x X position of the new Electron.
		 * @param	_y Y position of the new Electron.
		 */
		public function Electron(_x:Number, _y:Number):void {
			if (electrons == null) { electrons = new Array(); }
			position = new Point(_x, _y);
			velocity = new Point();
			force = new Point();
			
			electrons.push(this);
		}
		
		/**
		 * Each update cycle, calculate each point's force, then update velocity, then update position, then draw.
		 */
		public static function update(e:Event = null):void {
			if (electrons != null) {
				
				for (var i:int = 0; i < electrons.length; i++) {
					(electrons[i] as Electron).updateForce();
					(electrons[i] as Electron).updateVelocity();
				}
				for (i = 0; i < electrons.length; i++) {
					(electrons[i] as Electron).updatePosition();
				}
				
			}
		}
		
		private function updateForce():void {
			
		}
		
		private function updateVelocity():void {
			
		}
		
		private function updatePosition():void {
			
		}
		
		
	}
}