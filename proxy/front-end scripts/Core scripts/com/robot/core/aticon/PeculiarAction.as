package com.robot.core.aticon
{
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.net.*;
   import com.robot.core.skeleton.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import gs.*;
   import gs.easing.*;
   
   public class PeculiarAction
   {
      
      public function PeculiarAction()
      {
         super();
      }
      
      public function execute(obj:BasePeoleModel, dir:String, isNet:Boolean = true) : void
      {
         var bodyMCArray:Array = null;
         var compose:MovieClip = null;
         var id:uint = 0;
         var skeleton:EmptySkeletonStrategy = null;
         var num:uint = 0;
         var i:uint = 0;
         var mc:MovieClip = null;
         bodyMCArray = null;
         compose = null;
         if(isNet)
         {
            SocketConnection.send(CommandID.DANCE_ACTION,10001,Direction.strToIndex(obj.direction));
         }
         else
         {
            id = SpecialXMLInfo.getSpecialID(obj.info.clothIDs);
            if(id > 0)
            {
               obj.stop();
               obj.specialAction(id);
               return;
            }
            bodyMCArray = [];
            obj.sprite.addEventListener(RobotEvent.WALK_START,function(_arg_1:RobotEvent):void
            {
               var _local_3:MovieClip = null;
               obj.sprite.removeEventListener(RobotEvent.WALK_START,arguments.callee);
               for each(_local_3 in bodyMCArray)
               {
                  TweenLite.to(_local_3,0.2,{
                     "alpha":1,
                     "scaleX":1,
                     "scaleY":1
                  });
               }
               TweenLite.to(compose,0.5,{
                  "y":-21.4,
                  "ease":Bounce.easeOut
               });
            });
            obj.stop();
            obj.direction = dir;
            skeleton = obj.skeleton as EmptySkeletonStrategy;
            compose = skeleton.getBodyMC();
            num = uint(compose.numChildren);
            i = 0;
            while(i < num)
            {
               mc = compose.getChildAt(i) as MovieClip;
               if(mc.name != "cloth" && mc.name != "color" && mc.name != "waist" && mc.name != "head" && mc.name != "decorator")
               {
                  bodyMCArray.push(mc);
                  TweenLite.to(mc,0.2,{
                     "alpha":0,
                     "scaleX":0,
                     "scaleY":0
                  });
               }
               i++;
            }
            TweenLite.to(compose,0.5,{
               "y":-8,
               "ease":Bounce.easeOut
            });
         }
      }
      
      public function keepUp(param1:EmptySkeletonStrategy, param2:Number) : void
      {
         var _loc3_:MovieClip = null;
         if(param1 == null)
         {
            return;
         }
         var _loc4_:MovieClip = param1.getBodyMC();
         var _loc5_:uint = uint(_loc4_.numChildren);
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = _loc4_.getChildAt(_loc6_) as MovieClip;
            if(_loc3_.name != "cloth" && _loc3_.name != "color" && _loc3_.name != "waist" && _loc3_.name != "head" && _loc3_.name != "decorator")
            {
               TweenLite.to(_loc3_,0.2,{
                  "alpha":0,
                  "scaleX":0,
                  "scaleY":0
               });
            }
            _loc6_++;
         }
         TweenLite.to(_loc4_,0.2,{
            "y":param2,
            "ease":Bounce.easeOut
         });
         if(Boolean(param1.people))
         {
            (param1.people as BasePeoleModel).topIconY = param2 - 48.6;
         }
      }
      
      public function keepDown(_arg_1:EmptySkeletonStrategy) : void
      {
         var _local_2:MovieClip = null;
         var _local_5:uint = 0;
         if(!_arg_1)
         {
            return;
         }
         var _local_3:MovieClip = _arg_1.getBodyMC();
         var _local_4:uint = uint(_local_3.numChildren);
         while(_local_5 < _local_4)
         {
            _local_2 = _local_3.getChildAt(_local_5) as MovieClip;
            if(_local_2.name != "cloth" && _local_2.name != "color" && _local_2.name != "waist" && _local_2.name != "head" && _local_2.name != "decorator")
            {
               TweenLite.to(_local_2,0.2,{
                  "alpha":0,
                  "scaleX":0,
                  "scaleY":0
               });
            }
            _local_5++;
         }
         TweenLite.to(_local_3,0.5,{
            "y":-8,
            "ease":Bounce.easeOut
         });
      }
      
      public function standUp(_arg_1:EmptySkeletonStrategy) : void
      {
         var _local_2:MovieClip = null;
         var _local_5:uint = 0;
         var _local_3:MovieClip = _arg_1.getBodyMC();
         var _local_4:uint = uint(_local_3.numChildren);
         while(_local_5 < _local_4)
         {
            _local_2 = _local_3.getChildAt(_local_5) as MovieClip;
            if(_local_2.name != "cloth" && _local_2.name != "color" && _local_2.name != "waist" && _local_2.name != "head" && _local_2.name != "decorator")
            {
               TweenLite.to(_local_2,0.2,{
                  "alpha":1,
                  "scaleX":1,
                  "scaleY":1
               });
            }
            _local_5++;
         }
         TweenLite.to(_local_3,0.5,{
            "y":-21.4,
            "ease":Bounce.easeOut
         });
      }
   }
}

