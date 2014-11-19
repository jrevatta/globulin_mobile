package
{

	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import citrus.utils.Mobile;
	import starling.core.Starling;
	import citrus.core.starling.StarlingCitrusEngine;
	
	/**
	 * @author jrevatta
	 */
	
	public class globulin_mobile extends StarlingCitrusEngine
	{
		public function globulin_mobile()
		{
			
			if (Mobile.isAndroid()) {
				
				Starling.handleLostContext = true;
				Starling.multitouchEnabled = true;
			}
		
			setUpStarling();
			
			state = new GameState();
			
			// support autoOrients

			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
		}
	}
}