// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ViewDietPlanPDF extends StatefulWidget {
  final String headerText;
  final String pdfUrl;
  const ViewDietPlanPDF(
      {Key? key, required this.pdfUrl, required this.headerText})
      : super(key: key);
  @override
  State<ViewDietPlanPDF> createState() => _EBookReadState();
}

class _EBookReadState extends State<ViewDietPlanPDF> {
  String urlPDFPath = "";
  bool fileReady = false;
  bool pdfReady = false;
  late PDFViewController pdfViewController;

  @override
  void initState() {
    createFileOfPdfUrl(true).then((f) {
      setState(() {
        urlPDFPath = f.path;
        fileReady = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pageBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.blackLabelColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "${widget.headerText} - Food Plan",
          style: appBarTextStyle(),
        ),
        actions: [
          InkWell(
              onTap: () {
                setState(() {
                  fileReady = false;
                  createFileOfPdfUrl(false).then((f) {
                    setState(() {
                      urlPDFPath = f.path;
                      fileReady = true;
                    });
                  });
                });
              },
              child: const Icon(
                Icons.refresh,
                color: AppColors.blackLabelColor,
              )),
          SizedBox(
            width: 26.h,
          ),
        ],
      ),
      body: !fileReady
          ? Center(
              child: Text(
                "Downloading your diet plan.Please wait!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          : createPDFViewer(),
    );
  }

  Future<File> createFileOfPdfUrl(bool useLocalFile) async {
    final filename =
        widget.pdfUrl.substring(widget.pdfUrl.lastIndexOf("/") + 1);

    if (useLocalFile == true) {
      String dir = (await getApplicationDocumentsDirectory()).path;
      bool fileExist = await File('$dir/$filename').exists();
      if (fileExist) {
        File file = File('$dir/$filename');
        return file;
      }
    }
    HttpClientRequest request =
        await HttpClient().getUrl(Uri.parse(widget.pdfUrl));
    HttpClientResponse response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  createPDFViewer() {
    return Stack(
      children: <Widget>[
        PDFView(
          filePath: urlPDFPath,
          autoSpacing: false,
          enableSwipe: true,
          pageSnap: true,
          pageFling: true,
          swipeHorizontal: false,
          nightMode: false,
          fitPolicy: FitPolicy.BOTH,
          preventLinkNavigation: true,
          fitEachPage: true,
          onError: (error) {
            showSnackBar(context, error.toString(), SnackBarMessageTypes.Error);
          },
          onRender: (int? pages) async {
            setState(() {
              pdfReady = true;
            });
          },
          onViewCreated: (PDFViewController vc) {
            pdfViewController = vc;
          },
          onPageChanged: (int? page, int? total) async {},
          onPageError: (page, error) {
            showSnackBar(context, error.toString(), SnackBarMessageTypes.Error);
          },
        ),
        !pdfReady ? showLoading() : const Offstage(),
      ],
    );
  }
}
