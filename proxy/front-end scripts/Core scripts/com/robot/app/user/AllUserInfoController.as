package com.robot.app.user
{
   import com.robot.core.info.UserInfo;
   import com.robot.core.manager.MainManager;
   import flash.display.DisplayObjectContainer;
   import org.taomee.utils.DisplayUtil;
   
   public class AllUserInfoController
   {
      
      private static var _myPanel:AllUserInfoPanel;
      
      private static var _oTherPanel:AllUserInfoPanel;
      
      private static var status:Boolean = false;
      
      public function AllUserInfoController()
      {
         super();
      }
      
      public static function get myPanel() : AllUserInfoPanel
      {
         if(!_myPanel)
         {
            _myPanel = new AllUserInfoPanel();
         }
         return _myPanel;
      }
      
      public static function get oTherPanel() : AllUserInfoPanel
      {
         if(!_oTherPanel)
         {
            _oTherPanel = new AllUserInfoPanel();
         }
         return _oTherPanel;
      }
      
      public static function show(_arg_1:UserInfo, _arg_2:DisplayObjectContainer) : void
      {
         if(_arg_1.userID == MainManager.actorInfo.userID)
         {
            if(!DisplayUtil.hasParent(myPanel))
            {
               myPanel.show(_arg_1,_arg_2);
            }
            else
            {
               myPanel.init(_arg_1);
            }
         }
         else
         {
            if(!DisplayUtil.hasParent(oTherPanel))
            {
               oTherPanel.show(_arg_1,_arg_2);
            }
            else
            {
               oTherPanel.init(_arg_1);
            }
            status = true;
         }
      }
      
      public static function hide() : void
      {
         oTherPanel.hide();
         status = false;
      }
      
      public static function set setStatus(_arg_1:Boolean) : void
      {
         status = _arg_1;
      }
      
      public static function get getStatus() : Boolean
      {
         return status;
      }
   }
}

