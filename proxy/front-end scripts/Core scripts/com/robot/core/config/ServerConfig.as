package com.robot.core.config
{
   import org.taomee.ds.*;
   
   public class ServerConfig
   {
      
      private static var xml:XML;
      
      private static var hashMap:HashMap = new HashMap();
      
      public function ServerConfig()
      {
         super();
      }
      
      public static function setup(_arg_1:XML) : void
      {
      }
      
      public static function getNameByID(_arg_1:uint) : String
      {
         if(!hashMap.containsKey(_arg_1))
         {
            return _arg_1 + "服务器";
         }
         return hashMap.getValue(_arg_1).toString();
      }
      
      public static function SetName(_arg_1:uint, _arg_2:String) : void
      {
         hashMap.add(_arg_1,_arg_2);
      }
   }
}

