import 'package:nasa_pictures_app/modules/pictures/data/helpers/date_formater_extension.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/entities/picture.dart';

class PictureDto {
  final String copyright;
  final String date;
  final String explanation;
  final String hdurl;
  final String mediaType;
  final String serviceVersion;
  final String title;
  final String url;

  PictureDto({
    required this.copyright,
    required this.date,
    required this.explanation,
    required this.hdurl,
    required this.mediaType,
    required this.serviceVersion,
    required this.title,
    required this.url,
  });

  factory PictureDto.fromMap(Map<String, dynamic> map) {
    return PictureDto(
      copyright: map['copyright'] ?? '',
      date: map['date'] ?? '',
      explanation: map['explanation'] ?? '',
      hdurl: map['hdurl'] ?? '',
      mediaType: map['media_type'] ?? '',
      serviceVersion: map['service_version'] ?? '',
      title: map['title'] ?? '',
      url: map['url'] ?? '',
    );
  }

  Picture toEntity() {
    return Picture(
      copyright: copyright,
      date: date.formatDate(date),
      explanation: explanation,
      hdurl: hdurl,
      mediaType: mediaType,
      serviceVersion: serviceVersion,
      title: title,
      url: url,
    );
  }
}
