package com.robot.app.task.noviceGuide.GuideTaskAfter
{
   import com.robot.app.task.taskUtils.manage.TaskUIManage;
   import com.robot.app.task.taskUtils.taskDialog.TaskBaseDialog;
   import flash.display.MovieClip;
   
   public class GetMonsterCapsule
   {
      
      private static var sDialog:MovieClip;
      
      public function GetMonsterCapsule()
      {
         super();
      }
      
      public static function show(_arg_1:String = "", _arg_2:Function = null) : void
      {
         sDialog = TaskUIManage.getMovieClip("getMonsterCapsules",4);
         TaskBaseDialog.dialogMC = sDialog;
         TaskBaseDialog.showAwardDialog(_arg_1,_arg_2);
      }
   }
}

