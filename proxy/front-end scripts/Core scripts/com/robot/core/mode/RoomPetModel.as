package com.robot.core.mode
{
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.info.pet.PetListInfo;
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.events.Event;
   import flash.filters.*;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class RoomPetModel extends BobyModel
   {
      
      private var _info:PetListInfo;
      
      private var _obj:MovieClip;
      
      private var _inTime:uint;
      
      private var _dialogTime:uint;
      
      protected var filte:GlowFilter = new GlowFilter(3355443,0.9,3,3,3.1);
      
      public function RoomPetModel(_arg_1:PetListInfo)
      {
         super();
         buttonMode = true;
         mouseChildren = false;
         _speed = 2;
         this._info = _arg_1;
      }
      
      override public function get width() : Number
      {
         if(Boolean(this._obj))
         {
            return this._obj.width;
         }
         return super.width;
      }
      
      override public function get height() : Number
      {
         if(Boolean(this._obj))
         {
            return this._obj.height;
         }
         return super.height;
      }
      
      public function get info() : PetListInfo
      {
         return this._info;
      }
      
      override public function set direction(_arg_1:String) : void
      {
         if(_arg_1 == null || _arg_1 == "")
         {
            return;
         }
         if(Boolean(this._obj))
         {
            this._obj.gotoAndStop(_arg_1);
         }
      }
      
      override public function get centerPoint() : Point
      {
         _centerPoint.x = x;
         _centerPoint.y = y - 10;
         return _centerPoint;
      }
      
      override public function get hitRect() : Rectangle
      {
         _hitRect.x = x - this.width / 2;
         _hitRect.y = y - this.height;
         _hitRect.width = this.width;
         _hitRect.height = this.height;
         return _hitRect;
      }
      
      public function show(_arg_1:Point) : void
      {
         if(Boolean(this._obj))
         {
            return;
         }
         pos = _arg_1;
         ResourceManager.getResource(ClientConfig.getPetSwfPath(this._info.skinID != 0 ? this.info.skinID : this._info.id),this.onLoad,"pet");
      }
      
      override public function destroy() : void
      {
         clearInterval(this._dialogTime);
         super.destroy();
         removeEventListener(RobotEvent.WALK_START,this.onWalkStart);
         removeEventListener(RobotEvent.WALK_END,this.onWalkOver);
         ResourceManager.cancel(ClientConfig.getPetSwfPath(this._info.skinID != 0 ? this.info.skinID : this._info.id),this.onLoad);
         DisplayUtil.removeForParent(this);
         this._obj = null;
      }
      
      override public function aimatState(_arg_1:AimatInfo) : void
      {
      }
      
      private function onLoad(_arg_1:DisplayObject) : void
      {
         var _local_2:ColorMatrixFilter = null;
         var _local_3:Array = null;
         var _local_4:GlowFilter = null;
         var _local_5:Array = null;
         this._obj = _arg_1 as MovieClip;
         this._obj.gotoAndStop(_direction);
         addChild(this._obj);
         if(this._info.isshiny != 0)
         {
            this._obj.filters = [this.filte,this._info.shiny.GetGlowFilter,this._info.shiny.GetColorMatrixFilter];
         }
         MapManager.currentMap.depthLevel.addChild(this);
         starAutoWalk(2000);
         MovieClipUtil.childStop(this._obj,1);
         addEventListener(RobotEvent.WALK_START,this.onWalkStart);
         addEventListener(RobotEvent.WALK_END,this.onWalkOver);
         if(Boolean(NonoManager.info))
         {
            if(Boolean(NonoManager.info.func[9]))
            {
               clearInterval(this._dialogTime);
               this._dialogTime = setInterval(this.onAutoDialog,MathUtil.randomHalfAdd(20000));
            }
         }
      }
      
      private function onAutoDialog() : void
      {
         var _local_1:String = MovesLangXMLInfo.getRandomLang(this._info.id);
         if(_local_1 != "")
         {
            showBox(_local_1);
         }
      }
      
      private function onWalkStart(_arg_1:Event) : void
      {
         var _local_2:MovieClip = null;
         if(Boolean(this._obj))
         {
            _local_2 = this._obj.getChildAt(0) as MovieClip;
            if(Boolean(_local_2))
            {
               if(_local_2.currentFrame == 1)
               {
                  _local_2.gotoAndPlay(2);
               }
            }
         }
      }
      
      private function onWalkOver(_arg_1:Event) : void
      {
         if(Boolean(this._obj))
         {
            MovieClipUtil.childStop(this._obj,1);
         }
      }
   }
}

