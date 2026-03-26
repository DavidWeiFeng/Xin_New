package com.robot.app.bag
{
   import com.robot.core.config.xml.*;
   import com.robot.core.info.clothInfo.PeopleItemInfo;
   import com.robot.core.info.item.*;
   import com.robot.core.mode.ISkeletonSprite;
   import com.robot.core.skeleton.ClothPreview;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class BagClothPreview extends ClothPreview
   {
      
      public function BagClothPreview(_arg_1:Sprite, _arg_2:ISkeletonSprite = null, _arg_3:uint = 0)
      {
         super(_arg_1,_arg_2,_arg_3);
      }
      
      override protected function initChangeCloth() : void
      {
         var _local_1:String = null;
         var _local_2:BagChangeClothAction = null;
         for each(_local_1 in flagArray)
         {
            _local_2 = new BagChangeClothAction(people,mcObj[_local_1],_local_1,model);
            changeClothActObj[_local_1] = _local_2;
         }
      }
      
      public function showCloth(_arg_1:uint, _arg_2:uint) : void
      {
         var _local_3:BagChangeClothAction = null;
         var _local_4:ClothData = ClothInfo.getItemInfo(_arg_1);
         _local_3 = changeClothActObj[_local_4.type];
         _local_3.changeClothByPath(_arg_1,_local_4.getPrevUrl(_arg_2));
      }
      
      public function showCloths(_arg_1:Array) : void
      {
         var _local_2:PeopleItemInfo = null;
         takeOffCloth();
         for each(_local_2 in _arg_1)
         {
            this.showCloth(_local_2.id,_local_2.level);
         }
      }
      
      public function getChangeClothAct(_arg_1:String) : BagChangeClothAction
      {
         return changeClothActObj[_arg_1];
      }
      
      public function showDoodle(texture:uint) : void
      {
         var url:String = null;
         DisplayUtil.removeAllChild(doodleMC);
         url = DoodleXMLInfo.getPrevURL(texture);
         if(url == "")
         {
            return;
         }
         ResourceManager.getResource(url,function(_arg_1:DisplayObject):void
         {
            _arg_1.x = 3;
            _arg_1.y = 14;
            doodleMC.addChild(_arg_1);
         });
      }
   }
}

