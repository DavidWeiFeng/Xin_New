package com.robot.core.skeleton
{
   import com.robot.core.info.clothInfo.*;
   import com.robot.core.info.item.*;
   import com.robot.core.mode.ISkeletonSprite;
   import flash.display.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class ClothPreview
   {
      
      public static const MODEL_PEOPLE:uint = 0;
      
      public static const MODEL_SHOW:uint = 1;
      
      public static const FLAG_TOP:String = "top";
      
      public static const FLAG_HEAD:String = "head";
      
      public static const FLAG_EYE:String = "eye";
      
      public static const FLAG_HAND:String = "hand";
      
      public static const FLAG_WAIST:String = "waist";
      
      public static const FLAG_DECORATOR:String = "decorator";
      
      public static const FLAG_FOOT:String = "foot";
      
      public static const FLAG_BG:String = "bg";
      
      public static const FLAG_COLOR:String = "color";
      
      protected var skeletonMC:MovieClip;
      
      protected var composeMC:Sprite;
      
      protected var colorMC:MovieClip;
      
      protected var doodleMC:MovieClip;
      
      protected var people:ISkeletonSprite;
      
      protected var mcObj:Object;
      
      protected var changeClothActObj:Object;
      
      protected var flagArray:Array;
      
      protected var model:uint;
      
      public function ClothPreview(_arg_1:Sprite, _arg_2:ISkeletonSprite = null, _arg_3:uint = 0)
      {
         var _local_4:String = null;
         this.mcObj = {};
         this.changeClothActObj = {};
         super();
         this.model = _arg_3;
         this.people = _arg_2;
         this.flagArray = this.getFlagArray();
         this.composeMC = _arg_1;
         this.colorMC = this.composeMC[FLAG_COLOR];
         this.colorMC.gotoAndStop(1);
         this.doodleMC = this.composeMC[FLAG_DECORATOR];
         this.doodleMC.gotoAndStop(1);
         for each(_local_4 in this.flagArray)
         {
            this.mcObj[_local_4] = this.composeMC[_local_4];
         }
         this.initChangeCloth();
      }
      
      public function getClothArray() : Array
      {
         var _local_1:ChangeClothAction = null;
         var _local_2:Array = [];
         for each(_local_1 in this.changeClothActObj)
         {
            if(_local_1.getClothID() > 0)
            {
               _local_2.push(new PeopleItemInfo(_local_1.getClothID(),_local_1.getClothLevel()));
            }
         }
         return _local_2;
      }
      
      public function getClothIDs() : Array
      {
         var _local_1:PeopleItemInfo = null;
         var _local_2:Array = [];
         var _local_3:Array = this.getClothArray();
         for each(_local_1 in _local_3)
         {
            _local_2.push(_local_1.id);
         }
         return _local_2;
      }
      
      public function getClothStr() : String
      {
         var _local_1:PeopleItemInfo = null;
         var _local_2:Array = this.getClothArray();
         var _local_3:Array = [];
         for each(_local_1 in _local_2)
         {
            _local_3.push(_local_1.id);
         }
         return _local_3.sort().join(",");
      }
      
      public function takeOffCloth() : void
      {
         var _local_1:ChangeClothAction = null;
         for each(_local_1 in this.changeClothActObj)
         {
            _local_1.takeOffCloth();
         }
      }
      
      protected function getFlagArray() : Array
      {
         return new Array(FLAG_TOP,FLAG_HEAD,FLAG_EYE,FLAG_HAND,FLAG_WAIST,FLAG_DECORATOR,FLAG_FOOT,FLAG_BG);
      }
      
      public function changeCloth(_arg_1:Array) : void
      {
         var _local_2:PeopleItemInfo = null;
         var _local_3:String = null;
         var _local_4:ChangeClothAction = null;
         for each(_local_2 in _arg_1)
         {
            _local_3 = ClothInfo.getItemInfo(_local_2.id).type;
            _local_4 = this.changeClothActObj[_local_3];
            _local_4.changeCloth(_local_2);
         }
      }
      
      public function changeColor(_arg_1:uint, _arg_2:Boolean = true) : void
      {
         DisplayUtil.FillColor(this.colorMC,_arg_1);
         if(_arg_2)
         {
            DisplayUtil.removeAllChild(this.doodleMC);
         }
      }
      
      public function changeDoodle(url:String) : void
      {
         DisplayUtil.removeAllChild(this.doodleMC);
         ResourceManager.getResource(url,function(_arg_1:DisplayObject):void
         {
            (_arg_1 as MovieClip).gotoAndStop(people.direction);
            doodleMC.addChild(_arg_1);
         });
      }
      
      protected function initChangeCloth() : void
      {
         var _local_1:String = null;
         var _local_2:ChangeClothAction = null;
         for each(_local_1 in this.flagArray)
         {
            _local_2 = new ChangeClothAction(this.people,this.mcObj[_local_1],_local_1,this.model);
            this.changeClothActObj[_local_1] = _local_2;
         }
      }
      
      public function destroy() : void
      {
         this.skeletonMC = null;
         this.composeMC = null;
         this.colorMC = null;
         this.doodleMC = null;
         this.people = null;
         this.mcObj = null;
         this.changeClothActObj = null;
      }
   }
}

