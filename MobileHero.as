package
{


	import citrus.objects.platformer.box2d.Hero;

	/**
	 * @author Aymeric
	 * adaptación de Nape to Box2D por jrevatta
	 */
	
	public class MobileHero extends Hero
	{

		
		private var _mobileInput:MobileInput;
		
		public function MobileHero(name:String, params:Object=null)
		{
			super(name, params);
			
			_mobileInput = new MobileInput();
			_mobileInput.initialize();
			
			_friction = 0.85;
		}
		
		override public function destroy():void {
			
			_mobileInput.destroy();
			
			super.destroy();
		}
		

		

		override public function update(timeDelta:Number):void {
			

			
			if (_mobileInput.screenTouched) {
				super.update(timeDelta);
						
			
				
				if (_onGround && _ce.input.justDid("jump", inputChannel) && !_ducking)
				{
					velocity.y = -jumpHeight;
					onJump.dispatch();
					//_onGround = false; // also removed in the handleEndContact. Useful here if permanent contact e.g. box on hero.
				}
				
				if (_ce.input.isDoing("jump", inputChannel) && !_onGround && velocity.y < 0)
				{
					velocity.y -= jumpAcceleration;
				}
				
			}
		}
		
		private function _updateAnimation():void {

			super.updateAnimation();
			
		}
		
	}
}