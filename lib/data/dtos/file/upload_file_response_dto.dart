///
/// 파일(이미지, 비디오) 업로드 응답 DTO
///
class UploadFileResponseDTO {
  final String fileName;
  final String fileURL;

  UploadFileResponseDTO({
    required this.fileName,
    required this.fileURL,
  });

  factory UploadFileResponseDTO.fromJson(Map<String, dynamic> json) {
    final result = json['result'];

    return UploadFileResponseDTO(
      fileName: result['originalName'] as String,
      fileURL: result['url'] as String,
    );
  }
}
