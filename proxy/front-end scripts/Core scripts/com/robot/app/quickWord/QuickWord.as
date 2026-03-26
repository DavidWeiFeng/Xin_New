package com.robot.app.quickWord
{
   import com.robot.core.config.XmlConfig;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.XmlLoader;
   
   public class QuickWord
   {
      
      private var _path:String = "1";
      
      private var xml:XML;
      
      private var menuContainer:Sprite;
      
      private var qw:QuickWordList;
      
      private var timer:Timer;
      
      public function QuickWord()
      {
         var onLoad:Function;
         var xmlLoader:XmlLoader;
         super();
         onLoad = function(_arg_1:XML):void
         {
            xml = _arg_1;
            timer = new Timer(500,1);
            timer.addEventListener(TimerEvent.TIMER,addStageListener);
            xmlLoader = null;
         };
         xmlLoader = new XmlLoader();
         xmlLoader.loadXML(this._path,XmlConfig.getXmlVerByPath(this._path),onLoad);
      }
      
      public function show(_arg_1:DisplayObject) : void
      {
         var _local_2:Point = null;
         if(Boolean(this.qw))
         {
            this.hide();
            return;
         }
         _local_2 = _arg_1.localToGlobal(new Point());
         this.qw = new QuickWordList(this.xml);
         this.qw.x = _local_2.x - 50;
         this.qw.y = _local_2.y - this.qw.height - 10;
         this.qw.addEventListener(Event.CLOSE,this.closeQw);
         LevelManager.toolsLevel.addChild(this.qw);
         this.timer.stop();
         this.timer.start();
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this.qw);
         this.closeQw(null);
      }
      
      private function addStageListener(_arg_1:TimerEvent) : void
      {
         MainManager.getStage().addEventListener(MouseEvent.CLICK,this.stageClick);
      }
      
      private function stageClick(_arg_1:MouseEvent) : void
      {
         if(!this.qw.hitTestPoint(MainManager.getStage().mouseX,MainManager.getStage().mouseY,true))
         {
            this.qw.destroy();
         }
      }
      
      private function closeQw(_arg_1:Event) : void
      {
         MainManager.getStage().removeEventListener(MouseEvent.CLICK,this.stageClick);
         this.qw.removeEventListener(Event.CLOSE,this.closeQw);
         this.qw = null;
         this.timer.stop();
      }
   }
}

