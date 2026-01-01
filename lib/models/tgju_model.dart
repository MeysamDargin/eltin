// To parse this JSON data, do
//
// final tgjuResponse = tgjuResponseFromJson(jsonString);

import 'dart:convert';

TgjuResponse tgjuResponseFromJson(String str) =>
    TgjuResponse.fromJson(json.decode(str));
String tgjuResponseToJson(TgjuResponse data) => json.encode(data.toJson());

/// مدل اصلی پاسخ API شبکه اطلاع‌رسانی طلا و ارز (tgju.org)
class TgjuResponse {
  final Map<String, PriceItem> current;
  final List<ToleranceItem> toleranceLow;
  final List<ToleranceItem> toleranceHigh;
  final List<ToleranceItem> last;

  TgjuResponse({
    required this.current,
    required this.toleranceLow,
    required this.toleranceHigh,
    required this.last,
  });

  factory TgjuResponse.fromJson(Map<String, dynamic> json) => TgjuResponse(
    current: Map.from(
      json["current"],
    ).map((k, v) => MapEntry<String, PriceItem>(k, PriceItem.fromJson(v))),
    toleranceLow: List<ToleranceItem>.from(
      json["tolerance_low"].map((x) => ToleranceItem.fromJson(x)),
    ),
    toleranceHigh: List<ToleranceItem>.from(
      json["tolerance_high"].map((x) => ToleranceItem.fromJson(x)),
    ),
    last: List<ToleranceItem>.from(
      json["last"].map((x) => ToleranceItem.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "current": Map.from(
      current,
    ).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "tolerance_low": List<dynamic>.from(toleranceLow.map((x) => x.toJson())),
    "tolerance_high": List<dynamic>.from(toleranceHigh.map((x) => x.toJson())),
    "last": List<dynamic>.from(last.map((x) => x.toJson())),
  };
}

/// مدل قیمت‌های لحظه‌ای (بخش current)
class PriceItem {
  final String p; // قیمت فعلی
  final String h; // بالاترین امروز
  final String l; // پایین‌ترین امروز
  final String d; // تغییر مطلق
  final double dp; // تغییر درصدی
  final ChangeDirection dt; // جهت تغییر (صعودی/نزولی)
  final String t; // زمان به فارسی
  final String tEn; // زمان به انگلیسی
  final String tG; // زمان گرگوری
  final DateTime ts; // timestamp

  PriceItem({
    required this.p,
    required this.h,
    required this.l,
    required this.d,
    required this.dp,
    required this.dt,
    required this.t,
    required this.tEn,
    required this.tG,
    required this.ts,
  });

  factory PriceItem.fromJson(Map<String, dynamic> json) => PriceItem(
    p: json["p"] ?? "",
    h: json["h"] ?? "",
    l: json["l"] ?? "",
    d: json["d"] ?? "",
    dp: (json["dp"] ?? 0.0).toDouble(),
    dt: changeDirectionValues.map[json["dt"]] ?? ChangeDirection.empty,
    t: json["t"] ?? "",
    tEn: json["t_en"] ?? "",
    tG: json["t-g"] ?? "",
    ts: DateTime.parse(json["ts"]),
  );

  Map<String, dynamic> toJson() => {
    "p": p,
    "h": h,
    "l": l,
    "d": d,
    "dp": dp,
    "dt": changeDirectionValues.reverse[dt],
    "t": t,
    "t_en": tEn,
    "t-g": tG,
    "ts": ts.toIso8601String(),
  };
}

/// جهت تغییر قیمت
enum ChangeDirection { empty, high, low }

final changeDirectionValues = EnumValues({
  "": ChangeDirection.empty,
  "high": ChangeDirection.high,
  "low": ChangeDirection.low,
});

/// مدل آیتم‌های خاص (tolerance_low, tolerance_high, last)
class ToleranceItem {
  final String name;
  final int itemId;
  final String slug;
  final String p;
  final String h;
  final String l;
  final String o; // قیمت باز شدن روز
  final String d;
  final double dp;
  final ChangeDirection dt;
  final String t;
  final String tEn;
  final String createdAt;
  final String title; // عنوان فارسی
  final String titleEn; // عنوان انگلیسی
  final String phpFirstPrice; // اولین قیمت امروز

  ToleranceItem({
    required this.name,
    required this.itemId,
    required this.slug,
    required this.p,
    required this.h,
    required this.l,
    required this.o,
    required this.d,
    required this.dp,
    required this.dt,
    required this.t,
    required this.tEn,
    required this.createdAt,
    required this.title,
    required this.titleEn,
    required this.phpFirstPrice,
  });

  factory ToleranceItem.fromJson(Map<String, dynamic> json) => ToleranceItem(
    name: json["name"] ?? "",
    itemId: json["item_id"] ?? 0,
    slug: json["slug"] ?? "",
    p: json["p"] ?? "",
    h: json["h"] ?? "",
    l: json["l"] ?? "",
    o: json["o"] ?? "",
    d: json["d"] ?? "",
    dp: (json["dp"] ?? 0.0).toDouble(),
    dt: changeDirectionValues.map[json["dt"]] ?? ChangeDirection.empty,
    t: json["t"] ?? "",
    tEn: json["t_en"] ?? "",
    createdAt: json["created_at"] ?? "",
    title: json["title"] ?? "",
    titleEn: json["title_en"] ?? "",
    phpFirstPrice: json["php:first-price"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "item_id": itemId,
    "slug": slug,
    "p": p,
    "h": h,
    "l": l,
    "o": o,
    "d": d,
    "dp": dp,
    "dt": changeDirectionValues.reverse[dt],
    "t": t,
    "t_en": tEn,
    "created_at": createdAt,
    "title": title,
    "title_en": titleEn,
    "php:first-price": phpFirstPrice,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
