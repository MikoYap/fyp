class Plant {
  String? species_name;
  String? common_name;
  String? family;
  String? genus;
  String? image;

  Plant(
      {
        this.species_name,
        this.common_name,
        this.family,
        this.genus,
        this.image
      }
      );

  Plant.fromJson(Map<String, dynamic> json) {
    species_name = json['species_name'];
    common_name = json['common_name'];
    family = json['family'];
    genus = json['genus'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['species_name'] = this.species_name;
    data['common_name'] = this.common_name;
    data['family'] = this.family;
    data['genus'] = this.genus;
    data['image'] = this.image;
    return data;
  }
}