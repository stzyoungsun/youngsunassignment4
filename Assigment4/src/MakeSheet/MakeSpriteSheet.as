package MakeSheet
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import Animaiton.Atlastexture;
	
	
	public class MakeSpriteSheet
	{	
		private var _pieceImage : Atlastexture;
		
		private var _cBinaryTree : BinaryTree;
		private var _cIDBitmap : IDBitmap;
		private var _cSaveToFile : SaveToFile;
		
		private var _spriteSheet : BitmapData;
		
		private var _spriteSheetBitmap : Vector.<Bitmap> = new Vector.<Bitmap>;
		private var _spriteSheetRect : Vector.<Vector.<Rectangle>> = new  Vector.<Vector.<Rectangle>>;
		private var _spriteSheetName : Vector.<Array> = new  Vector.<Array>;
		
		private var _bitmap : Bitmap;
		
		private var _imagePos : Point = new Point(0,0);
		private var _pieceBitmap : Vector.<IDBitmap> = new Vector.<IDBitmap>;
		
		public function MakeSpriteSheet(pieceImage : Atlastexture)
		{
			_pieceImage = pieceImage;
			sortImage();
			setPacking();
		}
		/**
		 *Note @유영선 로드 된 이미지 데이터를 크기 별로 정렬 하는 함수 
		 * -> 크기 별로 정렬 하면 병합 알고리즘의 성능이 더 높아 지기 때문에 정렬을 하였습니다
		 */		
		private function sortImage() : void
		{
			var imageTemp : Vector.<Bitmap> = new Vector.<Bitmap>;
			
			for(var i : int=0; i<LoaderImage.sImageMaxCount; i++)
			{
				_cIDBitmap = new IDBitmap(_pieceImage[LoaderImage.sFileNameVecotr[i]],LoaderImage.sFileNameVecotr[i]);
				_pieceBitmap[i] = _cIDBitmap;
			}
			_pieceBitmap.sort(orderAbs);
			
			function orderAbs(image1:IDBitmap, image2:IDBitmap):int		
			{
				if(image1.getBitmap().width * image1.getBitmap().height< image2.getBitmap().width * image2.getBitmap().height)
					return 1;
				else if(image1.getBitmap().width * image1.getBitmap().height > image2.getBitmap().width * image2.getBitmap().height)
					return -1;
				else
					return 0;	
			}
		}
		/**
		 *Note @유영선 Image 병합 시작 
		 * 이진 트리를 이용하여 큰 Bimap을 쪼개어 그 좌표 값을 이진트리로 만든후 중위 순회를 이용하여 이미지들의 좌표를 저장
		 * sheet에 평행 이동을 이용하여 저장 된 좌표에 출력
		 * _spriteSheetRect [sheet 개수][sheet 안에 이미지 개수의 위치 값] 의 이차원 벡터
		 * _spriteSheetName [sheet 개수][sheet 안에 이미지 이름] 의 이차원 벡터
		 */		
		private function setPacking() : void
		{
			var excessImage : Vetor.<IDBitmap> = new Vector.<IDBitmap>;
			var powCount : int = 1;
			var rootSize : int = 2;
			var rc :Rectangle = new Rectangle(0,0,Math.pow(rootSize,powCount),Math.pow(rootSize,powCount));
			
			_cBinaryTree = new BinaryTree(rc);		//root의 크기를 2의 n승의 크기로 증가를 시키면서 병합을 진행합니다.
			
			for(var i : int=0; i<_pieceBitmap.length; i++)
			{
				var NewNode : Node = _cBinaryTree.insert(_pieceBitmap[i].getBitmap(),_pieceBitmap[i].getFileName(),_cBinaryTree.getroot())
				if(NewNode==null && Math.pow(rootSize,powCount) < 1024)		//이미지가 들어 갈 공간이 없고  sheet의 크기가 1024 보다 작을 경우
				{
					trace("크기 초과");
					i =-1;
					powCount++;
					rc = new Rectangle(0,0,Math.pow(rootSize,powCount),Math.pow(rootSize,powCount));
					_cBinaryTree = new BinaryTree(rc);
				}
				else if(NewNode==null && Math.pow(rootSize,powCount) == 1024)	//이미지가 들어 갈 공간이 없고  sheet의 크기가 1024 인 경우
				{
					trace("크기 초과하고 시트 크기가 1024인 경우");
					excessImage.push(_pieceBitmap[i]);		//초과 이미지 벡터에 이미지 저장
				}
				else
					continue;
				
			}
			trace(Math.pow(rootSize,powCount));
			_cBinaryTree.inOrder();		//중위 순회를 이용하여 이미지만 탐색
			
			
			_spriteSheet= new BitmapData(Math.pow(rootSize,powCount),Math.pow(rootSize,powCount));
			for(var j : int=0; j<_pieceBitmap.length-excessImage.length; j++)
			{
				var imageMatrix:Matrix = new Matrix();
				trace("ImageName : "+_cBinaryTree.getNameArray()[j]);
				trace("Image x: "+_cBinaryTree.getRectVetor()[j].x);
				trace("Image y : "+_cBinaryTree.getRectVetor()[j].y);
				_bitmap = _pieceImage[_cBinaryTree.getNameArray()[j]];
				
				imageMatrix.translate(_cBinaryTree.getRectVetor()[j].x,_cBinaryTree.getRectVetor()[j].y);
				_spriteSheet.draw(_bitmap,imageMatrix);
			}
			
			_spriteSheetBitmap.push(new Bitmap(_spriteSheet));
			_spriteSheetRect.push(_cBinaryTree.getRectVetor());
			_spriteSheetName.push(_cBinaryTree.getNameArray());
			
			if(excessImage.length != 0)
			{
				_pieceBitmap=excessImage;
				setPacking();
			}
			else
				return;
		}
		/**
		 *Note @유영선 삽입된 Image의 크기에 맞게 Sheet를 생성합니다. 
		 * 
		 */		
		public function getSheet() : Vector.<Bitmap>
		{
			trace(_spriteSheetRect.length);
			_cSaveToFile = new SaveToFile(_spriteSheetBitmap,_spriteSheetRect, _spriteSheetName);
			
			return _spriteSheetBitmap;
		}
		
	}
}