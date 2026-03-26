package org.taomee.utils
{
   import flash.display.*;
   import flash.geom.*;
   
   public class BitmapDataUtil
   {
      
      public function BitmapDataUtil()
      {
         super();
      }
      
      public static function makeList(_arg_1:BitmapData, _arg_2:int, _arg_3:int, _arg_4:uint, _arg_5:Boolean = false) : Array
      {
         var _local_6:int = 0;
         var _local_7:int = 0;
         var _local_8:BitmapData = null;
         var _local_11:int = 0;
         var _local_9:int = int(int(Math.min(_arg_1.width,2880) / _arg_2));
         var _local_10:int = int(int(Math.min(_arg_1.height,2880) / _arg_3));
         var _local_12:Array = [];
         var _local_13:Rectangle = new Rectangle(0,0,_arg_2,_arg_3);
         var _local_14:Point = new Point();
         _local_7 = 0;
         while(_local_7 < _local_10)
         {
            _local_6 = 0;
            while(_local_6 < _local_9)
            {
               if(_local_11 >= _arg_4)
               {
                  return _local_12;
               }
               _local_13.x = _local_6 * _arg_2;
               _local_13.y = _local_7 * _arg_3;
               _local_8 = new BitmapData(_arg_2,_arg_3);
               _local_8.copyPixels(_arg_1,_local_13,_local_14);
               _local_12[_local_11] = _local_8;
               _local_11++;
               _local_6++;
            }
            _local_7++;
         }
         if(_arg_5)
         {
            _arg_1.dispose();
         }
         return _local_12;
      }
   }
}

