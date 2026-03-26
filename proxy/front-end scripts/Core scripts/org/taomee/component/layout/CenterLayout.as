package org.taomee.component.layout
{
   import org.taomee.component.UIComponent;
   
   public class CenterLayout extends EmptyLayout implements ILayoutManager
   {
      
      private static const TYPE:String = "centerLayout";
      
      public function CenterLayout()
      {
         super();
      }
      
      override public function getType() : String
      {
         return TYPE;
      }
      
      override public function doLayout() : void
      {
         var _local_1:UIComponent = null;
         for each(_local_1 in container.compList)
         {
            _local_1.x = (container.width - _local_1.width) / 2;
            _local_1.y = (container.height - _local_1.height) / 2;
         }
      }
   }
}

