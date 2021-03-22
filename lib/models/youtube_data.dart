import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class YoutubeData extends Equatable {
  final String driveId;
  final String name;
  final String description;
  final List<String> tags;
  final GlobalKey formKey;
  final String thumbnail;
  final String visibility;

  const YoutubeData(this.driveId, { this.name, this.description, this.tags, this.formKey, this.thumbnail, this.visibility });

  @override
  List<Object> get props => [driveId, name, description, tags, formKey, thumbnail, visibility];

  @override
  String toString() => 'YoutubeData { driveId: $driveId, name: $name, description: $description, tags: $tags, formKey: $formKey, thumbnail: $thumbnail, visibility: $visibility }';

  YoutubeData copyWith({String name, String description, List<String> tags, GlobalKey formKey, String thumbnail, String visibility}) {
    return new YoutubeData(
      this.driveId,
      name: name ?? this.name,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      formKey: formKey ?? this.formKey,
      thumbnail: thumbnail ?? this.thumbnail,
      visibility: visibility ?? this.visibility
    );
  }

  YoutubeData updateByName(String attr, dynamic value) {
    switch(attr) {
      case 'name': {
        return this.copyWith(name: value);
      }
      break;

      case 'description': {
        return this.copyWith(description: value);
      }
      break;

      case 'visibility': {
        return this.copyWith(visibility: value);
      }
      break;

      default: {
        return this;
      }
      break;
    }
  }

  YoutubeData updateTags(bool add, List<String> value) {
    List<String> tags = this.tags;
    if(add) {
      tags.addAll(value);
      // Turn into set to remove duplicates
      Set tagsSet = tags.toSet();
      tagsSet.remove('');
      return this.copyWith(tags: tagsSet.toList());
    } else {
      for(String tag in value) {
        tags.remove(tag);
      }
      return this.copyWith(tags: tags);
    }
  }
}