import 'dart:convert';

class PenyewaProfileRequestModel {
    String? name;
    String? address;
    String? phone;
    String? photo;

    PenyewaProfileRequestModel({
        this.name,
        this.address,
        this.phone,
        this.photo,
    });

    factory PenyewaProfileRequestModel.fromJson(String str) => PenyewaProfileRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PenyewaProfileRequestModel.fromMap(Map<String, dynamic> json) => PenyewaProfileRequestModel(
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        photo: json["photo"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "address": address,
        "phone": phone,
        "photo": photo,
    };
}
