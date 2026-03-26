package com.robot.core.mode
{
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.pet.PetGlowFilter;
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.events.*;
   import flash.external.ExternalInterface;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.utils.*;
   import gs.*;
   import gs.easing.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class OgreModel extends BobyModel
   {
      
      public static var isShow:Boolean = true;
      
      private const PATH_STR:String = "resource/pet/sound/";
      
      private var _id:uint;
      
      private var shiny:PetGlowFilter;
      
      private var _index:uint;
      
      private var _obj:MovieClip;
      
      private var _dialogTime:uint;
      
      private var _sound:Sound;
      
      private var idList:Array;
      
      protected var filter:GlowFilter = new GlowFilter(3355443,0.9,3,3,3.1);
      
      public function OgreModel(_arg_1:uint)
      {
         super();
         _speed = 2;
         mouseEnabled = false;
         this._index = _arg_1;
         this.idList = new Array();
         this.idList = ExternalInterface.call("sun.getShinyPetID");
         trace("稀有精灵列表",this.idList);
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
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get index() : uint
      {
         return this._index;
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
      
      public function show(_arg_1:uint, _arg_2:Point, shiny:PetGlowFilter) : void
      {
         if(Boolean(this._obj))
         {
            return;
         }
         this._id = _arg_1;
         this.shiny = shiny;
         pos = _arg_2;
         autoRect = new Rectangle(_arg_2.x - 20,_arg_2.y - 20,40,40);
         alpha = 0;
         if(isShow)
         {
            ResourceManager.getResource(ClientConfig.getPetSwfPath(_arg_1),this.onLoad,"pet");
         }
      }
      
      private function playSound() : void
      {
         if(Boolean(this._sound))
         {
            this._sound = null;
         }
         this._sound = new Sound();
         this._sound.load(new URLRequest(this.PATH_STR + this._id + ".mp3"));
         this._sound.play();
      }
      
      override public function destroy() : void
      {
         clearInterval(this._dialogTime);
         super.destroy();
         if(Boolean(this._obj))
         {
            this._obj.removeEventListener(MouseEvent.CLICK,this.onClick);
         }
         removeEventListener(RobotEvent.WALK_START,this.onWalkStart);
         removeEventListener(RobotEvent.WALK_END,this.onWalkOver);
         ResourceManager.cancel(ClientConfig.getPetSwfPath(this._id),this.onLoad);
         this.effect("Pet_Effect_Out");
         TweenLite.to(this,1,{
            "alpha":0,
            "ease":Back.easeOut,
            "onComplete":this.onFinishTween
         });
      }
      
      private function effect(_arg_1:String) : void
      {
         var _local_2:MovieClip = UIManager.getMovieClip(_arg_1);
         MovieClipUtil.playEndAndRemove(_local_2);
         addChild(_local_2);
      }
      
      private function onLoad(_arg_1:DisplayObject) : void
      {
         var _local_2:MovieClip = null;
         var _loc2_:ColorMatrixFilter = null;
         var _loc3_:Array = null;
         var _loc4_:GlowFilter = null;
         var _loc5_:Array = null;
         var _loc6_:MovieClip = null;
         this._obj = _arg_1 as MovieClip;
         this._obj.gotoAndStop(_direction);
         this._obj.buttonMode = true;
         this._obj.addEventListener(MouseEvent.CLICK,this.onClick);
         ToolTipManager.add(this._obj,PetXMLInfo.getName(this._id));
         if(this.shiny != null)
         {
            this._obj.filters = [this.filter,this.shiny.GetGlowFilter,this.shiny.GetColorMatrixFilter];
         }
         addChild(this._obj);
         this.effect("Pet_Effect_Over");
         MapManager.currentMap.depthLevel.addChild(this);
         TweenLite.to(this,1,{"alpha":1});
         starAutoWalk(3000);
         MovieClipUtil.childStop(this._obj,1);
         addEventListener(RobotEvent.WALK_START,this.onWalkStart);
         addEventListener(RobotEvent.WALK_END,this.onWalkOver);
         if(Boolean(NonoManager.info))
         {
            if(Boolean(NonoManager.info.func[9]))
            {
               clearInterval(this._dialogTime);
               this._dialogTime = setInterval(this.onAutoDialog,MathUtil.randomHalfAdd(10000));
            }
         }
         if(this.idList.indexOf(this._id) > -1 && TaomeeManager.nonoSpriteTrack == 1 && Boolean(MainManager.actorModel.nono))
         {
            _local_2 = CoreAssetsManager.getMovieClip("pk_flash_mc");
            this._obj.addChildAt(_local_2,0);
            this.playSound();
         }
         if(this.shiny != null && TaomeeManager.nonoSpriteTrack == 1 && Boolean(MainManager.actorModel.nono))
         {
            _local_2 = CoreAssetsManager.getMovieClip("pk_flash_mc");
            this._obj.addChildAt(_local_2,0);
            this.playSound();
         }
      }
      
      private function onFinishTween() : void
      {
         DisplayUtil.removeForParent(this);
         this._obj = null;
      }
      
      private function onAutoDialog() : void
      {
         var _local_1:String = MovesLangXMLInfo.getRandomLang(this._id);
         if(_local_1 != "")
         {
            showBox(_local_1);
         }
      }
      
      private function onClick(_arg_1:MouseEvent) : void
      {
         dispatchEvent(new RobotEvent(RobotEvent.OGRE_CLICK));
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

