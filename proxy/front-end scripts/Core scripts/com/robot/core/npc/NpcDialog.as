package com.robot.core.npc
{
   import com.robot.core.config.xml.*;
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import org.taomee.component.containers.*;
   import org.taomee.component.control.*;
   import org.taomee.component.layout.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class NpcDialog
   {
      
      private static var _npcMc:Sprite;
      
      private static var _dialogA:Array;
      
      private static var _questionA:Array;
      
      private static var _handlerA:Array;
      
      private static var _bgMc:Sprite;
      
      private static var _prevBtn:MovieClip;
      
      private static var _nextBtn:MovieClip;
      
      private static var _curNpcPath:String;
      
      private static var txtBox:Box;
      
      private static var btnBox:VBox;
      
      private static var mcL:MLoadPane;
      
      private static const MAX:uint = 3;
      
      private static var _curIndex:uint = 0;
      
      private static var _btnA:Array = [];
      
      setup();
      
      public function NpcDialog()
      {
         super();
      }
      
      public static function setup() : void
      {
         _bgMc = TaskIconManager.getIcon("NPC_BG_MC") as Sprite;
         _nextBtn = _bgMc["nextBtn"];
         _prevBtn = _bgMc["prevBtn"];
         _prevBtn.gotoAndStop(1);
         _prevBtn.visible = false;
         txtBox = new Box();
         txtBox.x = 144;
         txtBox.y = 20;
         txtBox.setSizeWH(520,112);
         txtBox.layout = new FlowWarpLayout(FlowWarpLayout.LEFT,FlowWarpLayout.BOTTOM,-3,-2);
         btnBox = new VBox(2);
         btnBox.x = 144;
         btnBox.y = 32;
         btnBox.setSizeWH(520,112);
         btnBox.valign = FlowLayout.BOTTOM;
         _bgMc.addChild(btnBox);
         _bgMc.addChild(txtBox);
         _bgMc.addChild(_nextBtn);
         _bgMc.addChild(_prevBtn);
      }
      
      public static function show(_arg_1:uint, _arg_2:Array, _arg_3:Array = null, _arg_4:Array = null) : void
      {
         var _local_5:int = 0;
         LevelManager.closeMouseEvent();
         if(_curNpcPath != "")
         {
            ResourceManager.cancelURL(_curNpcPath);
         }
         if(Boolean(_npcMc))
         {
            DisplayUtil.removeForParent(_npcMc);
            _npcMc = null;
         }
         if(_btnA.length > 0)
         {
            _local_5 = 0;
            while(_local_5 < _btnA.length)
            {
               (_btnA[_local_5] as MLabelButton).removeEventListener(MouseEvent.CLICK,onTxtBtnClickHandler);
               _btnA[_local_5] = null;
               _local_5++;
            }
         }
         _btnA = new Array();
         txtBox.removeAll();
         btnBox.removeAll();
         _curNpcPath = NPC.getDialogNpcPathById(_arg_1);
         _curIndex = 0;
         _dialogA = _arg_2;
         _questionA = _arg_3;
         _handlerA = _arg_4;
         _prevBtn.visible = false;
         _prevBtn.gotoAndStop(1);
         if(_dialogA.length <= 1)
         {
            _nextBtn.visible = false;
            _nextBtn.gotoAndStop(1);
         }
         else
         {
            _nextBtn.visible = true;
            _nextBtn.play();
         }
         addTxtBtn();
         shwoTxt(_curIndex);
         addEvent();
         LevelManager.appLevel.addChild(_bgMc);
         DisplayUtil.align(_bgMc,null,AlignType.BOTTOM_CENTER,new Point(0,-60));
         ResourceManager.getResource(_curNpcPath,onComHandler);
      }
      
      private static function addTxtBtn() : void
      {
         var _local_1:int = 0;
         var _local_2:MLabelButton = null;
         if(_questionA != null)
         {
            _local_1 = 0;
            while(_local_1 < _questionA.length)
            {
               _local_2 = new MLabelButton(_questionA[_local_1]);
               _local_2.overColor = 65535;
               _local_2.outColor = 16776960;
               _local_2.underLine = true;
               _local_2.buttonMode = true;
               btnBox.append(_local_2);
               _local_2.name = "btn" + _local_1;
               _local_2.addEventListener(MouseEvent.CLICK,onTxtBtnClickHandler);
               _btnA.push(_local_2);
               _local_1++;
            }
         }
      }
      
      private static function onTxtBtnClickHandler(_arg_1:MouseEvent) : void
      {
         hide();
         LevelManager.openMouseEvent();
         var _local_2:String = (_arg_1.currentTarget as MLabelButton).name;
         var _local_3:uint = uint(_local_2.slice(3,_local_2.length));
         if(Boolean(_handlerA))
         {
            if(_handlerA[_local_3] != null && _handlerA[_local_3] != undefined)
            {
               (_handlerA[_local_3] as Function)();
            }
         }
      }
      
      private static function onComHandler(_arg_1:DisplayObject) : void
      {
         if(Boolean(mcL))
         {
            DisplayUtil.removeForParent(mcL);
            mcL.destroy();
            mcL = null;
         }
         _npcMc = _arg_1 as Sprite;
         DisplayUtil.stopAllMovieClip(_npcMc as MovieClip);
         mcL = new MLoadPane(_npcMc);
         if(_npcMc.width > _npcMc.height)
         {
            mcL.fitType = MLoadPane.FIT_WIDTH;
         }
         else
         {
            mcL.fitType = MLoadPane.FIT_HEIGHT;
         }
         mcL.setSizeWH(160,170);
         mcL.x = -15;
         mcL.y = -18;
         _bgMc.addChild(mcL);
      }
      
      private static function addEvent() : void
      {
         _nextBtn.addEventListener(MouseEvent.CLICK,onNextClickHandler);
         _prevBtn.addEventListener(MouseEvent.CLICK,onPrevClickHandler);
      }
      
      private static function removeEvent() : void
      {
         _nextBtn.removeEventListener(MouseEvent.CLICK,onNextClickHandler);
         _prevBtn.removeEventListener(MouseEvent.CLICK,onPrevClickHandler);
      }
      
      private static function onNextClickHandler(_arg_1:MouseEvent) : void
      {
         ++_curIndex;
         if(_curIndex >= _dialogA.length)
         {
            _nextBtn.visible = false;
            _nextBtn.stop();
            _prevBtn.visible = true;
            _prevBtn.play();
         }
         else
         {
            shwoTxt(_curIndex);
            if(_curIndex == _dialogA.length - 1)
            {
               _nextBtn.visible = false;
               _nextBtn.stop();
               _prevBtn.visible = true;
               _prevBtn.play();
            }
         }
      }
      
      private static function onPrevClickHandler(_arg_1:MouseEvent) : void
      {
         --_curIndex;
         if(_curIndex < 0)
         {
            _nextBtn.visible = true;
            _nextBtn.play();
            _prevBtn.visible = false;
            _prevBtn.stop();
         }
         else
         {
            shwoTxt(_curIndex);
            if(_curIndex == 0)
            {
               _nextBtn.visible = true;
               _nextBtn.play();
               _prevBtn.visible = false;
               _prevBtn.stop();
            }
         }
      }
      
      private static function hide() : void
      {
         DisplayUtil.removeForParent(_bgMc);
         txtBox.removeAll();
         btnBox.removeAll();
      }
      
      private static function shwoTxt(_arg_1:uint) : void
      {
         var _local_2:String = null;
         var _local_3:uint = 0;
         var _local_4:String = null;
         var _local_5:MLabel = null;
         var _local_6:MLoadPane = null;
         var _local_9:uint = 0;
         txtBox.removeAll();
         var _local_7:String = "    " + _dialogA[_arg_1];
         var _local_8:ParseDialogStr = new ParseDialogStr(_local_7);
         for each(_local_2 in _local_8.strArray)
         {
            _local_3 = 0;
            while(_local_3 < _local_2.length)
            {
               _local_4 = _local_2.charAt(_local_3);
               _local_5 = new MLabel(_local_4);
               _local_5.textColor = uint("0x" + _local_8.getColor(_local_9));
               _local_5.cacheAsBitmap = true;
               txtBox.append(_local_5);
               _local_3++;
            }
            _local_9++;
            if(_local_8.getEmotionNum(_local_9) != -1)
            {
               _local_6 = new MLoadPane(EmotionXMLInfo.getURL("#" + _local_8.getEmotionNum(_local_9)),MLoadPane.FIT_NONE,MLoadPane.MIDDLE,MLoadPane.MIDDLE);
               _local_6.setSizeWH(45,40);
               txtBox.append(_local_6);
            }
         }
      }
   }
}

