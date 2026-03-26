package com.robot.core.mode
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.pet.PetShowInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.pet.PetInfoController;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.MovieClipUtil;
   
   public class PetModel extends ActionSpriteModel
   {
      
      public static const MAX:int = 40;
      
      private var _people:ActionSpriteModel;
      
      private var _petMc:MovieClip;
      
      private var _info:PetShowInfo;
      
      private var _petLight:MovieClip;
      
      protected var filte:GlowFilter = new GlowFilter(3355443,0.9,3,3,3.1);
      
      public function PetModel(_arg_1:ActionSpriteModel)
      {
         super();
         _speed = 3;
         this._people = _arg_1;
         buttonMode = true;
      }
      
      public function get info() : PetShowInfo
      {
         return this._info;
      }
      
      override public function set direction(_arg_1:String) : void
      {
         if(_arg_1 == null || _arg_1 == "")
         {
            return;
         }
         if(Boolean(this._petMc))
         {
            this._petMc.gotoAndStop(_arg_1);
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
         _hitRect.x = x - width / 2;
         _hitRect.y = y - height;
         _hitRect.width = width;
         _hitRect.height = height;
         return _hitRect;
      }
      
      public function setVisible(_arg_1:Boolean) : void
      {
         if(Boolean(this._petMc))
         {
            this._petMc.visible = _arg_1;
         }
      }
      
      public function show(_arg_1:PetShowInfo) : void
      {
         this._info = _arg_1;
         x = this._people.x + 40;
         y = this._people.y + 5;
         MapManager.currentMap.depthLevel.addChild(this);
         this.addEvent();
         if(Boolean(this._petMc))
         {
            this.bright();
            if(_arg_1.userID != MainManager.actorID && UserManager._hideOtherUserModelFlag)
            {
               this.visible = false;
            }
            return;
         }
         ResourceManager.getResource(ClientConfig.getPetSwfPath(this._info.skinID != 0 ? this._info.skinID : this._info.petID),this.onLoad,"pet");
         if(_arg_1.userID != MainManager.actorID && UserManager._hideOtherUserModelFlag)
         {
            this.visible = false;
         }
      }
      
      public function hide() : void
      {
         this.removeEvent();
         DisplayUtil.removeForParent(this);
      }
      
      public function bright() : void
      {
         this.removeBright();
         if(this._info.dv == 31 && Boolean(this._petMc))
         {
            this._petLight = UIManager.getMovieClip("PetBright_MC");
            this._petMc.addChildAt(this._petLight,0);
         }
      }
      
      public function removeBright() : void
      {
         if(Boolean(this._petLight))
         {
            DisplayUtil.removeForParent(this._petLight);
            this._petLight = null;
         }
      }
      
      public function walkAction(_arg_1:Object) : void
      {
         if(this._people == null)
         {
            return;
         }
         _walk.execute(this,_arg_1,false);
      }
      
      override public function destroy() : void
      {
         ResourceManager.cancel(ClientConfig.getPetSwfPath(this._info.skinID != 0 ? this._info.skinID : this._info.petID),this.onLoad);
         super.destroy();
         this.hide();
         this._people = null;
         if(Boolean(this._petMc))
         {
            this._petMc = null;
         }
      }
      
      private function onLoad(_arg_1:DisplayObject) : void
      {
         var _local_2:ColorMatrixFilter = null;
         var _local_3:Array = null;
         var _local_4:GlowFilter = null;
         var _local_5:Array = null;
         if(this._people == null)
         {
            return;
         }
         this._petMc = _arg_1 as MovieClip;
         MovieClipUtil.childStop(this._petMc,1);
         this.direction = this._people.direction;
         addChild(this._petMc);
         if(this._info.isshiny != 0)
         {
            this._petMc.filters = [this.filte,this._info.shiny.GetGlowFilter,this._info.shiny.GetColorMatrixFilter];
         }
         this.bright();
         if(_walk.isPlaying)
         {
            this.onWalkStart(null);
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(RobotEvent.WALK_START,this.onWalkStart);
         addEventListener(RobotEvent.WALK_END,this.onWalkOver);
         addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalkEnterFrame);
         this._people.addEventListener(RobotEvent.WALK_START,this.onPeopleWalkStart);
         if(this._people.walk.isPlaying)
         {
            this._people.addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onPeopleWalkEnter);
         }
         addEventListener(MouseEvent.CLICK,this.onPetClickHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(RobotEvent.WALK_START,this.onWalkStart);
         removeEventListener(RobotEvent.WALK_END,this.onWalkOver);
         removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalkEnterFrame);
         this._people.removeEventListener(RobotEvent.WALK_START,this.onPeopleWalkStart);
         this._people.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onPeopleWalkEnter);
         removeEventListener(MouseEvent.CLICK,this.onPetClickHandler);
      }
      
      private function onWalkStart(_arg_1:Event) : void
      {
         var _local_2:MovieClip = null;
         if(Boolean(this._petMc))
         {
            _local_2 = this._petMc.getChildAt(0) as MovieClip;
            if(Boolean(_local_2))
            {
               if(_local_2.currentFrame == 1)
               {
                  _local_2.gotoAndPlay(2);
               }
            }
         }
      }
      
      private function onWalkEnterFrame(_arg_1:Event) : void
      {
         if(Point.distance(pos,_walk.endP) < MAX)
         {
            stop();
         }
      }
      
      private function onWalkOver(_arg_1:Event) : void
      {
         if(Boolean(this._petMc))
         {
            MovieClipUtil.childStop(this._petMc,1);
         }
      }
      
      private function onPetClickHandler(_arg_1:MouseEvent) : void
      {
         PetInfoController.getInfo(false,this._info.userID,this._info.catchTime);
      }
      
      private function onPeopleWalkStart(_arg_1:Event) : void
      {
         this._people.addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onPeopleWalkEnter);
      }
      
      private function onPeopleWalkEnter(_arg_1:Event) : void
      {
         var _local_2:Array = null;
         if(Boolean(this._petMc))
         {
            if(Point.distance(pos,this._people.pos) > MAX)
            {
               if(Point.distance(pos,this._people.walk.endP) > Point.distance(this._people.pos,this._people.walk.endP))
               {
                  _local_2 = this._people.walk.remData;
                  _local_2.unshift(this._people.pos);
                  _local_2.unshift(pos);
                  this.walkAction(_local_2);
                  this._people.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onPeopleWalkEnter);
               }
            }
         }
      }
   }
}

