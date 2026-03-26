package com.robot.core.effect.shotBehavior
{
   import com.robot.core.manager.*;
   import com.robot.core.mode.PKArmModel;
   import com.robot.core.mode.SpriteModel;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.utils.*;
   import org.taomee.utils.*;
   
   public class ShotEffect_144_2 implements IShotBehavior
   {
      
      private var modelMC:MovieClip;
      
      private var bombMC:MovieClip;
      
      private var people:SpriteModel;
      
      private var armModel:PKArmModel;
      
      private var amc:Shape = new Shape();
      
      private var isP:Boolean = false;
      
      private var movPos:Point;
      
      private var startPos:Point;
      
      private var endPos:Point;
      
      private var speedPos:Point;
      
      private var color:uint = 65280;
      
      private var _speed:Number = 100;
      
      public function ShotEffect_144_2()
      {
         super();
         this.modelMC = ShotBehaviorManager.getMovieClip("shotEffect_144_2");
         this.bombMC = ShotBehaviorManager.getMovieClip("boomEffect_144");
         this.modelMC.gotoAndStop(1);
         this.bombMC.gotoAndStop(1);
      }
      
      public function shot(_arg_1:PKArmModel, _arg_2:SpriteModel) : void
      {
         this.armModel = _arg_1;
         this.people = _arg_2;
         var _local_3:Rectangle = _arg_1.getRect(_arg_1);
         if(_arg_1.isMirror)
         {
            this.modelMC.x = -_local_3.x;
            this.modelMC.scaleX = -1;
         }
         else
         {
            this.modelMC.x = _local_3.x;
            this.modelMC.scaleX = 1;
         }
         this.modelMC.y = _local_3.y;
         _arg_1.container.addChild(this.modelMC);
         _arg_1.hideBmp();
         this.modelMC.gotoAndPlay(2);
         setTimeout(this.showLight,2400);
      }
      
      private function showLight() : void
      {
         this.armModel.showBmp();
         DisplayUtil.removeForParent(this.modelMC);
         this.startPos = new Point(this.armModel.x,this.armModel.y - 55);
         this.endPos = new Point(this.people.x,this.people.y);
         if(Point.distance(this.startPos,this.endPos) < this._speed / 2)
         {
            return;
         }
         this.speedPos = GeomUtil.angleSpeed(this.startPos,this.endPos);
         this.speedPos.x *= this._speed;
         this.speedPos.y *= this._speed;
         this.amc = new Shape();
         this.amc.filters = [new GlowFilter(this.color)];
         MapManager.currentMap.depthLevel.addChild(this.amc);
         this.movPos = this.startPos.clone();
         this.amc.addEventListener(Event.ENTER_FRAME,this.onEnter);
      }
      
      private function showBoom() : void
      {
         if(Boolean(this.amc))
         {
            this.amc.removeEventListener(Event.ENTER_FRAME,this.onEnter);
         }
         DisplayUtil.removeForParent(this.amc);
         this.bombMC.x = this.people.x;
         this.bombMC.y = this.people.y;
         MapManager.currentMap.depthLevel.addChild(this.bombMC);
         this.bombMC.gotoAndPlay(2);
         setTimeout(function():void
         {
            DisplayUtil.removeForParent(bombMC);
         },1500);
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this.modelMC);
         DisplayUtil.removeForParent(this.bombMC);
         this.modelMC = null;
         this.bombMC = null;
         this.people = null;
         this.armModel = null;
         if(Boolean(this.amc))
         {
            this.amc.removeEventListener(Event.ENTER_FRAME,this.onEnter);
            DisplayUtil.removeForParent(this.amc);
            this.amc = null;
         }
         this.movPos = null;
         this.speedPos = null;
      }
      
      private function onEnter(_arg_1:Event) : void
      {
         this.amc.graphics.clear();
         if(Point.distance(this.movPos,this.endPos) < this._speed / 2)
         {
            if(this.isP)
            {
               this.amc.removeEventListener(Event.ENTER_FRAME,this.onEnter);
               DisplayUtil.removeForParent(this.amc);
               this.isP = false;
               return;
            }
            this.isP = true;
            this.movPos = this.startPos.clone();
            this.showBoom();
         }
         this.amc.graphics.lineStyle(4,16777215);
         if(this.isP)
         {
            this.amc.graphics.moveTo(this.endPos.x,this.endPos.y);
            this.amc.graphics.lineTo(this.movPos.x,this.movPos.y);
         }
         else
         {
            this.amc.graphics.moveTo(this.startPos.x,this.startPos.y);
            this.amc.graphics.lineTo(this.movPos.x,this.movPos.y);
         }
         this.movPos = this.movPos.subtract(this.speedPos);
      }
   }
}

