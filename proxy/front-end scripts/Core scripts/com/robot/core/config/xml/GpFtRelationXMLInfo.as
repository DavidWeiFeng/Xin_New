package com.robot.core.config.xml
{
   import org.taomee.ds.HashMap;
   
   public class GpFtRelationXMLInfo
   {
      
      private static var _hashMap:HashMap;
      
      private static var _xml:XML;
      
      private static var _xmllist:XMLList;
      
      private static var xmlClass:Class = GpFtRelationXMLInfo_xmlClass;
      
      setup();
      
      public function GpFtRelationXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc1_:XML = null;
         _xml = XML(new xmlClass());
         _hashMap = new HashMap();
         _xmllist = _xml.Relation;
         for each(_loc1_ in _xmllist)
         {
            _hashMap.add(uint(_loc1_.@ID),_loc1_);
         }
      }
      
      public static function getRelationColor(param1:uint) : uint
      {
         var _loc2_:XML = _hashMap.getValue(param1);
         if(Boolean(_loc2_) && Boolean(_loc2_.hasOwnProperty("@Color")))
         {
            return uint(_loc2_.@Color);
         }
         return 0;
      }
   }
}

