import 'dart:ui';

import '../../custom_code/model/furlough_ticket.dart';
import '../../flutter_flow/flutter_flow_util.dart';

import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class PTCLoginCall {
  static Future<ApiCallResponse> call({
    String? userName = '',
    String? password = '',
  }) {
    final body = '''
{
  "UserName": "${userName}",
  "Password": "${password}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'PTCLogin',
      apiUrl: 'https://app.phattien.com/api/User/Login',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
    );
  }

  static dynamic tesst(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
}

class PTCTitleCall {
  static Future<ApiCallResponse> call({
    String? userName = '',
  }) {
    return ApiManager.instance.makeApiCall(
      callName: 'PTCTitle',
      apiUrl:
          'https://app.phattien.com/api/Timekeep/GetTitleTimekeepApp?userName=${userName}',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
    );
  }
}

class PTCTimekeepCall {
  static Future<ApiCallResponse> call({
    String? userName = '',
  }) {
    return ApiManager.instance.makeApiCall(
      callName: 'PTCTimekeep',
      apiUrl:
          'https://app.phattien.com/api/Timekeep/GetCalendarApp?userName=${userName}',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
    );
  }
}

class PTCDetailDateCall {
  static Future<ApiCallResponse> call({
    String? userName = '',
    String? selectDate = '',
  }) {
    return ApiManager.instance.makeApiCall(
      callName: 'PTCDetailDate',
      apiUrl:
          'https://app.phattien.com/api/Timekeep/GetDateDetail?userName=${userName}&selectDate=${selectDate}',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
    );
  }
}

class PTCGetLeaveYear {
  static Future<ApiCallResponse> call({
    String? userName = '',
    String? fromDate = '',
  }) {
    return ApiManager.instance.makeApiCall(
      callName: 'PTCGetLeaveYear',
      apiUrl:
          'https://app.phattien.com/api/Timekeep/GetLeaveYear?userName=${userName}&fromDate=${fromDate}',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
    );
  }
}

class PTCCreateTicketTSCall {
  static Future<ApiCallResponse> call({
    String? userName = '',
    String? reasonType = '',
    String? lateReason = '',
    String? note = '',
    String? timeIn = '',
    String? timeOut = '',
    String? afterApprovedTimeIn = '',
    String? afterApprovedTimeOut = '',
    String? requestingDate = '',
  }) {
    final body = '''
{
  "UserName": "${userName}",
  "RequestingDate": "${requestingDate}",
  "ReasonType": "${reasonType}",
  "LateReason":"${lateReason}",
  "Note":"${note}",
  "TimeIn": "${timeIn}",
  "TimeOut": "${timeOut}",
  "AfterApprovedTimeIn": "${afterApprovedTimeIn}",
  "AfterApprovedTimeOut": "${afterApprovedTimeOut}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'PTCCreateTicketTS',
      apiUrl: 'https://app.phattien.com/api/Timekeep/CreateTicketTS',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
    );
  }
}

class PTCCreateTicketCTCall {
  static Future<ApiCallResponse> call({
    String? userName = '',
    String? requestingDate = '',
    String? reasonType = '',
    String? note = '',
    String? timeIn = '',
    String? timeOut = '',
    String? afterApprovedTimeIn = '',
    String? afterApprovedTimeOut = '',
  }) {
    final body = '''
{
  "UserName": "${userName}",
  "RequestingDate": "${requestingDate}",
  "ReasonType": "${reasonType}",
  "Note":"${note}",
  "TimeIn": "${timeIn}",
  "TimeOut": "${timeOut}",
  "AfterApprovedTimeIn": "${afterApprovedTimeIn}",
  "AfterApprovedTimeOut": "${afterApprovedTimeOut}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'PTCCreateTicketCT',
      apiUrl: 'https://app.phattien.com/api/Timekeep/CreateTicketCT',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
    );
  }
}

class PTCCreateTicketTCCall {
  static Future<ApiCallResponse> call({
    String? userName = '',
    String? requestingDate = '',
    String? reasonType = '',
    String? otHours = '',
    String? note = '',
  }) {
    final body = '''
{
  "UserName": "${userName}",
  "RequestingDate": "${requestingDate}",
  "ReasonType":"${reasonType}",
  "OTHours": "${otHours}",
  "Note":"${note}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'PTCCreateTicketTC',
      apiUrl: 'https://app.phattien.com/api/Timekeep/CreateTicketTC',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
    );
  }
}

class PTCCreateTicketNPTT {
  static Future<ApiCallResponse> call(
      {double? annualLeave = 0,
      double? avaiableLeaveRemain = 0,
      double? leaveRemain = 0,
      double? leaveRemainPrevYear = 0,
      double? loanLeave = 0,
      double? maxLoanLeave = 0,
      double? noSalary = 0,
      String? note = "",
      double? numberFurloughDetail = 0,
      double? tempLeave = 0,
      String? userName = "",
      List<FurloughTicket>? listFurloughDetail}) {
    
    String detail = '';
    listFurloughDetail!.forEach((element) {
      detail = detail + '''{
        "ShiftName":"${element.shiftName}",
        "ShiftID": ${element.shiftId},
        "HaftFurlough":"${element.haftFurlough}",
        "FromDate":"${element.fromDate}",
        "ToDate":"${element.toDate}",
        "NumberFurlough": ${element.numberFurlough}
       },''';
    });

    detail = detail.substring(0,detail.length - 1);
    final body = """
{ 
  "TicketNP": {
    "UserName": "${userName}",
    "AnnualLeave": ${annualLeave},
    "AvaiableLeaveRemain":${avaiableLeaveRemain},
    "LeaveRemain": ${leaveRemain},
    "LeaveRemainPrevYear":${leaveRemainPrevYear},
    "LoanLeave":${loanLeave},
    "MaxLoanLeave":${maxLoanLeave},
    "NoSalary":${noSalary},
    "Note":"${note}",
    "NumberFurloughDetail":${numberFurloughDetail},
    "TempLeave":${tempLeave}
  },
  "TicketDetailNP":[
    ${detail}
  ]
}""";
    return ApiManager.instance.makeApiCall(
      callName: 'PTCCreateTicketTC',
      apiUrl: 'https://app.phattien.com/api/Timekeep/CreateTicketNPTT',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
    );
  }
}

class PTCDeleteTicketUpdate {
  static Future<ApiCallResponse> call(
      {String? ticketID = '', String? updateDate = '', String? userName = ''}) {
    return ApiManager.instance.makeApiCall(
        callName: 'PTCDeleteTicketUpdate',
        apiUrl:
            'https://app.phattien.com/api/Timekeep/DeleteTicketTS?ticketID=${ticketID}&updateDate=${updateDate}&userName=${userName}',
        callType: ApiCallType.GET,
        headers: {},
        params: {},
        returnBody: true);
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}
