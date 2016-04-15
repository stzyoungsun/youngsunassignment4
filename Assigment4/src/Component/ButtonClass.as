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
			_button.x = _buttonRect.x;
			_button.y = _buttonRect.y;
			
			_button.addChild(_buttonImage);
		}
		
		private function createTextButton(buttonText : String) : void
		{
			_button = new Sprite();
			
			_button.x = _buttonRect.x;
			_button.y = _buttonRect.y;
			_button.width = _buttonRect.width;
			_button.height = _buttonRect.height;
			
			_button.addChild(_buttonImage);
			
			// TextField 객체 생성
			var textField:TextField = new TextField(_button.width, _button.height, buttonText);
			// 버튼 객체의 자식으로 등록
			_button.addChild(textField);
		}
	}
}