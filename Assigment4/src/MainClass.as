package
{
	import flash.geom.Rectangle;
	
	import Animaiton.Atlastexture;
	
	import Component.RadioButtonClass;
	
	import Window.AnimationWindow;
	import Window.ImageWindow;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import Component.ButtonClass;
	
	/**
	 * 
	 * @author user
	 * Note @유영선 중심이 되는 Class
	 */	
	public class MainClass extends Sprite
	{
		private var _cLoader : LoaderClass;
		private var _cAnimationWindow : AnimationWindow;
		private var _cImageWindow : ImageWindow;
		private var _componentAtlas : Atlastexture; 
		
		private var _backButton :ButtonClass;
		private var _radioButton : Vector.<RadioButtonClass> = new Vector.<RadioButtonClass>;    //라디오 버튼은  Animation/Image Window를 조절 하는 버튼 이므로 Main에 삽입
		public function MainClass()
		{
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		public function initialize() : void
		{
			
			_cLoader = new LoaderClass(completeLoadImage);
			
		}
		/**
		 *Note @유영선 이미지 로딩 완료 후 AnimationWindow 창 로드  
		 * 
		 */		
		private function completeLoadImage() : void
		{
			
			_componentAtlas = new Atlastexture(Texture.fromBitmap(_cLoader.getSpriteSheetDictionary()["Component_Sheet0.png"]),_cLoader.getxmlDictionary()["Component_Sheet0.xml"]);
			initWindow();
		}
		
		private function initWindow() : void 
		{
			_cAnimationWindow = new AnimationWindow(0,30,stage.stageWidth,stage.stageHeight,_componentAtlas.getsubSpriteSheet(),drawRadioButton);
			
			var loadImage : Image = new Image(_componentAtlas.getsubSpriteSheet()["LoadSprite.png"]);
			
			_backButton = new ButtonClass(new Rectangle(345,390, loadImage.width/2, loadImage.height),loadImage,"Back");
			_backButton.getButton().addEventListener(TouchEvent.TOUCH,onBackClick);
			
			addChild(_backButton.getButton());
			addChild(_cAnimationWindow);
		}
		/**
		 * Note @유영선 두개의 라디오 버튼을 생성  
		 * 
		 */		
		private function drawRadioButton(curTexture : Atlastexture) : void
		{
			var RadioOFFImageA:Image = new Image(_componentAtlas.getsubSpriteSheet()["RadioOFF.png"]);
			var RadioONImageA:Image = new Image(_componentAtlas.getsubSpriteSheet()["RadioON.png"]);
			
			var RadioOFFImageI:Image = new Image(_componentAtlas.getsubSpriteSheet()["RadioOFF.png"]);
			var RadioONImageI:Image = new Image(_componentAtlas.getsubSpriteSheet()["RadioON.png"]);
			
			_radioButton[0] = new RadioButtonClass(new Rectangle(345, 480, 200, 150), RadioONImageA,RadioOFFImageA,"Animation Mode");
			_radioButton[1] = new RadioButtonClass(new Rectangle(345, 530,200, 150), RadioONImageI,RadioOFFImageI,"Image Mode");	
			_radioButton[1].swtichClicked(false);
			
			
			
			_radioButton[0].getRadioButton().addEventListener(TouchEvent.TOUCH,onRadioClick);
			_radioButton[1].getRadioButton().addEventListener(TouchEvent.TOUCH,onRadioClick);
			
			
			
			addChild(_radioButton[0].getRadioButton());
			addChild(_radioButton[1].getRadioButton());
			
			_cImageWindow = new ImageWindow(0,30,stage.stageWidth,stage.stageHeight,_componentAtlas.getsubSpriteSheet(),curTexture);
			_cImageWindow.visible = false;
			addChild(_cImageWindow);
		}
		
		private function onRadioClick(e:TouchEvent): void
		{
			var touch:Touch = e.getTouch(stage,TouchPhase.BEGAN);
			
			if(touch)
			{
				if(e.currentTarget == _radioButton[0].getRadioButton())
				{
					trace("0번 라디오 찍힘");
					_radioButton[0].swtichClicked(true);
					_radioButton[1].swtichClicked(false);
					_cAnimationWindow.visible = true;
					_cImageWindow.visible = false;
				}
				else if(e.currentTarget == _radioButton[1].getRadioButton())
				{
					trace("1번 라디오 찍힘");
					_radioButton[0].swtichClicked(false);
					_radioButton[1].swtichClicked(true);
					_cAnimationWindow.visible = false;
					_cImageWindow.visible = true;
				}
				else
					return;
			}
		}
		/**
		 * 
		 * @param e
		 * back 버튼 클릭 시 window 창들 삭제 후 재 생성
		 */		
		private function onBackClick(e:TouchEvent): void
		{
			var touch:Touch = e.getTouch(stage,TouchPhase.BEGAN);
			
			if(touch)
			{
				if(_radioButton)
				{
					for(var i: int =0; i < _radioButton.length; i++)
					{
						_radioButton[i].release();
					}
				}
				_backButton.clickedONMotion();
				if(_cAnimationWindow)
					_cAnimationWindow.release();
				if(_cImageWindow)
					_cImageWindow.release();
				_backButton.release();
				
				initWindow();
			}
			else
				_backButton.clickedOFFMotion();
		}
		public function release() : void 
		{
			// TODD @유영선 해제 필요 하면 여기다 추가
			trace("메인 클래스 해제");
			for(var i: int =0; i < _radioButton.length; i++)
			{
				_radioButton[i].release();
			}
			_cAnimationWindow.release();
			_cImageWindow.release();
			
			this.removeChildren();
			this.removeEventListeners();
		}
	}
}