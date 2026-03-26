package com.robot.app.RegisterCode
{
   import com.robot.core.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.*;
   
   public class GetRegisterCode
   {
      
      private static var code:uint;
      
      private static var codeMC:MovieClip;
      
      private static var curUserId:uint;
      
      public function GetRegisterCode()
      {
         super();
      }
      
      public static function getCode() : void
      {
         code = MainManager.actorInfo.userID + 1321047;
         Alarm.show("点右上角星际联络官图标后可得到邀请码");
      }
      
      public static function count() : void
      {
         if(MapManager.currentMap.id > 50000)
         {
            code = MapManager.currentMap.id + 1321047;
            curUserId = MapManager.currentMap.id;
         }
         else
         {
            code = MainManager.actorInfo.userID + 1321047;
            curUserId = MainManager.actorInfo.userID;
         }
         SocketConnection.addCmdListener(CommandID.REQUEST_COUNT,onCount);
         SocketConnection.send(CommandID.REQUEST_COUNT,curUserId);
      }
      
      private static function onCount(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.REQUEST_COUNT,onCount);
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         var _local_4:uint = _local_2.readUnsignedInt();
         codeMC = UIManager.getMovieClip("requestCodePanel");
         LevelManager.appLevel.addChild(codeMC);
         DisplayUtil.align(codeMC,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         (codeMC["codeTxt"] as TextField).text = code.toString();
         (codeMC["countTxt"] as TextField).text = _local_4.toString();
         codeMC.addEventListener(MouseEvent.CLICK,remove);
      }
      
      private static function remove(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(codeMC);
         LevelManager.openMouseEvent();
         codeMC.removeEventListener(MouseEvent.CLICK,remove);
         codeMC = null;
      }
      
      public static function get getRegCode() : uint
      {
         return MainManager.actorInfo.userID + 1321047;
      }
   }
}

