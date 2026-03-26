package com.robot.core.ui
{
   import com.robot.core.config.xml.*;
   import com.robot.core.manager.*;
   import com.robot.core.npc.*;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   import org.taomee.component.containers.*;
   import org.taomee.component.control.*;
   import org.taomee.component.layout.*;
   import org.taomee.utils.*;
   
   public class DialogBox extends Sprite
   {
      
      private var boxMC:MovieClip;
      
      private var bgMC:MovieClip;
      
      private var arrowMC:MovieClip;
      
      private var txt:TextField;
      
      private var timer:Timer;
      
      private var txtBox:Box;
      
      private var instance:DialogBox;
      
      public function DialogBox()
      {
         super();
         mouseChildren = false;
         mouseEnabled = false;
         this.boxMC = UIManager.getMovieClip("word_box");
         this.bgMC = this.boxMC["bg_mc"];
         this.arrowMC = this.boxMC["arrow_mc"];
         this.txt = this.boxMC["txt"];
         this.txt.autoSize = TextFieldAutoSize.LEFT;
         this.timer = new Timer(4000,1);
         this.timer.addEventListener(TimerEvent.TIMER,this.closeBox);
         this.instance = this;
         this.txtBox = new Box();
         this.txtBox.isMask = false;
         this.txtBox.width = 140;
         this.txtBox.layout = new FlowWarpLayout(FlowWarpLayout.LEFT,FlowWarpLayout.BOTTOM,-5,-3);
      }
      
      public function show(_arg_1:String, _arg_2:Number = 0, _arg_3:Number = 0, _arg_4:DisplayObjectContainer = null) : void
      {
         var _local_5:MovieClip = null;
         if(_arg_1.indexOf("#") != -1)
         {
            this.showNewEmotion(_arg_1,_arg_2,_arg_3,_arg_4);
            return;
         }
         if(_arg_1.substr(0,1) == "$")
         {
            _local_5 = UIManager.getMovieClip("e" + _arg_1.substring(1,_arg_1.length));
            if(Boolean(_local_5))
            {
               _local_5.scaleY = 1.5;
               _local_5.scaleX = 1.5;
               _local_5.x = this.bgMC.x + this.bgMC.width / 2;
               _local_5.y = -38;
               this.boxMC.addChild(_local_5);
               this.txt.text = "\n\n\n";
            }
            else
            {
               this.txt.text = _arg_1;
            }
         }
         else
         {
            this.txt.text = _arg_1;
         }
         if(this.txt.textWidth > 70)
         {
            this.bgMC.width = this.txt.textWidth + 14;
            this.bgMC.x = -this.bgMC.width / 2;
         }
         this.bgMC.height = this.txt.textHeight + 8;
         this.bgMC.y = -this.bgMC.height - this.arrowMC.height + 4;
         this.txt.x = this.bgMC.x + 5;
         this.txt.y = this.bgMC.y + 2;
         this.addChild(this.boxMC);
         this.x = _arg_2;
         this.y = _arg_3;
         if(Boolean(_arg_4))
         {
            _arg_4.addChild(this);
         }
         this.txt.x = this.bgMC.x + (this.bgMC.width - this.txt.textWidth) / 2 - 2;
         this.autoClose();
      }
      
      public function setArrow(_arg_1:String, _arg_2:*) : void
      {
         this.arrowMC[_arg_1] = _arg_2;
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this);
      }
      
      public function destroy() : void
      {
         if(Boolean(this.txtBox))
         {
            this.txtBox.removeAll();
            this.txtBox.destroy();
            this.txtBox = null;
         }
         DisplayUtil.removeForParent(this);
         this.boxMC = null;
         this.bgMC = null;
         this.arrowMC = null;
         this.txt = null;
         if(Boolean(this.timer))
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.closeBox);
            this.timer = null;
         }
      }
      
      public function getBoxMC() : MovieClip
      {
         return this.boxMC;
      }
      
      private function autoClose() : void
      {
         this.timer.start();
      }
      
      private function closeBox(_arg_1:TimerEvent) : void
      {
         this.destroy();
      }
      
      private function showNewEmotion(str:String, x:Number = 0, y:Number = 0, owner:DisplayObjectContainer = null) : void
      {
         var i:String = null;
         var add:Function = null;
         var j:uint = 0;
         var s:String = null;
         var lable:MLabel = null;
         var c:uint = 0;
         var loadPanel:MLoadPane = null;
         var count:uint = 0;
         add = function():void
         {
            bgMC.width = txtBox.getContainSprite().width + 14;
            bgMC.x = -bgMC.width / 2;
            bgMC.height = txtBox.getContainSprite().height + 8;
            bgMC.y = -bgMC.height - arrowMC.height + 4;
            txtBox.x = bgMC.x + 5;
            txtBox.y = bgMC.y + 2;
            boxMC.addChild(txtBox);
            addChild(boxMC);
            instance.x = x;
            instance.y = y;
            if(Boolean(owner))
            {
               owner.addChild(instance);
            }
            autoClose();
         };
         var parse:ParseDialogStr = new ParseDialogStr(str);
         for each(i in parse.strArray)
         {
            j = 0;
            while(j < i.length)
            {
               s = i.charAt(j);
               lable = new MLabel(s);
               lable.fontSize = 12;
               c = uint("0x" + parse.getColor(count));
               if(c == 16777215)
               {
                  c = 0;
               }
               lable.textColor = c;
               lable.cacheAsBitmap = true;
               this.txtBox.append(lable);
               j++;
            }
            count++;
            if(parse.getEmotionNum(count) != -1)
            {
               loadPanel = new MLoadPane(EmotionXMLInfo.getURL("#" + parse.getEmotionNum(count)),MLoadPane.FIT_NONE,MLoadPane.MIDDLE,MLoadPane.MIDDLE);
               loadPanel.setSizeWH(45,40);
               this.txtBox.append(loadPanel);
            }
         }
         setTimeout(add,300);
      }
   }
}

