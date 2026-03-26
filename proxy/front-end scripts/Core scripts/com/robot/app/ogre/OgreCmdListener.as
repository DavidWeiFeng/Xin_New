package com.robot.app.ogre
{
   import com.robot.app.automaticFight.*;
   import com.robot.core.*;
   import com.robot.core.info.pet.PetGlowFilter;
   import com.robot.core.manager.*;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   
   public class OgreCmdListener extends BaseBeanController
   {
      
      public function OgreCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.MAP_OGRE_LIST,this.onOgreList);
         finish();
      }
      
      private function onOgreList(_arg_1:SocketEvent) : void
      {
         var _local_2:uint = 0;
         var _local_3:Object = null;
         var _local_6:int = 0;
         var shiny:PetGlowFilter = null;
         var isshiny:int = 0;
         if(!MapManager.isInMap)
         {
            return;
         }
         var _local_4:ByteArray = _arg_1.data as ByteArray;
         var _local_5:Array = [];
         while(_local_6 < 9)
         {
            _local_2 = _local_4.readUnsignedInt();
            shiny = null;
            isshiny = int(_local_4.readUnsignedInt());
            if(Boolean(isshiny))
            {
               shiny = new PetGlowFilter(_local_4);
            }
            if(Boolean(_local_2))
            {
               trace("异色配置3",_local_6,_local_2,shiny);
               OgreController.add(_local_6,_local_2,shiny);
               _local_5.push({
                  "_id":_local_2,
                  "_index":_local_6
               });
            }
            else
            {
               OgreController.remove(_local_6);
            }
            _local_6++;
         }
         if(_local_5.length > 0)
         {
            _local_3 = _local_5[Math.floor(Math.random() * _local_5.length)];
            AutomaticFightManager.beginFight(_local_3._index,_local_3._id);
         }
      }
   }
}

