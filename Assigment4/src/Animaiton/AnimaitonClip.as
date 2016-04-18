package Animaiton
{

	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.display.Image;
	import starling.textures.Texture;
	

	public class AnimaitonClip extends Image 
	{
		private var _timer : Timer;
		private var _ImageNum : int = 0;
		private var _textures : Vector.<Texture >;
		
		public function AnimaitonClip(textures:Vector.<Texture > ,fps:Number,animation:Function)
		{
			super(textures[0]);
			_textures = textures;
			_timer = new Timer(fps*100,0);
			
			_timer.addEventListener(TimerEvent.TIMER, timerActive);           //타이머가 진행 하는 함수
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete); //타이머가 끝났을떄
			
			 function timerActive():void
			{
				
				animation(_textures[_ImageNum++]);
		
				if(_ImageNum == _textures.length)
					_ImageNum =0;  
				
			}
			
			 function timerComplete():void
			{
				_timer.removeEventListener(TimerEvent.TIMER, timerActive);
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
				
			}
		}
		public function release() : void
		{
			// TODD @유영선 해제 필요 하면 여기다 추가
			trace("애니매이션 클릭 해제");
			_timer.stop();
			
			dispose();
		}
		public function getTimer() : Timer
		{
			return _timer;
		}
		
	}
}