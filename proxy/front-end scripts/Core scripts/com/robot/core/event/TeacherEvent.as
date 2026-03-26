package com.robot.core.event
{
   import com.robot.core.info.InformInfo;
   import flash.events.Event;
   
   public class TeacherEvent extends Event
   {
      
      public static const REQUEST_ME_AS_TEACHER:String = "requestMeAsTeacher";
      
      public static const REQUEST_TEACHER_HANDLED:String = "requestTeacherHandled";
      
      public static const REQUEST_ME_AS_STUDENT:String = "requestMeAsStudent";
      
      public static const REQUEST_STUDENT_HANDLED:String = "requestStudentHandled";
      
      public static const DELETE_AS_TEACHER:String = "deleteAsTeacher";
      
      public static const DELETE_AS_STUDENT:String = "deleteAsStudent";
      
      private var _info:InformInfo;
      
      public function TeacherEvent(_arg_1:String, _arg_2:InformInfo, _arg_3:Boolean = false, _arg_4:Boolean = false)
      {
         super(_arg_1,_arg_3,_arg_4);
         this._info = _arg_2;
      }
      
      public function get info() : InformInfo
      {
         return this._info;
      }
   }
}

