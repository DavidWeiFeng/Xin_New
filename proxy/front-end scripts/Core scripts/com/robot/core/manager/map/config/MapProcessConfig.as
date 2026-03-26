package com.robot.core.manager.map.config
{
   import com.robot.core.manager.map.MapType;
   import org.taomee.utils.Utils;
   
   public class MapProcessConfig
   {
      
      public static var currentProcessInstance:BaseMapProcess;
      
      private static var PATH:String = "com.robot.app.mapProcess.MapProcess_";
      
      public function MapProcessConfig()
      {
         super();
      }
      
      public static function configMap(_arg_1:uint, _arg_2:uint = 0) : void
      {
         var _local_3:String = null;
         if(_arg_1 > 50000)
         {
            switch(_arg_2)
            {
               case MapType.HOOM:
                  _local_3 = "com.robot.app.mapProcess.RoomMap";
                  break;
               case MapType.CAMP:
                  _local_3 = "com.robot.app.mapProcess.FortressMap";
                  break;
               case MapType.HEAD:
                  _local_3 = "com.robot.app.mapProcess.HeadquartersMap";
                  break;
               case MapType.PK_TYPE:
                  _local_3 = "com.robot.app.mapProcess.PKMap";
            }
            if(_local_3 == null || _local_3 == "")
            {
               return;
            }
         }
         else
         {
            _local_3 = PATH + _arg_1.toString();
         }
         var _local_4:Class = Utils.getClass(_local_3);
         if(Boolean(_local_4))
         {
            currentProcessInstance = new _local_4() as BaseMapProcess;
         }
         else
         {
            currentProcessInstance = new BaseMapProcess();
         }
      }
      
      public static function destroy() : void
      {
         if(Boolean(currentProcessInstance))
         {
            currentProcessInstance.destroy();
         }
         currentProcessInstance = null;
      }
   }
}

