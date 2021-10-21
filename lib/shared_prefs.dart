import 'dart:convert';

import 'package:flutter/foundation.dart';

class SharedObject {
  List<List> data;
  SharedObject({
    required this.data,
  });

  SharedObject copyWith({
    List<List>? data,
  }) {
    return SharedObject(
      data: data ?? this.data,
    );
  }

  static Map<String, dynamic> toMap(List<List> data) {
    return {
      'data': data,
    };
  }

  factory SharedObject.fromMap(Map<String, dynamic> map) {
    return SharedObject(
      data: List<List>.from(map['data']?.map((x) => x)),
    );
  }

  static String toJson(List<List> data) => json.encode(toMap(data));

  factory SharedObject.fromJson(String source) => SharedObject.fromMap(json.decode(source));

  @override
  String toString() => 'SharedObject(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SharedObject &&
      listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
