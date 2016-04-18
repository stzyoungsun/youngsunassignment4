package
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import starling.core.Starling;
	
	[SWF(width="600", height="600", frameRate="60", backgroundColor="#ffffff")]
	public class Assigment4 extends Sprite
	{
		private var _mainStarling:Starling;
		private var _cMainClass : MainClass = new MainClass();
		
		public function Assigment4()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE ;		//stage 모드를  No_SCALE로 변경
			stage.align = StageAlign.TOP_LEFT; 
			
			_mainStarling = new Starling(MainClass, stage);
			_mainStarling.showStats = true;
			_mainStarling.start();
			
		
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExit);
		}
		
		private function onExit(event:Event):void
		{
			//_cMainClass.release();
		}
	}
}