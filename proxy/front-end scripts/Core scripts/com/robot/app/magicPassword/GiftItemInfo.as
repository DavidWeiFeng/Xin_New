package com.robot.app.magicPassword
{
   import com.robot.app.cmd.SysMsgCmdListener;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.controller.GetPetController;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.alert.ItemInBagAlert;
   import flash.utils.IDataInput;
   
   public class GiftItemInfo
   {
      
      private var giftList_a:Array;
      
      private var _title:uint;
      
      public function GiftItemInfo(_arg_1:IDataInput)
      {
         var _local_2:uint = 0;
         var _local_3:uint = 0;
         var _local_4:uint = 0;
         var _local_6:uint = 0;
         var _local_7:uint = 0;
         var petlen:uint = 0;
         var peti:uint = 0;
         var alertStr:String = null;
         super();
         this.giftList_a = new Array();
         var _local_5:uint = _arg_1.readUnsignedInt();
         if(_local_5 == 1)
         {
            this._title = _arg_1.readUnsignedInt();
            SysMsgCmdListener.getInstance().processTitleImage(this._title);
            _local_2 = _arg_1.readUnsignedInt();
            _local_3 = 0;
            while(_local_3 < _local_2)
            {
               _local_4 = _arg_1.readUnsignedInt();
               _local_7 = _arg_1.readUnsignedInt();
               alertStr = _local_7 + "个<font color=\'#ff0000\'>" + ItemXMLInfo.getName(_local_4) + "</font>已放入了你的储存箱。";
               ItemInBagAlert.show(_local_4,alertStr);
               _local_3++;
            }
            petlen = _arg_1.readUnsignedInt();
            peti = 0;
            while(peti < petlen)
            {
               _local_4 = _arg_1.readUnsignedInt();
               _local_6 = _arg_1.readUnsignedInt();
               GetPetController.getPet(_local_4,_local_6);
               peti++;
            }
         }
         else
         {
            Alarm.show("你已经有这些礼物了");
         }
      }
   }
}

