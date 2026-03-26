package com.robot.app.buyItem
{
   import com.adobe.crypto.*;
   import com.robot.app.bag.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.app.vipSession.*;
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.info.clothInfo.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.skeleton.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.text.TextField;
   import flash.utils.*;
   import org.taomee.component.control.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.*;
   
   public class ProductAction
   {
      
      public static var productID:uint;
      
      private static var count:uint;
      
      private static var closeBtn:SimpleButton;
      
      private static var okBtn:SimpleButton;
      
      private static var cancelBtn:SimpleButton;
      
      private static var pswTxt:TextField;
      
      private static var contentTxt:TextField;
      
      private static var panel:MovieClip;
      
      private static var loadPanel:MLoadPane;
      
      setup();
      
      public function ProductAction()
      {
         super();
      }
      
      private static function setup() : void
      {
         SocketConnection.addCmdListener(CommandID.GOLD_CHECK_REMAIN,onCheckGold);
         SocketConnection.addCmdListener(CommandID.MONEY_CHECK_PSW,onCheckPSW);
         SocketConnection.addCmdListener(CommandID.MONEY_CHECK_REMAIN,onCheckMoney);
      }
      
      public static function buyGoldProduct(_arg_1:uint, _arg_2:uint = 1) : void
      {
         trace("购买金豆商品1",_arg_1,_arg_2);
         productID = _arg_1;
         count = _arg_2;
         SocketConnection.send(CommandID.GOLD_CHECK_REMAIN);
      }
      
      private static function onCheckGold(event:SocketEvent) : void
      {
         var name:String;
         var price:Number;
         var num:Number = (event.data as ByteArray).readUnsignedInt() / 100;
         trace("购买金豆商品",productID);
         name = GoldProductXMLInfo.getNameByProID(productID);
         price = Number(GoldProductXMLInfo.getPriceByProID(productID));
         Alert.show(TextFormatUtil.getRedTxt(name) + "需要花费" + TextFormatUtil.getRedTxt(price.toString()) + "金豆，" + "目前你拥有" + TextFormatUtil.getRedTxt(num.toString()) + "金豆，要确认购买吗？",function():void
         {
            var _local_1:ByteArray = new ByteArray();
            _local_1.writeShort(count);
            SocketConnection.send(CommandID.GOLD_BUY_PRODUCT,productID,_local_1);
         });
      }
      
      public static function buyMoneyProduct(proID:uint, cnt:uint = 1) : void
      {
         if(proID == 200000 || proID == 200001 || proID == 200002)
         {
            if(!MainManager.actorInfo.vip)
            {
               NpcTipDialog.showAnswer("很抱歉哟，只有超能NoNo才能帮助金豆兑换。你想立刻拥有超能NoNo吗？",function():void
               {
                  var r:VipSession = new VipSession();
                  r.addEventListener(VipSession.GET_SESSION,function(_arg_1:Event):void
                  {
                  });
                  r.getSession();
               },null,NpcTipDialog.ROCKY);
               return;
            }
         }
         productID = proID;
         count = cnt;
         SocketConnection.send(CommandID.MONEY_CHECK_PSW);
      }
      
      private static function onCheckPSW(event:SocketEvent) : void
      {
         var num:uint = (event.data as ByteArray).readUnsignedInt();
         if(num == 1)
         {
            SocketConnection.send(CommandID.MONEY_CHECK_REMAIN);
         }
         else
         {
            Alert.show("你的米币账户设置还没有完成，需要购买米币商品必须输入<font color=\'#ff0000\'>米币账户支付密码</font>，确定现在去进行<font color=\'#ff0000\'>米币账户支付密码</font>的设置吗？",function():void
            {
               var r:VipSession = new VipSession();
               r.addEventListener(VipSession.GET_SESSION,function(_arg_1:Event):void
               {
               });
               r.getSession();
            });
         }
      }
      
      private static function onCheckMoney(_arg_1:SocketEvent) : void
      {
         var _local_2:String = null;
         var _local_3:Sprite = null;
         var _local_4:BagClothPreview = null;
         var _local_5:Array = null;
         var _local_6:uint = 0;
         if(!panel)
         {
            panel = CoreAssetsManager.getMovieClip("ui_moneyBuyPanel");
            closeBtn = panel["closeBtn"];
            okBtn = panel["okBtn"];
            cancelBtn = panel["cancelBtn"];
            pswTxt = panel["txt"];
            contentTxt = panel["content_txt"];
            closeBtn.addEventListener(MouseEvent.CLICK,closePanel);
            cancelBtn.addEventListener(MouseEvent.CLICK,closePanel);
            okBtn.addEventListener(MouseEvent.CLICK,sendPassword);
            loadPanel = new MLoadPane(null,MLoadPane.FIT_HEIGHT);
            loadPanel.isMask = false;
            loadPanel.setSizeWH(84,84);
            loadPanel.x = 56;
            loadPanel.y = 105;
            panel.addChild(loadPanel);
            DisplayUtil.align(panel,null,AlignType.MIDDLE_CENTER);
         }
         var _local_7:Array = MoneyProductXMLInfo.getItemIDs(productID);
         if(_local_7.length == 1)
         {
            _local_2 = ItemXMLInfo.getIconURL(_local_7[0]);
            loadPanel.setIcon(ItemXMLInfo.getIconURL(_local_7[0]));
         }
         else
         {
            _local_3 = UIManager.getSprite("ComposeMC");
            _local_4 = new BagClothPreview(_local_3,null,ClothPreview.MODEL_SHOW);
            _local_5 = [];
            for each(_local_6 in _local_7)
            {
               _local_5.push(new PeopleItemInfo(_local_6));
            }
            _local_4.changeCloth(_local_5);
            loadPanel.setIcon(_local_3);
         }
         pswTxt.text = "";
         var _local_8:Number = (_arg_1.data as ByteArray).readUnsignedInt() / 100;
         var _local_9:String = MoneyProductXMLInfo.getNameByProID(productID);
         var _local_10:Number = Number(MoneyProductXMLInfo.getPriceByProID(productID));
         if(Boolean(MainManager.actorInfo.vip))
         {
            _local_10 *= MoneyProductXMLInfo.getVipByProID(productID);
         }
         if(_local_10 <= _local_8)
         {
            contentTxt.htmlText = "你选择了" + TextFormatUtil.getRedTxt(_local_9) + "需要花费" + TextFormatUtil.getRedTxt(_local_10.toString()) + "米币，" + "目前你拥有" + TextFormatUtil.getRedTxt(_local_8.toString()) + "米币，若确认购买该物品，请输入你的<font color=\'#ff0000\'>米币账户支付密码</font>：";
            LevelManager.appLevel.addChild(panel);
         }
         else
         {
            Alarm.show("你选择了" + TextFormatUtil.getRedTxt(_local_9) + "需要花费" + TextFormatUtil.getRedTxt(_local_10.toString()) + "米币，" + "目前你拥有" + TextFormatUtil.getRedTxt(_local_8.toString()) + "米币，你的米币余额不足以购买此物品！");
         }
      }
      
      private static function closePanel(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(panel);
      }
      
      private static function sendPassword(_arg_1:MouseEvent) : void
      {
         if(pswTxt.text == "")
         {
            Alarm.show("请输入你的米币帐户密码！");
            return;
         }
         var _local_2:ByteArray = new ByteArray();
         _local_2.writeShort(count);
         var _local_3:ByteArray = new ByteArray();
         _local_3.writeUTFBytes(MD5.hash(pswTxt.text));
         _local_3.length = 32;
         SocketConnection.send(CommandID.MONEY_BUY_PRODUCT,productID,_local_2,_local_3);
         closePanel(null);
      }
   }
}

