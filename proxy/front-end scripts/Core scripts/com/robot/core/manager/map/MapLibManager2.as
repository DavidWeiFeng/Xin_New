package com.robot.core.manager.map
{
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.media.Sound;
   import org.taomee.utils.Utils;
   
   public class MapLibManager2
   {
      
      private var _loader:Loader;
      
      public function MapLibManager2()
      {
         super();
      }
      
      public function setup(_arg_1:Loader) : void
      {
         this._loader = _arg_1;
      }
      
      public function destroy() : void
      {
         this._loader = null;
      }
      
      public function get loader() : Loader
      {
         return this._loader;
      }
      
      public function getClass(_arg_1:String) : Class
      {
         return Utils.getClassFromLoader(_arg_1,this._loader);
      }
      
      public function getMovieClip(_arg_1:String) : MovieClip
      {
         return Utils.getMovieClipFromLoader(_arg_1,this._loader);
      }
      
      public function getSprite(_arg_1:String) : Sprite
      {
         return Utils.getSpriteFromLoader(_arg_1,this._loader);
      }
      
      public function getButton(_arg_1:String) : SimpleButton
      {
         return Utils.getSimpleButtonFromLoader(_arg_1,this._loader);
      }
      
      public function getBitmap(_arg_1:String) : Bitmap
      {
         return new Bitmap(Utils.getBitmapDataFromLoader(_arg_1,this._loader));
      }
      
      public function getSound(_arg_1:String) : Sound
      {
         return Utils.getSoundFromLoader(_arg_1,this._loader);
      }
   }
}

