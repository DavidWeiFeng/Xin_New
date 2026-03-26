package com.robot.app.task.noviceGuide
{
   import com.robot.app.task.taskUtils.manage.TaskUIManage;
   import com.robot.app.task.taskUtils.taskDialog.TaskBaseDialog;
   import flash.display.MovieClip;
   
   public class ShiperUnReadDialog
   {
      
      private static var sDialog:MovieClip;
      
      private static var _fun:Function;
      
      public function ShiperUnReadDialog()
      {
         super();
      }
      
      public static function show(_arg_1:String = "", _arg_2:Function = null) : void
      {
         sDialog = TaskUIManage.getMovieClip("shiperUnread",4);
         TaskBaseDialog.dialogMC = sDialog;
         TaskBaseDialog.showNpcImgDialog(_arg_1,_arg_2);
      }
   }
}

