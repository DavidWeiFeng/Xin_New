package com.robot.app.protectSys
{
   import com.robot.core.config.xml.*;
   import com.robot.core.manager.*;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.text.*;
   import org.taomee.component.containers.*;
   import org.taomee.component.control.*;
   import org.taomee.component.layout.*;
   import org.taomee.utils.*;
   
   public class KillPluginPanel extends Sprite
   {
      
      public static const WRONG:String = "wrong";
      
      public static const RIGHT:String = "right";
      
      private var bg:Sprite;
      
      private var mainBox:VBox;
      
      private var petBox:HBox;
      
      private var DIR_TYPE:uint;
      
      private var STR_LIST:Array = ["背面","正面","侧面"];
      
      public function KillPluginPanel()
      {
         super();
         this.petBox = new HBox(15);
         this.petBox.halign = FlowLayout.CENTER;
         this.petBox.valign = FlowLayout.MIDLLE;
         this.petBox.setSizeWH(410,130);
         this.bg = UIManager.getSprite("Panel_Background");
         this.bg.width = 475;
         this.bg.height = 292;
         addChild(this.bg);
         var _local_1:Sprite = UIManager.getSprite("Panel_Background_5");
         _local_1.width = 424;
         _local_1.height = 240;
         DisplayUtil.align(_local_1,this.getRect(this),AlignType.MIDDLE_CENTER);
         addChild(_local_1);
         this.mainBox = new VBox();
         this.mainBox.halign = FlowLayout.CENTER;
         this.mainBox.valign = FlowLayout.MIDLLE;
         this.mainBox.setSizeWH(410,225);
         DisplayUtil.align(this.mainBox,this.getRect(this),AlignType.MIDDLE_CENTER);
         addChild(this.mainBox);
         this.mainBox.append(this.petBox);
         this.DIR_TYPE = Math.floor(Math.random() * 3);
         var _local_2:MText = new MText();
         _local_2.align = TextFormatAlign.CENTER;
         _local_2.setSizeWH(410,30);
         _local_2.text = "请选择<b><font color=\'#0000ff\'>" + this.STR_LIST[this.DIR_TYPE] + "</font><font color=\'#ff0000\'>朝向你</font></b>的精灵！";
         this.mainBox.append(_local_2);
         this.getPet();
      }
      
      private function getPet() : void
      {
         var _local_1:uint = 0;
         var _local_2:SinglePetBox = null;
         var _local_3:uint = 0;
         var _local_5:uint = 0;
         var _local_4:uint = Math.floor(Math.random() * 4);
         while(_local_5 < 4)
         {
            _local_1 = Math.floor(Math.random() * 500);
            if(_local_5 == _local_4)
            {
               _local_2 = new SinglePetBox(PetXMLInfo.getIdList()[_local_1],this.DIR_TYPE);
            }
            else
            {
               if(this.DIR_TYPE == SinglePetBox.DOWN)
               {
                  _local_3 = SinglePetBox.UP;
               }
               else if(this.DIR_TYPE == SinglePetBox.LEFT)
               {
                  _local_3 = SinglePetBox.UP;
               }
               else if(this.DIR_TYPE == SinglePetBox.UP)
               {
                  _local_3 = SinglePetBox.DOWN;
               }
               _local_2 = new SinglePetBox(PetXMLInfo.getIdList()[_local_1],_local_3);
            }
            _local_2.buttonMode = true;
            _local_2.mouseChildren = true;
            _local_2.addEventListener(MouseEvent.CLICK,this.clickSinglePet);
            this.petBox.append(_local_2);
            _local_5++;
         }
      }
      
      private function clickSinglePet(_arg_1:MouseEvent) : void
      {
         var _local_2:SinglePetBox = _arg_1.currentTarget as SinglePetBox;
         if(_local_2.dirType == this.DIR_TYPE)
         {
            dispatchEvent(new Event(RIGHT));
         }
         else
         {
            dispatchEvent(new Event(WRONG));
         }
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this);
         this.mainBox.destroy();
         this.mainBox = null;
         this.petBox = null;
      }
   }
}

