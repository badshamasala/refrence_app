import 'package:aayu/model/grow/grow.page.content.model.dart';
import 'package:get/get.dart';

class ContentPreviewController extends GetxController {
  RxBool playContentPreview = false.obs;
  Rx<Content?> selectedContent = Content().obs;

  startContentPreview(Content content){
    playContentPreview.value = true;
    selectedContent.value = content;
    update();
  }

  stopContentPreview(){
    playContentPreview.value = false;
    selectedContent.value = null;
    update();
  }
}