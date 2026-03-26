package com.robot.core.ui.mapTip
{
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.text.*;
   
   public class MapTipItem extends Sprite
   {
      
      private var tipMC:Sprite;
      
      private var icon:MovieClip;
      
      private var difIcon:MovieClip;
      
      private var titleTxt:TextField;
      
      private var desContainer:Sprite;
      
      private var _info:MapItemTipInfo;
      
      public function MapTipItem()
      {
         super();
         this.icon = UIManager.getMovieClip("MapTipIcon");
         this.difIcon = UIManager.getMovieClip("MapTipDifIcon");
         this.tipMC = new Sprite();
         this.addChild(this.tipMC);
      }
      
      public function set info(_arg_1:MapItemTipInfo) : void
      {
         this._info = _arg_1;
         this.setTitle(_arg_1);
         this.setDes(_arg_1);
         this.drawBg();
         if(_arg_1.type != 0)
         {
            this.icon.gotoAndStop(_arg_1.type);
         }
         this.icon.x = 2;
         this.tipMC.addChild(this.icon);
         this.tipMC.addChild(this.titleTxt);
         this.tipMC.addChild(this.desContainer);
         this.desContainer.x = 6;
         this.desContainer.y = this.titleTxt.height;
      }
      
      public function get info() : MapItemTipInfo
      {
         return this._info;
      }
      
      private function setTitle(_arg_1:MapItemTipInfo) : void
      {
         var _local_2:TextFormat = new TextFormat();
         _local_2.size = 14;
         if(_arg_1.type == 0)
         {
            this.icon.visible = false;
            _local_2.align = TextFormatAlign.CENTER;
            _local_2.color = 16776960;
            this.titleTxt = this.getTextField(_local_2);
            this.titleTxt.x = (160 - this.titleTxt.width) / 2;
         }
         else
         {
            _local_2.align = TextFormatAlign.LEFT;
            _local_2.color = 16777215;
            this.titleTxt = this.getTextField(_local_2);
            this.titleTxt.x = this.icon.width + 8;
         }
         this.titleTxt.htmlText = _arg_1.title;
      }
      
      private function setDes(_arg_1:MapItemTipInfo) : void
      {
         var _local_2:TextField = null;
         var _local_3:TextField = null;
         var _local_4:TextFormat = new TextFormat();
         _local_4.size = 12;
         _local_4.color = 16776960;
         if(_arg_1.type == 0)
         {
            this.desContainer = new Sprite();
            if(uint(_arg_1.content[0]) != 0)
            {
               _local_2 = this.getTextField(_local_4);
               _local_2.width = 40;
               _local_2.text = "难度:";
               this.difIcon.gotoAndStop(uint(_arg_1.content[0]));
            }
            if(_arg_1.content[1] != "")
            {
               _local_3 = this.getTextField(_local_4);
               _local_3.text = "适合等级:" + _arg_1.content[1];
               _local_3.width = 120;
            }
            if(Boolean(_local_2))
            {
               this.desContainer.addChild(_local_2);
               this.desContainer.addChild(this.difIcon);
               this.difIcon.x = 30;
               this.difIcon.y = 2;
            }
            if(Boolean(_local_3))
            {
               this.desContainer.addChild(_local_3);
               _local_3.y = 20;
            }
         }
         else
         {
            this.desContainer = this.getDesContainer(_arg_1);
         }
      }
      
      private function drawBg() : void
      {
         var _local_1:Number = this.titleTxt.height + this.desContainer.height;
         this.tipMC.graphics.beginFill(73547,0.8);
         this.tipMC.graphics.drawRoundRect(0,0,160,_local_1,10,10);
         this.tipMC.graphics.endFill();
      }
      
      private function getDesContainer(_arg_1:MapItemTipInfo) : Sprite
      {
         var _local_2:String = null;
         var _local_3:TextField = null;
         var _local_4:Array = null;
         var _local_5:Sprite = new Sprite();
         var _local_6:Array = this._info.content;
         var _local_7:TextFormat = new TextFormat();
         _local_7.size = 12;
         _local_7.color = 16777215;
         var _local_8:uint = 1;
         for each(_local_2 in _local_6)
         {
            if(_local_2 != "")
            {
               _local_3 = this.getTextField(_local_7);
               if(_local_2.indexOf("#") != -1)
               {
                  _local_4 = _local_2.split("#");
                  _local_2 = _local_4[1];
                  _local_3.htmlText = "<font color=\'#ff0000\'>" + "*" + _local_2 + "</font>";
               }
               else
               {
                  _local_3.htmlText = "*" + _local_2;
               }
               if(_arg_1.type == 2)
               {
                  if(_local_8 > 1 && _local_8 % 2 == 0)
                  {
                     _local_3.x = 74;
                  }
                  else
                  {
                     _local_3.x = 0;
                  }
                  _local_3.y = (Math.ceil(_local_8 / 2) - 1) * _local_3.height;
               }
               else
               {
                  _local_3.y = _local_3.height * (_local_8 - 1);
               }
               _local_5.addChild(_local_3);
               _local_8++;
            }
         }
         return _local_5;
      }
      
      private function getTextField(_arg_1:TextFormat) : TextField
      {
         var _local_2:TextField = new TextField();
         _local_2.width = 80;
         _local_2.height = 20;
         _local_2.selectable = false;
         _local_2.defaultTextFormat = _arg_1;
         return _local_2;
      }
   }
}

