package org.taomee.component.layout
{
   import org.taomee.component.UIComponent;
   
   public class FitSizeLayout extends EmptyLayout implements ILayoutManager
   {
      
      private static const TYPE:String = "fitSizeLayout";
      
      public function FitSizeLayout()
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
            _local_1.y = 0;
            _local_1.x = 0;
            _local_1.setSizeWH(container.width,container.height);
         }
      }
   }
}

