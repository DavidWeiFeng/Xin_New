package org.taomee.display
{
   import flash.display.Bitmap;
   
   public class ExtBitmapPlayer extends Bitmap
   {
      
      private var _totalFrames:uint;
      
      private var _bitmapList:Array = [];
      
      private var _currentFrame:uint;
      
      public function ExtBitmapPlayer(_arg_1:Array = null)
      {
         super();
         if(Boolean(_arg_1))
         {
            this.dataList = _arg_1;
         }
      }
      
      public function destroy(gc:Boolean = false) : void
      {
         if(gc)
         {
            this._bitmapList.forEach(function(_arg_1:*, _arg_2:int, _arg_3:Array):void
            {
               if(_arg_1)
               {
                  _arg_1.dispose();
               }
            });
         }
         bitmapData = null;
         this._bitmapList = null;
      }
      
      public function set currentFrame(_arg_1:uint) : void
      {
         if(_arg_1 > this._totalFrames - 1)
         {
            _arg_1 = uint(this._totalFrames - 1);
         }
         if(_arg_1 < 0)
         {
            return;
         }
         this._currentFrame = _arg_1;
         bitmapData = this._bitmapList[this._currentFrame];
      }
      
      public function get totalFrames() : uint
      {
         return this._totalFrames;
      }
      
      public function clear() : void
      {
         bitmapData = null;
         this._totalFrames = 0;
         this._currentFrame = 0;
         this._bitmapList = [];
      }
      
      public function set dataList(_arg_1:Array) : void
      {
         if(_arg_1 == null)
         {
            this.clear();
            return;
         }
         this._bitmapList = _arg_1;
         this._totalFrames = this._bitmapList.length;
         this._currentFrame = 0;
         bitmapData = this._bitmapList[this._currentFrame];
      }
      
      public function get currentFrame() : uint
      {
         return this._currentFrame;
      }
      
      public function nextFrame() : void
      {
         if(this._totalFrames > 1)
         {
            bitmapData = this._bitmapList[this._currentFrame];
            ++this._currentFrame;
            if(this._currentFrame == this._totalFrames)
            {
               this._currentFrame = 0;
            }
         }
      }
   }
}

