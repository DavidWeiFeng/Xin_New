package com.robot.app.spacesurvey
{
   import com.robot.app.task.control.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.newloader.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.TextField;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class SpaceSurveyResult extends Sprite
   {
      
      private const PATH:String = "module/surveyPole/surveyResultPanel.swf";
      
      private const SPACE:uint = 80;
      
      private var mainMC:MovieClip;
      
      private var petContainer:MovieClip;
      
      private var energyContainer:MovieClip;
      
      private var iconContainer:MovieClip;
      
      private var closeBtn:SimpleButton;
      
      private var introlTxt:TextField;
      
      private var spaceNameTxt:TextField;
      
      private var sprite:Sprite;
      
      private var namestr:String = "";
      
      private var bgCls:Class;
      
      private var iconMC:MovieClip;
      
      public function SpaceSurveyResult()
      {
         super();
      }
      
      public function show(_arg_1:String) : void
      {
         this.namestr = _arg_1;
         this.loadUI();
      }
      
      private function loadUI() : void
      {
         var _local_1:String = ClientConfig.getResPath(this.PATH);
         var _local_2:MCLoader = new MCLoader(_local_1,LevelManager.appLevel,1,"正在加载测绘报告");
         _local_2.addEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess);
         _local_2.doLoad();
      }
      
      private function onLoadSuccess(_arg_1:MCLoadEvent) : void
      {
         var _local_2:MCLoader = _arg_1.currentTarget as MCLoader;
         _local_2.removeEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess);
         this.bgCls = _arg_1.getApplicationDomain().getDefinition("bg") as Class;
         var _local_3:Class = _arg_1.getApplicationDomain().getDefinition("mainMC") as Class;
         this.mainMC = new _local_3() as MovieClip;
         this.sprite = this.mainMC["ttMC"];
         var _local_4:Class = _arg_1.getApplicationDomain().getDefinition(SurveyResultXMLInfo.getIconName(this.namestr)) as Class;
         this.iconMC = new _local_4() as MovieClip;
         this.closeBtn = this.mainMC["close_btn"];
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.close);
         this.petContainer = this.mainMC["petContainer"];
         this.energyContainer = this.mainMC["energyContainer"];
         this.iconContainer = this.mainMC["iconContainer"];
         this.introlTxt = this.mainMC["introl_txt"];
         this.spaceNameTxt = this.mainMC["spaceName_txt"];
         _local_2.clear();
         this.init();
      }
      
      private function init() : void
      {
         this.addChild(this.mainMC);
         this.iconContainer.addChild(this.iconMC);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         LevelManager.appLevel.addChild(this);
         this.introlTxt.text = SurveyResultXMLInfo.getIntrolInfo(this.namestr);
         this.spaceNameTxt.text = this.namestr;
         this.loadPet();
         this.loadItem();
      }
      
      private function close(event:MouseEvent) : void
      {
         DisplayUtil.removeAllChild(this.petContainer);
         DisplayUtil.removeAllChild(this.iconContainer);
         DisplayUtil.removeAllChild(this.energyContainer);
         DisplayUtil.removeForParent(this);
         if(TasksManager.getTaskStatus(TaskController_37.TASK_ID) == TasksManager.ALR_ACCEPT)
         {
            TasksManager.getProStatusList(TaskController_37.TASK_ID,function(_arg_1:Array):void
            {
               if((Boolean(_arg_1[0]) || Boolean(_arg_1[1]) || Boolean(_arg_1[2]) || Boolean(_arg_1[3]) || Boolean(_arg_1[4]) || Boolean(_arg_1[5]) || Boolean(_arg_1[6]) || Boolean(_arg_1[7]) || Boolean(_arg_1[8])) && Boolean(_arg_1[9]) && !_arg_1[10])
               {
                  TaskController_37.showTaskPanel();
               }
            });
         }
      }
      
      private function loadPet() : void
      {
         var _local_1:uint = 0;
         var _local_2:String = SurveyResultXMLInfo.getPetsByName(this.namestr);
         var _local_3:Array = _local_2.split("|");
         if(_local_3.length > 0)
         {
            _local_1 = 0;
            while(_local_1 < _local_3.length)
            {
               ResourceManager.getResource(ClientConfig.getPetSwfPath(uint(_local_3[_local_1])),this.onLoadPet(_local_1,_local_3),"pet");
               _local_1++;
            }
         }
      }
      
      private function onLoadPet(index:uint, petsArr:Array) : Function
      {
         var func:Function = function(o:DisplayObject):void
         {
            var bmpData:BitmapData = null;
            var ma:Matrix = null;
            var rect:Rectangle = null;
            var bmp:Bitmap = null;
            var _showMc:MovieClip = null;
            _showMc = null;
            _showMc = o as MovieClip;
            var bg:MovieClip = new bgCls() as MovieClip;
            bg.x = SPACE * index;
            if(Boolean(_showMc))
            {
               _showMc.gotoAndStop("rightdown");
               _showMc.addEventListener(Event.ENTER_FRAME,function():void
               {
                  var _local_2:MovieClip = _showMc.getChildAt(0) as MovieClip;
                  if(Boolean(_local_2))
                  {
                     _local_2.gotoAndStop(1);
                     _showMc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  }
               });
               DisplayUtil.stopAllMovieClip(_showMc);
            }
            bmpData = new BitmapData(_showMc.width,_showMc.height,true,0);
            ma = new Matrix();
            rect = _showMc.getRect(_showMc);
            ma.translate(-rect.x,-rect.y);
            bmpData.draw(_showMc,ma);
            bmp = new Bitmap(bmpData);
            DisplayUtil.align(bmp,bg.getRect(bg),AlignType.MIDDLE_CENTER);
            bg.addChild(bmp);
            ToolTipManager.add(bg,PetXMLInfo.getName(petsArr[index]));
            petContainer.addChild(bg);
         };
         return func;
      }
      
      private function loadItem() : void
      {
         var _local_1:uint = 0;
         var _local_2:String = SurveyResultXMLInfo.getEnergysByName(this.namestr);
         var _local_3:Array = _local_2.split("|");
         if(_local_3.length >= 1 && _local_3[0] != "")
         {
            _local_1 = 0;
            while(_local_1 < _local_3.length)
            {
               ResourceManager.getResource(ItemXMLInfo.getIconURL(uint(_local_3[_local_1])),this.onLoadItem(_local_1,_local_3),"item");
               _local_1++;
            }
            this.sprite.visible = true;
         }
         else
         {
            this.sprite.visible = false;
         }
      }
      
      private function onLoadItem(index:uint, energysArr:Array) : Function
      {
         var func:Function = function(_arg_1:DisplayObject):void
         {
            var _local_2:MovieClip = _arg_1 as MovieClip;
            _local_2.gotoAndStop(1);
            var _local_3:MovieClip = new bgCls() as MovieClip;
            _local_3.x = SPACE * index;
            _local_2.x = _local_2.x - _local_3.width / 2 + 10;
            _local_2.y = _local_2.y - _local_3.height + 10;
            _local_3.addChild(_local_2);
            ToolTipManager.add(_local_3,ItemXMLInfo.getName(energysArr[index]));
            energyContainer.addChild(_local_3);
            DisplayUtil.align(_local_2,_local_3.getRect(_local_3),AlignType.MIDDLE_CENTER);
         };
         return func;
      }
   }
}

