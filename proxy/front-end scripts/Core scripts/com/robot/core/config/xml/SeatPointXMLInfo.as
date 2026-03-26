package com.robot.core.config.xml
{
   import com.robot.core.manager.MapManager;
   import flash.display.MovieClip;
   import org.taomee.ds.HashMap;
   
   public class SeatPointXMLInfo
   {
      
      private static var _xmllist:XMLList;
      
      private static var _hashMap:HashMap;
      
      private static var xmlClass:Class = SeatPointXMLInfo_xmlClass;
      
      private static var _xml:XML = XML(new xmlClass());
      
      setup();
      
      public function SeatPointXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc1_:XML = null;
         _hashMap = new HashMap();
         _xmllist = _xml.seat;
         for each(_loc1_ in _xmllist)
         {
            _hashMap.add(uint(_loc1_.@mapID),_loc1_);
         }
      }
      
      public static function getGroupBtn(param1:uint) : MovieClip
      {
         var _loc2_:String = null;
         var _loc3_:MovieClip = null;
         var _loc4_:XML = _hashMap.getValue(param1);
         if(Boolean(_loc4_) && Boolean(_loc4_.hasOwnProperty("@btn")))
         {
            _loc2_ = _loc4_.@btn;
            _loc3_ = MapManager.currentMap.controlLevel[_loc2_];
            if(Boolean(_loc3_))
            {
               return _loc3_;
            }
            throw new Error("元件【" + _loc2_ + "】功能层没有找到");
         }
         return null;
      }
      
      public static function getSeatPointMC(param1:uint, param2:uint, param3:uint) : MovieClip
      {
         var _loc4_:XMLList = null;
         var _loc5_:XML = null;
         var _loc6_:uint = 0;
         var _loc7_:XMLList = null;
         var _loc8_:XML = null;
         var _loc9_:String = null;
         var _loc10_:MovieClip = null;
         var _loc11_:XML = _hashMap.getValue(param1);
         if(Boolean(_loc11_) && Boolean(_loc11_.hasOwnProperty("sct")))
         {
            _loc4_ = _loc11_.sct;
            if(Boolean(_loc4_))
            {
               for each(_loc5_ in _loc4_)
               {
                  _loc6_ = uint(_loc5_.@id);
                  if(_loc6_ == param2)
                  {
                     _loc7_ = _loc5_.point;
                     for each(_loc8_ in _loc7_)
                     {
                        if(_loc8_.@id == param3)
                        {
                           _loc9_ = _loc8_.@mc;
                           _loc10_ = MapManager.currentMap.controlLevel[_loc9_];
                           if(Boolean(_loc10_))
                           {
                              return _loc10_;
                           }
                        }
                     }
                  }
               }
            }
         }
         return null;
      }
      
      public static function getSctMaxPoint(param1:uint, param2:uint) : uint
      {
         var _loc3_:XMLList = null;
         var _loc4_:XML = null;
         var _loc5_:uint = 0;
         var _loc6_:XML = _hashMap.getValue(param1);
         if(Boolean(_loc6_) && Boolean(_loc6_.hasOwnProperty("sct")))
         {
            _loc3_ = _loc6_.sct;
            if(Boolean(_loc3_))
            {
               for each(_loc4_ in _loc3_)
               {
                  _loc5_ = uint(_loc4_.@id);
                  if(_loc5_ == param2)
                  {
                     return (_loc4_.point as XMLList).length();
                  }
               }
            }
         }
         return 0;
      }
   }
}

