package com.robot.app.bag
{
   import com.robot.core.info.clothInfo.PeopleItemInfo;
   import com.robot.core.info.item.ClothInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.mode.ISkeletonSprite;
   import com.robot.core.skeleton.ChangeClothAction;
   import com.robot.core.skeleton.ClothPreview;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.events.DynamicEvent;
   
   public class BagChangeClothAction extends ChangeClothAction
   {
      
      public static const TAKE_OFF_CLOTH:String = "takeOffCloth";
      
      public static const REPLACE_CLOTH:String = "replaceCloth";
      
      public static const USE_CLOTH:String = "useCloth";
      
      public static const CLOTH_CHANGE:String = "bagClothChange";
      
      public function BagChangeClothAction(_arg_1:ISkeletonSprite, _arg_2:Sprite, _arg_3:String, _arg_4:uint)
      {
         super(_arg_1,_arg_2,_arg_3,_arg_4);
      }
      
      override protected function unloadCloth(_arg_1:MouseEvent) : void
      {
         var _local_2:uint = 0;
         if(clothID == ClothInfo.DEFAULT_FOOT || clothID == ClothInfo.DEFAULT_HEAD || clothID == ClothInfo.DEFAULT_WAIST)
         {
            return;
         }
         if(Boolean(clothSWF))
         {
            clothSWF.parent.removeChild(clothSWF);
            clothSWF = null;
            MainManager.actorModel.dispatchEvent(new DynamicEvent(BagChangeClothAction.TAKE_OFF_CLOTH,clothID));
            clothID = 0;
            MainManager.actorModel.dispatchEvent(new Event(BagChangeClothAction.CLOTH_CHANGE));
         }
         if(type == ClothPreview.FLAG_HEAD)
         {
            _local_2 = uint(ClothInfo.DEFAULT_HEAD);
         }
         else if(type == ClothPreview.FLAG_FOOT)
         {
            _local_2 = uint(ClothInfo.DEFAULT_FOOT);
         }
         else
         {
            if(type != ClothPreview.FLAG_WAIST)
            {
               return;
            }
            _local_2 = uint(ClothInfo.DEFAULT_WAIST);
         }
         var _local_3:String = ClothInfo.getItemInfo(_local_2).getPrevUrl();
         this.changeClothByPath(_local_2,_local_3);
      }
      
      override public function changeCloth(_arg_1:PeopleItemInfo) : void
      {
         if(this.clothID != 0 && this.clothID != ClothInfo.DEFAULT_FOOT && this.clothID != ClothInfo.DEFAULT_HEAD && this.clothID != ClothInfo.DEFAULT_WAIST)
         {
            if(Boolean(MainManager.actorModel))
            {
               MainManager.actorModel.dispatchEvent(new DynamicEvent(REPLACE_CLOTH,this.clothID));
            }
         }
         else if(Boolean(MainManager.actorModel))
         {
            MainManager.actorModel.dispatchEvent(new DynamicEvent(USE_CLOTH,this.clothID));
         }
         this.clothID = _arg_1.id;
         beginLoad();
         if(Boolean(MainManager.actorModel))
         {
            MainManager.actorModel.dispatchEvent(new Event(BagChangeClothAction.CLOTH_CHANGE));
         }
      }
      
      override public function changeClothByPath(_arg_1:int, _arg_2:String) : void
      {
         if(!(_arg_1 == ClothInfo.DEFAULT_FOOT || _arg_1 == ClothInfo.DEFAULT_HEAD || _arg_1 == ClothInfo.DEFAULT_WAIST))
         {
            if(this.clothID != 0 && this.clothID != ClothInfo.DEFAULT_FOOT && this.clothID != ClothInfo.DEFAULT_HEAD && this.clothID != ClothInfo.DEFAULT_WAIST)
            {
               if(Boolean(MainManager.actorModel))
               {
                  MainManager.actorModel.dispatchEvent(new DynamicEvent(REPLACE_CLOTH,this.clothID));
               }
            }
            else if(Boolean(MainManager.actorModel))
            {
               MainManager.actorModel.dispatchEvent(new DynamicEvent(USE_CLOTH,this.clothID));
            }
         }
         this.clothID = _arg_1;
         beginLoad(_arg_2);
         if(Boolean(MainManager.actorModel))
         {
            MainManager.actorModel.dispatchEvent(new Event(BagChangeClothAction.CLOTH_CHANGE));
         }
      }
   }
}

