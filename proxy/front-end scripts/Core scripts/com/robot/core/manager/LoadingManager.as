package com.robot.core.manager
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import org.taomee.utils.Utils;
   
   public class LoadingManager
   {
      
      private static var _loader:Loader;
      
      public function LoadingManager()
      {
         super();
      }
      
      public static function setup(_arg_1:Loader) : void
      {
         _loader = _arg_1;
      }
      
      public static function get loader() : Loader
      {
         return _loader;
      }
      
      public static function getMovieClip(_arg_1:String) : MovieClip
      {
         return Utils.getMovieClipFromLoader(_arg_1,_loader);
      }
   }
}

