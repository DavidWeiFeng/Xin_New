package com.robot.app.control
{
   import com.robot.app.task.taskUtils.taskDialog.DynamicNpcTipDialog;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.app.vipSession.VipSession;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.info.NonoInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.NonoManager;
   import flash.events.Event;
   
   public class FollowController
   {
      
      public function FollowController()
      {
         super();
      }
      
      public static function followSuperNono(withoutNonoStr:String, noSuperStr:String, func:Function = null, superFunc:Function = null) : void
      {
         var info:NonoInfo = null;
         if(Boolean(MainManager.actorModel.nono))
         {
            if(func != null)
            {
               func();
            }
            info = NonoManager.info;
            if(info.superNono)
            {
               if(superFunc != null)
               {
                  superFunc();
               }
            }
            else
            {
               DynamicNpcTipDialog.show(noSuperStr,function():void
               {
                  var r:VipSession = new VipSession();
                  r.addEventListener(VipSession.GET_SESSION,function(_arg_1:Event):void
                  {
                  });
                  r.getSession();
               },NpcTipDialog.NONO);
            }
         }
         else
         {
            NpcTipDialog.show(withoutNonoStr,null,NpcTipDialog.NONO);
         }
      }
      
      public static function followPet(_arg_1:Function = null, _arg_2:Function = null, _arg_3:Array = null, _arg_4:String = null, _arg_5:Function = null, _arg_6:Function = null) : void
      {
         var _local_7:uint = 0;
         var _local_8:uint = 0;
         if(Boolean(MainManager.actorModel.pet))
         {
            _local_7 = uint(MainManager.actorModel.pet.info.petID);
            if(_arg_3 == null && _arg_4 == null && _arg_4 == "")
            {
               if(_arg_2 != null)
               {
                  _arg_2();
               }
            }
            else if(_arg_3 != null)
            {
               for each(_local_8 in _arg_3)
               {
                  if(_local_8 == _local_7)
                  {
                     if(_arg_5 != null)
                     {
                        _arg_5();
                     }
                     return;
                  }
               }
               if(_arg_6 != null)
               {
                  _arg_6();
               }
            }
            else
            {
               if(_arg_4 == null || _arg_4 == "")
               {
                  return;
               }
               if(PetXMLInfo.getTypeCN(_local_7) == _arg_4)
               {
                  if(_arg_5 != null)
                  {
                     _arg_5();
                  }
               }
               else if(_arg_6 != null)
               {
                  _arg_6();
               }
            }
         }
         else if(_arg_1 != null)
         {
            _arg_1();
         }
      }
   }
}

