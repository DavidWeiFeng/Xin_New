package com.robot.app.picturebook.ui
{
   import com.robot.app.picturebook.info.*;
   import com.robot.core.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.info.pet.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.uic.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import flash.media.*;
   import flash.net.*;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import org.taomee.ds.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class PictureBookPanel extends UIPanel
   {
      
      private static const LIST_LENGTH:int = 10;
      
      private const STXT:String = "输入ID或名称";
      
      private const PATH_STR:String = "resource/pet/sound/";
      
      private var DIR_A:Array;
      
      private var _stxt:TextField;
      
      private var _ptxt:TextField;
      
      private var _showMc:MovieClip;
      
      private var _searchTxt:TextField;
      
      private var _searchBtn:SimpleButton;
      
      private var _listCon:Sprite;
      
      private var _leftBtn:SimpleButton;
      
      private var _rightBtn:SimpleButton;
      
      private var _dataList:Array;
      
      private var _len:int;
      
      private var _showMap:HashMap;
      
      private var _scrollBar:UIScrollBar;
      
      private var _soundBtn:SimpleButton;
      
      private var _sound:Sound;
      
      private var _soundC:SoundChannel;
      
      private var _url:String = "";
      
      private var _petId:uint;
      
      private var _index:uint;
      
      public function PictureBookPanel()
      {
         var _local_1:PictureBookListItem = null;
         var _local_2:int = 0;
         this.DIR_A = [];
         this._showMap = new HashMap();
         this.DIR_A = [Direction.DOWN,Direction.LEFT_DOWN,Direction.LEFT_UP,Direction.UP,Direction.RIGHT_UP,Direction.RIGHT_DOWN];
         super(UIManager.getSprite("PictureBookMc"));
         this._stxt = _mainUI["stxt"];
         this._ptxt = _mainUI["ptxt"];
         this._searchTxt = _mainUI["searchTxt"];
         this._searchBtn = _mainUI["searchBtn"];
         this._dataList = PetBookXMLInfo.dataList;
         this._len = this._dataList.length;
         this._leftBtn = _mainUI["leftBtn"];
         this._rightBtn = _mainUI["rightBtn"];
         this._soundBtn = _mainUI["soundBtn"];
         this._listCon = new Sprite();
         this._listCon.x = 322;
         this._listCon.y = 109;
         addChild(this._listCon);
         while(_local_2 < LIST_LENGTH)
         {
            _local_1 = new PictureBookListItem();
            _local_1.index = _local_2;
            _local_1.id = _local_2 + 1;
            _local_1.text = StringUtil.renewZero(this._dataList[_local_2].@ID.toString(),3) + ":" + "---";
            _local_1.y = (_local_1.height + 1) * _local_2;
            _local_1.addEventListener(MouseEvent.CLICK,this.onItemClick);
            this._listCon.addChild(_local_1);
            _local_2++;
         }
         this._scrollBar = new UIScrollBar(_mainUI["barBlock"],_mainUI["barBack"],LIST_LENGTH,_mainUI["upBtn"],_mainUI["downBtn"]);
         this._scrollBar.wheelObject = this;
         this.showInfo(this._listCon.getChildAt(0) as PictureBookListItem);
         this._searchTxt.text = this.STXT;
         this._searchTxt.textColor = 16777215;
      }
      
      public function show() : void
      {
         _show();
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._url != "")
         {
            ResourceManager.cancel(this._url,this.onLoadRes);
         }
         if(Boolean(this._soundC))
         {
            this._soundC.stop();
            this._soundC = null;
            this._sound = null;
         }
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         SocketConnection.addCmdListener(CommandID.PET_BARGE_LIST,this.onPetBarge);
         SocketConnection.send(CommandID.PET_BARGE_LIST,1,this._len);
         this._searchBtn.addEventListener(MouseEvent.CLICK,this.onSearch);
         this._searchTxt.addEventListener(FocusEvent.FOCUS_IN,this.onSFin);
         this._searchTxt.addEventListener(FocusEvent.FOCUS_OUT,this.onSFout);
         this._scrollBar.addEventListener(MouseEvent.MOUSE_MOVE,this.onBarBallMove);
         this._leftBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onRotatePetHandler);
         this._rightBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onRotatePetHandler);
         this._soundBtn.addEventListener(MouseEvent.CLICK,this.onPlaySoundHandler);
      }
      
      private function onPlaySoundHandler(_arg_1:MouseEvent) : void
      {
         if(Boolean(this._soundC))
         {
            this._soundC.stop();
            this._soundC = null;
            this._sound = null;
         }
         this._sound = new Sound();
         this._sound.load(new URLRequest(this.PATH_STR + this._petId + ".mp3"));
         this._soundC = this._sound.play();
      }
      
      private function onRotatePetHandler(_arg_1:MouseEvent) : void
      {
         var _local_2:String = null;
         if(!this._showMc)
         {
            return;
         }
         this._showMc.removeEventListener(Event.ENTER_FRAME,this.onPetEnterHandler);
         var _local_3:String = this._showMc.currentLabel;
         var _local_4:SimpleButton = _arg_1.currentTarget as SimpleButton;
         var _local_5:uint = uint(this.DIR_A.indexOf(_local_3));
         if(_local_4 == this._leftBtn)
         {
            _local_2 = this.DIR_A[_local_5 + 1];
            if(_local_5 + 1 > this.DIR_A.length)
            {
               _local_2 = this.DIR_A[0];
            }
         }
         else
         {
            _local_2 = this.DIR_A[_local_5 - 1];
            if(_local_5 - 1 < 0)
            {
               _local_2 = this.DIR_A[this.DIR_A.length - 1];
            }
         }
         this._showMc.gotoAndStop(_local_2);
         DisplayUtil.stopAllMovieClip(this._showMc);
         this._showMc.addEventListener(Event.ENTER_FRAME,this.onPetEnterHandler);
      }
      
      private function onPetEnterHandler(_arg_1:Event) : void
      {
         var _local_2:MovieClip = this._showMc.getChildAt(0) as MovieClip;
         if(Boolean(_local_2))
         {
            this._showMc.removeEventListener(Event.ENTER_FRAME,this.onPetEnterHandler);
            DisplayUtil.stopAllMovieClip(this._showMc);
         }
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         SocketConnection.removeCmdListener(CommandID.PET_BARGE_LIST,this.onPetBarge);
         this._searchBtn.removeEventListener(MouseEvent.CLICK,this.onSearch);
         this._scrollBar.removeEventListener(MouseEvent.MOUSE_MOVE,this.onBarBallMove);
         this._leftBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onRotatePetHandler);
         this._rightBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onRotatePetHandler);
         this._showMc.removeEventListener(Event.ENTER_FRAME,this.onPetEnterHandler);
         this._soundBtn.removeEventListener(MouseEvent.CLICK,this.onPlaySoundHandler);
      }
      
      private function checkItem(_arg_1:PictureBookListItem) : void
      {
         var _local_2:PictureBookInfo = this._showMap.getValue(_arg_1.id) as PictureBookInfo;
         if(Boolean(_local_2))
         {
            _arg_1.isShow = true;
            _arg_1.hasPet(_local_2.isCacth);
            _arg_1.text = StringUtil.renewZero(_arg_1.id.toString(),3) + ":" + PetBookXMLInfo.getName(_arg_1.id);
         }
         else
         {
            _arg_1.isShow = false;
            _arg_1.hasPet(false);
            _arg_1.text = StringUtil.renewZero(_arg_1.id.toString(),3) + ":" + "— — — —";
         }
      }
      
      private function showInfo(_arg_1:PictureBookListItem) : void
      {
         var _local_2:String = null;
         if(this._url != "")
         {
            ResourceManager.cancel(this._url,this.onLoadRes);
         }
         this._stxt.text = "";
         this._ptxt.text = "";
         if(Boolean(this._showMc))
         {
            this._showMc.removeEventListener(Event.ENTER_FRAME,this.onPetEnterHandler);
            DisplayUtil.removeForParent(this._showMc);
            this._showMc = null;
         }
         this._petId = _arg_1.id;
         if(_arg_1.isShow)
         {
            this._stxt.htmlText = StringUtil.renewZero(_arg_1.id.toString(),3) + ":" + "<font color=\'#ffff00\'>" + PetBookXMLInfo.getName(_arg_1.id) + "</font>\n";
            this._stxt.htmlText += "属性:" + "<font color=\'#ffff00\'>" + PetBookXMLInfo.getType(_arg_1.id) + "</font>\n";
            this._stxt.htmlText += "身高:" + "<font color=\'#ffff00\'>" + PetBookXMLInfo.getHeight(_arg_1.id) + " cm" + "</font>\n";
            this._stxt.htmlText += "体重:" + "<font color=\'#ffff00\'>" + PetBookXMLInfo.getWeight(_arg_1.id) + " kg" + "</font>\n";
            this._stxt.htmlText += "分布:" + "<font color=\'#ffff00\'>" + PetBookXMLInfo.getFoundin(_arg_1.id) + "</font>\n";
            this._stxt.htmlText += "喜欢的食物:" + "<font color=\'#ffff00\'>" + PetBookXMLInfo.food(_arg_1.id) + "</font>\n";
            if(PetBookXMLInfo.hasSound(_arg_1.id))
            {
               this._stxt.htmlText += "声音:";
               this._soundBtn.visible = true;
            }
            else
            {
               this._soundBtn.visible = false;
            }
            this._ptxt.htmlText = "精灵简介:\n    " + "<font color=\'#ffff00\'>" + PetBookXMLInfo.getFeatures(_arg_1.id) + "</font>\n";
            this._url = ClientConfig.getPetSwfPath(_arg_1.id);
         }
         else
         {
            this._soundBtn.visible = false;
            _local_2 = "<font color=\'#ffff00\'>" + "？？？" + "</font>\n";
            this._stxt.htmlText = StringUtil.renewZero(_arg_1.id.toString(),3) + ":" + _local_2 + "\n";
            this._stxt.htmlText += "属性:" + _local_2 + "\n";
            this._stxt.htmlText += "身高:" + _local_2 + "\n";
            this._stxt.htmlText += "体重:" + _local_2 + "\n";
            this._stxt.htmlText += "分布:" + _local_2 + "\n";
            this._ptxt.htmlText += "精灵简介:\n    " + _local_2;
            this._url = ClientConfig.getPetSwfPath(0);
         }
         ResourceManager.getResource(this._url,this.onLoadRes,"pet");
      }
      
      private function onLoadRes(_arg_1:DisplayObject) : void
      {
         this._showMc = _arg_1 as MovieClip;
         this._showMc.x = 92;
         this._showMc.y = 150;
         this._showMc.scaleX = 2;
         this._showMc.scaleY = 2;
         _mainUI.addChildAt(this._showMc,_mainUI.getChildIndex(this._rightBtn));
         _mainUI.addChildAt(this._showMc,_mainUI.getChildIndex(this._leftBtn));
         MovieClipUtil.childStop(this._showMc,1);
         DisplayUtil.stopAllMovieClip(this._showMc);
      }
      
      private function onBarBallMove(_arg_1:MouseEvent) : void
      {
         var _local_2:PictureBookListItem = null;
         var _local_3:int = 0;
         while(_local_3 < LIST_LENGTH)
         {
            _local_2 = this._listCon.getChildAt(_local_3) as PictureBookListItem;
            _local_2.id = _local_3 + this._scrollBar.index + 1;
            _local_2.index = _local_3 + this._scrollBar.index;
            this.checkItem(_local_2);
            _local_3++;
         }
      }
      
      private function onPetBarge(_arg_1:SocketEvent) : void
      {
         var _local_2:PictureBookInfo = null;
         var _local_3:PictureBookListItem = null;
         var _local_6:int = 0;
         var _local_7:int = 0;
         SocketConnection.removeCmdListener(CommandID.PET_BARGE_LIST,this.onPetBarge);
         this._showMap.clear();
         var _local_4:ByteArray = (_arg_1.data as PetBargeListInfo).data;
         var _local_5:uint = _local_4.readUnsignedInt();
         while(_local_6 < _local_5)
         {
            _local_2 = new PictureBookInfo(_local_4);
            this._showMap.add(_local_2.id,_local_2);
            _local_6++;
         }
         this._scrollBar.totalLength = this._len;
         while(_local_7 < LIST_LENGTH)
         {
            _local_3 = this._listCon.getChildAt(_local_7) as PictureBookListItem;
            this.checkItem(_local_3);
            _local_7++;
         }
      }
      
      private function onItemClick(_arg_1:MouseEvent) : void
      {
         var _local_2:PictureBookListItem = _arg_1.currentTarget as PictureBookListItem;
         this.showInfo(_local_2);
      }
      
      public function serachId(_arg_1:int) : void
      {
         var _local_2:XML = null;
         var _local_3:int = 0;
         var _local_4:int = 0;
         var _local_5:int = 0;
         var _local_6:PictureBookListItem = null;
         var _local_7:PictureBookListItem = null;
         var _local_8:int = _arg_1;
         var _local_9:int = -1;
         if(Boolean(_local_8))
         {
            _arg_1 = 0;
            while(true)
            {
               if(_arg_1 < this._len)
               {
                  _local_2 = this._dataList[_arg_1] as XML;
                  if(int(_local_2.@ID) != _local_8)
                  {
                     continue;
                  }
                  _local_9 = int(_local_2.@ID) - 1;
               }
               _arg_1++;
            }
         }
         else
         {
            _local_3 = 0;
            while(_local_3 < this._len)
            {
               _local_2 = this._dataList[_local_3] as XML;
               if(String(_local_2.@DefName) == this._searchTxt.text)
               {
                  _local_9 = int(_local_2.@ID) - 1;
                  break;
               }
               _local_3++;
            }
         }
         if(_local_9 != -1)
         {
            if(_local_9 >= LIST_LENGTH)
            {
               _local_5 = 0;
               while(_local_5 < LIST_LENGTH)
               {
                  _local_6 = this._listCon.getChildAt(_local_5) as PictureBookListItem;
                  _local_6.id = _local_5 + _local_9 - _local_9 % LIST_LENGTH + 1;
                  _local_6.index = _local_5 + _local_9 - _local_9 % LIST_LENGTH;
                  this.checkItem(_local_6);
                  _local_5++;
               }
               this._scrollBar.index = _local_9 - 9;
            }
            else
            {
               this._scrollBar.index = 0;
            }
            _local_4 = 0;
            while(_local_4 < LIST_LENGTH)
            {
               _local_7 = this._listCon.getChildAt(_local_4) as PictureBookListItem;
               if(_local_7.id == _local_9 + 1)
               {
                  _local_7.setSelect(true);
                  this.showInfo(_local_7);
                  return;
               }
               _local_4++;
            }
         }
      }
      
      private function onSearch(_arg_1:MouseEvent) : void
      {
         if(this._searchTxt.text != null)
         {
            this.serachId(parseInt(this._searchTxt.text));
         }
      }
      
      private function onSFin(_arg_1:FocusEvent) : void
      {
         this._searchTxt.text = "";
         this._searchTxt.textColor = 16777215;
      }
      
      private function onSFout(_arg_1:FocusEvent) : void
      {
         if(this._searchTxt.text == "")
         {
            this._searchTxt.text = this.STXT;
            this._searchTxt.textColor = 16777215;
         }
      }
   }
}

