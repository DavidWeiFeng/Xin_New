package com.robot.app.superParty
{
   public class SPConfig
   {
      
      private static var _infoA:Array;
      
      private static var xmlClass:Class = SPConfig_xmlClass;
      
      private static var xml:XML = XML(new xmlClass());
      
      public function SPConfig()
      {
         super();
      }
      
      public static function makeInfo() : void
      {
         var _local_1:XML = null;
         var _local_2:SuperPartyInfo = null;
         _infoA = new Array();
         var _local_3:XMLList = xml.elements("SP");
         for each(_local_1 in _local_3)
         {
            _local_2 = new SuperPartyInfo();
            if(_local_1.@games == "")
            {
               _local_2.games = new Array();
            }
            else
            {
               _local_2.games = String(_local_1.@games).split("|");
            }
            _local_2.mapID = uint(_local_1.@mapID);
            if(_local_1.@oreIDs == "")
            {
               _local_2.oreIDs = new Array();
            }
            else
            {
               _local_2.oreIDs = String(_local_1.@oreIDs).split("|");
            }
            if(_local_1.@petIDs != "")
            {
               _local_2.petIDs = String(_local_1.@petIDs).split("|");
            }
            else
            {
               _local_2.petIDs = new Array();
            }
            _infoA.push(_local_2);
         }
      }
      
      public static function get infos() : Array
      {
         if(!_infoA)
         {
            makeInfo();
         }
         return _infoA;
      }
      
      public static function get title() : String
      {
         var _local_1:XML = null;
         var _local_2:XMLList = xml.elements("title");
         var _local_3:String = "";
         for each(_local_1 in _local_2)
         {
            _local_3 += _local_1.@msg;
         }
         return _local_3;
      }
   }
}

