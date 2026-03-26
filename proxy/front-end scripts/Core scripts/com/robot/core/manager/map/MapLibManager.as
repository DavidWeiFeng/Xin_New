package com.robot.core.manager.map
{
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.media.Sound;
   import org.taomee.utils.Utils;
   
   public class MapLibManager
   {
      
      private static var _loader:Loader;
      
      public function MapLibManager()
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
      
      public static function getClass(_arg_1:String) : Class
      {
         return Utils.getClassFromLoader(_arg_1,_loader);
      }
      
      public static function getMovieClip(_arg_1:String) : MovieClip
      {
         return Utils.getMovieClipFromLoader(_arg_1,_loader);
      }
      
      public static function getButton(_arg_1:String) : SimpleButton
      {
         return Utils.getSimpleButtonFromLoader(_arg_1,_loader);
      }
      
      public static function getBitmap(_arg_1:String) : Bitmap
      {
         return new Bitmap(Utils.getBitmapDataFromLoader(_arg_1,_loader));
      }
      
      public static function getSound(_arg_1:String) : Sound
      {
         return Utils.getSoundFromLoader(_arg_1,_loader);
      }
   }
}

