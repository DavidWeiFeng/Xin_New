package org.taomee.tmf
{
   import flash.utils.*;
   
   public class TMF
   {
      
      private static var dataDic:Dictionary = new Dictionary();
      
      public function TMF()
      {
         super();
      }
      
      public static function getClass(_arg_1:uint) : Class
      {
         if(dataDic[_arg_1] == null)
         {
            return TmfByteArray;
         }
         return dataDic[_arg_1];
      }
      
      public static function removeClass(_arg_1:uint) : void
      {
         delete dataDic[_arg_1];
      }
      
      public static function registerClass(_arg_1:uint, _arg_2:Class) : void
      {
         dataDic[_arg_1] = _arg_2;
      }
   }
}

