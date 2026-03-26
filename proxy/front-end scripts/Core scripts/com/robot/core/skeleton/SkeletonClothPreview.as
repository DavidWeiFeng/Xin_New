package com.robot.core.skeleton
{
   import com.robot.core.info.item.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   
   public class SkeletonClothPreview extends ClothPreview
   {
      
      public static var FLAG_CLOTH:String = "cloth";
      
      private var defaultCloth:MovieClip;
      
      public function SkeletonClothPreview(_arg_1:MovieClip, _arg_2:ISkeletonSprite = null)
      {
         super(_arg_1,_arg_2);
      }
      
      override protected function getFlagArray() : Array
      {
         return new Array(FLAG_TOP,FLAG_HEAD,FLAG_EYE,FLAG_HAND,FLAG_WAIST,FLAG_DECORATOR,FLAG_FOOT,FLAG_BG,FLAG_CLOTH);
      }
      
      public function changeDefaultCloth() : void
      {
         this.defaultCloth = UIManager.getMovieClip("defaultCloth");
         var _local_1:ChangeClothAction = changeClothActObj[FLAG_CLOTH];
         _local_1.addChildCloth(this.defaultCloth,composeMC[FLAG_CLOTH]);
      }
      
      public function play() : void
      {
         var _local_1:ChangeClothAction = null;
         var _local_2:MovieClip = null;
         var _local_3:MovieClip = null;
         var _local_4:MovieClip = colorMC.getChildAt(0) as MovieClip;
         if(Boolean(_local_4))
         {
            _local_4.gotoAndPlay(2);
         }
         if(doodleMC.numChildren > 0)
         {
            _local_2 = doodleMC.getChildAt(0) as MovieClip;
            if(Boolean(_local_2))
            {
               _local_3 = _local_2.getChildAt(0) as MovieClip;
               if(Boolean(_local_3))
               {
                  _local_3.gotoAndPlay(2);
               }
            }
         }
         for each(_local_1 in changeClothActObj)
         {
            _local_1.goStart();
         }
      }
      
      public function stop() : void
      {
         var _local_1:ChangeClothAction = null;
         var _local_2:MovieClip = null;
         var _local_3:MovieClip = null;
         if(colorMC.numChildren == 0)
         {
            return;
         }
         var _local_4:MovieClip = colorMC.getChildAt(0) as MovieClip;
         if(Boolean(_local_4))
         {
            _local_4.gotoAndStop(1);
         }
         if(doodleMC.numChildren > 0)
         {
            _local_2 = doodleMC.getChildAt(0) as MovieClip;
            if(Boolean(_local_2))
            {
               _local_3 = _local_2.getChildAt(0) as MovieClip;
               if(Boolean(_local_3))
               {
                  _local_3.gotoAndStop(1);
               }
            }
         }
         for each(_local_1 in changeClothActObj)
         {
            _local_1.goOver();
         }
      }
      
      public function onEnterFrame() : void
      {
         var _local_1:ChangeClothAction = null;
         var _local_2:MovieClip = null;
         var _local_3:MovieClip = null;
         var _local_4:MovieClip = colorMC.getChildAt(0) as MovieClip;
         if(Boolean(_local_4))
         {
            if(_local_4.currentFrame == 1)
            {
               _local_4.gotoAndPlay(2);
            }
         }
         if(doodleMC.numChildren > 0)
         {
            _local_2 = doodleMC.getChildAt(0) as MovieClip;
            if(Boolean(_local_2))
            {
               _local_3 = _local_2.getChildAt(0) as MovieClip;
               if(Boolean(_local_3))
               {
                  if(_local_3.currentFrame == 1)
                  {
                     _local_3.gotoAndPlay(2);
                  }
               }
            }
         }
         for each(_local_1 in changeClothActObj)
         {
            _local_1.goEnterFrame();
         }
      }
      
      override public function changeCloth(_arg_1:Array) : void
      {
         super.changeCloth(_arg_1);
         colorMC.gotoAndStop(people.direction);
         this.defaultCloth.gotoAndStop(people.direction);
      }
      
      public function changeDirection(_arg_1:String) : void
      {
         var _local_2:ChangeClothAction = null;
         var _local_3:MovieClip = null;
         colorMC.gotoAndStop(_arg_1);
         if(doodleMC.numChildren > 0)
         {
            _local_3 = doodleMC.getChildAt(0) as MovieClip;
            if(Boolean(_local_3))
            {
               _local_3.gotoAndStop(_arg_1);
            }
         }
         for each(_local_2 in changeClothActObj)
         {
            _local_2.changeDir(_arg_1);
         }
      }
      
      public function specialAction(_arg_1:BasePeoleModel, _arg_2:int) : void
      {
         var _local_3:String = null;
         var _local_4:ChangeClothAction = null;
         var _local_5:ChangeClothAction = null;
         var _local_6:ClothData = ClothInfo.getItemInfo(_arg_2);
         var _local_7:int = _local_6.actionDir;
         if(_local_7 != -1)
         {
            _local_3 = _local_6.type;
            people.direction = Direction.indexToStr(_local_7);
            _local_4 = changeClothActObj[_local_3];
            _local_4.specialAction(_arg_1,_arg_2,false);
         }
         else
         {
            colorMC.gotoAndStop(BasePeoleModel.SPECIAL_ACTION);
            for each(_local_5 in changeClothActObj)
            {
               _local_5.specialAction(_arg_1,_arg_2);
            }
         }
      }
   }
}

