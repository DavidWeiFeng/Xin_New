package com.robot.core.aimat
{
   import com.robot.core.event.AimatEvent;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.mode.ISprite;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.utils.Direction;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.system.ApplicationDomain;
   import flash.utils.setTimeout;
   import gs.TweenMax;
   import gs.easing.Quad;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.GeomUtil;
   
   public class ThrowPropsController
   {
      
      private var mc:MovieClip;
      
      private var _isFullScreen:Boolean = false;
      
      private var _itemID:uint;
      
      private var _userID:uint;
      
      private var _startPoint:Point;
      
      private var _endPoint:Point;
      
      public function ThrowPropsController(_arg_1:uint, _arg_2:uint, _arg_3:ISprite, _arg_4:Point)
      {
         var _local_5:Point = null;
         var _local_6:int = 0;
         var _local_7:int = 0;
         _local_5 = null;
         super();
         if(_arg_1 == 600002)
         {
            this._isFullScreen = true;
         }
         this._itemID = _arg_1;
         this._userID = _arg_2;
         this._endPoint = _arg_4;
         this.mc = TaskIconManager.getIcon("item_" + _arg_1.toString()) as MovieClip;
         this.mc.gotoAndStop(1);
         _local_5 = _arg_3.pos.clone();
         this._startPoint = _local_5;
         _local_5.y -= 40;
         _arg_3.direction = Direction.angleToStr(GeomUtil.pointAngle(_local_5,_arg_4));
         var _local_8:BasePeoleModel = _arg_3 as BasePeoleModel;
         if(_local_8.direction == Direction.RIGHT_UP || _local_8.direction == Direction.LEFT_UP)
         {
            _local_6 = int(_arg_4.y - Math.abs(_arg_4.x - _local_5.y) / 2);
         }
         else
         {
            _local_6 = int(_local_5.y - Math.abs(_arg_4.x - _local_5.y) / 2);
         }
         _local_7 = int(_local_5.x + (_arg_4.x - _local_5.x) / 2);
         this.mc.x = _local_5.x;
         this.mc.y = _local_5.y;
         LevelManager.mapLevel.addChild(this.mc);
         var _local_9:AimatInfo = new AimatInfo(_arg_1,_arg_2,_local_5,_arg_4);
         AimatController.dispatchEvent(AimatEvent.PLAY_START,_local_9);
         TweenMax.to(this.mc,1,{
            "bezier":[{
               "x":_local_7,
               "y":_local_6
            },{
               "x":_arg_4.x,
               "y":_arg_4.y
            }],
            "onComplete":this.onThrowComp,
            "orientToBezier":true,
            "ease":Quad.easeIn
         });
      }
      
      private function onThrowComp() : void
      {
         var url:String = null;
         var mcloader:MCLoader = null;
         mcloader = null;
         var info:AimatInfo = new AimatInfo(this._itemID,this._userID,this._startPoint,this._endPoint);
         AimatController.dispatchEvent(AimatEvent.PLAY_END,info);
         this.mc.gotoAndPlay(2);
         url = "resource/item/throw/animate/" + this._itemID + ".swf";
         mcloader = new MCLoader(url,LevelManager.mapLevel,-1);
         mcloader.addEventListener(MCLoadEvent.SUCCESS,this.onLoaded);
         setTimeout(function():void
         {
            if(Boolean(mc))
            {
               DisplayUtil.removeForParent(mc);
               mc = null;
            }
            mcloader.doLoad();
         },1000);
      }
      
      private function onLoaded(evt:MCLoadEvent) : void
      {
         var app:ApplicationDomain = null;
         var r:uint = 0;
         var throwMC:MovieClip = null;
         var cls:* = undefined;
         throwMC = null;
         (evt.currentTarget as MCLoader).removeEventListener(MCLoadEvent.SUCCESS,this.onLoaded);
         app = evt.getApplicationDomain();
         cls = app.getDefinition("ThrowPropMC");
         throwMC = new cls() as MovieClip;
         r = Math.floor(Math.random() * throwMC.totalFrames) + 1;
         throwMC.gotoAndStop(r);
         if(this._isFullScreen)
         {
            throwMC.x = MainManager.getStage().width / 2;
            throwMC.y = MainManager.getStage().height / 2;
         }
         else
         {
            throwMC.x = this._endPoint.x;
            throwMC.y = this._endPoint.y;
         }
         LevelManager.mapLevel.addChild(throwMC);
         setTimeout(function():void
         {
            if(Boolean(throwMC))
            {
               DisplayUtil.removeForParent(throwMC);
               throwMC = null;
            }
         },10000);
      }
   }
}

