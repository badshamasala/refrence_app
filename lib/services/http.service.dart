import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config.dart';

bool printHeaders = false;
bool printResponse = true;

Future httpGet(String serviceName, String path,
    {Map<String, dynamic>? customHeaders}) async {
  dynamic responseData;
  String url = "";
  dynamic headers = {};
  http.Response? httpResponse;

  try {
    String apiBaseUrl = Config.apiBaseUrl[serviceName]["baseUrl"];
    url = apiBaseUrl + path;
    headers = {
      "X-Api-Key": Config.apiBaseUrl[serviceName]["apiKey"].toString(),
    };

    customHeaders?.forEach((key, value) {
      headers[key] = value;
    });

    httpResponse = await http.get(Uri.parse(url), headers: headers);
    responseData = json.decode(httpResponse.body);
    return responseData;
  } catch (err) {
    logException("httpGet", url, headers, null, err);
    if (err.toString().contains("Failed host lookup")) {
      responseData = {
        "success": false,
        "error": {"code": 0, "message": "Failed host lookup"},
      };
      return responseData;
    }
    responseData = {
      "success": false,
      "error": {
        "code": 0,
        "message": "Something went wrong. Please try again!"
      },
    };

    return responseData;
  } finally {
    print(
        '---------HTTP SERVICE---------\nmethod => httpGet\nURL => $url\nheaders => ${printHeaders == true ? json.encode(headers) : "Headers printing disabled"}\npostData => \nstatusCode => ${httpResponse?.statusCode}\nresponse => ${printResponse == true ? json.encode(responseData) : "Reponse printing disabled"}');
  }
}

Future httpDelete(String serviceName, String path,
    {Map<String, dynamic>? customHeaders}) async {
  dynamic responseData;
  String url = "";
  dynamic headers = {};
  http.Response? httpResponse;

  try {
    String apiBaseUrl = Config.apiBaseUrl[serviceName]["baseUrl"];
    url = apiBaseUrl + path;
    headers = {
      "X-Api-Key": Config.apiBaseUrl[serviceName]["apiKey"].toString(),
    };

    customHeaders?.forEach((key, value) {
      headers[key] = value;
    });

    httpResponse = await http.delete(Uri.parse(url), headers: headers);
    responseData = json.decode(httpResponse.body);
    return responseData;
  } catch (err) {
    logException("httpDelete", url, headers, null, err);
    if (err.toString().contains("Failed host lookup")) {
      responseData = {
        "success": false,
        "error": {"code": 0, "message": "Failed host lookup"},
      };
      return responseData;
    }
    responseData = {
      "success": false,
      "error": {
        "code": 0,
        "message": "Something went wrong. Please try again!"
      },
    };

    return responseData;
  } finally {
    print(
        '---------HTTP SERVICE---------\nmethod => httpDelete\nURL => $url\nheaders => ${printHeaders == true ? json.encode(headers) : "Headers printing disabled"}\npostData => \nstatusCode => ${httpResponse?.statusCode}\nresponse => ${printResponse == true ? json.encode(responseData) : "Reponse printing disabled"}');
  }
}

Future httpPost(String serviceName, String path, Map<String, dynamic>? postData,
    {Map<String, dynamic>? customHeaders}) async {
  Map<String, dynamic> responseData = {};
  String url = "";
  dynamic headers = {};
  http.Response? httpResponse;

  try {
    String apiBaseUrl = Config.apiBaseUrl[serviceName]["baseUrl"];
    url = apiBaseUrl + path;
    headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      "X-Api-Key": Config.apiBaseUrl[serviceName]["apiKey"].toString(),
    };

    customHeaders?.forEach((key, value) {
      headers[key] = value;
    });

    httpResponse = await http.post(Uri.parse(url),
        headers: headers,
        body: (postData == null ? postData : json.encode(postData)));

    responseData =
        json.decode(const Utf8Codec().decode(httpResponse.bodyBytes));
    return responseData;
  } catch (err) {
    logException("httpPost", url, headers, postData, err);
    if (err.toString().contains("Failed host lookup")) {
      responseData = {
        "success": false,
        "error": {"code": 0, "message": "Failed host lookup"},
      };
      return responseData;
    }
    responseData = {
      "success": false,
      "error": {
        "code": 0,
        "message": "Something went wrong. Please try again!"
      },
    };

    return responseData;
  } finally {
    print(
        '---------HTTP SERVICE---------\nmethod => httpPost\nURL => $url\nheaders => ${printHeaders == true ? json.encode(headers) : "Headers printing disabled"}\npostData => ${postData == null ? postData : json.encode(postData)}\nstatusCode => ${httpResponse?.statusCode}\nresponse => ${printResponse == true ? json.encode(responseData) : "Reponse printing disabled"}');
  }
}

Future httpPatch(
    String serviceName, String path, Map<String, dynamic>? postData,
    {Map<String, dynamic>? customHeaders}) async {
  Map<String, dynamic> responseData = {};
  String url = "";
  dynamic headers = {};
  http.Response? httpResponse;

  try {
    String apiBaseUrl = Config.apiBaseUrl[serviceName]["baseUrl"];
    url = apiBaseUrl + path;
    headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      "X-Api-Key": Config.apiBaseUrl[serviceName]["apiKey"].toString(),
    };

    customHeaders?.forEach((key, value) {
      headers[key] = value;
    });

    httpResponse = await http.patch(Uri.parse(url),
        headers: headers,
        body: (postData == null ? postData : json.encode(postData)));

    responseData =
        json.decode(const Utf8Codec().decode(httpResponse.bodyBytes));
    return responseData;
  } catch (err) {
    logException("httpPatch", url, headers, postData, err);
    if (err.toString().contains("Failed host lookup")) {
      responseData = {
        "success": false,
        "error": {"code": 0, "message": "Failed host lookup"},
      };
      return responseData;
    }
    responseData = {
      "success": false,
      "error": {
        "code": 0,
        "message": "Something went wrong. Please try again!"
      },
    };

    return responseData;
  } finally {
    print(
        '---------HTTP SERVICE---------\nmethod => httpPatch\nURL => $url\nheaders => ${printHeaders == true ? json.encode(headers) : "Headers printing disabled"}\npostData => ${postData == null ? postData : json.encode(postData)}\nstatusCode => ${httpResponse?.statusCode}\nresponse => ${printResponse == true ? json.encode(responseData) : "Reponse printing disabled"}');
  }
}

Future httpPut(
    String serviceName, String path, Map<String, dynamic>? postData,
    {Map<String, dynamic>? customHeaders}) async {
  Map<String, dynamic> responseData = {};
  String url = "";
  dynamic headers = {};
  http.Response? httpResponse;

  try {
    String apiBaseUrl = Config.apiBaseUrl[serviceName]["baseUrl"];
    url = apiBaseUrl + path;
    headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      "X-Api-Key": Config.apiBaseUrl[serviceName]["apiKey"].toString(),
    };

    customHeaders?.forEach((key, value) {
      headers[key] = value;
    });

    httpResponse = await http.put(Uri.parse(url),
        headers: headers,
        body: (postData == null ? postData : json.encode(postData)));

    responseData =
        json.decode(const Utf8Codec().decode(httpResponse.bodyBytes));
    return responseData;
  } catch (err) {
    logException("httpPut", url, headers, postData, err);
    responseData = {
      "success": false,
      "error": {"code": 0, "message": "Something went wrong. Please try again!"}
    };
    return responseData;
  } finally {
    print(
        '---------HTTP SERVICE---------\nmethod => httpPut\nURL => $url\nheaders => ${printHeaders == true ? json.encode(headers) : "Headers printing disabled"}\npostData => ${postData == null ? postData : json.encode(postData)}\nstatusCode => ${httpResponse?.statusCode}\nresponse => ${printResponse == true ? json.encode(responseData) : "Reponse printing disabled"}');
  }
}

httpFileUpload(String serviceName, String path, Map<String, dynamic>? postData,
    http.MultipartFile multipartFile,
    {Map<String, dynamic>? customHeaders}) async {
  Map<String, dynamic> responseData = {};
  String url = "";
  dynamic headers = {};
  http.StreamedResponse httpResponse;
  int statusCode = 0;

  try {
    String apiBaseUrl = Config.apiBaseUrl[serviceName]["baseUrl"];
    url = apiBaseUrl + path;
    headers = {
      HttpHeaders.contentTypeHeader: "multipart/form-data",
      "X-Api-Key": Config.apiBaseUrl[serviceName]["apiKey"].toString(),
    };

    customHeaders?.forEach((key, value) {
      headers[key] = value;
    });

    http.MultipartRequest multipartRequest =
        http.MultipartRequest("PATCH", Uri.parse(url));
    multipartRequest.headers.addAll(headers);
    multipartRequest.files.add(multipartFile);
    httpResponse = await multipartRequest.send();
    statusCode = httpResponse.statusCode;

    responseData = json
        .decode(const Utf8Codec().decode(await httpResponse.stream.toBytes()));

    return responseData;
  } catch (err) {
    logException("httpFileUpload", url, headers, postData, err);
    if (err.toString().contains("Failed host lookup")) {
      responseData = {
        "success": false,
        "error": {"code": 0, "message": "Failed host lookup"},
      };
      return responseData;
    }
    responseData = {
      "success": false,
      "error": {
        "code": 0,
        "message": "Something went wrong. Please try again!"
      },
    };

    return responseData;
  } finally {
    print(
        '---------HTTP SERVICE---------\nmethod => httpFileUpload\nURL => $url\nheaders => ${printHeaders == true ? json.encode(headers) : "Headers printing disabled"}\npostData => ${postData == null ? postData : json.encode(postData)}\nstatusCode => $statusCode\nresponse => ${printResponse == true ? json.encode(responseData) : "Reponse printing disabled"}');
  }
}

logException(String method, String url, dynamic headers,
    Map<String, dynamic>? postData, err) {
  print(
      '---------HTTP SERVICE | Exception---------\nmethod => $method\nURL => $url\nheaders => ${json.encode(headers)}\npostData => ${postData == null ? null : json.encode(postData)}\nexception => ${err.toString()}');
}
