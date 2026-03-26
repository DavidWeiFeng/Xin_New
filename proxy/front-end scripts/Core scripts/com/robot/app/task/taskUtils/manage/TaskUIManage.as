package com.robot.app.task.taskUtils.manage
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.Utils;
   
   public class TaskUIManage
   {
      
      private static var _loader:Loader;
      
      public static var loadHash:HashMap = new HashMap();
      
      public function TaskUIManage()
      {
         super();
      }
      
      public static function getMovieClip(_arg_1:String, _arg_2:uint) : MovieClip
      {
         _loader = loadHash.getValue(_arg_2);
         return Utils.getMovieClipFromLoader(_arg_1,_loader);
      }
      
      public static function getButton(_arg_1:String, _arg_2:uint) : SimpleButton
      {
         _loader = loadHash.getValue(_arg_2);
         return Utils.getSimpleButtonFromLoader(_arg_1,_loader);
      }
      
      public static function destroyLoder(_arg_1:uint) : void
      {
         var _local_2:Loader = loadHash.getValue(_arg_1);
         loadHash.remove(_arg_1);
         _local_2 = null;
      }
   }
}

