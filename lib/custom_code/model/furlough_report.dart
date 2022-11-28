import 'package:flutter/material.dart';

class Furlough_Report {
  double? yearOfWork;
  double? leaveRemainPrevYear;
  double? leaveIssue;
  double? leaveCurrent;
  double? anualLeave;
  double? leavePrevYearNotUse;
  double? leaveAdjust;
  double? totalLeave;
  double? totalLeaveInYear;
  double? leaveUsing;
  double? advanceLeave;
  double? leaveRemain;
  double? maxAdvanceLeave;

  Furlough_Report(
      {this.yearOfWork = 0,
      this.leaveRemainPrevYear = 0,
      this.leaveIssue = 0,
      this.leaveCurrent = 0,
      this.anualLeave = 0,
      this.leavePrevYearNotUse = 0,
      this.leaveAdjust = 0,
      this.totalLeave = 0,
      this.totalLeaveInYear = 0,
      this.leaveUsing = 0,
      this.advanceLeave = 0,
      this.leaveRemain = 0,
      this.maxAdvanceLeave = 0});
}
