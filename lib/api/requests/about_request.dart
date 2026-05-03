class AboutRequest {
  final String? shopName;
  final String? shopLocation;
  final String? businessType;
  final String? otherBusinessType;
  final int? uploadedFileId;
  final String? ownerName;

  AboutRequest({
    this.shopName,
    this.shopLocation,
    this.businessType,
    this.otherBusinessType,
    this.uploadedFileId,
    this.ownerName,
  });

  Map<String, dynamic> toJson() {
    return {
      'shop_name': shopName,
      'shop_location': shopLocation,
      'business_type': businessType,
      'other_business_type': otherBusinessType,
      if (uploadedFileId != null) 'uploaded_file_id': uploadedFileId,
      'owner_name': ownerName,
    };
  }
}
