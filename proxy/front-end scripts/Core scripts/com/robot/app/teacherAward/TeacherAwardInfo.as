package com.robot.app.teacherAward
{
   import com.robot.core.manager.MainManager;
   import com.robot.core.ui.alert.Alarm;
   import flash.utils.IDataInput;
   
   public class TeacherAwardInfo
   {
      
      private var info_a:Array;
      
      public function TeacherAwardInfo(_arg_1:IDataInput)
      {
         var _local_2:int = 0;
         var _local_3:uint = 0;
         super();
         this.info_a = new Array();
         var _local_4:uint = _arg_1.readUnsignedInt();
         MainManager.actorInfo.graduationCount = _local_4;
         var _local_5:uint = _arg_1.readUnsignedInt();
         if(_local_5 > 0)
         {
            _local_2 = 0;
            while(_local_2 < _local_5)
            {
               _local_3 = _arg_1.readUnsignedInt();
               this.info_a.push(_local_3);
               _local_2++;
            }
         }
         else if(_local_4 == 0)
         {
            Alarm.show("你还没有培养出一个赛尔精英,加油");
         }
         else
         {
            Alarm.show("你已经培养了 " + _local_4 + " 个精英赛尔");
         }
      }
      
      public function get getInfo() : Array
      {
         return this.info_a;
      }
   }
}

