package com.robot.app.other.filter
{
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.newloader.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.TextField;
   import org.taomee.utils.*;
   
   public class FilterPanel extends Sprite
   {
      
      private static const PET_PATH:String = "resource/fightResource/pet/swf/";
      
      private var PATH:String = "resource/module/other/filterPanel.swf?20250323-1";
      
      private var mc:MovieClip;
      
      public var app:ApplicationDomain;
      
      private var _beforeBG:MovieClip;
      
      private var _afterBG:MovieClip;
      
      private var _loadPetBtn:SimpleButton;
      
      private var _sendBtn:SimpleButton;
      
      private var _petIDInputBox:TextField;
      
      private var _filterInputBox:TextField;
      
      private var _glowInputBox:TextField;
      
      private var assetsObj:Object;
      
      private var currentID:int = 1;
      
      private var petLoader:Loader = new Loader();
      
      protected var filte:GlowFilter = new GlowFilter(3355443,0.9,3,3,3.1);
      
      private var defaultID:int = 0;
      
      public function FilterPanel()
      {
         super();
      }
      
      public function show() : void
      {
         var _local_1:MCLoader = null;
         if(!this.mc)
         {
            _local_1 = new MCLoader(this.PATH,this,1,"正在打开异色生成面板");
            _local_1.addEventListener(MCLoadEvent.SUCCESS,this.onLoad);
            _local_1.doLoad();
            this.petLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadPetAsset);
         }
         else
         {
            DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
            LevelManager.closeMouseEvent();
            LevelManager.appLevel.addChild(this);
         }
      }
      
      private function onLoad(_arg_1:MCLoadEvent) : void
      {
         this.app = _arg_1.getApplicationDomain();
         this.mc = new (this.app.getDefinition("colorMatrixFilterPanel") as Class)() as MovieClip;
         this._loadPetBtn = this.mc["loadPetBtn"];
         this._sendBtn = this.mc["sendBtn"];
         this._beforeBG = this.mc["beforeBG"];
         this._afterBG = this.mc["afterBG"];
         this._petIDInputBox = this.mc["writeTxt"];
         this._petIDInputBox.restrict = "0-9";
         this._glowInputBox = this.mc["glowTxt"];
         this._glowInputBox.restrict = "0-9,.";
         this._filterInputBox = this.mc["filterTxt"];
         this._filterInputBox.restrict = "0-9\\-,.";
         var _local_2:SimpleButton = this.mc["closeBtn"];
         _local_2.addEventListener(MouseEvent.CLICK,this.closeHandler);
         this._loadPetBtn.addEventListener(MouseEvent.CLICK,this.loadPetAsset);
         this._sendBtn.addEventListener(MouseEvent.CLICK,this.setFilter);
         addChild(this.mc);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         LevelManager.appLevel.addChild(this);
         this.loadPetAsset(new MouseEvent(MouseEvent.CLICK));
      }
      
      private function closeHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this);
         LevelManager.openMouseEvent();
      }
      
      private function loadPetAsset(_arg_1:MouseEvent) : void
      {
         var _local_2:MovieClip = null;
         this.currentID = int(this._petIDInputBox.text);
         if(this.currentID < 1)
         {
            Alarm.show("请输入正确的精灵ID");
            return;
         }
         while(this._beforeBG.numChildren > 0)
         {
            this._beforeBG.removeChildAt(0);
         }
         while(this._afterBG.numChildren > 0)
         {
            this._afterBG.removeChildAt(0);
         }
         _local_2 = this.getAssetsByID(this.currentID);
         if(!_local_2)
         {
            this.petLoader.load(new URLRequest(PET_PATH + (this.currentID < 100 ? (this.currentID < 10 ? "00" : "0") + this.currentID.toString() : this.currentID) + ".swf"));
         }
         else
         {
            _local_2.x = 120;
            _local_2.y = 0;
            _local_2.scaleX = _local_2.scaleY = _local_2.width > 400 ? 0.8 : 1;
            _local_2.gotoAndStop(1);
            _local_2.filters = [this.filte];
            this._beforeBG.addChild(_local_2);
         }
      }
      
      private function onLoadPetAsset(_arg_1:Event) : void
      {
         var _local_2:ApplicationDomain = (_arg_1.target as LoaderInfo).applicationDomain;
         this.addAsset(this.currentID,_local_2);
         var _local_3:MovieClip = this.getAssetsByID(this.currentID);
         if(Boolean(_local_3))
         {
            _local_3.x = 120;
            _local_3.y = 0;
            _local_3.scaleX = _local_3.scaleY = _local_3.width > 400 ? 0.8 : 1;
            _local_3.gotoAndStop(1);
            _local_3.filters = [this.filte];
            this._beforeBG.addChild(_local_3);
         }
      }
      
      private function addAsset(_arg_1:int, _arg_2:ApplicationDomain) : void
      {
         if(!this.assetsObj)
         {
            this.assetsObj = {};
            this.defaultID = _arg_1;
         }
         this.assetsObj["asset_" + _arg_1] = _arg_2;
      }
      
      private function getAssetsByID(id:int) : MovieClip
      {
         var petFightResource:Class = null;
         try
         {
            petFightResource = (this.assetsObj["asset_" + id] as ApplicationDomain).getDefinition("pet") as Class;
            return new petFightResource() as MovieClip;
         }
         catch(error:Error)
         {
            return null;
         }
      }
      
      private function setFilter(e:MouseEvent) : void
      {
         var shiny:String;
         var shinyArray:Array;
         var petAsset:MovieClip;
         var matrix:ColorMatrixFilter = null;
         var glowFilter:GlowFilter = null;
         var glow:String = this._glowInputBox.text;
         var glowArray:Array = glow.split(",");
         if(glowArray.length != 5)
         {
            Alarm.show("光晕参数必须为5，请检查之后重新加载！");
            return;
         }
         shiny = this._filterInputBox.text;
         shinyArray = shiny.split(",");
         if(shinyArray.length != 20)
         {
            Alarm.show("滤镜参数需为5*4的矩阵，请检查之后重新加载！");
            return;
         }
         try
         {
            matrix = new ColorMatrixFilter(shinyArray);
            glowFilter = new GlowFilter(uint(glowArray[0]),int(glowArray[1]),int(glowArray[2]),int(glowArray[3]),int(glowArray[4]));
         }
         catch(error:Error)
         {
            Alarm.show("初始化滤镜时出错，请检查之后重新加载！");
            return;
         }
         while(this._afterBG.numChildren > 0)
         {
            this._afterBG.removeChildAt(0);
         }
         petAsset = this.getAssetsByID(this.currentID);
         if(Boolean(petAsset))
         {
            petAsset.x = 120;
            petAsset.y = 0;
            petAsset.scaleX = petAsset.scaleY = petAsset.width > 400 ? 0.8 : 1;
            petAsset.gotoAndStop(1);
            petAsset.filters = [this.filte,glowFilter,matrix];
            this._afterBG.addChild(petAsset);
         }
      }
   }
}

