package com.robot.core.info.userItem
{
   import com.robot.core.utils.ItemType;
   import flash.utils.IDataInput;
   
   public class SoulBeadItemInfo extends SingleItemInfo
   {
      
      public var obtainTime:uint;
      
      public function SoulBeadItemInfo(_arg_1:IDataInput = null)
      {
         super();
         type = ItemType.SOULBEAD;
         leftTime = 365 * 24 * 60 * 60;
      }
   }
}

