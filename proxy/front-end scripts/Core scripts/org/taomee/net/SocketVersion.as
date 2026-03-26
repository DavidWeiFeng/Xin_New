package org.taomee.net
{
   public class SocketVersion
   {
      
      public static const SV_1:String = "1";
      
      public static const SV_2:String = "2";
      
      public function SocketVersion()
      {
         super();
      }
      
      public static function getHeadLength(_arg_1:String) : uint
      {
         if(_arg_1 == SV_1)
         {
            return 17;
         }
         if(_arg_1 == SV_2)
         {
            return 21;
         }
         throw new Error("没有该socket版本");
      }
   }
}

