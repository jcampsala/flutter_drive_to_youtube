import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class YoutubeData extends Equatable {
  final String name;
  final String description;
  final List<String> tags;
  final GlobalKey formKey;

  const YoutubeData({ this.name, this.description, this.tags, this.formKey });

  @override
  List<Object> get props => [name, description, tags, formKey];

  @override
  String toString() => 'YoutubeData { name: $name, description: $description, tags: $tags, formKey: $formKey }';

  YoutubeData copyWith({String name, String description, List<String> tags, GlobalKey formKey}) {
    return new YoutubeData(
      name: name ?? this.name,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      formKey: formKey ?? this.formKey
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

      case 'tags': {
        List<String> tags = this.tags;
        tags.addAll(value);
        // Turn into set to remove duplicates
        Set tagsSet = tags.toSet();
        tagsSet.remove('');
        return this.copyWith(tags: tagsSet.toList());
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