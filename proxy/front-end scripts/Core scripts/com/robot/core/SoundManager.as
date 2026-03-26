package com.robot.core
{
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.*;
   import flash.media.*;
   import flash.utils.*;
   
   public class SoundManager
   {
      
      private static var soundChannel:SoundChannel;
      
      private static var currentSound:Sound;
      
      private static var dict:Dictionary = new Dictionary();
      
      public static var isPlay_b:Boolean = true;
      
      init();
      
      public function SoundManager()
      {
         super();
      }
      
      public static function playSound() : void
      {
         var _local_1:Sound = null;
         var _local_2:SoundTransform = new SoundTransform(0.2);
         if(isPlay_b == true)
         {
            _local_1 = dict["map_" + MainManager.actorInfo.mapID];
            if(Boolean(_local_1))
            {
               if(getQualifiedClassName(_local_1) == getQualifiedClassName(currentSound))
               {
                  return;
               }
               if(Boolean(soundChannel))
               {
                  soundChannel.stop();
               }
               soundChannel = _local_1.play(0,999999,_local_2);
               currentSound = _local_1;
            }
            else
            {
               stopSound();
               try
               {
                  soundChannel = MapLibManager.getSound("sound").play(0,999999,_local_2);
               }
               catch(e:Error)
               {
               }
            }
         }
      }
      
      public static function stopSound() : void
      {
         if(Boolean(soundChannel))
         {
            soundChannel.stop();
         }
         currentSound = null;
      }
      
      private static function init() : void
      {
         add(CoreAssetsManager.getClass("KLS_Sound"),10,11,12);
         add(CoreAssetsManager.getClass("HS_Sound"),15);
         add(CoreAssetsManager.getClass("HY_Sound"),20,21,22);
         add(CoreAssetsManager.getClass("YX_Sound"),25,26,27);
         add(CoreAssetsManager.getClass("HEK_Sound"),30);
      }
      
      private static function add(_arg_1:Class, ... _args) : void
      {
         var _local_3:uint = 0;
         for each(_local_3 in _args)
         {
            dict["map_" + _local_3] = new _arg_1() as Sound;
         }
      }
      
      public static function set setIsPlay(_arg_1:Boolean) : void
      {
         isPlay_b = _arg_1;
      }
      
      public static function get getIsPlay() : Boolean
      {
         return isPlay_b;
      }
   }
}

