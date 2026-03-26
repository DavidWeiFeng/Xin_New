package com.robot.core.manager
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.media.Sound;
   import org.taomee.utils.Utils;
   
   public class AimatUIManager
   {
      
      private static var _loader:Loader;
      
      public function AimatUIManager()
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
      
      public static function getSound(_arg_1:String) : Sound
      {
         return Utils.getSoundFromLoader(_arg_1,_loader);
      }
      
      public static function getSimplerButton(_arg_1:String) : SimpleButton
      {
         return Utils.getSimpleButtonFromLoader(_arg_1,_loader);
      }
      
      public static function getDisplayObject(_arg_1:String) : DisplayObject
      {
         return Utils.getDisplayObjectFromLoader(_arg_1,_loader);
      }
      
      public static function getSprite(_arg_1:String) : Sprite
      {
         return Utils.getSpriteFromLoader(_arg_1,_loader);
      }
      
      public static function getBitMap(_arg_1:String) : Bitmap
      {
         return new Bitmap(Utils.getBitmapDataFromLoader(_arg_1,_loader));
      }
      
      public static function hasDefinition(_arg_1:String) : Boolean
      {
         return _loader.contentLoaderInfo.applicationDomain.hasDefinition(_arg_1);
      }
   }
}

