class DeviceInfoModel {
  final String deviceModel;
  final String deviceFingerprint;
  final String deviceBrand;
  final String deviceId;
  final String deviceName;
  final String deviceManufacturer;
  final String deviceProduct;
  final String deviceSerialNumber;

  DeviceInfoModel({
    required this.deviceModel,
    required this.deviceFingerprint,
    required this.deviceBrand,
    required this.deviceId,
    required this.deviceName,
    required this.deviceManufacturer,
    required this.deviceProduct,
    required this.deviceSerialNumber,
  });

  /// Convert from JSON
  factory DeviceInfoModel.fromJson(Map<String, dynamic> json) {
    return DeviceInfoModel(
      deviceModel: json['deviceModel'] ?? '',
      deviceFingerprint: json['deviceFingerprint'] ?? '',
      deviceBrand: json['deviceBrand'] ?? '',
      deviceId: json['deviceId'] ?? '',
      deviceName: json['deviceName'] ?? '',
      deviceManufacturer: json['deviceManufacturer'] ?? '',
      deviceProduct: json['deviceProduct'] ?? '',
      deviceSerialNumber: json['deviceSerialNumber'] ?? '',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'deviceModel': deviceModel,
      'deviceFingerprint': deviceFingerprint,
      'deviceBrand': deviceBrand,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceManufacturer': deviceManufacturer,
      'deviceProduct': deviceProduct,
      'deviceSerialNumber': deviceSerialNumber,
    };
  }

  @override
  String toString() {
    return 'DeviceInfoModel('
        'deviceModel: $deviceModel, '
        'deviceFingerprint: $deviceFingerprint, '
        'deviceBrand: $deviceBrand, '
        'deviceId: $deviceId, '
        'deviceName: $deviceName, '
        'deviceManufacturer: $deviceManufacturer, '
        'deviceProduct: $deviceProduct, '
        'deviceSerialNumber: $deviceSerialNumber'
        ')';
  }
}
