package com.robot.core.aticon
{
   import com.robot.core.CommandID;
   import com.robot.core.aimat.AimatController;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.config.xml.SuitXMLInfo;
   import com.robot.core.controller.SaveUserInfo;
   import com.robot.core.event.UserEvent;
   import com.robot.core.info.clothInfo.PeopleItemInfo;
   import com.robot.core.info.item.DoodleInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.skeleton.TransformSkeleton;
   import flash.utils.ByteArray;
   import org.taomee.manager.EventManager;
   
   public class FigureAction
   {
      
      public function FigureAction()
      {
         super();
      }
      
      public function changeCloth(_arg_1:BasePeoleModel, _arg_2:Array, _arg_3:Boolean = true) : void
      {
         var _local_4:PeopleItemInfo = null;
         var _local_5:uint = 0;
         var _local_6:ByteArray = null;
         var _local_7:Array = null;
         if(_arg_3)
         {
            _local_5 = _arg_2.length;
            _local_6 = new ByteArray();
            for each(_local_4 in _arg_2)
            {
               _local_6.writeUnsignedInt(_local_4.id);
            }
            SocketConnection.send(CommandID.CHANGE_CLOTH,_local_5,_local_6);
         }
         else
         {
            _arg_1.skeleton.takeOffCloth();
            _arg_1.skeleton.changeCloth(_arg_2);
            _arg_1.info.clothes = _arg_2;
            if(_arg_1.skeleton is TransformSkeleton)
            {
               if(SuitXMLInfo.getSuitID(_arg_1.info.clothIDs) == 0)
               {
                  TransformSkeleton(_arg_1.skeleton).untransform();
               }
               else if(!SuitXMLInfo.getIsTransform(SuitXMLInfo.getSuitID(_arg_1.info.clothIDs)))
               {
                  TransformSkeleton(_arg_1.skeleton).untransform();
               }
            }
            SaveUserInfo.saveSo();
            _local_7 = [];
            for each(_local_4 in _arg_2)
            {
               _local_7.push(_local_4.id);
            }
            if(_arg_1.info.userID == MainManager.actorID)
            {
               AimatController.setClothType(_local_7);
            }
            _arg_1.speed = ItemXMLInfo.getSpeed(_local_7);
            EventManager.dispatchEvent(new UserEvent(UserEvent.INFO_CHANGE,_arg_1.info));
            _arg_1.showClothLight();
         }
      }
      
      public function changeNickName(_arg_1:BasePeoleModel, _arg_2:String, _arg_3:Boolean = true) : void
      {
         var _local_4:ByteArray = null;
         if(_arg_3)
         {
            _local_4 = new ByteArray();
            _local_4.writeUTFBytes(_arg_2);
            _local_4.length = 16;
            SocketConnection.send(CommandID.CHANG_NICK_NAME,_local_4);
         }
         else
         {
            _arg_1.info.nick = _arg_2;
            EventManager.dispatchEvent(new UserEvent(UserEvent.INFO_CHANGE,_arg_1.info));
         }
      }
      
      public function changeColor(_arg_1:BasePeoleModel, _arg_2:uint, _arg_3:Boolean = true) : void
      {
         if(_arg_3)
         {
            SocketConnection.send(CommandID.CHANGE_COLOR,_arg_2);
         }
         else
         {
            _arg_1.skeleton.changeColor(_arg_2);
            _arg_1.info.color = _arg_2;
            _arg_1.info.texture = 0;
            SaveUserInfo.saveSo();
         }
      }
      
      public function changeDoodle(_arg_1:BasePeoleModel, _arg_2:DoodleInfo, _arg_3:Boolean = true) : void
      {
         if(_arg_2.texture == 0)
         {
            this.changeColor(_arg_1,_arg_2.color);
            return;
         }
         if(_arg_3)
         {
            SocketConnection.send(CommandID.CHANGE_DOODLE,_arg_2.id,_arg_2.color);
         }
         else
         {
            _arg_1.info.texture = _arg_2.texture;
            _arg_1.info.color = _arg_2.color;
            _arg_1.info.coins = _arg_2.coins;
            if(_arg_2.URL == "" || _arg_2.URL == null)
            {
               return;
            }
            _arg_1.skeleton.changeDoodle(_arg_2.URL);
            _arg_1.skeleton.changeColor(_arg_2.color,false);
            SaveUserInfo.saveSo();
         }
      }
   }
}

