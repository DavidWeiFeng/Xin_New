package org.taomee.utils
{
   import flash.display.*;
   import flash.media.*;
   import flash.system.ApplicationDomain;
   import flash.utils.*;
   
   public class Utils
   {
      
      private static var _bmdPacket:Dictionary = new Dictionary(true);
      
      public function Utils()
      {
         super();
      }
      
      public static function getClass(name:String) : Class
      {
         var ClassReference:Class = null;
         try
         {
            ClassReference = getDefinitionByName(name) as Class;
         }
         catch(e:Error)
         {
            return null;
         }
         return ClassReference;
      }
      
      public static function getClassFromLoader(_arg_1:String, _arg_2:Loader) : Class
      {
         var _local_3:ApplicationDomain = _arg_2.contentLoaderInfo.applicationDomain;
         if(_local_3.hasDefinition(_arg_1))
         {
            return _local_3.getDefinition(_arg_1) as Class;
         }
         return null;
      }
      
      public static function getMovieClipFromLoader(_arg_1:String, _arg_2:Loader) : MovieClip
      {
         var _local_3:DisplayObject = getDisplayObjectFromLoader(_arg_1,_arg_2);
         return _local_3 == null ? null : _local_3 as MovieClip;
      }
      
      public static function getDisplayObjectFromLoader(name:String, loader:Loader) : DisplayObject
      {
         var classReference:Class = getClassFromLoader(name,loader);
         if(classReference == null)
         {
            return null;
         }
         try
         {
            return new classReference() as DisplayObject;
         }
         catch(e:Error)
         {
            return null;
         }
      }
      
      public static function getBitmapDataFromLoader(name:String, loader:Loader, isCache:Boolean = false) : BitmapData
      {
         var classReference:Class = null;
         var bmd:BitmapData = null;
         if(Boolean(_bmdPacket[name]))
         {
            return _bmdPacket[name];
         }
         classReference = getClassFromLoader(name,loader);
         if(Boolean(classReference))
         {
            try
            {
               bmd = new classReference(0,0) as BitmapData;
            }
            catch(e:Error)
            {
            }
            if(isCache)
            {
               if(Boolean(bmd))
               {
                  _bmdPacket[name] = bmd;
               }
            }
            return bmd;
         }
         return null;
      }
      
      public static function getLoaderClass(_arg_1:Loader) : Class
      {
         return _arg_1.contentLoaderInfo.applicationDomain.getDefinition(getQualifiedClassName(_arg_1.content)) as Class;
      }
      
      public static function getSoundFromLoader(_arg_1:String, _arg_2:Loader) : Sound
      {
         var _local_3:Class = getClassFromLoader(_arg_1,_arg_2);
         return new _local_3() as Sound;
      }
      
      public static function getSimpleButtonFromLoader(_arg_1:String, _arg_2:Loader) : SimpleButton
      {
         var _local_3:DisplayObject = getDisplayObjectFromLoader(_arg_1,_arg_2);
         return _local_3 == null ? null : _local_3 as SimpleButton;
      }
      
      public static function getSpriteFromLoader(_arg_1:String, _arg_2:Loader) : Sprite
      {
         var _local_3:DisplayObject = getDisplayObjectFromLoader(_arg_1,_arg_2);
         return _local_3 == null ? null : _local_3 as Sprite;
      }
      
      public static function getClassByObject(obj:DisplayObject) : Class
      {
         var mcs:Class = null;
         try
         {
            mcs = getClassFromLoader(getQualifiedClassName(obj),obj.loaderInfo.loader) as Class;
         }
         catch(e:Error)
         {
            return null;
         }
         return mcs;
      }
   }
}

