package Component
{
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;



	public class ButtonClass 
	{
		/**
		 *Note @버큰을 만들기 위한 클래스
		 * 버튼은 이미지 버튼, 텍스트 버튼 두가지로 나타납니다. 
		 */		
		private var _button : Sprite;
		private var _buttonRect : Rectangle;
		private var _buttonImage : Image;
		
		public function ButtonClass(buttonRect : Rectangle, buttonImage : Image, buttonText : String = "")
		{
			_buttonRect = buttonRect;
			_buttonImage = buttonImage;

			if(buttonText == "")
				createImageButton();	//Image 버튼 생성
			else
				createTextButton(buttonText);		//Text 버튼 생성
		}
		
		public function getButton() : Sprite
		{
			return _button;
		}
		
		private function createImageButton() : void
		{
			_button = new Sprite();
			
			_button.pivotX = _button.width / 2;
			_button.pivotY = _button.height / 2;
			
			_button.x = _buttonRect.x;
			_button.y = _buttonRect.y;
			
			_button.addChild(_buttonImage);
		}
		
		private function createTextButton(buttonText : String) : void
		{
			_button = new Sprite();
			
			_button.pivotX = _button.width / 2;
			_button.pivotY = _button.height / 2;
			
			_button.x = _buttonRect.x;
			_button.y = _buttonRect.y;
			_button.width = _buttonRect.width;
			_button.height = _buttonRect.height;
			
			_button.addChild(_buttonImage);
			_button.name = buttonText;
			trace(_button.name);
			// TextField 객체 생성
			var textField:TextField = new TextField(_button.width, _button.height, buttonText);
			// 버튼 객체의 자식으로 등록
			_button.addChild(textField);
		}
		/**
		 * 
		 * Note @유영선 버튼 클릭 됬을 때 모션
		 */		
		public function clickedONMotion() : void 
		{
			_button.scale = 0.8;
		}
		/**
		 * 
		 * Note @유영선 버튼 클릭 됬을 때 모션
		 */	
		public function clickedOFFMotion() : void 
		{
			_button.scale = 1.0;
		}
		public function release() : void
		{
			// TODD @유영선 해제 필요 하면 여기다 추가
			trace("버튼 클래스 해제");
			_button.removeChildren();
			_button.removeEventListeners();
			
		}
	}
}