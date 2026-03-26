package com.robot.app.bag
{
   import com.robot.app.*;
   import com.robot.core.manager.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class ChangeNickName
   {
      
      private var chNickBtn:SimpleButton;
      
      private var chNickTagBtn:SimpleButton;
      
      private var nickTxt:TextField;
      
      public function ChangeNickName()
      {
         super();
      }
      
      public function init(_arg_1:MovieClip) : void
      {
         this.nickTxt = _arg_1["name_txt"];
         this.nickTxt.text = MainManager.actorInfo.nick;
         this.nickTxt.addEventListener(Event.CHANGE,this.onTxtChange);
         this.nickTxt.selectable = true;
         this.nickTxt.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.chNickBtn = _arg_1["chNickBtn"] as SimpleButton;
         this.chNickTagBtn = _arg_1["chNickTagBtn"] as SimpleButton;
         this.chNickTagBtn.visible = false;
         this.chNickBtn.addEventListener(MouseEvent.CLICK,this.onChangeTag);
      }
      
      private function onChangeTag(_arg_1:MouseEvent) : void
      {
         this.chNickTagBtn.visible = true;
         this.chNickBtn.visible = false;
         this.nickTxt.type = TextFieldType.INPUT;
         this.nickTxt.background = true;
         this.nickTxt.backgroundColor = 11131128;
         MainManager.getStage().focus = this.nickTxt;
         this.chNickTagBtn.addEventListener(MouseEvent.CLICK,this.onChangeName);
         EventManager.addEventListener(ParseSocketError.NAME_BAD_LANGUAGE,this.onBadName);
      }
      
      private function onKeyDown(_arg_1:KeyboardEvent) : void
      {
         if(_arg_1.keyCode == Keyboard.ENTER)
         {
            this.changeName();
         }
      }
      
      private function onBadName(_arg_1:Event) : void
      {
         EventManager.removeEventListener(ParseSocketError.NAME_BAD_LANGUAGE,this.onBadName);
         this.nickTxt.text = MainManager.actorInfo.nick;
      }
      
      private function onChangeName(_arg_1:MouseEvent) : void
      {
         this.changeName();
      }
      
      private function changeName() : void
      {
         this.nickTxt.text = StringUtil.trim(this.nickTxt.text);
         if(this.nickTxt.text == "")
         {
            Alarm.show("昵称不能为空");
            return;
         }
         if(this.checkNickLength())
         {
            return;
         }
         this.chNickTagBtn.visible = false;
         this.chNickBtn.visible = true;
         this.nickTxt.type = TextFieldType.DYNAMIC;
         this.nickTxt.background = false;
         if(this.nickTxt.text == MainManager.actorInfo.nick)
         {
            return;
         }
         MainManager.actorModel.changeNickName(this.nickTxt.text);
      }
      
      private function checkNickLength() : Boolean
      {
         var _local_1:Boolean = false;
         var _local_2:ByteArray = new ByteArray();
         _local_2.writeUTFBytes(this.nickTxt.text);
         if(_local_2.length > 15)
         {
            this.nickTxt.text = StringUtil.trim(this.nickTxt.text);
            this.nickTxt.type = TextFieldType.DYNAMIC;
            this.nickTxt.setSelection(0,1);
            Alarm.show("输入的文字太长了",this.onReceive);
            _local_1 = true;
         }
         return _local_1;
      }
      
      private function onReceive() : void
      {
         this.nickTxt.type = TextFieldType.INPUT;
      }
      
      private function onTxtChange(_arg_1:Event) : void
      {
         if(this.checkNickLength())
         {
            return;
         }
      }
      
      public function destory() : void
      {
         this.chNickTagBtn.visible = false;
         this.chNickBtn.visible = true;
         this.nickTxt.type = TextFieldType.DYNAMIC;
         this.nickTxt.background = false;
      }
   }
}

