package com.robot.core.group.manager
{
   import com.robot.core.group.info.GroupIDInfo;
   
   public class GroupIDInfoManager
   {
      
      public function GroupIDInfoManager()
      {
         super();
      }
      
      public static function checkIsSelfGp(param1:GroupIDInfo) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         return false;
      }
      
      public static function checkIsTargetGp(param1:GroupIDInfo, param2:GroupIDInfo) : Boolean
      {
         if(!param1 || !param2)
         {
            return false;
         }
         if(param1.svrID == param2.svrID && param1.seqID == param2.seqID && param1.time == param2.time)
         {
            return true;
         }
         return false;
      }
   }
}

