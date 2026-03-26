package com.robot.core.controller
{
   import com.robot.core.config.*;
   import com.robot.core.manager.*;
   import flash.net.SharedObject;
   
   public class SaveUserInfo
   {
      
      private static const USERCOUNT:int = 3;
      
      private static var mySo:SharedObject = SOManager.getCommon_login();
      
      public static var isSave:Boolean = false;
      
      public static var pass:String = "";
      
      private static var vesion:uint = 0;
      
      private static var newsSo:SharedObject = SOManager.getNews_Read();
      
      public function SaveUserInfo()
      {
         super();
      }
      
      public static function saveSo() : void
      {
         var _local_1:int = 0;
         if(!SaveUserInfo.isSave)
         {
            return;
         }
         var _local_2:Array = SaveUserInfo.getUserInfo();
         if(_local_2 == null)
         {
            _local_2 = new Array();
         }
         else if(_local_2.length <= USERCOUNT)
         {
            _local_1 = 0;
            while(_local_1 < _local_2.length)
            {
               if(MainManager.actorID == _local_2[_local_1].id)
               {
                  _local_2.splice(_local_1,1);
               }
               _local_1++;
            }
         }
         _local_2.push({
            "id":MainManager.actorID,
            "nickName":MainManager.actorInfo.nick,
            "color":MainManager.actorInfo.color,
            "pwd":SaveUserInfo.pass,
            "clothes":MainManager.actorInfo.clothIDs,
            "texture":MainManager.actorInfo.texture
         });
         if(_local_2.length > 3)
         {
            _local_2.shift();
         }
         mySo.data.ousers = _local_2;
         SOManager.flush(mySo);
      }
      
      public static function saveNewsSO() : void
      {
         vesion = ClientConfig.newsVersion;
         newsSo.data.version = vesion;
         newsSo.data.userId = MainManager.actorInfo.userID;
         SOManager.flush(newsSo);
      }
      
      public static function getUserInfo() : Array
      {
         return mySo.data.ousers;
      }
      
      public static function getNewsVersion() : Object
      {
         var _local_1:Object = new Object();
         _local_1.id = newsSo.data.userId;
         _local_1.version = newsSo.data.version;
         return _local_1;
      }
   }
}

