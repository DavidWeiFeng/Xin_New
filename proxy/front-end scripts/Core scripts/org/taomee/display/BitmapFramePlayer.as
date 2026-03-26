package org.taomee.display
{
   import flash.display.Bitmap;
   import flash.events.*;
   
   public class BitmapFramePlayer extends Bitmap
   {
      
      public static const END_MOVIE:String = "endMovie";
      
      private var _totalFrames:uint;
      
      private var _bitmapList:Array = [];
      
      private var _currentFrame:uint;
      
      private var _playing:Boolean;
      
      private var _repeatCount:uint;
      
      private var _currentCount:uint;
      
      public function BitmapFramePlayer()
      {
         super();
      }
      
      public function stop() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._playing = false;
      }
      
      public function get repeatCount() : uint
      {
         return this._repeatCount;
      }
      
      public function gotoAndPlay(_arg_1:uint) : void
      {
         if(_arg_1 > this._totalFrames - 1)
         {
            _arg_1 = uint(this._totalFrames - 1);
         }
         if(_arg_1 < 0)
         {
            return;
         }
         if(this._currentFrame == _arg_1)
         {
            return;
         }
         this._currentFrame = _arg_1;
         if(!this._playing)
         {
            this.play();
         }
      }
      
      public function get totalFrames() : uint
      {
         return this._totalFrames;
      }
      
      public function clear() : void
      {
         this.stop();
         bitmapData = null;
         this._totalFrames = 0;
         this._currentFrame = 0;
         this._bitmapList = [];
         this._currentCount = 0;
      }
      
      public function set dataList(_arg_1:Array) : void
      {
         if(_arg_1 == null)
         {
            this.clear();
            return;
         }
         this.stop();
         this._bitmapList = _arg_1;
         this._totalFrames = this._bitmapList.length;
         this._currentFrame = 0;
         this._currentCount = 0;
         bitmapData = this._bitmapList[this._currentFrame];
      }
      
      public function gotoAndStop(_arg_1:uint) : void
      {
         if(_arg_1 > this._totalFrames - 1)
         {
            _arg_1 = uint(this._totalFrames - 1);
         }
         if(_arg_1 < 0)
         {
            return;
         }
         this.stop();
         this._currentFrame = _arg_1;
         bitmapData = this._bitmapList[this._currentFrame];
      }
      
      private function onEnterFrame(_arg_1:Event) : void
      {
         ++this._currentFrame;
         if(this._currentFrame == this._totalFrames)
         {
            this._currentFrame = 0;
            if(this._repeatCount != 0)
            {
               ++this._currentCount;
               if(this._currentCount >= this._repeatCount)
               {
                  this.stop();
                  return;
               }
            }
            dispatchEvent(new Event(END_MOVIE));
         }
         bitmapData = this._bitmapList[this._currentFrame];
      }
      
      public function set repeatCount(_arg_1:uint) : void
      {
         this._repeatCount = _arg_1;
      }
      
      public function get playing() : Boolean
      {
         return this._playing;
      }
      
      public function play() : void
      {
         this._playing = true;
         if(this._totalFrames > 1)
         {
            addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         else
         {
            this.onEnterFrame(null);
         }
      }
      
      public function destroy(gc:Boolean = false) : void
      {
         this.stop();
         this._totalFrames = 0;
         this._currentFrame = 0;
         this._currentCount = 0;
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
      
      public function get currentFrame() : uint
      {
         return this._currentFrame;
      }
   }
}

