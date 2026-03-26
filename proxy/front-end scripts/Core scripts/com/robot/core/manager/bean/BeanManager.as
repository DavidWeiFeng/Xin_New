package com.robot.core.manager.bean
{
   import com.robot.core.event.*;
   import com.robot.core.newloader.*;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.manager.*;
   
   public class BeanManager
   {
      
      private static var xmlData:XMLList;
      
      private static var dataArray:Array;
      
      private static var dataDictionary:Dictionary;
      
      public static const BEAN_FINISH:String = "beanFinish";
      
      private static const ID_NODE:String = "id";
      
      private static const CLASS_NODE:String = "class";
      
      public function BeanManager()
      {
         super();
      }
      
      public static function start() : void
      {
         var _local_1:* = getDefinitionByName("DLLLoader");
         xmlData = _local_1.getBeanXML();
         parseXML();
      }
      
      private static function failLoadHandler(_arg_1:XMLLoadEvent) : void
      {
         var _local_2:XMLLoader = _arg_1.currentTarget as XMLLoader;
         _local_2.removeEventListener(XMLLoadEvent.ERROR,failLoadHandler);
      }
      
      private static function parseXML() : void
      {
         var _local_1:XML = null;
         var _local_2:String = null;
         var _local_3:String = null;
         dataArray = [];
         dataDictionary = new Dictionary(true);
         for each(_local_1 in xmlData.elements())
         {
            _local_2 = _local_1.attribute(ID_NODE).toString();
            _local_3 = _local_1.attribute(CLASS_NODE).toString();
            dataArray.push({
               "id":_local_2,
               "classPath":_local_3
            });
         }
         EventManager.addEventListener(BEAN_FINISH,initClasses);
         initClasses();
      }
      
      private static function initClasses(_arg_1:Event = null) : void
      {
         var _local_2:Class = null;
         var _local_3:* = undefined;
         if(dataArray.length > 0)
         {
            _local_2 = getDefinitionByName(dataArray[0]["classPath"]) as Class;
            _local_3 = new _local_2();
            dataDictionary[dataArray[0]["id"]] = _local_3;
            dataArray.shift();
            _local_3.start();
         }
         else
         {
            EventManager.removeEventListener(BeanManager.BEAN_FINISH,initClasses);
            EventManager.dispatchEvent(new Event(RobotEvent.BEAN_COMPLETE));
         }
      }
      
      public static function getBeanInstance(_arg_1:String) : *
      {
         return dataDictionary[_arg_1];
      }
   }
}

