package com.robot.core.manager
{
   import com.robot.core.effect.shotBehavior.EmptyBehavior;
   import com.robot.core.effect.shotBehavior.IShotBehavior;
   import com.robot.core.effect.shotBehavior.LaserBehavior;
   import com.robot.core.effect.shotBehavior.LightBehavior;
   import com.robot.core.effect.shotBehavior.MissileBehavior;
   import com.robot.core.effect.shotBehavior.ShotEffect_143_2;
   import com.robot.core.effect.shotBehavior.ShotEffect_143_3;
   import com.robot.core.effect.shotBehavior.ShotEffect_143_4;
   import com.robot.core.effect.shotBehavior.ShotEffect_144_2;
   import com.robot.core.effect.shotBehavior.ShotEffect_144_3;
   import com.robot.core.effect.shotBehavior.ShotEffect_144_4;
   import com.robot.core.effect.shotBehavior.ShotEffect_1_4;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.Utils;
   
   public class ShotBehaviorManager
   {
      
      private static var _loader:Loader;
      
      private static var hashMap:HashMap = new HashMap();
      
      public function ShotBehaviorManager()
      {
         super();
      }
      
      public static function setup(_arg_1:Loader) : void
      {
         _loader = _arg_1;
         addBehavior(1,2,LightBehavior);
         addBehavior(1,3,LightBehavior);
         addBehavior(1,4,ShotEffect_1_4);
         addBehavior(141,2,LaserBehavior);
         addBehavior(141,3,LaserBehavior);
         addBehavior(141,4,LaserBehavior);
         addBehavior(142,2,MissileBehavior);
         addBehavior(142,3,MissileBehavior);
         addBehavior(142,4,MissileBehavior);
         addBehavior(143,2,ShotEffect_143_2);
         addBehavior(143,3,ShotEffect_143_3);
         addBehavior(143,4,ShotEffect_143_4);
         addBehavior(144,2,ShotEffect_144_2);
         addBehavior(144,3,ShotEffect_144_3);
         addBehavior(144,4,ShotEffect_144_4);
      }
      
      public static function addBehavior(_arg_1:uint, _arg_2:uint, _arg_3:Class) : void
      {
         hashMap.add(_arg_1 + "_" + _arg_2,_arg_3);
      }
      
      public static function removeBehavior(_arg_1:uint) : void
      {
         hashMap.remove(_arg_1);
      }
      
      public static function getBehavior(_arg_1:uint, _arg_2:uint) : IShotBehavior
      {
         var _local_3:Class = hashMap.getValue(_arg_1 + "_" + _arg_2);
         if(_local_3 == null)
         {
            return new EmptyBehavior();
         }
         return new _local_3() as IShotBehavior;
      }
      
      public static function getMovieClip(_arg_1:String) : MovieClip
      {
         return Utils.getMovieClipFromLoader(_arg_1,_loader);
      }
      
      public static function getButton(_arg_1:String) : SimpleButton
      {
         return Utils.getSimpleButtonFromLoader(_arg_1,_loader);
      }
   }
}

