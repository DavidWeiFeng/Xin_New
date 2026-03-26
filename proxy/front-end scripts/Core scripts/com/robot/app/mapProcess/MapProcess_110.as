package com.robot.app.mapProcess
{
   import com.robot.app.darkPortal.DarkPortalModel;
   import com.robot.app.task.taskUtils.taskDialog.DynamicNpcTipDialog;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.PetBookXMLInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.SOManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.SharedObject;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.manager.ResourceManager;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_110 extends BaseMapProcess
   {
      
      private var _timer:uint;
      
      private const _petId:uint = 169;
      
      private var _point:Point = new Point(479.9,335);
      
      private var _perMc:MovieClip;
      
      private var _collId:uint = 400053;
      
      private var _doorIndex:uint;
      
      private var _lenght:uint = 8;
      
      private var _tipsA:Array = ["暗黑第1门","暗黑第2门","暗黑第3门","暗黑第4门","暗黑第5门","暗黑第6门","暗黑第7门","暗黑第8门","暗黑第9门","暗黑第10门","暗黑第11门"];
      
      private var _so:SharedObject;
      
      private var _bookApp:AppModel;
      
      public function MapProcess_110()
      {
         super();
      }
      
      override protected function init() : void
      {
         var i1:int = 0;
         var so:SharedObject = null;
         LevelManager.iconLevel.visible = false;
         ToolTipManager.add(btnLevel["monsterMc"],"试炼之门");
         btnLevel["monsterMc"].gotoAndStop(1);
         btnLevel["monsterMc"].visible = true;
         btnLevel["monsterMc"].addEventListener(MouseEvent.CLICK,this.onClickHandler);
         i1 = 0;
         while(i1 < this._lenght)
         {
            conLevel["darkMc_" + i1].addEventListener(MouseEvent.CLICK,this.onDoorMcClickHandler);
            conLevel["darkMc_" + i1].buttonMode = true;
            ToolTipManager.add(conLevel["darkMc_" + i1],this._tipsA[i1]);
            i1++;
         }
         this._so = SOManager.getUserSO(SOManager.Is_Readed_DarkBook);
         if(this._so.data.hasOwnProperty("isShow"))
         {
            if(this._so.data["isShow"] == true)
            {
               conLevel["darkBookMc"]["mc"].gotoAndStop(1);
               conLevel["darkBookMc"]["mc"].visible = false;
            }
         }
         else
         {
            this._so.data["isShow"] = false;
            SOManager.flush(this._so);
         }
         ToolTipManager.add(conLevel["darkBookMc"],"暗黑武斗手册");
         conLevel["darkBookMc"].buttomMode = true;
         conLevel["darkBookMc"].addEventListener(MouseEvent.MOUSE_OVER,this.onBookOverHandler);
         conLevel["darkBookMc"].addEventListener(MouseEvent.MOUSE_OUT,this.onBookOutHandler);
         conLevel["darkBookMc"].addEventListener(MouseEvent.CLICK,this.onBookHandler);
      }
      
      private function onBookHandler(param1:MouseEvent) : void
      {
         this._so.data["isShow"] = true;
         SOManager.flush(this._so);
         conLevel["darkBookMc"]["mc"].visible = false;
         conLevel["darkBookMc"]["mc"].gotoAndStop(1);
         if(this._bookApp == null)
         {
            this._bookApp = new AppModel(ClientConfig.getBookModule("DarkProtalBookPanel"),"正在打开");
            this._bookApp.setup();
         }
         this._bookApp.show();
      }
      
      private function onBookOverHandler(param1:MouseEvent) : void
      {
         conLevel["darkBookMc"].gotoAndStop(2);
      }
      
      private function onBookOutHandler(param1:MouseEvent) : void
      {
         conLevel["darkBookMc"].gotoAndStop(1);
      }
      
      private function onDoorMcClickHandler(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         var nameStr:String = String(e.currentTarget.name);
         this._doorIndex = uint(nameStr.slice(7,nameStr.length));
         LevelManager.showOrRemoveMapLevelandToolslevel(false,true);
         DarkPortalModel.curDoor = this._doorIndex;
         DarkPortalModel.showDoor(this._doorIndex,function():void
         {
            LevelManager.showOrRemoveMapLevelandToolslevel(true);
         });
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         NpcTipDialog.showAnswer("欢迎来到暗黑武斗场，你正在开启试炼之门，我是被赋予了反物质力量的守门精灵！你确定现在就开始接受我的试炼吗？",function():void
         {
            btnLevel["monsterMc"].gotoAndStop(3);
            _timer = setTimeout(onTimerOutHandler,1650);
         },null,NpcTipDialog.DARKPET);
      }
      
      public function onJoinHandler() : void
      {
         if(!NonoManager.info.superNono)
         {
            DynamicNpcTipDialog.show("只有在超能nono的帮助下，赛尔们才能进入暗黑武道会驾驭反物质能量。快为你的NoNo充能，让它成为超能NoNo吧！",function():void
            {
            },NpcTipDialog.SEER);
            return;
         }
         MapManager.changeLocalMap(10030);
      }
      
      private function onTimerOutHandler() : void
      {
         clearTimeout(this._timer);
         ResourceManager.getResource(ClientConfig.getPetSwfPath(this._petId),this.onPetComHandler,"pet");
      }
      
      private function onPetComHandler(param1:DisplayObject) : void
      {
         if(Boolean(param1))
         {
            this._perMc = param1 as MovieClip;
            depthLevel.addChild(this._perMc);
            this._perMc.x = this._point.x;
            this._perMc.y = this._point.y;
            this._perMc.scaleX = 1.8;
            this._perMc.scaleY = 1.8;
            ToolTipManager.add(this._perMc,PetBookXMLInfo.getName(this._petId));
            this._perMc.addEventListener(MouseEvent.CLICK,this.onPetClickHandler);
            this._perMc.buttonMode = true;
            btnLevel["monsterMc"].removeEventListener(MouseEvent.CLICK,this.onClickHandler);
            btnLevel["monsterMc"].visible = false;
         }
      }
      
      private function onPetClickHandler(param1:MouseEvent) : void
      {
         var t:uint = 0;
         t = 0;
         var e:MouseEvent = param1;
         this._perMc.removeEventListener(MouseEvent.CLICK,this.onPetClickHandler);
         t = setTimeout(function():void
         {
            clearTimeout(t);
            if(Boolean(_perMc))
            {
               _perMc.addEventListener(MouseEvent.CLICK,onPetClickHandler);
            }
         },1000);
         SocketConnection.send(CommandID.CHALLENGE_BOSS,0);
      }
      
      public function onEnterDoorHandler() : void
      {
         MapManager.changeLocalMap(10029);
      }
      
      override public function destroy() : void
      {
         LevelManager.iconLevel.visible = true;
         this._so = null;
         this._point = null;
         if(Boolean(this._perMc))
         {
            this._perMc.removeEventListener(MouseEvent.CLICK,this.onPetClickHandler);
            DisplayUtil.removeForParent(this._perMc);
            this._perMc = null;
         }
         ToolTipManager.remove(btnLevel["monsterMc"]);
         btnLevel["monsterMc"].removeEventListener(MouseEvent.CLICK,this.onClickHandler);
         var _loc1_:int = 0;
         while(_loc1_ < this._lenght)
         {
            conLevel["darkMc_" + _loc1_].removeEventListener(MouseEvent.CLICK,this.onDoorMcClickHandler);
            _loc1_++;
         }
         ToolTipManager.remove(btnLevel["monsterMc"]);
         ToolTipManager.remove(conLevel["darkMc_0"]);
         ToolTipManager.remove(conLevel["darkBookMc"]);
         conLevel["darkBookMc"].removeEventListener(MouseEvent.MOUSE_OVER,this.onBookOverHandler);
         conLevel["darkBookMc"].removeEventListener(MouseEvent.MOUSE_OUT,this.onBookOutHandler);
         if(Boolean(this._bookApp))
         {
            this._bookApp.destroy();
            this._bookApp = null;
         }
         DarkPortalModel.destroy();
      }
   }
}

