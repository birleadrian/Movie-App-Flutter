// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: always_specify_types

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$Movie$ _$$Movie$FromJson(Map<String, dynamic> json) => _$Movie$(
      title: json['title'] as String,
      year: json['year'] as int,
      rating: json['rating'] as num,
      runtime: json['runtime'] as int,
      summary: json['summary'] as String,
      mediumImage: json['medium_cover_image'] as String,
      largeImage: json['large_cover_image'] as String,
      torrents: (json['torrents'] as List<dynamic>).map((e) => Torrent.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$$Movie$ToJson(_$Movie$ instance) => <String, dynamic>{
      'title': instance.title,
      'year': instance.year,
      'rating': instance.rating,
      'runtime': instance.runtime,
      'summary': instance.summary,
      'medium_cover_image': instance.mediumImage,
      'large_cover_image': instance.largeImage,
      'torrents': instance.torrents,
    };
