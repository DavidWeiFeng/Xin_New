package com.robot.core.ui.itemTip
{
   import com.robot.core.config.xml.ItemTipXMLInfo;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import org.taomee.component.UIComponent;
   import org.taomee.component.bgFill.SoildFillStyle;
   import org.taomee.component.containers.Canvas;
   import org.taomee.component.containers.HBox;
   import org.taomee.component.containers.VBox;
   import org.taomee.component.control.MLabel;
   import org.taomee.component.control.MLoadPane;
   import org.taomee.component.control.MText;
   import org.taomee.component.layout.CenterLayout;
   import org.taomee.component.layout.FitSizeLayout;
   import org.taomee.component.layout.FlowLayout;
   import org.taomee.utils.DisplayUtil;
   
   public class ItemInfoTip
   {
      
      private static var tipMC:Canvas;
      
      private static var box:HBox;
      
      private static var txtBox:VBox;
      
      private static var iconPanel:MLoadPane;
      
      private static var _info:SingleItemInfo;
      
      public function ItemInfoTip()
      {
         super();
      }
      
      public static function show(_arg_1:SingleItemInfo, _arg_2:Boolean = false, _arg_3:DisplayObjectContainer = null) : void
      {
         _info = _arg_1;
         if(!tipMC)
         {
            tipMC = new Canvas();
            tipMC.layout = new CenterLayout();
            tipMC.bgFillStyle = new SoildFillStyle(0,0.8,20,20);
            box = new HBox(10);
            box.valign = FlowLayout.TOP;
            iconPanel = new MLoadPane(null,MLoadPane.FIT_HEIGHT);
            iconPanel.setSizeWH(80,80);
            txtBox = new VBox();
         }
         txtBox.removeAll();
         iconPanel.setIcon(ItemXMLInfo.getIconURL(_arg_1.itemID,_arg_1.itemLevel));
         var _local_4:UIComponent = getTitleBox();
         var _local_5:UIComponent = getPetBox();
         var _local_6:UIComponent = getTeamPKBox();
         var _local_7:UIComponent = getDesBox();
         txtBox.appendAll(_local_4,_local_5,_local_6,_local_7);
         txtBox.setSizeWH(160,_local_4.height + _local_5.height + _local_6.height + _local_7.height + 3 * box.gap);
         box.appendAll(iconPanel,txtBox);
         box.setSizeWH(160 + 80 + box.gap,Math.max(txtBox.height,iconPanel.height));
         tipMC.setSizeWH(box.width + 20,box.height + 20);
         tipMC.append(box);
         if(Boolean(_arg_3))
         {
            _arg_3.addChild(tipMC);
         }
         else
         {
            LevelManager.appLevel.addChild(tipMC);
         }
         tipMC.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
      }
      
      public static function hide() : void
      {
         if(Boolean(tipMC))
         {
            tipMC.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
            DisplayUtil.removeForParent(tipMC);
         }
      }
      
      private static function enterFrameHandler(_arg_1:Event) : void
      {
         if(MainManager.getStage().mouseX + tipMC.width + 20 >= MainManager.getStageWidth())
         {
            tipMC.x = MainManager.getStageWidth() - tipMC.width - 10;
         }
         else
         {
            tipMC.x = MainManager.getStage().mouseX + 10;
         }
         if(MainManager.getStage().mouseY + tipMC.height + 20 >= MainManager.getStageHeight())
         {
            tipMC.y = MainManager.getStageHeight() - tipMC.height - 10;
         }
         else
         {
            tipMC.y = MainManager.getStage().mouseY + 20;
         }
      }
      
      private static function getTitleBox() : HBox
      {
         var _local_1:HBox = null;
         _local_1 = new HBox();
         var _local_2:MLabel = new MLabel();
         _local_2.fontSize = 14;
         var _local_3:String = ItemXMLInfo.getName(_info.itemID);
         var _local_4:String = ItemTipXMLInfo.getItemColor(_info.itemID);
         _local_2.htmlText = "<font color=\'" + _local_4 + "\'>" + _local_3 + "</font>";
         _local_2.width = 160;
         _local_2.blod = true;
         _local_1.setSizeWH(160,_local_2.height);
         _local_1.append(_local_2);
         return _local_1;
      }
      
      private static function getPetBox() : Canvas
      {
         var _local_1:MText = null;
         _local_1 = null;
         var _local_2:String = ItemTipXMLInfo.getPetDes(_info.itemID,_info.itemLevel);
         var _local_3:Canvas = new Canvas();
         _local_3.layout = new FitSizeLayout();
         if(_local_2 != "")
         {
            _local_1 = new MText();
            _local_1.fontSize = 12;
            _local_1.width = 160;
            _local_1.selectable = false;
            _local_1.textColor = 16776960;
            _local_1.text = "精灵属性：\r" + _local_2;
            _local_3.setSizeWH(160,_local_1.textField.height);
            _local_3.append(_local_1);
         }
         return _local_3;
      }
      
      private static function getTeamPKBox() : Canvas
      {
         var _local_1:MText = null;
         var _local_2:String = ItemTipXMLInfo.getTeamPKDes(_info.itemID,_info.itemLevel);
         var _local_3:Canvas = new Canvas();
         _local_3.layout = new FitSizeLayout();
         if(_local_2 != "")
         {
            _local_1 = new MText();
            _local_1.fontSize = 12;
            _local_1.width = 160;
            _local_1.selectable = false;
            _local_1.textColor = 16777215;
            _local_1.text = "要塞保卫战：\r" + _local_2;
            _local_3.setSizeWH(160,_local_1.textField.height);
            _local_3.append(_local_1);
         }
         return _local_3;
      }
      
      private static function getDesBox() : Canvas
      {
         var _local_1:MText = null;
         var _local_2:String = ItemTipXMLInfo.getItemDes(_info.itemID);
         var _local_3:Canvas = new Canvas();
         _local_3.layout = new FitSizeLayout();
         if(_local_2 != "")
         {
            _local_1 = new MText();
            _local_1.fontSize = 12;
            _local_1.width = 160;
            _local_1.selectable = false;
            _local_1.textColor = 10092288;
            _local_1.text = "用途：\r" + _local_2;
            _local_3.setSizeWH(160,_local_1.textField.height);
            _local_3.append(_local_1);
         }
         return _local_3;
      }
   }
}

