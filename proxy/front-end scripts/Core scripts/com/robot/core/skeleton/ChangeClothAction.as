package com.robot.core.skeleton
{
   import com.robot.core.info.clothInfo.*;
   import com.robot.core.info.item.*;
   import com.robot.core.mode.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.Point;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class ChangeClothAction
   {
      
      private static const B_S:Number = 0.2;
      
      private static const S_S:Number = 1;
      
      public static const GLOW_1:Array = [new GlowFilter(16777215,1,10,10,0.8),new GlowFilter(16776960,1,B_S,B_S,S_S)];
      
      public static const GLOW_2:Array = [new GlowFilter(16777215,1,10,10,0.8),new GlowFilter(16711680,1,B_S,B_S,S_S)];
      
      protected var clothID:int = 0;
      
      protected var clothLevel:uint = 0;
      
      protected var people:ISkeletonSprite;
      
      protected var clothSWF:MovieClip;
      
      protected var isLoaded:Boolean = false;
      
      protected var offsetPoint:Point;
      
      protected var container:Sprite;
      
      protected var type:String;
      
      protected var model:uint;
      
      private var _clothURL:String = "";
      
      public function ChangeClothAction(_arg_1:ISkeletonSprite, _arg_2:Sprite, _arg_3:String, _arg_4:uint)
      {
         super();
         this.model = _arg_4;
         this.type = _arg_3;
         this.people = _arg_1;
         this.container = _arg_2;
         this.takeOffCloth();
      }
      
      public function changeCloth(_arg_1:PeopleItemInfo) : void
      {
         if(ClothInfo.getItemInfo(_arg_1.id).type == "bg")
         {
            return;
         }
         this.clothID = _arg_1.id;
         this.clothLevel = _arg_1.level;
         this.beginLoad();
      }
      
      public function changeClothByPath(_arg_1:int, _arg_2:String) : void
      {
         this.clothID = _arg_1;
         this.beginLoad(_arg_2);
      }
      
      public function addChildCloth(_arg_1:MovieClip, _arg_2:Sprite) : void
      {
         this.clothSWF = _arg_1;
         this.container = _arg_2;
         this.clothSWF.cacheAsBitmap = true;
         if(Boolean(this.people))
         {
            this.clothSWF.gotoAndStop(this.people.direction);
         }
         if(Boolean(_arg_2))
         {
            _arg_2.addChild(this.clothSWF);
         }
         this.isLoaded = true;
      }
      
      public function takeOffCloth() : void
      {
         if(this.type == SkeletonClothPreview.FLAG_CLOTH)
         {
            return;
         }
         if(Boolean(this.clothSWF))
         {
            DisplayUtil.removeForParent(this.clothSWF);
            this.clothSWF = null;
            this.isLoaded = false;
            this.clothID = 0;
         }
         if(this.type == ClothPreview.FLAG_HEAD)
         {
            this.changeCloth(new PeopleItemInfo(ClothInfo.DEFAULT_HEAD));
         }
         else if(this.type == ClothPreview.FLAG_WAIST)
         {
            this.changeCloth(new PeopleItemInfo(ClothInfo.DEFAULT_WAIST));
         }
         else if(this.type == ClothPreview.FLAG_FOOT)
         {
            this.changeCloth(new PeopleItemInfo(ClothInfo.DEFAULT_FOOT));
         }
      }
      
      public function changeDir(_arg_1:String) : void
      {
         if(this.isLoaded)
         {
            this.clothSWF.gotoAndStop(_arg_1);
         }
      }
      
      public function specialAction(peopleMode:BasePeoleModel, id:uint, isCheckID:Boolean = true) : void
      {
         if(Boolean(this.clothSWF))
         {
            this.clothSWF.gotoAndStop(BasePeoleModel.SPECIAL_ACTION);
         }
         if(id == this.clothID && isCheckID)
         {
            this.clothSWF.addEventListener(Event.ENTER_FRAME,function():void
            {
               var _local_2:MovieClip = null;
               var _local_3:MovieClip = clothSWF.getChildByName("bodyMC") as MovieClip;
               if(Boolean(_local_3))
               {
                  _local_2 = _local_3["colorMC"];
                  DisplayUtil.FillColor(_local_2,peopleMode.info.color);
                  clothSWF.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               }
            });
         }
      }
      
      public function goStart() : void
      {
         var _local_1:MovieClip = null;
         if(Boolean(this.clothSWF))
         {
            _local_1 = this.clothSWF.getChildAt(0) as MovieClip;
            if(Boolean(_local_1))
            {
               _local_1.gotoAndPlay(2);
            }
         }
      }
      
      public function goOver() : void
      {
         var _local_1:MovieClip = null;
         if(Boolean(this.clothSWF))
         {
            _local_1 = this.clothSWF.getChildAt(0) as MovieClip;
            if(Boolean(_local_1))
            {
               _local_1.gotoAndStop(1);
            }
         }
      }
      
      public function goEnterFrame() : void
      {
         var _local_1:MovieClip = null;
         if(Boolean(this.clothSWF))
         {
            _local_1 = this.clothSWF.getChildAt(0) as MovieClip;
            if(Boolean(_local_1))
            {
               if(_local_1.currentFrame == 1)
               {
                  _local_1.gotoAndPlay(2);
               }
            }
         }
      }
      
      protected function beginLoad(_arg_1:String = "") : void
      {
         if(this._clothURL != "")
         {
            ResourceManager.cancel(this._clothURL,this.onLoadCloth);
         }
         if(_arg_1 == "")
         {
            switch(this.model)
            {
               case ClothPreview.MODEL_PEOPLE:
                  this._clothURL = ClothInfo.getItemInfo(this.clothID).getUrl(this.clothLevel);
                  break;
               case ClothPreview.MODEL_SHOW:
                  this._clothURL = ClothInfo.getItemInfo(this.clothID).getPrevUrl(this.clothLevel);
                  break;
               default:
                  this._clothURL = ClothInfo.getItemInfo(this.clothID).getUrl(this.clothLevel);
            }
         }
         else
         {
            this._clothURL = _arg_1;
         }
         ResourceManager.getResource(this._clothURL,this.onLoadCloth);
      }
      
      private function onLoadCloth(_arg_1:DisplayObject) : void
      {
         if(Boolean(this.clothSWF))
         {
            this.clothSWF.removeEventListener(MouseEvent.CLICK,this.unloadCloth);
            DisplayUtil.removeForParent(this.clothSWF);
         }
         this.clothSWF = _arg_1 as MovieClip;
         this.clothSWF.cacheAsBitmap = true;
         this.clothSWF.mouseChildren = false;
         this.clothSWF.addEventListener(MouseEvent.CLICK,this.unloadCloth);
         this.clothSWF.addEventListener(MouseEvent.MOUSE_OVER,this.onClothOver);
         this.clothSWF.addEventListener(MouseEvent.MOUSE_OUT,this.onClothOut);
         if(Boolean(this.people))
         {
            this.clothSWF.gotoAndStop(this.people.direction);
         }
         if(Boolean(this.container))
         {
            this.container.addChild(this.clothSWF);
         }
         this.isLoaded = true;
      }
      
      protected function unloadCloth(_arg_1:MouseEvent) : void
      {
      }
      
      protected function onClothOver(_arg_1:MouseEvent) : void
      {
         (_arg_1.currentTarget as DisplayObject).filters = [new GlowFilter()];
      }
      
      protected function onClothOut(_arg_1:MouseEvent) : void
      {
         (_arg_1.currentTarget as DisplayObject).filters = [];
      }
      
      public function getClothLevel() : uint
      {
         return this.clothLevel;
      }
      
      public function getClothID() : int
      {
         var _local_1:uint = 0;
         if(this.clothID == ClothInfo.DEFAULT_FOOT || this.clothID == ClothInfo.DEFAULT_HEAD || this.clothID == ClothInfo.DEFAULT_WAIST)
         {
            _local_1 = 0;
         }
         else
         {
            _local_1 = uint(this.clothID);
         }
         return _local_1;
      }
   }
}

