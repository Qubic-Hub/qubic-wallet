import 'package:qubic_wallet/dtos/explorer_transaction_info_dto.dart';

//Holds info about an ID as returned from a random computor
class ExplorerIdInfoReportedValueDto {
  // The IP of the computor
  // ignore: non_constant_identifier_names
  String IP;
  // The public key of the ID
  String publicKey;
  // The total amount of incoming tokens
  int incomingAmount;
  // The total amount of outgoing tokens
  int outgoingAmount;
  // The total amount of incoming transfers
  int numberOfIncomingTransfers;
  // The total amount of outgoing transfers
  int numberOfOutgoingTransfers;
  // Latest tick the ID received tokens
  int latestIncomingTransferTick;
  // Latest tick the ID sent tokens
  int latestOutgoingTransferTick;

  ExplorerIdInfoReportedValueDto(
      this.IP,
      this.publicKey,
      this.incomingAmount,
      this.outgoingAmount,
      this.numberOfIncomingTransfers,
      this.numberOfOutgoingTransfers,
      this.latestIncomingTransferTick,
      this.latestOutgoingTransferTick);

  factory ExplorerIdInfoReportedValueDto.fromJson(Map<String, dynamic> data) {
    return ExplorerIdInfoReportedValueDto(
      data['IP'],
      data['publicKey'],
      data['incomingAmount'],
      data['outgoingAmount'],
      data['numberOfIncomingTransfers'],
      data['numberOfOutgoingTransfers'],
      data['latestIncomingTransferTick'],
      data['latestOutgoingTransferTick'],
    );
  }

  @override
  // ignore: override_on_non_overriding_member
  List<Object> get props {
    //For use with equatable
    return [
      publicKey,
      incomingAmount,
      outgoingAmount,
      numberOfIncomingTransfers,
      numberOfOutgoingTransfers,
      latestIncomingTransferTick,
      latestOutgoingTransferTick
    ];
  }
}

//Holds the complete info as returned by the explorer for a specific ID
class ExplorerIdInfoDto {
  // A list of reported values for the ID
  List<ExplorerIdInfoReportedValueDto> reportedValues;
  // The public Id
  String id;
  // A list of latest transfers
  List<ExplorerTransactionInfoDto>? latestTransfers;
  //Check if all reported values are equal
  bool get areReportedValuesEqual {
    if ((reportedValues.length == 1) || (reportedValues.isEmpty)) {
      return true;
    }
    for (var i = 1; i < reportedValues.length; i++) {
      if ((reportedValues[i].incomingAmount !=
              reportedValues[0].incomingAmount) ||
          (reportedValues[i].latestIncomingTransferTick !=
              reportedValues[0].latestIncomingTransferTick) ||
          (reportedValues[i].latestOutgoingTransferTick !=
              reportedValues[0].latestOutgoingTransferTick) ||
          (reportedValues[i].numberOfIncomingTransfers !=
              reportedValues[0].numberOfIncomingTransfers) ||
          (reportedValues[i].numberOfOutgoingTransfers !=
              reportedValues[0].numberOfOutgoingTransfers) ||
          (reportedValues[i].outgoingAmount !=
              reportedValues[0].outgoingAmount)) {
        return false;
      }
    }
    return true;
  }

  List<String> get reportedIPs {
    List<String> output = [];
    for (var element in reportedValues) {
      output.add(element.IP);
    }
    return output;
  }

  ExplorerIdInfoDto(
    this.reportedValues,
    this.id,
    this.latestTransfers,
  );

  factory ExplorerIdInfoDto.fromJson(Map<String, dynamic> data) {
    List<ExplorerTransactionInfoDto>? latestTransfers;
    if (data['latestTransfers'] != null) {
      latestTransfers = data['latestTransfers']
          ?.map<ExplorerTransactionInfoDto>(
              (e) => ExplorerTransactionInfoDto.fromJson(e))
          .toList();
    }

    //reportedValues is a key-value store, have to convert to an array
    List<ExplorerIdInfoReportedValueDto> repValues = [];
    data['reportedValues'].forEach((key, value) {
      value['IP'] = key;
      repValues.add(ExplorerIdInfoReportedValueDto.fromJson(value));
    });

    return ExplorerIdInfoDto(
      repValues,
      data['id'],
      latestTransfers,
    );
  }
}

class ReportedValues {
  Map<String, ExplorerIdInfoReportedValueDto> values;

  ReportedValues(this.values);

  factory ReportedValues.fromJson(Map<String, dynamic> json) {
    Map<String, ExplorerIdInfoReportedValueDto> values = {};
    json.forEach((key, value) {
      value['IP'] = key;
      values[key] = ExplorerIdInfoReportedValueDto.fromJson(value);
    });

    return ReportedValues(values);
  }
}
