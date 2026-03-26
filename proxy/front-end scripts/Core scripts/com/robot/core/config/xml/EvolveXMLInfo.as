package com.robot.core.config.xml
{
   public class EvolveXMLInfo
   {
      
      private static var xml:XML;
      
      private static var xmlcls:Class = EvolveXMLInfo_xmlcls;
      
      public function EvolveXMLInfo()
      {
         super();
      }
      
      private static function getXMLData() : XML
      {
         if(xml == null)
         {
            xml = new XML(new xmlcls());
         }
         return xml;
      }
      
      public static function getEvolveID() : Array
      {
         var _local_1:XML = null;
         var _local_2:Array = new Array();
         var _local_3:XMLList = EvolveXMLInfo.getXMLData().elements("Evolve");
         for each(_local_1 in _local_3)
         {
            _local_2.push(Number(_local_1.@ID));
         }
         if(_local_2.length <= 0)
         {
            return null;
         }
         return _local_2;
      }
      
      public static function getMonToIDs(_arg_1:Number) : Array
      {
         var _local_2:XML = null;
         var _local_3:XMLList = null;
         var _local_4:XML = null;
         var _local_5:Object = null;
         var _local_6:Array = new Array();
         var _local_7:XMLList = EvolveXMLInfo.getXMLData().elements("Evolve");
         for each(_local_2 in _local_7)
         {
            if(Number(_local_2.@ID) == _arg_1)
            {
               _local_3 = _local_2.elements("Branch");
               for each(_local_4 in _local_3)
               {
                  _local_5 = new Object();
                  _local_5.MonTo = Number(_local_4.@MonTo);
                  _local_5.EvolvItem = Number(_local_4.@EvolvItem);
                  _local_5.EvolvItemCount = Number(_local_4.@EvolvItemCount);
                  _local_6.push(_local_5);
               }
            }
         }
         if(_local_6.length <= 0)
         {
            return null;
         }
         return _local_6;
      }
      
      public static function getEvolveItem(_arg_1:Number, _arg_2:Number) : Number
      {
         return 0;
      }
      
      public static function getEvolveCount(_arg_1:Number, _arg_2:Number) : Number
      {
         return 0;
      }
   }
}

