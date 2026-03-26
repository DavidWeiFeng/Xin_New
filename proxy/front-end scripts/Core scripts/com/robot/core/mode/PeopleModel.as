package com.robot.core.mode
{
   import com.robot.core.info.*;
   
   public class PeopleModel extends BasePeoleModel
   {
      
      public function PeopleModel(_arg_1:UserInfo)
      {
         var _local_2:NonoInfo = null;
         super(_arg_1);
         if(Boolean(_arg_1.nonoState[1]))
         {
            trace("PeopleModel.showNono",_arg_1.nonoColor);
            _local_2 = new NonoInfo();
            _local_2.userID = _arg_1.userID;
            _local_2.color = _arg_1.nonoColor;
            _local_2.superStage = _arg_1.vipStage;
            _local_2.nick = _arg_1.nonoNick;
            _local_2.superNono = _arg_1.superNono;
            showNono(_local_2,_arg_1.actionType);
         }
      }
   }
}

