package com.robot.app.npc.npcClass
{
   import com.robot.app.buyItem.*;
   import com.robot.app.newspaper.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.*;
   import com.robot.core.mode.*;
   import com.robot.core.newloader.*;
   import com.robot.core.npc.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.utils.*;
   
   public class NpcClass_9 implements INpc
   {
      
      private var _curNpcModel:NpcModel;
      
      private var conVertDialog:MovieClip;
      
      private var _box:SimpleButton;
      
      private var _loader:MCLoader;
      
      private var _content:MovieClip;
      
      public function NpcClass_9(_arg_1:NpcInfo, _arg_2:DisplayObject)
      {
         super();
         this.conVertDialog = MapLibManager.getMovieClip("BeanPanel");
         this._box = MapManager.currentMap.controlLevel["box"];
         this._box.addEventListener(MouseEvent.CLICK,this.convertBeanDialog);
         this._curNpcModel = new NpcModel(_arg_1,_arg_2 as Sprite);
         this._curNpcModel.addEventListener(NpcEvent.NPC_CLICK,this.onClickNpc);
      }
      
      private function onClickNpc(_arg_1:NpcEvent) : void
      {
         NpcDialog.show(NPC.ROCKY,["嗨！小赛尔你好呀，我是来自火星基地的百事通罗开，有什么问题你尽管问我吧！"],["我想了解金豆","我想兑换金豆","我有一些关于金豆道具的建议哦！"],[this.handlerOne,this.handlerTwo,this.handlerThree]);
      }
      
      private function handlerOne() : void
      {
         this.loadBeanInfoSwf();
      }
      
      private function handlerTwo() : void
      {
         NpcDialog.show(NPC.ROCKY,["我带来的所有最in、最hot的商品都必须用赛尔金豆才可以换取哟！嗯？你现在就准备换取赛尔金豆吗？"],["哟呼！我已经准备好咯！","嗯……我还是稍后再来换取吧！"],[this.change]);
      }
      
      private function change() : void
      {
         this.convertBeanDialog(null);
      }
      
      private function handlerThree() : void
      {
         NpcDialog.show(NPC.ROCKY,["你是个充满智慧的小赛尔，找到我可算你有眼光了！想要什么呢？尽管和我说吧！我想我们火星港一定能够为你提供最前面的服务！"],["我这就写信和你说！","还是等等吧..."],[this.write]);
      }
      
      private function write() : void
      {
         ContributeAlert.show(ContributeAlert.ROCKY);
      }
      
      private function loadBeanInfoSwf() : void
      {
         this._loader = new MCLoader("resource/book/beaninfo.swf",LevelManager.topLevel,1,"正在打开");
         this._loader.addEventListener(MCLoadEvent.SUCCESS,this.onLoad);
         this._loader.doLoad();
      }
      
      private function onLoad(_arg_1:MCLoadEvent) : void
      {
         this._loader.removeEventListener(MCLoadEvent.SUCCESS,this.onLoad);
         this._content = _arg_1.getContent() as MovieClip;
         LevelManager.appLevel.addChild(this._content);
         DisplayUtil.align(this._content,null,AlignType.MIDDLE_CENTER);
         this._content["close_btn"].addEventListener(MouseEvent.CLICK,this.onCloseHandler);
      }
      
      private function onCloseHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this._content);
      }
      
      private function convertBeanDialog(_arg_1:MouseEvent) : void
      {
         var _local_2:SimpleButton = null;
         var _local_3:uint = 0;
         LevelManager.appLevel.addChild(this.conVertDialog);
         DisplayUtil.align(this.conVertDialog,null,AlignType.MIDDLE_CENTER);
         while(_local_3 < this.conVertDialog.numChildren)
         {
            if(this.conVertDialog.getChildAt(_local_3) is SimpleButton)
            {
               _local_2 = this.conVertDialog.getChildAt(_local_3) as SimpleButton;
               _local_2.addEventListener(MouseEvent.CLICK,this.onBtnClickHandler);
            }
            _local_3++;
         }
      }
      
      private function onBtnClickHandler(_arg_1:MouseEvent) : void
      {
         switch(_arg_1.currentTarget.name)
         {
            case "tenbean":
               ProductAction.buyMoneyProduct(200000);
               return;
            case "fiftybean":
               ProductAction.buyMoneyProduct(200001);
               return;
            case "percentbean":
               ProductAction.buyMoneyProduct(200002);
               return;
            case "closeBtn":
               DisplayUtil.removeForParent(this.conVertDialog);
         }
      }
      
      public function destroy() : void
      {
         if(Boolean(this._curNpcModel))
         {
            this._curNpcModel.removeEventListener(NpcEvent.NPC_CLICK,this.onClickNpc);
            this._curNpcModel.destroy();
            this._curNpcModel = null;
         }
         if(Boolean(this._box))
         {
            this._box.removeEventListener(MouseEvent.CLICK,this.convertBeanDialog);
         }
         if(Boolean(this._loader))
         {
            this._loader.removeEventListener(MCLoadEvent.SUCCESS,this.onLoad);
            this._loader.clear();
            this._loader = null;
         }
         if(Boolean(this._content))
         {
            this._content["close_btn"].removeEventListener(MouseEvent.CLICK,this.onCloseHandler);
         }
      }
      
      public function get npc() : NpcModel
      {
         return this._curNpcModel;
      }
   }
}

