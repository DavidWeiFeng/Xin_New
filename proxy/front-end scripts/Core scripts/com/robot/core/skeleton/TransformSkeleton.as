package com.robot.core.skeleton
{
   import com.robot.core.*;
   import com.robot.core.aimat.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.UserInfo;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import com.robot.core.net.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import flash.media.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class TransformSkeleton implements ISkeleton
   {
      
      private var _people:ISkeletonSprite;
      
      private var box:Sprite;
      
      private var _info:UserInfo;
      
      private var skeletonMC:MovieClip;
      
      private var movie:MovieClip;
      
      private var sound:Sound;
      
      public function TransformSkeleton()
      {
         super();
         this.box = new Sprite();
         this.box.buttonMode = true;
         this.box.mouseChildren = false;
         this.box.mouseEnabled = false;
      }
      
      public function set people(_arg_1:ISkeletonSprite) : void
      {
         this._people = _arg_1;
         this._people.direction = Direction.DOWN;
         this._people.sprite.addChild(this.box);
      }
      
      public function get people() : ISkeletonSprite
      {
         return this._people;
      }
      
      public function getSkeletonMC() : MovieClip
      {
         return this.skeletonMC;
      }
      
      public function destroy() : void
      {
         this.sound = null;
         DisplayUtil.removeForParent(this.movie);
         DisplayUtil.removeForParent(this.skeletonMC);
         this._people = null;
         this.movie = null;
         this.skeletonMC = null;
         this.box = null;
      }
      
      public function getBodyMC() : MovieClip
      {
         return this.skeletonMC;
      }
      
      public function set info(_arg_1:UserInfo) : void
      {
         this._info = _arg_1;
         var _local_2:uint = _arg_1.changeShape;
         ResourceManager.getResourceList(ClientConfig.getTransformMovieUrl(_arg_1.changeShape),this.onLoadMovie,["item","sound"]);
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.TRANSFORM_START));
      }
      
      public function play() : void
      {
         if(Boolean(this.skeletonMC))
         {
            this.skeletonMC.addEventListener(Event.ENTER_FRAME,function(_arg_1:Event):void
            {
               var _local_3:MovieClip = skeletonMC.getChildAt(0) as MovieClip;
               if(Boolean(_local_3))
               {
                  skeletonMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  _local_3.gotoAndPlay(2);
               }
            });
         }
      }
      
      public function stop() : void
      {
         if(Boolean(this.skeletonMC))
         {
            this.skeletonMC.addEventListener(Event.ENTER_FRAME,function(_arg_1:Event):void
            {
               var _local_3:MovieClip = skeletonMC.getChildAt(0) as MovieClip;
               if(Boolean(_local_3))
               {
                  skeletonMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  _local_3.gotoAndPlay(1);
               }
            });
         }
      }
      
      public function changeDirection(_arg_1:String) : void
      {
         if(Boolean(this.skeletonMC))
         {
            this.skeletonMC.gotoAndStop(_arg_1);
         }
      }
      
      public function changeCloth(_arg_1:Array) : void
      {
      }
      
      public function takeOffCloth() : void
      {
      }
      
      public function changeColor(_arg_1:uint, _arg_2:Boolean = true) : void
      {
      }
      
      public function changeDoodle(_arg_1:String) : void
      {
      }
      
      public function specialAction(_arg_1:BasePeoleModel, _arg_2:int) : void
      {
      }
      
      public function untransform() : void
      {
         var mc:MovieClip = null;
         mc = null;
         if(Boolean(this.sound))
         {
            this.sound.play(0,1);
         }
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.TRANSFORM_START));
         this._people.direction = Direction.DOWN;
         DisplayUtil.removeForParent(this.skeletonMC);
         if(Boolean(this.movie))
         {
            this._people.sprite.addChild(this.movie);
            mc = this.movie["mc"];
            mc.addEventListener(Event.ENTER_FRAME,function():void
            {
               if(mc.currentFrame > 1)
               {
                  mc.prevFrame();
               }
               else
               {
                  mc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  if(_people == MainManager.actorModel)
                  {
                     SocketConnection.send(CommandID.PEOPLE_TRANSFROM,0);
                     EventManager.dispatchEvent(new RobotEvent(RobotEvent.TRANSFORM_OVER));
                  }
                  (_people as BasePeoleModel).skeleton = new EmptySkeletonStrategy();
                  AimatController.setClothType(MainManager.actorInfo.clothIDs);
               }
            });
         }
         else
         {
            if(this._people == MainManager.actorModel)
            {
               SocketConnection.send(CommandID.PEOPLE_TRANSFROM,0);
               EventManager.dispatchEvent(new RobotEvent(RobotEvent.TRANSFORM_OVER));
            }
            (this._people as BasePeoleModel).skeleton = new EmptySkeletonStrategy();
            AimatController.setClothType(MainManager.actorInfo.clothIDs);
         }
      }
      
      private function onLoadMovie(_arg_1:Array) : void
      {
         this.movie = _arg_1[0] as MovieClip;
         this.sound = _arg_1[1] as Sound;
         this.loadSWF();
      }
      
      private function loadSWF() : void
      {
         ResourceManager.getResource(ClientConfig.getTransformClothUrl(this._info.changeShape),this.onLoadSWF);
      }
      
      private function onLoadSWF(_arg_1:DisplayObject) : void
      {
         this.skeletonMC = _arg_1 as MovieClip;
         this.transform();
      }
      
      private function transform() : void
      {
         var mc:MovieClip = null;
         mc = null;
         AimatController.setClothType(MainManager.actorInfo.clothIDs);
         if(Boolean(this.sound))
         {
            this.sound.play(0,1);
         }
         this._people.clearOldSkeleton();
         this.people.sprite.addChild(this.movie);
         mc = this.movie["mc"];
         mc.gotoAndPlay(2);
         mc.addEventListener(Event.ENTER_FRAME,function():void
         {
            if(mc.currentFrame == mc.totalFrames)
            {
               stop();
               mc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               DisplayUtil.removeForParent(movie);
               box.addChild(skeletonMC);
               (_people as BasePeoleModel).speed = SuitXMLInfo.getSuitTranSpeed(_info.changeShape);
               EventManager.dispatchEvent(new RobotEvent(RobotEvent.TRANSFORM_OVER));
            }
         });
      }
   }
}

