package com.robot.core.config
{
   public class UpdateConfig
   {
      
      private static var _xml:XML;
      
      public static var loadingArray:Array = [];
      
      public static var mapScrollArray:Array = [];
      
      public static var blueArray:Array = [];
      
      public static var greenArray:Array = [];
      
      public static var brotherArray:Array = [];
      
      public static var niusiArray:Array = [];
      
      public static var niuChangeMapArray:Array = [];
      
      public function UpdateConfig()
      {
         super();
      }
      
      public static function setup(_arg_1:XML) : void
      {
         var _local_2:XML = null;
         var _local_3:String = null;
         _xml = _arg_1;
         for each(_local_2 in _arg_1.loading.list)
         {
            loadingArray.push(_local_2.@str);
         }
         for each(_local_2 in _arg_1.map.list)
         {
            mapScrollArray.push(_local_2.@str);
         }
         for each(_local_2 in _arg_1.blue.list)
         {
            _local_3 = String(_local_2.@str);
            _local_3 = _local_3.replace(/\$/g,"\r");
            blueArray.push(_local_3);
         }
         for each(_local_2 in _arg_1.green.list)
         {
            _local_3 = String(_local_2.@str);
            _local_3 = _local_3.replace(/\$/g,"\r");
            greenArray.push(_local_3);
         }
         for each(_local_2 in _arg_1.brother.list)
         {
            brotherArray.push(_local_2.@str);
         }
         for each(_local_2 in _arg_1.news.list)
         {
            niusiArray.push(_local_2.@str);
         }
         for each(_local_2 in _arg_1.newsChangeMap.list)
         {
            niuChangeMapArray.push(_local_2.@id);
         }
      }
   }
}

