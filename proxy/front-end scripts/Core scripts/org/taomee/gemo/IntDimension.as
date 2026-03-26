package org.taomee.gemo
{
   public class IntDimension
   {
      
      private var _height:int = 0;
      
      private var _width:int = 0;
      
      public function IntDimension(_arg_1:int = 0, _arg_2:int = 0)
      {
         super();
         this._width = _arg_1;
         this._height = _arg_2;
      }
      
      public function setSize(_arg_1:IntDimension) : void
      {
         this._width = _arg_1.width;
         this._height = _arg_1.height;
      }
      
      public function setSizeWH(_arg_1:int, _arg_2:int) : void
      {
         this._width = _arg_1;
         this._height = _arg_2;
      }
      
      public function set height(_arg_1:int) : void
      {
         this._height = _arg_1;
      }
      
      public function set width(_arg_1:int) : void
      {
         this._width = _arg_1;
      }
      
      public function get width() : int
      {
         return this._width;
      }
      
      public function get height() : int
      {
         return this._height;
      }
   }
}

